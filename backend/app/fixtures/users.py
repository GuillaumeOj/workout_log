import uuid

from sqlmodel import Session

from app.crud.users import create_user as crud_create_user
from app.models.users import User, UserCreate


def create_user(session: Session, password: str | None = None, default_user: bool = False) -> User:
    user_password = password or "verycomplicatedpassworD-1"

    username_uuid = uuid.uuid4()

    username = "foo" if default_user else f"foo-{username_uuid}"
    email = f"{username}@bar.com"

    user = UserCreate(
        username=username,
        email=email,
        password1=user_password,
        password2=user_password,
    )

    user = crud_create_user(user, session)

    return user
