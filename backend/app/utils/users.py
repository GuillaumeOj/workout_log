from typing import Annotated

import daiquiri
import jwt
from fastapi import Depends, HTTPException, status
from sqlmodel import Session

from app.crud.users import get_user_by_email
from app.database import get_session
from app.models.users import User
from app.settings import settings
from app.utils.auth import oauth2_scheme, verify_password

logger = daiquiri.getLogger(__name__)


async def authenticate_user(
    username: str,
    password: str,
    session: Annotated[Session, Depends(get_session)],
) -> User:
    # Oauth2 specify a username, but in our case this is the email of the user
    try:
        user = get_user_by_email(username, session)
    except ValueError:
        raise ValueError(settings.AUTHENTICATION_ERROR)

    if not verify_password(password, user.password):
        raise ValueError(settings.AUTHENTICATION_ERROR)

    return user


async def get_current_user(
    token: Annotated[str, Depends(oauth2_scheme)],
    session: Annotated[Session, Depends(get_session)],
) -> User:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate crendentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(
            token, settings.SECRET_KEY, algorithms=[settings.ACCESS_TOKEN_ALGORITHM]
        )
        email: str | None = payload.get("sub")
    except jwt.exceptions.InvalidTokenError:
        raise credentials_exception

    if email is None:
        raise credentials_exception

    try:
        user = get_user_by_email(email, session)
    except ValueError:
        raise credentials_exception

    return user
