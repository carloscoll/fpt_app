import uuid
from peewee import Model, DateTimeField, BooleanField, CharField, SQL
from ..core.database import database


class FptBaseModel(Model):
    id = CharField(primary_key=True, default=lambda: str(uuid.uuid4()))
    created_at = DateTimeField(default=SQL('CURRENT_TIMESTAMP'))
    updated_at = DateTimeField(default=SQL('CURRENT_TIMESTAMP'))
    active = BooleanField(default=True)

    class Meta:
        database = database
        abstract = True
