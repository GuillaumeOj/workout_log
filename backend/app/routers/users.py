from datetime import timedelta
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.exceptions import RequestValidationError
from fastapi.security import OAuth2PasswordRequestForm
from sqlmodel import Session, exists, select

from app.crud.users import create_user
from app.database import get_session
from app.models.tokens import Token
from app.models.users import User, UserCreate, UserReadDetail
from app.settings import settings
from app.utils.tokens import create_access_token
from app.utils.users import authenticate_user, get_current_user

router = APIRouter(prefix="/users", tags=["users"])


@router.post("/signup", response_model=UserReadDetail, status_code=status.HTTP_201_CREATED)
async def signup(user: UserCreate, session: Annotated[Session, Depends(get_session)]):
    existing_user = session.scalar(
        select(
            exists(
                select(User).where((User.username == user.username) | (User.email == user.email))
            )
        )
    )
    if existing_user:
        raise RequestValidationError(errors=[{"msg": "Username or email already used"}])

    db_user = create_user(user, session)

    return UserReadDetail.model_validate(db_user)


@router.post("/token", response_model=Token)
async def login_for_access_token(
    form_data: Annotated[OAuth2PasswordRequestForm, Depends()],
    session: Annotated[Session, Depends(get_session)],
):
    try:
        user = await authenticate_user(form_data.username, form_data.password, session)
    except ValueError as error:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=error.args[0],
            headers={"WWW-Authenticate": "Bearer"},
        )

    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRES_MINUTES)
    access_token = create_access_token(data={"sub": user.email}, expires_delta=access_token_expires)

    return Token(access_token=access_token, token_type="bearer")


@router.get("/me", response_model=UserReadDetail)
async def get_users_me(current_user: Annotated[User, Depends(get_current_user)]):
    user = UserReadDetail.model_validate(current_user)

    return user
