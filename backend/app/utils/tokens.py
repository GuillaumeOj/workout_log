from datetime import datetime, timedelta

import jwt

from app.settings import settings


def create_access_token(data: dict, expires_delta: timedelta | None = None) -> str:
    to_encode = data.copy()

    if expires_delta:
        expire = datetime.now(settings.TIMEZONE) + expires_delta
    else:
        expire = datetime.now(settings.TIMEZONE) + timedelta(
            minutes=settings.ACCESS_TOKEN_EXPIRES_MINUTES
        )

    to_encode.update({"exp": expire})

    encoded_jwt = jwt.encode(
        to_encode, settings.SECRET_KEY, algorithm=settings.ACCESS_TOKEN_ALGORITHM
    )

    return encoded_jwt
