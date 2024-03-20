from sqlmodel import Session, SQLModel, create_engine

from app.fixtures.users import create_user
from app.fixtures.workouts import create_equiments, create_movements, create_workout
from app.models.users import *  # noqa: F401, F403
from app.models.workouts import *  # noqa: F401, F403
from app.settings import settings


def get_database_base_url() -> str:
    return (
        f"{settings.POSTGRES_USER}:{settings.POSTGRES_PASSWORD}"
        f"@{settings.POSTGRES_HOST}:{settings.POSTGRES_PORT}/{settings.POSTGRES_DB}"
    )


def get_databse_sync_url() -> str:
    databse_base_url = get_database_base_url()
    return f"{settings.POSTGRES_PYSCOPG}://{databse_base_url}"


sync_engine = create_engine(get_databse_sync_url(), echo=True)


def get_session():
    with Session(sync_engine) as session:
        yield session


def init_db():
    SQLModel.metadata.create_all(sync_engine)

    # Create fake data
    with Session(sync_engine) as session:
        create_equiments(session)
        create_movements(session)
        user = create_user(session, default_user=True)
        create_workout(session, user)


def drop_db():
    SQLModel.metadata.drop_all(sync_engine)
