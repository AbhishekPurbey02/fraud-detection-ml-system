import requests
import pandas as pd

API_URL = "http://127.0.0.1:5000/predict"
DATA_PATH = "../data/creditcard.csv"

dataset = pd.read_csv(DATA_PATH)

safe_transaction = dataset[dataset["Class"] == 0].iloc[0]
fraud_transaction = dataset[dataset["Class"] == 1].iloc[0]

feature_columns = dataset.columns.drop("Class")

def test_transaction(row, label):
    features = row[feature_columns].tolist()

    response = requests.post(API_URL, json={
        "features": features
    })

    print(f"\nActual Label: {label}")
    print("API Response:")
    print(response.json())

test_transaction(safe_transaction, "Safe")
test_transaction(fraud_transaction, "Fraud")
