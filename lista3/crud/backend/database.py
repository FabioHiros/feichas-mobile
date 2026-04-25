import sqlite3
from pathlib import Path

DB_PATH = Path(__file__).parent / "grocery.db"


def get_connection() -> sqlite3.Connection:
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def init_db() -> None:
    conn = get_connection()
    conn.execute("""
        CREATE TABLE IF NOT EXISTS items (
            id       INTEGER PRIMARY KEY AUTOINCREMENT,
            name     TEXT    NOT NULL,
            quantity REAL    NOT NULL DEFAULT 1,
            unit     TEXT    NOT NULL DEFAULT 'units',
            category TEXT    NOT NULL DEFAULT 'General',
            bought   INTEGER NOT NULL DEFAULT 0
        )
    """)
    conn.commit()
    conn.close()
