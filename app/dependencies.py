from app.core.database import database


def get_db():
    db = database
    try:
        yield db
    finally:
        db.close()
