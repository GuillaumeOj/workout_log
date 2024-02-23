from typing import Annotated

from fastapi import APIRouter, Depends, status
from sqlmodel import Session, col, select

from app.database import get_session
from app.models.users import User
from app.models.workouts import Equipment, EquipmentSearch, Movement, MovementSearch
from app.utils.users import get_current_user

router = APIRouter(prefix="/search", tags=["search"])


def search_equipment(session: Session, equipment: str) -> list[EquipmentSearch]:
    equipment_name = equipment.lower()

    statement = select(Equipment).where(col(Equipment.name).ilike(f"%{equipment_name}%"))
    db_equipments = session.exec(statement).all()

    return [EquipmentSearch.model_validate(db_equipment) for db_equipment in db_equipments]


def search_movement(session: Session, movement: str) -> list[MovementSearch]:
    movement_name = movement.lower()

    statement = select(Movement).where(col(Movement.name).ilike(f"%{movement_name}%"))
    db_movements = session.exec(statement).all()

    return [MovementSearch.model_validate(db_movement) for db_movement in db_movements]


@router.get("", status_code=status.HTTP_200_OK)
async def search(
    current_user: Annotated[User, Depends(get_current_user)],
    session: Annotated[Session, Depends(get_session)],
    equipment: str | None = None,
    movement: str | None = None,
) -> list[EquipmentSearch] | list[MovementSearch]:
    if equipment is not None:
        return search_equipment(session, equipment)
    if movement is not None:
        return search_movement(session, movement)

    return []
