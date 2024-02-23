import jwt
from fastapi.testclient import TestClient
from sqlmodel import Session, exists, select

from app.models.users import User
from app.settings import settings


def test_signup(client: TestClient, session: Session):
    test_user = {
        "username": "foo",
        "email": "foo@bar.com",
        "password1": "testpassword",
        "password2": "testpassword",
    }

    response = client.post("/users/signup", json=test_user)

    # Password is weak
    assert response.status_code == 422
    response_detail = response.json()["detail"]
    assert len(response_detail) == 1
    assert "Value error, Password is weak" in response_detail[0]["msg"]
    statement = select(exists(select(User).where(User.username == test_user["username"])))
    assert session.scalar(statement) is False

    # Password are not matching
    test_user["password1"] = "verycomplicatedpassworD-1"
    response = client.post("/users/signup", json=test_user)

    assert response.status_code == 422

    response_detail = response.json()["detail"]
    assert len(response_detail) == 1
    assert "Value error, Passwords do not match" in response_detail[0]["msg"]
    statement = select(exists(select(User).where(User.username == test_user["username"])))
    assert session.scalar(statement) is False

    # User is correcly created
    test_user["password2"] = test_user["password1"]
    response = client.post("/users/signup", json=test_user)

    assert response.status_code == 201

    response_detail = response.json()
    db_user = session.exec(select(User).where(User.username == test_user["username"])).one()
    assert response_detail["id"] == str(db_user.id)
    assert response_detail["username"] == test_user["username"] == db_user.username
    assert response_detail["email"] == test_user["email"] == db_user.email

    # User already exits
    response = client.post("/users/signup", json=test_user)

    assert response.status_code == 422

    response_detail = response.json()["detail"]
    assert response_detail[0]["msg"] == "Username or email already used"

    db_users = session.exec(select(User).where(User.username == test_user["username"])).all()
    assert len(db_users) == 1


def test_login_for_access_token(client: TestClient, foo_user, password):
    user, _ = foo_user
    # Empty fields
    response = client.post("/users/token", data={"username": "", "password": ""})

    assert response.status_code == 422

    response_detail = response.json()
    for error in response_detail["detail"]:
        assert error["msg"] == "Field required"
        for loc in error["loc"]:
            assert loc in ["body", "username", "password"]

    # Wrong username
    response = client.post("/users/token", data={"username": user.username, "password": password})

    assert response.status_code == 401
    response_detail = response.json()
    assert response_detail["detail"] == "Username and/or password are wrong"

    # Wrong password
    response = client.post("/users/token", data={"username": user.email, "password": "foopassword"})

    assert response.status_code == 401
    response_detail = response.json()
    assert response_detail["detail"] == "Username and/or password are wrong"

    # Correct password and Username
    response = client.post("/users/token", data={"username": user.email, "password": password})

    assert response.status_code == 200
    response_detail = response.json()
    token = response_detail["access_token"]
    payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ACCESS_TOKEN_ALGORITHM])
    assert payload["sub"] == user.email


def test_get_users_me(client: TestClient, foo_token):
    token, _, _ = foo_token

    # With legit token
    response = client.get(
        "users/me",
        headers={"Authorization": f"{token.token_type} {token.access_token}"},
    )

    assert response.status_code == 200

    # Without token
    response = client.get("users/me")
    assert response.status_code == 401

    # With wrong token
    response = client.get(
        "users/me",
        headers={"Authorization": f"{token.token_type} footoken"},
    )
    assert response.status_code == 401
