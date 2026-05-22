import os
from datetime import datetime
import psycopg2
from psycopg2.extras import RealDictCursor

def get_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=os.getenv("DB_PORT", "5432"),
        dbname=os.getenv("DB_NAME", "fraud_db"),
        user=os.getenv("DB_USER", "fraud_user"),
        password=os.getenv("DB_PASSWORD", "fraud_password"),
        cursor_factory=RealDictCursor,
    )

def init_db():
    connection = get_connection()
    cursor = connection.cursor()


    cursor.execute("""
    CREATE TABLE IF NOT EXISTS predictions (
        id SERIAL PRIMARY KEY,
        source TEXT NOT NULL,
        prediction INTEGER NOT NULL,
        result TEXT NOT NULL,
        fraud_probability REAL NOT NULL,
        risk_percentage REAL NOT NULL,
        reviewed BOOLEAN NOT NULL DEFAULT FALSE,
        created_at TEXT NOT NULL
    )
""")
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        role TEXT NOT NULL DEFAULT 'analyst',
        created_at TEXT NOT NULL
    )
""")
    connection.commit()
    connection.close()

def insert_prediction(prediction, result, fraud_probability, risk_percentage):
    connection = get_connection()
    cursor = connection.cursor()

    cursor.execute("""
        INSERT INTO predictions (
            source,
            prediction,
            result,
            fraud_probability,
            risk_percentage,
            reviewed,
            created_at
        )
        VALUES (%s, %s, %s, %s, %s, %s,%s)
        RETURNING id
    """, (
        source,
        prediction,
        result,
        fraud_probability,
        risk_percentage,
        False,
        datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
    ))

    prediction_id = cursor.fetchone()["id"]

    connection.commit()
    connection.close()

    return prediction_id

def get_predictions():
    connection = get_connection()
    cursor = connection.cursor()

    cursor.execute("""
        SELECT *
        FROM predictions
        ORDER BY id DESC
    """)

    predictions = cursor.fetchall()

    connection.close()

    return [dict(row) for row in predictions]


def mark_prediction_reviewed(prediction_id):
    connection = get_connection()
    cursor = connection.cursor()

    cursor.execute("""
        UPDATE predictions
        SET reviewed = TRUE
        WHERE id = %s
    """, (prediction_id,))

    connection.commit()
    connection.close()


def clear_predictions():
    connection = get_connection()
    cursor = connection.cursor()

    cursor.execute("DELETE FROM predictions")

    connection.commit()
    connection.close()

def create_user(name, email, password_hash, role,created_at):
    connection = get_connection()
    cursor = connection.cursor()

    cursor.execute("""
        INSERT INTO users (
            name,
            email,
            password_hash,
            role,
            created_at
        )
        VALUES (%s, %s, %s, %s, %s)
        RETURNING id
    """, (
        name,
        email,
        password_hash,
        role,
        created_at,
        datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
    ))

    user_id = cursor.fetchone()["id"]

    connection.commit()
    connection.close()

    return user_id


def get_user_by_email(email):
    connection = get_connection()
    cursor = connection.cursor()

    cursor.execute("""
        SELECT *
        FROM users
        WHERE email = %s
    """, (email,))

    user = cursor.fetchone()

    connection.close()

    if user is None:
        return None

    return dict(user)

