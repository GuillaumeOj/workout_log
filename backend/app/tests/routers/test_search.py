from fastapi import status
from fastapi.testclient import TestClient
from sqlmodel import Session

from app.fixtures.workouts import create_equiments, create_movements
from app.models.tokens import Token
from app.models.users import User


def test_search(client: TestClient, foo_token: tuple[Token, User, Session]):
    token, _, session = foo_token

    # User is not authenticated
    response = client.get("/search")
    assert response.status_code == status.HTTP_401_UNAUTHORIZED

    # User send empty search
    headers = {"Authorization": f"{token.token_type} {token.access_token}"}
    response = client.get("/search", headers=headers)
    assert response.status_code == status.HTTP_200_OK

    create_equiments(session)

    # User send search for equipment
    expected_equipment_names = ["Barbell", "Dumbbell", "Kettlebell"]
    response = client.get("/search?equipment=bell", headers=headers)
    assert response.status_code == status.HTTP_200_OK
    for equipment in response.json():
        assert equipment["name"] in expected_equipment_names

    response = client.get("/search?equipment=foo", headers=headers)
    assert response.status_code == status.HTTP_200_OK
    assert response.json() == []

    create_movements(session)

    # Use send search for movement
    expected_movement_names = ["Bench press", "Overhead press"]
    response = client.get("/search?movement=press", headers=headers)
    assert response.status_code == status.HTTP_200_OK
    for movement in response.json():
        assert movement["name"] in expected_movement_names

    response = client.get("/search?movement=foo", headers=headers)
    assert response.status_code == status.HTTP_200_OK
    assert response.json() == []

    # Other objects are not searchable
    response = client.get("/search?foo=bar", headers=headers)
    assert response.status_code == status.HTTP_200_OK
