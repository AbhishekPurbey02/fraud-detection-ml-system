from flask import Flask, request, jsonify
from flask_cors import CORS
import pickle
import os
import numpy as np 
from datetime import datetime
from werkzeug.security import generate_password_hash, check_password_hash

from database import (
    init_db,
    insert_prediction,
    get_predictions,
    mark_prediction_reviewed,
    clear_predictions,
    create_user,
    get_user_by_email,
)
app = Flask(__name__)
CORS(app)
init_db()


# Get path of the saved model
model_path = os.path.join(os.path.dirname(__file__), "..", "models", "fraud_model.pkl")

scaler_path = os.path.join(os.path.dirname(__file__), "..", "models", "scaler.pkl")

# Load trained Random Forest model
with open(model_path, "rb") as file:
    model = pickle.load(file)

# Load fitted RobustScaler
with open(scaler_path, "rb") as file:
    scaler = pickle.load(file)

feature_names = [
    "Time",
    "V1", "V2", "V3", "V4", "V5", "V6", "V7",
    "V8", "V9", "V10", "V11", "V12", "V13", "V14",
    "V15", "V16", "V17", "V18", "V19", "V20", "V21",
    "V22", "V23", "V24", "V25", "V26", "V27", "V28",
    "Amount"
]
@app.route("/features", methods=["GET"])
def features():
    return jsonify({
        "feature_count": len(feature_names),
        "features": feature_names
    })
@app.route("/health", methods=["GET"])
def health():
    return jsonify({
        "status": "ok",
        "model_loaded": model is not None,
        "scaler_loaded": scaler is not None
    })
@app.route("/")
def home():
    return "Fraud Detection Backend is running!"


@app.route("/predict", methods=["POST"])
def predict():
    data = request.get_json()
    if data is None:
        return jsonify({
            "error": "No JSON data received"
        }), 400
    features = data.get("features")

    if features is None:
        return jsonify({
            "error": "No features provided"
        }), 400
    
    if len(features) !=30:
        return jsonify({
            "error": "Model expects exactly 30 features",
            "received": len(features)
        }), 400
    try:
        features_array = np.array(features, dtype=float).reshape(1, -1)
    except ValueError:
        return jsonify({
            "error": "All features must be numeric values"
        }), 400

    # Scale only Time and Amount columns
    features_array[:,[0,29]] = scaler.transform(features_array[:,[0,29]])
    fraud_probability = model.predict_proba(features_array)[0][1]
    prediction = model.predict(features_array)[0]

    if prediction == 1:
        result = "Fraud Transaction"
    else:
        result = "Safe Transaction"

    created_at = datetime.now().isoformat()
    source = data.get("source", "API Prediction")

    prediction_id = insert_prediction(
        source=source,
        result=result,
        risk_percentage=round(float(fraud_probability) * 100, 2),
        created_at=created_at
    )

    return jsonify({
        "id": prediction_id,
        "source": source,
        "prediction": int(prediction),
        "result": result,
        "fraud_probability": round(float(fraud_probability),4),
        "risk_percentage": round(float(fraud_probability)*100,2),
        "created_at": created_at
    })

@app.route("/predictions", methods=["GET"])
def predictions():
    return jsonify({
        "predictions": get_predictions()
    })


@app.route("/predictions/<int:prediction_id>/review", methods=["PATCH"])
def review_prediction(prediction_id):
    mark_prediction_reviewed(prediction_id)

    return jsonify({
        "message": "Prediction marked as reviewed",
        "id": prediction_id
    })


@app.route("/predictions", methods=["DELETE"])
def delete_predictions():
    clear_predictions()

    return jsonify({
        "message": "Prediction history cleared"
    })

@app.route("/register", methods=["POST"])
def register():
    data = request.get_json()

    if data is None:
        return jsonify({"error": "No JSON data received"}), 400

    name = data.get("name")
    email = data.get("email")
    password = data.get("password")
    role = data.get("role", "analyst")

    if not name or not email or not password:
        return jsonify({"error": "Name, email, and password are required"}), 400

    existing_user = get_user_by_email(email)
    if existing_user is not None:
        return jsonify({"error": "User already exists"}), 409

    password_hash = generate_password_hash(password)
    created_at = datetime.now().isoformat()

    user_id = create_user(
        name=name,
        email=email,
        password_hash=password_hash,
        role=role,
        created_at=created_at
    )

    return jsonify({
        "message": "User registered successfully",
        "user": {
            "id": user_id,
            "name": name,
            "email": email,
            "role": role,
            "created_at": created_at
        }
    }), 201


@app.route("/login", methods=["POST"])
def login():
    data = request.get_json()

    if data is None:
        return jsonify({"error": "No JSON data received"}), 400

    email = data.get("email")
    password = data.get("password")

    if not email or not password:
        return jsonify({"error": "Email and password are required"}), 400

    user = get_user_by_email(email)

    if user is None:
        return jsonify({"error": "Invalid email or password"}), 401

    if not check_password_hash(user["password_hash"], password):
        return jsonify({"error": "Invalid email or password"}), 401

    return jsonify({
        "message": "Login successful",
        "user": {
            "id": user["id"],
            "name": user["name"],
            "email": user["email"],
            "role": user["role"],
            "created_at": user["created_at"]
        }
    })

if __name__ == "__main__":
    app.run(debug=True)
