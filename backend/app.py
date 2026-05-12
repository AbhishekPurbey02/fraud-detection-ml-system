from flask import Flask, request, jsonify
from flask_cors import CORS
import pickle
import os
import numpy as np 
from database import init_db


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

    return jsonify({
        "prediction": int(prediction),
        "result": result,
        "fraud_probability": round(float(fraud_probability),4),
        "risk_percentage": round(float(fraud_probability)*100,2)
    })

if __name__ == "__main__":
    app.run(debug=True)
