from passlib.context import CryptContext
from peewee import CharField, DateField, IntegerField

from .base_model import FptBaseModel
from ..core.database import database

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


class FptUserModel(FptBaseModel):
    """id_card = CharField()"""
    name = CharField()
    surnames = CharField()
    password = CharField()
    """address = CharField()
    city = CharField()
    zip_code = CharField()
    phone = CharField()
    birth_date = DateField()"""
    drinks = IntegerField()
    email = CharField()

    class Meta:
        database = database
        table_name = 'fpt_users'

    @staticmethod
    def hash_password(password):
        return pwd_context.hash(password)

    @staticmethod
    def verify_password(plain_password, hashed_password):
        return pwd_context.verify(plain_password, hashed_password)
