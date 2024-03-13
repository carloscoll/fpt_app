from fastapi import FastAPI
from app.core.database import database
from .models.event_model import FptEventModel
from .models.user_model import FptUserModel
from .v1.endpoints.users_endpoints import router as user_router

app = FastAPI()

app.include_router(user_router)


@app.on_event("startup")
async def startup():
    if database.is_closed():
        database.connect()
    database.create_tables([FptUserModel, FptEventModel], safe=True)


@app.on_event("shutdown")
async def shutdown():
    if not database.is_closed():
        database.close()
