from typing import Optional

import uvicorn
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

import database


class ItemCreate(BaseModel):
    name: str
    quantity: float
    unit: str
    category: str
    bought: bool = False


class ItemUpdate(BaseModel):
    name: Optional[str] = None
    quantity: Optional[float] = None
    unit: Optional[str] = None
    category: Optional[str] = None
    bought: Optional[bool] = None


app = FastAPI(title="Grocery API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("startup")
def startup():
    database.init_db()


def row_to_dict(row) -> dict:
    d = dict(row)
    d["bought"] = bool(d["bought"])
    return d


@app.get("/items")
def list_items():
    conn = database.get_connection()
    rows = conn.execute(
        "SELECT * FROM items ORDER BY bought ASC, name ASC"
    ).fetchall()
    conn.close()
    return [row_to_dict(r) for r in rows]


@app.post("/items", status_code=201)
def create_item(body: ItemCreate):
    conn = database.get_connection()
    cur = conn.execute(
        "INSERT INTO items (name, quantity, unit, category, bought) VALUES (?, ?, ?, ?, ?)",
        (body.name, body.quantity, body.unit, body.category, int(body.bought)),
    )
    conn.commit()
    row = conn.execute("SELECT * FROM items WHERE id = ?", (cur.lastrowid,)).fetchone()
    conn.close()
    return row_to_dict(row)


@app.put("/items/{item_id}")
def update_item(item_id: int, body: ItemUpdate):
    updates = body.dict(exclude_unset=True)
    if not updates:
        raise HTTPException(status_code=400, detail="No fields to update")

    if "bought" in updates:
        updates["bought"] = int(updates["bought"])

    set_clause = ", ".join(f"{k} = ?" for k in updates)
    values = list(updates.values()) + [item_id]

    conn = database.get_connection()
    cur = conn.execute(
        f"UPDATE items SET {set_clause} WHERE id = ?", values
    )
    conn.commit()

    if cur.rowcount == 0:
        conn.close()
        raise HTTPException(status_code=404, detail="Item not found")

    row = conn.execute("SELECT * FROM items WHERE id = ?", (item_id,)).fetchone()
    conn.close()
    return row_to_dict(row)


@app.delete("/items/{item_id}")
def delete_item(item_id: int):
    conn = database.get_connection()
    cur = conn.execute("DELETE FROM items WHERE id = ?", (item_id,))
    conn.commit()
    conn.close()

    if cur.rowcount == 0:
        raise HTTPException(status_code=404, detail="Item not found")
    return {"ok": True}


if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
