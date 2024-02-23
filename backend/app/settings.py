import os
from datetime import UTC, timezone
from functools import lru_cache
from pathlib import Path

from dotenv import load_dotenv
from pydantic_settings import BaseSettings

load_dotenv()
CWD = Path.cwd()
ROOT_DIR = CWD.parent


class Settings(BaseSettings):
    # General settings
    SECRET_KEY: str = os.environ["SECRET_KEY"]
    ENCODING: str = "utf-8"
    TIMEZONE: timezone = UTC

    # Authentication
    ACCESS_TOKEN_ALGORITHM: str = os.environ["ALGORITHM"]
    ACCESS_TOKEN_EXPIRES_MINUTES: int = 7 * 24 * 60  # 7 days in minutes
    AUTHENTICATION_ERROR: str = "Username and/or password are wrong"
    PASSWORD_MIN_LENGTH: int = 10
    PASSWORD_SPECIAL_CHARACTERS: str = "!@#$%^&*()_+{}[]:;<>,.?~\\/-"

    # Database
    POSTGRES_HOST: str = os.environ["POSTGRES_HOST"]
    POSTGRES_PORT: str = os.environ["POSTGRES_PORT"]
    POSTGRES_DB: str = os.environ["POSTGRES_DB"]
    POSTGRES_USER: str = os.environ["POSTGRES_USER"]
    POSTGRES_PASSWORD: str = os.environ["POSTGRES_PASSWORD"]
    POSTGRES_PYSCOPG: str = "postgresql+psycopg"
    POSTGRES_ASYNCPG: str = "postgresql+asyncpg"


@lru_cache
def get_settings():
    return Settings()


settings = get_settings()
