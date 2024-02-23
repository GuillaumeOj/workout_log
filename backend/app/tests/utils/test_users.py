import pytest
from fastapi import HTTPException

from app.settings import settings
from app.utils.tokens import create_access_token
from app.utils.users import authenticate_user, get_current_user


@pytest.mark.asyncio
async def test_authenticate_user(foo_user, password):
    user, session = foo_user

    authenticated_user = await authenticate_user(user.email, password, session)

    assert authenticated_user.email == user.email
    assert authenticated_user.id == user.id

    with pytest.raises(ValueError) as error:
        authenticated_user = await authenticate_user(user.email, "foopassword", session)

    assert error.value.args[0] == settings.AUTHENTICATION_ERROR

    with pytest.raises(ValueError) as error:
        authenticated_user = await authenticate_user("bar@foo.com", password, session)

    assert error.value.args[0] == settings.AUTHENTICATION_ERROR


@pytest.mark.asyncio
async def test_get_current_user(foo_user):
    user, session = foo_user

    # Legit token
    token = create_access_token(data={"sub": user.email})
    current_user = await get_current_user(token, session)
    assert current_user.email == user.email

    # User has been deleted
    session.delete(user)
    session.commit()
    with pytest.raises(HTTPException):
        await get_current_user(token, session)

    # Illegal token
    token = "footoken"
    with pytest.raises(HTTPException):
        await get_current_user(token, session)
