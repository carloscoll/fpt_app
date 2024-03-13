"""import uuid
from typing import List

from fastapi import APIRouter, HTTPException, Depends

from ...cruds import event_crud as crud
from ...dependencies import get_db
from ...models.event_model import FptEventModel
from ...schemas.event_schema import FptEventSchema as eventSchema
from ...schemas.event_schema import FptEventSchemaUpdate as eventSchemaUpdate
from ...schemas.user_schema import FptUserSchema

router = APIRouter()


@router.post("/events/", response_model=eventSchema, status_code=201)
def create_user(event: eventSchema, db: Session = Depends(get_db)):
    return crud.create_event(db=db, event=event)


@router.get("/events/{event_id}", response_model=eventSchema)
def read_user(event_id: uuid.UUID, db: Session = Depends(get_db)):
    db_event = crud.get_event(db, event_id=event_id)
    if db_event is None:
        raise HTTPException(status_code=404, detail="Event not found")
    return db_event


@router.patch("/events/{event_id}", response_model=eventSchema)
def update_user(event_id: uuid.UUID, event: eventSchemaUpdate, db: Session = Depends(get_db)):
    db_event = crud.update_event(db, event_id=event_id, event_update=event)
    if db_event is None:
        raise HTTPException(status_code=404, detail="Event not found")
    return db_event


@router.get("/events/{event_id}/attendees", response_model=List[FptUserSchema])
def get_event_attendees(event_id: int, db: Session = Depends(get_db)):
    event = db.query(FptEventModel).filter(FptEventModel.id == event_id).first()
    if event is None:
        raise HTTPException(status_code=404, detail="Event not found")
    return event.usuarios"""
