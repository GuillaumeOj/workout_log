from sqlmodel import Session

from app.crud.users import create_user as crud_create_user
from app.models.users import UserCreate


def create_user(session: Session) -> None:
    user = UserCreate(
        username="foo",
        email="foo@bar.com",
        password1="verycomplicatedpassworD-1",
        password2="verycomplicatedpassworD-1",
    )

    crud_create_user(user, session)
