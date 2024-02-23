import daiquiri
from sqlalchemy.exc import NoResultFound
from sqlmodel import Session, select

from app.models.users import User, UserCreate
from app.utils.auth import get_password_hash

logger = daiquiri.getLogger(__name__)


def get_user_by_email(email: str, session: Session) -> User:
    error_exception = ValueError(f"The user with this email ({email}) do not exist")

    statement = select(User).where(User.email == email)

    try:
        user = session.exec(statement).one()
    except NoResultFound:
        raise error_exception

    return user


def create_user(user: UserCreate, session: Session) -> User:
    hashed_password = get_password_hash(user.password1)
    db_user = User(username=user.username, email=user.email, password=hashed_password)

    session.add(db_user)
    session.commit()
    session.refresh(db_user)

    return db_user
