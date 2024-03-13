from datetime import datetime

from pydantic import BaseModel


class EnumLocation:
    house = "HOUSE",
    square = "SQUARE"


class FptEventSchema(BaseModel):
    name: str
    date: datetime
    location: EnumLocation


class FptEventSchemaUpdate(FptEventSchema):
    name: str | None = None
    date: datetime | None = None
    location: EnumLocation | None = None
