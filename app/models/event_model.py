from peewee import DateTimeField, CharField

from .base_model import FptBaseModel
from ..core.database import database


class FptEventModel(FptBaseModel):
    name = CharField()
    event_datetime = DateTimeField()

    class Meta:
        database = database
        table_name = 'fpt_events'
