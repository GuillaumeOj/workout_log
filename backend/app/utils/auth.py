import bcrypt
from fastapi.security import OAuth2PasswordBearer

from app.settings import settings

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/users/token")


def verify_password(
    plain_password: str,
    hashed_password: str,
) -> bool:
    bytes_plain_password = bytes(plain_password, settings.ENCODING)
    bytes_hashed_password = bytes(hashed_password, settings.ENCODING)
    return bcrypt.checkpw(bytes_plain_password, bytes_hashed_password)


def get_password_hash(password: str) -> str:
    if password == "":
        raise ValueError("Password should not be an empty string")

    bytes_password = bytes(password, settings.ENCODING)
    return bcrypt.hashpw(bytes_password, bcrypt.gensalt()).decode(settings.ENCODING)
