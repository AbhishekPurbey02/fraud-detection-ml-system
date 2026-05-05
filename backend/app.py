from flask import Flask, request, jsonify
import pickle
import os

app = Flask(__name__)
# Get path of the saved model
model_path = os.path.join(os.path.dirname(__file__), "..", "models", "fraud_model.pkl")

# Load trained Random Forest model
with open(model_path, "rb") as file:
    model = pickle.load(file)

@app.route("/")
def home():
    return "Fraud Detection Backend is running!"

@app.route("/predict", methods=["POST"])
def predict():
    data = request.get_json()

    return jsonify({
        "received_data": data,
        "message": "Data received successfully"
    })

if __name__ == "__main__":
    app.run(debug=True)
