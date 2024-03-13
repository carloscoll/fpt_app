# crud.py
import uuid

from peewee import DoesNotExist

from app.models.user_model import FptUserModel
from app.schemas.user_schema import FptUserSchemaBaseCreate, FptUpdateUserSchema


def get_user(user_id: uuid.UUID):
    try:
        return FptUserModel.get(FptUserModel.id == str(user_id), FptUserModel.active)
    except DoesNotExist:
        return None


def get_user_by_email(email: str):
    try:
        return FptUserModel.get(FptUserModel.email == email, FptUserModel.active)
    except DoesNotExist:
        return None


def get_all():
    return FptUserModel.select().where(FptUserModel.active)


def create_user(user: FptUserSchemaBaseCreate):
    user.password = FptUserModel.hash_password(user.password)
    return FptUserModel.create(**user.model_dump())


def update_user(user_id: uuid.UUID, user_update: FptUpdateUserSchema):
    query = FptUserModel.update(**user_update.model_dump(exclude_unset=True)).where(FptUserModel.id == str(user_id))
    query.execute()
    return get_user(user_id)


def delete_user(user_id: uuid.UUID):
    query = FptUserModel.update(active=False).where(FptUserModel.id == str(user_id))
    query.execute()
    return True


def verify_password(password: str):
    return FptUserModel.verify_password(password, FptUserModel.hash_password(password))
