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

