from sqlmodel import Session

from app.crud.workout import create_rounds
from app.models.users import User
from app.models.workouts import (
    Equipment,
    Movement,
    MovementCreate,
    RoundCreate,
    Workout,
    WorkoutType,
)


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


def create_workout(session: Session, user: User) -> Workout:
    round = RoundCreate(position=1, repetitions=5)
    movement = MovementCreate(name="squat", position=1, repetitions=5)
    round.movements.append(movement)

    rounds = create_rounds([round], session)

    workout = Workout(
        workout_type=WorkoutType.AMRAP,
        name="Test workout",
        description="This is a test workout",
        user_id=user.id,
        rounds=rounds,
    )
    session.add(workout)
    session.commit()
    session.refresh(workout)

    return workout
