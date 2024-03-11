import uuid

from sqlmodel import Session

from app.crud.users import create_user as crud_create_user
from app.models.users import User, UserCreate


def create_user(session: Session, password: str | None = None) -> User:
    user_password = password or "verycomplicatedpassworD-1"

    username_uuid = uuid.uuid4()
    user = UserCreate(
        username=f"foo-{username_uuid}",
        email=f"foo-{username_uuid}@bar.com",
        password1=user_password,
        password2=user_password,
    )

    user = crud_create_user(user, session)

    return user
