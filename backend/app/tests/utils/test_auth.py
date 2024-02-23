import bcrypt
import pytest

from app.utils.auth import get_password_hash, verify_password


def test_get_password_hash(password, mocker):
    spy = mocker.spy(bcrypt, "hashpw")

    # Good string has password
    hashed_password = get_password_hash(password)
    assert spy.call_count == 1
    assert hashed_password != password

    spy.reset_mock()

    # Empty password
    with pytest.raises(ValueError):
        get_password_hash("")
    assert spy.call_count == 0

    # Password with special characters
    hashed_password = get_password_hash("passwordwithspecialcharacter😄")
    assert spy.call_count == 1
    assert hashed_password != password


def test_verify_password(password, mocker):
    spy = mocker.spy(bcrypt, "checkpw")

    hashed_password = get_password_hash(password)

    # Matching password
    result = verify_password(password, hashed_password)
    assert result is True
    assert spy.call_count == 1

    spy.reset_mock()

    # Wrong password
    result = verify_password("foopasword", hashed_password)
    assert result is False
    assert spy.call_count == 1

    spy.reset_mock()

    # Empty password
    result = verify_password("", hashed_password)
    assert result is False
    assert spy.call_count == 1

    spy.reset_mock()

    # Password with special characters
    password_with_special_character = "passwordwithspecialcharacter😄"
    hashed_password = get_password_hash(password_with_special_character)
    result = verify_password(password_with_special_character, hashed_password)
    assert result is True
    assert spy.call_count == 1
