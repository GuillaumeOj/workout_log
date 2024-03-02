import daiquiri
from fastapi.testclient import TestClient
from sqlmodel import Session, select

from app.models.tokens import Token
from app.models.users import User
from app.models.workouts import (
    Equipment,
    Movement,
    Round,
    Workout,
    WorkoutDetail,
    WorkoutType,
)

logger = daiquiri.getLogger(__name__)


def test_create_workout(client: TestClient, foo_token: tuple[Token, User, Session]):
    token, user, session = foo_token

    # User is not authenticated
    response = client.post("/workouts")
    assert response.status_code == 401

    # User send empty workout
    headers = {"Authorization": f"{token.token_type} {token.access_token}"}
    response = client.post("/workouts", headers=headers)
    assert response.status_code == 422

    invalid_workout_type = {"workoutType": "foo"}

    # User sends an invalid WorkoutType
    response = client.post("/workouts", json=invalid_workout_type, headers=headers)
    response_detail = response.json()["detail"]
    assert response.status_code == 422
    assert (
        response_detail[0]["msg"]
        == "Input should be 'AMRAP', 'EMOM', 'TABATA', 'For Time' or 'For Load'"
    )

    # User sends a valid WorkoutType
    valid_workout_type = {"workoutType": "AMRAP"}
    response = client.post("/workouts", json=valid_workout_type, headers=headers)
    assert response.status_code == 201
    # Workout is saved in the database
    db_workout = session.exec(select(Workout).where(Workout.user_id == user.id)).all()
    assert len(db_workout) == 1
    db_workout_detail = WorkoutDetail.model_validate(db_workout[0]).model_dump(
        mode="json", by_alias=True
    )
    assert db_workout_detail == response.json()


def test_create_workout_with_rounds_and_movements(
    client: TestClient, foo_token: tuple[Token, User, Session]
):
    token, user, session = foo_token
    headers = {"Authorization": f"{token.token_type} {token.access_token}"}

    # User sends a workouts with rounds and movements
    valid_workout_with_rounds = {
        "workoutType": "AMRAP",
        "rounds": [
            {
                "durationSeconds": 0,
                "position": 1,
                "repetition": 0,
                "movements": [
                    {
                        "name": "Push Up",
                        "position": 1,
                        "repetition": 100,
                    },
                    {
                        "name": "Pull Up",
                        "position": 2,
                        "repetition": 200,
                    },
                    {
                        "name": "Push Up",
                        "position": 3,
                        "repetition": 100,
                    },
                ],
            },
            {
                "position": 2,
                "movements": [
                    {
                        "name": "Deadlift",
                        "position": 1,
                        "repetition": 20,
                        "equipments": [
                            {
                                "name": "Barbell",
                            }
                        ],
                    }
                ],
            },
        ],
    }
    response = client.post("/workouts", json=valid_workout_with_rounds, headers=headers)
    assert response.status_code == 201

    # Workout is saved in the database
    db_workout = session.exec(select(Workout).where(Workout.user_id == user.id)).all()
    assert len(db_workout) == 1

    # Two rounds are created
    db_rounds = session.exec(select(Round)).all()
    assert len(db_rounds) == 2

    # Push up is not duplicated
    db_movements = session.exec(select(Movement)).all()
    assert len(db_movements) == 3

    # One equipment is created
    db_equipments = session.exec(select(Equipment)).all()
    assert len(db_equipments) == 1

    response_detail = response.json()
    rounds_detail = response_detail["rounds"]
    assert len(rounds_detail) == 2
    assert len(rounds_detail[0]["movements"]) == 3

    # User is authenticated and sends a workout with an invalid token
    invalid_headers = {"Authorization": f"{token.token_type} invalid_token"}
    response = client.post("/workouts", json=valid_workout_with_rounds, headers=invalid_headers)
    assert response.status_code == 401
    # No extra workout in the database
    db_workout = session.exec(select(Workout).where(Workout.user_id == user.id)).all()
    assert len(db_workout) == 1


def test_get_workout_types(client: TestClient):
    response = client.get("/workouts/workout-types")

    assert response.status_code == 200
    assert response.json() == {"values": WorkoutType.values()}
