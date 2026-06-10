# AI Credit Card Fraud Detection Platform

An end-to-end machine learning system for detecting fraudulent credit card transactions. The project combines a trained fraud detection model, a Flask REST API, PostgreSQL storage, Dockerized backend infrastructure and a Flutter web application for analysts to test transactions, review alerts and monitor prediction history.

This project was built as a full-stack AI product not just a notebook experiment.

## Live Demo

Frontend App: https://ai-fraud-detection-platform.netlify.app/

Backend API: https://fraud-backend-5x3y.onrender.com

## Project Overview

Credit card fraud detection is a highly imbalanced classification problem where fraudulent transactions are rare but costly. This system uses machine learning to classify transactions as safe or fraudulent and exposes the model through a real application workflow.

The platform supports:

- User registration and login
- Single transaction prediction
- Manual input for all model features
- Demo safe and fraud transaction samples
- Fraud risk percentage
- Prediction history
- Fraud dashboard and alert review
- PostgreSQL-backed persistence
- Dockerized backend deployment setup

## Architecture

```text
Flutter Web App
      |
      | HTTP / REST API
      v
Flask Backend API
      |
      | Loads model + scaler
      v
Random Forest Fraud Model
      |
      | Stores users, predictions, alerts
      v
PostgreSQL Database
      |
      v
Docker / Docker Compose
```

## Tech Stack

| Layer | Technology |
|---|---|
| Machine Learning | Python, scikit-learn, imbalanced-learn, NumPy, pandas |
| Model | Random Forest Classifier |
| Preprocessing | RobustScaler, SMOTE |
| Backend | Flask, Flask-CORS |
| Database | PostgreSQL |
| Authentication | Werkzeug password hashing |
| Frontend | Flutter |
| API Communication | HTTP REST API |
| Containerization | Docker, Docker Compose |

## Machine Learning Workflow

The ML pipeline follows a structured fraud detection workflow:

1. Data understanding and class imbalance analysis
2. Data preprocessing
3. Feature scaling for `Time` and `Amount`
4. SMOTE-based resampling for fraud class balancing
5. Model comparison
6. Random Forest model training
7. Model serialization using pickle
8. Backend integration using Flask

Saved artifacts:

```text
models/fraud_model.pkl
models/scaler.pkl
```

The model expects 30 input features:

```text
Time, V1, V2, ..., V28, Amount
```

## Key Features

### Fraud Prediction

Users can submit transaction data and receive:

- Prediction class
- Fraud or safe result
- Fraud probability
- Risk percentage
- Timestamped prediction record

### Manual Transaction Input

The Flutter app includes a manual prediction screen where analysts can enter transaction values directly.

### Demo Prediction

Safe and fraud sample transactions are included to quickly test the model and understand system behavior.

### Fraud Dashboard

The dashboard provides:

- Total predictions
- Safe transaction count
- Fraud transaction count
- Average risk score
- Recent transaction history
- Fraud alerts
- Reviewed alert status

### Authentication

The system supports:

- User registration
- User login
- Hashed password storage
- User role support

## Backend API Routes

| Method | Route | Description |
|---|---|---|
| GET | `/` | Backend health message |
| GET | `/health` | Checks model and scaler loading status |
| GET | `/features` | Returns model feature names |
| POST | `/predict` | Predicts fraud for a transaction |
| GET | `/predictions` | Returns stored prediction history |
| PATCH | `/predictions/<id>/review` | Marks a fraud alert as reviewed |
| DELETE | `/predictions` | Clears prediction history |
| POST | `/register` | Creates a new user |
| POST | `/login` | Logs in an existing user |

Example prediction request:

```json
{
  "source": "Manual Input",
  "features": [0, -1.35, -0.07, 2.53, 1.37, -0.33, 0.46, 0.23, 0.09, 0.36, 0.09, -0.55, -0.61, -0.99, -0.31, 1.46, -0.47, 0.20, 0.02, 0.40, 0.25, -0.01, 0.27, -0.11, 0.06, 0.12, -0.18, 0.13, -0.02, 149.62]
}
```

Example response:

