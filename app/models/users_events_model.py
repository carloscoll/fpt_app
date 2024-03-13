from peewee import ForeignKeyField, CompositeKey

from app.models.base_model import FptBaseModel
from app.models.event_model import FptEventModel
from app.models.user_model import FptUserModel
from app.core.database import database


class FptUsersEventsModel(FptBaseModel):
    user = ForeignKeyField(FptUserModel, backref='events')
    event = ForeignKeyField(FptEventModel, backref='users')

    class Meta:
        database = database
        primary_key = CompositeKey('user', 'event')
        table_name = 'fpt_users_events'
