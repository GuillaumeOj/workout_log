from datetime import timedelta

import pytest
from fastapi.testclient import TestClient
from sqlmodel import Session, SQLModel, create_engine

from app.database import get_session
from app.main import app
from app.models.tokens import Token
from app.models.users import User
from app.settings import settings
from app.utils.auth import get_password_hash
from app.utils.tokens import create_access_token


def get_database_base_url() -> str:
    return (
        f"{settings.POSTGRES_USER}:{settings.POSTGRES_PASSWORD}"
        f"@{settings.POSTGRES_HOST}:6544/wod_board_tests"
    )


def get_databse_sync_url() -> str:
    databse_base_url = get_database_base_url()
    return f"{settings.POSTGRES_PYSCOPG}://{databse_base_url}"


sync_engine = create_engine(get_databse_sync_url())


def init_db():
    SQLModel.metadata.create_all(sync_engine)


def drop_db():
    SQLModel.metadata.drop_all(sync_engine)


@pytest.fixture(name="client")
def client_fixture(session: Session):
    def get_session_override():
        return session

    app.dependency_overrides[get_session] = get_session_override

    client = TestClient(app)
    yield client

    app.dependency_overrides.clear()


@pytest.fixture(name="session")
def session_fixture():
    init_db()
    with Session(sync_engine) as session:
        yield session
    drop_db()


@pytest.fixture(name="password")
def test_password():
    return "testpassword"


@pytest.fixture(name="foo_user")
def create_foo_user(session, password):
    user = User(username="foo", email="foo@bar.com", password=get_password_hash(password))
    session.add(user)
    session.commit()

    yield user, session


@pytest.fixture(name="foo_token")
def get_token(foo_user):
    user, session = foo_user

    access_token = create_access_token(
        data={"sub": user.email},
        expires_delta=timedelta(minutes=settings.ACCESS_TOKEN_EXPIRES_MINUTES),
    )
    token = Token(access_token=access_token, token_type="bearer")

    yield token, user, session