```json
{
  "id": 1,
  "source": "Manual Input",
  "prediction": 0,
  "result": "Safe Transaction",
  "fraud_probability": 0.0,
  "risk_percentage": 0.0,
  "created_at": "2026-05-23T10:00:00"
}
```

## Project Structure

```text
fraud-detection-ml-system/
|
|-- backend/
|   |-- app.py
|   |-- database.py
|   |-- requirements.txt
|   |-- test_api.py
|
|-- data/
|   |-- creditcard.csv
|   |-- x_train_resampled.npy
|   |-- y_train_resampled.npy
|   |-- x_test.npy
|   |-- y_test.npy
|
|-- models/
|   |-- fraud_model.pkl
|   |-- scaler.pkl
|
|-- notebooks/
|   |-- data_understanding.ipynb
|   |-- data_preprocessing.ipynb
|   |-- model_building.ipynb
|
|-- flutter_app/
|   |-- fraud_detection_app/
|       |-- lib/
|           |-- screens/
|           |-- widgets/
|           |-- services/
|           |-- models/
|           |-- data/
|
|-- Dockerfile
|-- docker-compose.yml
|-- .dockerignore
|-- README.md
```

## Running Locally With Docker

Make sure Docker Desktop is running.

From the project root:

```powershell
docker compose up --build
```

Backend will run at:

```text
http://127.0.0.1:5000
```

Check backend health:

```text
http://127.0.0.1:5000/health
```

Expected response:

```json
{
  "status": "ok",
  "model_loaded": true,
  "scaler_loaded": true
}
```

## Running the Flutter App

Go to the Flutter project:

```powershell
cd flutter_app/fraud_detection_app
```

Install packages:

```powershell
flutter pub get
```

Run on Chrome:

```powershell
flutter run -d chrome
```

The Flutter app communicates with the Flask API running on:

```text
http://127.0.0.1:5000
```

For production builds, pass the deployed backend URL at build time:

```powershell
flutter build web --dart-define=API_BASE_URL=https://your-backend-url.com
```

## PostgreSQL Setup

PostgreSQL runs through Docker Compose.

Database configuration:

```text
Database: fraud_db
User: fraud_user
Password: fraud_password
Host inside Docker: postgres
Port: 5432
```

The backend receives these values through environment variables in `docker-compose.yml`.

## Deployment

Frontend App: ...
Backend API: ...

The project is deployed using:
- Frontend: Netlify
- Backend: Render
- Database: Render PostgreSQL
- Backend runtime: Docker + Gunicorn

Note: The backend is hosted on Render free tier so the first request may take a few seconds because of cold start.

## Production Deployment Notes

The backend Docker image runs Flask through Gunicorn:

```text
gunicorn --bind 0.0.0.0:${PORT:-5000} --workers ${WEB_CONCURRENCY:-2} app:app
```

This is more suitable for cloud deployment than Flask's local development server.

Recommended deployment setup:

1. Deploy PostgreSQL using a managed cloud database or a Docker Compose service.
2. Deploy the backend container with environment variables from `.env.example`.
3. Build the Flutter web app with the deployed backend URL.
4. Host Flutter web on a static hosting platform.
5. Update CORS settings if the frontend and backend use different domains.

Important production environment variables:

```text
DB_HOST
DB_PORT
DB_NAME
DB_USER
DB_PASSWORD
PORT
FLASK_DEBUG
WEB_CONCURRENCY
```

## Security Notes

- Passwords are stored as hashes using Werkzeug.
- Raw passwords are never stored in the database.
- Current authentication is suitable for a project prototype.
- For production, JWT/session-based authorization and protected routes should be added.

## Current Status

Completed:

- ML model training
- Flask backend API
- PostgreSQL database integration
- Dockerized backend
- Flutter frontend
- Authentication
- Prediction dashboard
- Fraud alert review
- Backend deployment on Render
- Frontend deployment on Netlify

Planned improvements:

- Role-based access control
- Production environment variables
- Batch CSV prediction
- Model monitoring
- CI/CD pipeline

## Project Summary

Built an end-to-end AI fraud detection platform using Random Forest, Flask, PostgreSQL, Docker, and Flutter. The system supports user authentication, real-time fraud prediction, persistent prediction history, dashboard analytics and fraud alert review through a full-stack machine learning architecture.
