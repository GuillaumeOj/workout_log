from sqlalchemy.exc import NoResultFound
from sqlmodel import Session, select

from app.models.users import User
from app.models.workouts import (
    Equipment,
    EquipmentCreate,
    Movement,
    MovementCreate,
    MovementEquipmentLink,
    Round,
    RoundCreate,
    RoundMovementLink,
    Workout,
)


# Links
def get_or_create_movement_equipment_link(
    movement: Movement, equipment: Equipment, session: Session, commit: bool = False
) -> MovementEquipmentLink:
    try:
        statement = select(MovementEquipmentLink).where(
            MovementEquipmentLink.movement_id == movement.id,
            MovementEquipmentLink.equipment_id == equipment.id,
        )
        db_movement_equipment_link = session.exec(statement).one()
    except NoResultFound:
        db_movement_equipment_link = MovementEquipmentLink(movement=movement, equipment=equipment)
        session.add(db_movement_equipment_link)

    if commit:
        session.commit()

    return db_movement_equipment_link


# Equipments
def get_or_create_equipment(
    equipment: EquipmentCreate, session: Session, commit: bool = False
) -> Equipment:
    try:
        statement = select(Equipment).where(Equipment.name == equipment.name)
        db_equipment = session.exec(statement).one()
    except NoResultFound:
        db_equipment = Equipment.model_validate(equipment)
        session.add(db_equipment)

    if commit:
        session.commit()

    return db_equipment


def create_equipments_with_movement(
    equipments: list[EquipmentCreate], movement: Movement, session: Session, commit: bool = False
) -> list[Equipment]:
    db_equipments = []
    for equipment in equipments:
        db_equipment = get_or_create_equipment(equipment, session)
        get_or_create_movement_equipment_link(movement, db_equipment, session)

    if commit:
        session.commit()

    return db_equipments


# Movements
def get_or_create_movement(movement: MovementCreate, session: Session) -> Movement:
    try:
        statement = select(Movement).where(Movement.name == movement.name)
        db_movement = session.exec(statement).one()
    except NoResultFound:
        db_movement = Movement.model_validate(movement)
        session.add(db_movement)

    return db_movement


def create_movements_with_round(
    movements: list[MovementCreate], round: Round, session: Session, commit: bool = False
) -> list[Movement]:
    db_movements = []
    round_movement_links = []
    for movement in movements:
        db_movement = get_or_create_movement(movement, session)
        create_equipments_with_movement(movement.equipments, db_movement, session)
        round_movement_link = RoundMovementLink(
            movement=db_movement,
            round=round,
            duration_seconds=movement.duration_seconds,
            position=movement.position,
            repetitions=movement.repetitions,
        )
        round_movement_links.append(round_movement_link)
        db_movements.append(db_movement)

    session.add_all(round_movement_links)

    if commit:
        session.commit()

    return db_movements


# Rounds
def create_rounds(rounds: list[RoundCreate], session: Session, commit: bool = False) -> list[Round]:
    db_rounds = []
    for round in rounds:
        db_round = Round.model_validate(round)
        db_rounds.append(db_round)
        create_movements_with_round(round.movements, db_round, session)

    session.add_all(db_rounds)

    if commit:
        session.commit()

    return db_rounds


def get_workouts_by_user_id(user: User, session: Session) -> list[Workout]:
    db_workouts = session.exec(select(Workout).where(Workout.user_id == user.id)).all()

    return list(db_workouts)
