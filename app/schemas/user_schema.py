from datetime import date, datetime

from pydantic import BaseModel, EmailStr


class FptUserSchemaBase(BaseModel):
    name: str
    surnames: str
    email: EmailStr
    drinks: int | None = 20
    """id_card: str
    address: str | None = None
    city: str | None = None
    zip_code: str | None = None
    phone: str | None = None
    birth_date: date | None = None"""


class FptUserSchemaBaseCreate(BaseModel):
    password: str


class FptUpdateUserSchema(FptUserSchemaBase):
    name: str | None
    surnames: str | None
    email: EmailStr | None
    """id_card: str
    address: str | None = None
    city: str | None = None
    zip_code: str | None = None
    phone: str | None = None
    birth_date: date | None = None"""


class FptConsumptionSchema(BaseModel):
    consumption_user_id: str
    reader_user_id: str
    drinks: int
    consumption_datetime: datetime


class LoginSchema(BaseModel):
    email: EmailStr
    password: str
