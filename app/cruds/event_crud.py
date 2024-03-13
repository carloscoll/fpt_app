# crud_event.py
import uuid
from app.models.event_model import FptEventModel
from app.schemas.event_schema import FptEventSchema, FptEventSchemaUpdate
from peewee import DoesNotExist


def get_event(event_id: uuid.UUID):
    try:
        return FptEventModel.get(FptEventModel.id == str(event_id), FptEventModel.active)
    except DoesNotExist:
        return None


def create_event(event: FptEventSchema):
    return FptEventModel.create(
        name=event.name,
        event_datetime=event.event_datetime
    )


def update_event(event_id: uuid.UUID, event_update: FptEventSchemaUpdate):
    query = FptEventModel.update(**event_update.model_dump(exclude_unset=True)).where(FptEventModel.id == str(event_id))
    query.execute()
    return get_event(event_id)
