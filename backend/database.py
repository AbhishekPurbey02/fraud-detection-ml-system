import sqlite3
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
DB_PATH = BASE_DIR / "fraud_predictions.db"

def get_connection():
    connection = sqlite3.connect(DB_PATH)
    connection.row_factory = sqlite3.Row
    return connection


def init_db():
    connection = get_connection()
    cursor = connection.cursor()


    cursor.execute("""
        CREATE TABLE IF NOT EXISTS predictions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            source TEXT NOT NULL,
            result TEXT NOT NULL,
            risk_percentage REAL NOT NULL,
            reviewed INTEGER NOT NULL DEFAULT 0,
            created_at TEXT NOT NULL
        )
""")
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password_hash TEXT NOT NULL,
            role TEXT NOT NULL DEFAULT 'analyst',
            created_at TEXT NOT NULL
        )
    """)
    connection.commit()
    connection.close()

def insert_prediction(source, result, risk_percentage, created_at):
    connection = get_connection()
    cursor = connection.cursor()

    cursor.execute("""
        INSERT INTO predictions (source, result, risk_percentage, created_at)
        VALUES (?, ?, ?, ?)
    """, (source, result, risk_percentage, created_at))

    connection.commit()
    prediction_id = cursor.lastrowid
    connection.close()

    return prediction_id


def get_predictions():
    connection = get_connection()
    cursor = connection.cursor()

    cursor.execute("""
        SELECT id, source, result, risk_percentage, reviewed, created_at
        FROM predictions
        ORDER BY id DESC
    """)

    rows = cursor.fetchall()
    connection.close()

    return [dict(row) for row in rows]


def mark_prediction_reviewed(prediction_id):
    connection = get_connection()
    cursor = connection.cursor()

    cursor.execute("""
        UPDATE predictions
        SET reviewed = 1
        WHERE id = ?
    """, (prediction_id,))

    connection.commit()
    connection.close()


def clear_predictions():
    connection = get_connection()
    cursor = connection.cursor()

    cursor.execute("DELETE FROM predictions")

    connection.commit()
    connection.close()

def create_user(name, email, password_hash, role, created_at):
    connection = get_connection()
    cursor = connection.cursor()

    cursor.execute("""
        INSERT INTO users (name, email, password_hash, role, created_at)
        VALUES (?, ?, ?, ?, ?)
    """, (name, email, password_hash, role, created_at))

    connection.commit()
    user_id = cursor.lastrowid
    connection.close()

    return user_id


def get_user_by_email(email):
    connection = get_connection()
    cursor = connection.cursor()

    cursor.execute("""
        SELECT id, name, email, password_hash, role, created_at
        FROM users
        WHERE email = ?
    """, (email,))

    row = cursor.fetchone()
    connection.close()

    if row is None:
        return None

    return dict(row)

