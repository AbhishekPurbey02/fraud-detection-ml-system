from flask import Flask, request, jsonify
import pickle
import os
import numpy as np 

app = Flask(__name__)
# Get path of the saved model
model_path = os.path.join(os.path.dirname(__file__), "..", "models", "fraud_model.pkl")

scaler_path = os.path.join(os.path.dirname(__file__), "..", "models", "scaler.pkl")

# Load trained Random Forest model
with open(model_path, "rb") as file:
    model = pickle.load(file)

# Load fitted RobustScaler
with open(scaler_path, "rb") as file:
    scaler = pickle.load(file)

@app.route("/")
def home():
    return "Fraud Detection Backend is running!"

@app.route("/predict", methods=["POST"])
def predict():
    data = request.get_json()
    
    features = data.get("features")

    if features is None:
        return jsonify({
            "error": "No features provided"
        })
    
    if len(features) !=30:
        return jsonify({
            "error": "Model expects exactly 30 features",
            "received": len(features)
        })
    
    features_array = np.array(features).reshape(1, -1)
    # Scale only Time and Amount columns
    features_array[:,[0,29]] = scaler.transform(features_array[:,[0,29]])
    prediction = model.predict(features_array)[0]

    if prediction == 1:
        result = "Fraud Transaction"
    else:
        result = "Safe Transaction"

    return jsonify({
        "prediction": int(prediction),
        "result": result
    })

if __name__ == "__main__":
    app.run(debug=True)
