from fastapi import FastAPI
from pathlib import Path

import sqlite3

DB_PATH = Path("../database/db/database.sqlite").resolve()
DB_CON = sqlite3.connect(DB_PATH)

def db_increment(scope):
    pass

def db_decrement(scope):
    pass

def db_read(scope):
    cur = DB_CON.cursor()
    result = cur.execute(
        "SELECT current_count FROM counter WHERE scope = :scope",
        {"scope": scope}
    )
    return result.fetchone()[0]

app = FastAPI()

@app.get("/")
async def root():
    return {"count": db_read("default")}
