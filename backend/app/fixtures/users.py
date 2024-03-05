from sqlmodel import Session

from app.crud.users import create_user as crud_create_user
from app.models.users import User, UserCreate


def create_user(session: Session) -> User:
    user = UserCreate(
        username="foo",
        email="foo@bar.com",
        password1="verycomplicatedpassworD-1",
        password2="verycomplicatedpassworD-1",
    )

    user = crud_create_user(user, session)

    return user
