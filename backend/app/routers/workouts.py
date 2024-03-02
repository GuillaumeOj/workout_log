from typing import Annotated

from fastapi import APIRouter, Depends, status
from sqlmodel import Session

from app.crud.workout import create_rounds
from app.database import get_session
from app.models.users import User
from app.models.workouts import Workout, WorkoutCreate, WorkoutDetail, WorkoutType
from app.utils.users import get_current_user

router = APIRouter(prefix="/workouts", tags=["workouts"])


@router.post("", response_model=WorkoutDetail, status_code=status.HTTP_201_CREATED)
async def create_workout(
    workout: WorkoutCreate,
    current_user: Annotated[User, Depends(get_current_user)],
    session: Session = Depends(get_session),
):
    rounds = create_rounds(workout.rounds, session)

    db_workout = Workout(
        workout_type=workout.workout_type,
        name=workout.name,
        description=workout.description,
        user_id=current_user.id,
        rounds=rounds,
    )

    session.add(db_workout)
    session.commit()
    session.refresh(db_workout)

    return WorkoutDetail.from_db(db_workout)


@router.get("/workout-types", response_model=dict, status_code=status.HTTP_200_OK)
async def get_workout_types():
    """Retrieve all the available workout types.

    Returns:
        dict: A dictionary with the available workout types under the key "values".
    """
    return {"values": [workout_type for workout_type in WorkoutType]}
