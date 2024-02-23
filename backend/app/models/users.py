import re
import typing
import uuid as uuid_pkg

from pydantic import model_validator
from sqlmodel import Relationship
from typing_extensions import Self

from app.models.core import WodBoardBase, WodBoardDatabseBase
from app.settings import settings

if typing.TYPE_CHECKING:
    from app.models.workouts import Workout


class UserBase(WodBoardBase):
    username: str
    email: str


class User(WodBoardDatabseBase, UserBase, table=True):
    password: str

    workouts: list["Workout"] = Relationship(
        sa_relationship_kwargs={"cascade": "all, delete"}, back_populates="user"
    )


class UserCreate(UserBase):
    password1: str
    password2: str

    @model_validator(mode="after")
    def check_password_match(self) -> Self:
        password1 = self.password1
        password2 = self.password2

        if password1 is not None and password2 is not None and password1 != password2:
            raise ValueError("Passwords do not match")

        return self

    @model_validator(mode="after")
    def check_password_strenght(self) -> Self:
        at_least_one_uppercase_letter_pattern = r"(?=.*[A-Z])"
        at_least_one_digit_pattern = r"(?=.*\d)"
        at_least_one_special_character_pattern = r"(?=.*[{}])".format(
            re.escape(settings.PASSWORD_SPECIAL_CHARACTERS)
        )
        no_space_pattern = r"(?!.*\s)"
        no_username_or_email_pattern = r"(?!.*(?:{}|{}))".format(
            re.escape(self.username), re.escape(self.email)
        )

        password_pattern = re.compile(
            r"^{}{}{}{}{}.{{{},{}}}$".format(
                at_least_one_uppercase_letter_pattern,
                at_least_one_digit_pattern,
                at_least_one_special_character_pattern,
                no_space_pattern,
                no_username_or_email_pattern,
                settings.PASSWORD_MIN_LENGTH,
                "",
            )
        )

        if not bool(password_pattern.match(self.password1)):
            raise ValueError(
                f"Password is weak. It should:\n"
                f" - be at least 10 characters long,"
                f" - contain at least one uppercase letter,\n"
                f" - contain at least one digit,\n"
                f" - contain at least one special character from "
                f"[{settings.PASSWORD_SPECIAL_CHARACTERS}],\n"
                f" - not have space,\n"
                f" - not use your username or your email.\n"
            )

        return self


class UserRead(WodBoardBase):
    id: uuid_pkg.UUID
    username: str


class UserReadDetail(UserBase):
    id: uuid_pkg.UUID
