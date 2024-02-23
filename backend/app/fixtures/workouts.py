from sqlmodel import Session

from app.models.workouts import Equipment, Movement


def create_equiments(session: Session) -> None:
    equipment_names = [
        "barbell",
        "dumbbell",
        "kettlebell",
        "pull-up bar",
        "rings",
        "jump rope",
        "box",
        "bench",
    ]

    equipments = [Equipment(name=equipment.capitalize()) for equipment in equipment_names]

    session.add_all(equipments)
    session.commit()


def create_movements(session: Session) -> None:
    movement_names = [
        "squat",
        "deadlift",
        "bench press",
        "overhead press",
        "pull-up",
        "dip",
        "push-up",
        "row",
    ]

    movements = [Movement(name=movement.capitalize()) for movement in movement_names]

    session.add_all(movements)
    session.commit()
