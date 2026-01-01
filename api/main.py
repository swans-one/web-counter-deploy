from fastapi import FastAPI
from pathlib import Path

import os
import sqlite3

DB_PATH_FROM_ENV = os.environ.get(
    "WEB_COUNTER_DB_PATH",
    "../database/db/database.sqlite"
)
DB_PATH = Path(DB_PATH_FROM_ENV).resolve()
DB_CON = sqlite3.connect(DB_PATH)

def db_increment(scope):
    query = '''
    UPDATE counter
    SET current_count = current_count + 1
    WHERE scope = :scope
    RETURNING current_count
    '''
    cur = DB_CON.cursor()
    result = cur.execute(query, {"scope": scope})
    count = result.fetchone()[0]
    DB_CON.commit()
    return count

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

@app.get("/increment")
async def root():
    return {"count": db_increment("default")}
