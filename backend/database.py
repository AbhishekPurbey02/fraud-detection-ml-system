import sqlite3
from pathlib import Path

Base_DIR = Path(__file__).resolve().parent
DB_PATH = Base_DIR / "fraud_predictions.db"

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