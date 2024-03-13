import datetime
import uuid

import pytz
from fastapi import APIRouter, HTTPException, Depends
from playhouse.shortcuts import model_to_dict

from ...core.security import create_access_token, get_current_user
from ...cruds import user_crud as crud
from ...schemas.user_schema import FptConsumptionSchema as ConsumptionSchema
from ...schemas.user_schema import FptUpdateUserSchema as UserSchemaUpdate, LoginSchema
from ...schemas.user_schema import FptUserSchemaBase as UserSchema
from ...schemas.user_schema import FptUserSchemaBaseCreate as UserSchemaCreate

router = APIRouter()


@router.post("/users/login", status_code=200)
def login(credentials: LoginSchema):
    user = crud.get_user_by_email(credentials.email)
    if not user:
        raise HTTPException(status_code=401, detail="Incorrect email")
    if not crud.verify_password(credentials.password):
        raise HTTPException(status_code=401, detail="Incorrect password")
    access_token = create_access_token(data={"sub": user.email})
    return {"access_token": access_token, "token_type": "bearer"}


@router.post("/users/", response_model=UserSchema, status_code=201)
def create_user(user: UserSchemaCreate, user_credentials: dict = Depends(get_current_user)) -> UserSchema:
    db_user = crud.get_user_by_email(user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    db_user_created = crud.create_user(user=user)
    return UserSchema(**model_to_dict(db_user_created))


@router.get("/users/{user_id}", response_model=UserSchema)
def read_user(user_id: uuid.UUID, user_credentials: dict = Depends(get_current_user)) -> UserSchema:
    db_user = crud.get_user(user_id=user_id)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return UserSchema(**model_to_dict(db_user))


@router.patch("/users/{user_id}", response_model=UserSchema)
def update_user(user_id: uuid.UUID, user: UserSchemaUpdate, user_credentials: dict = Depends(get_current_user)) -> UserSchema:
    db_user = crud.update_user(user_id=user_id, user_update=user)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return UserSchema(**model_to_dict(db_user))


@router.delete("/users/{user_id}")
def delete_user(user_id: uuid.UUID, user_credentials: dict = Depends(get_current_user)):
    success = crud.delete_user(user_id)
    if not success:
        raise HTTPException(status_code=404, detail="User not found")


@router.post("/users/drinks/consume", response_model=UserSchema)
def consume_one_drink(consumption_schema: ConsumptionSchema,
                      user_credentials: dict = Depends(get_current_user)) -> UserSchema:
    db_user_consumption = UserSchemaUpdate(**model_to_dict(
        crud.get_user(uuid.UUID(consumption_schema.consumption_user_id))))
    db_user_reader = UserSchema(**model_to_dict(crud.get_user(uuid.UUID(consumption_schema.reader_user_id))))
    if db_user_consumption is None or db_user_reader is None:
        raise HTTPException(status_code=404, detail="User not found")
    if consumption_schema.consumption_datetime + datetime.timedelta(minutes=10) < datetime.datetime.now(pytz.utc):
        raise HTTPException(status_code=400, detail="More than 10 minutes have passed")
    if consumption_schema.drinks != db_user_consumption.drinks:
        raise HTTPException(status_code=400, detail="Drinks not coincident")
    db_user_consumption.drinks = db_user_consumption.drinks - 1
    db_user = crud.update_user(user_id=uuid.UUID(
        consumption_schema.consumption_user_id), user_update=db_user_consumption)
    return UserSchema(**model_to_dict(db_user))
