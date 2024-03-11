import typing
import uuid as uuid_pkg

from sqlmodel import Field, PrimaryKeyConstraint, Relationship

from app.models.core import WodBoardBase, WodBoardDatabseBase
from app.utils.misc import WodBoardEnum

if typing.TYPE_CHECKING:
    from app.models.users import User


class WorkoutType(WodBoardEnum):
    AMRAP = "AMRAP"
    EMOM = "EMOM"
    TABATA = "TABATA"
    FOR_TIME = "For Time"
    FOR_LOAD = "For Load"


class MovementEquipmentLink(WodBoardBase, table=True):
    __table_args__ = (PrimaryKeyConstraint("movement_id", "equipment_id"),)

    equipment_id: uuid_pkg.UUID | None = Field(default=None, foreign_key="equipment.id")
    movement_id: uuid_pkg.UUID | None = Field(default=None, foreign_key="movement.id")

    equipment: "Equipment" = Relationship(back_populates="movement_links")
    movement: "Movement" = Relationship(back_populates="equipment_links")


class RoundMovementLink(WodBoardDatabseBase, table=True):
    movement_id: uuid_pkg.UUID | None = Field(default=None, foreign_key="movement.id")
    round_id: uuid_pkg.UUID | None = Field(default=None, foreign_key="round.id")

    # Extra fields
    duration_seconds: int = Field(default=0)
    position: int
    repetitions: int = Field(default=0)

    movement: "Movement" = Relationship(back_populates="round_links")
    round: "Round" = Relationship(back_populates="movement_links")


class EquipmentBase(WodBoardBase):
    name: str = Field(unique=True, index=True)


class Equipment(WodBoardDatabseBase, EquipmentBase, table=True):
    movement_links: list[MovementEquipmentLink] = Relationship(back_populates="equipment")


class EquipmentCreate(EquipmentBase):
    pass


class EquipmentSearch(EquipmentBase):
    id: uuid_pkg.UUID


class EquipmentDetail(EquipmentBase):
    id: uuid_pkg.UUID

    @classmethod
    def from_movement_equipment_link(
        cls, equipment_link: MovementEquipmentLink
    ) -> "EquipmentDetail":
        equipment = equipment_link.equipment

        return cls(name=equipment.name, id=equipment.id)


class MovementBase(WodBoardBase):
    name: str = Field(index=True, unique=True)


class Movement(WodBoardDatabseBase, MovementBase, table=True):
    round_links: list[RoundMovementLink] = Relationship(back_populates="movement")
    equipment_links: list[MovementEquipmentLink] = Relationship(
        back_populates="movement", sa_relationship_kwargs={"lazy": "selectin"}
    )


class MovementCreate(MovementBase):
    duration_seconds: int = Field(default=0)
    position: int
    repetitions: int = Field(default=0)
    equipments: list[EquipmentCreate] = []


class MovementSearch(MovementBase):
    id: uuid_pkg.UUID


class MovementDetail(MovementBase):
    id: uuid_pkg.UUID
    duration_seconds: int
    position: int
    repetitions: int
    equipments: list[EquipmentDetail] = []

    @classmethod
    def from_round_movement_link(cls, movement_link: RoundMovementLink) -> "MovementDetail":
        movement = movement_link.movement
        equiments_detail: list[EquipmentDetail] = [
            EquipmentDetail.from_movement_equipment_link(equipment_link)
            for equipment_link in movement.equipment_links
        ]

        return cls(
            id=movement.id,
            duration_seconds=movement_link.duration_seconds,
            repetitions=movement_link.repetitions,
            position=movement_link.position,
            name=movement.name,
            equipments=equiments_detail,
        )


class RoundBase(WodBoardBase):
    duration_seconds: int = Field(default=0)
    position: int
    repetitions: int = Field(default=0)


class Round(WodBoardDatabseBase, RoundBase, table=True):
    workout_id: uuid_pkg.UUID | None = Field(default=None, foreign_key="workout.id", index=True)

    workout: "Workout" = Relationship(back_populates="rounds")
    movement_links: list[RoundMovementLink] = Relationship(
        back_populates="round", sa_relationship_kwargs={"lazy": "selectin"}
    )


class RoundCreate(RoundBase):
    movements: list[MovementCreate] = []


class RoundDetail(RoundBase):
    id: uuid_pkg.UUID
    movements: list[MovementDetail] = []

    @classmethod
    def from_db(cls, round: Round) -> "RoundDetail":
        movements_detail: list[MovementDetail] = [
            MovementDetail.from_round_movement_link(movement_link)
            for movement_link in round.movement_links
        ]

        return cls(
            id=round.id,
            duration_seconds=round.duration_seconds,
            repetitions=round.repetitions,
            position=round.position,
            movements=movements_detail,
        )


class WorkoutBase(WodBoardBase):
    workout_type: WorkoutType
    name: str | None = Field(default=None)
    description: str | None = Field(default=None)


class Workout(WodBoardDatabseBase, WorkoutBase, table=True):
    user_id: uuid_pkg.UUID = Field(foreign_key="user.id", index=True)

    user: "User" = Relationship(back_populates="workouts")
    rounds: list["Round"] = Relationship(
        sa_relationship_kwargs={"cascade": "all, delete", "lazy": "selectin"},
        back_populates="workout",
    )


class WorkoutCreate(WorkoutBase):
    rounds: list[RoundCreate] = []


class WorkoutDetail(WorkoutBase):
    id: uuid_pkg.UUID
    user_id: uuid_pkg.UUID
    rounds: list[RoundDetail] = []

    @classmethod
    def from_db(cls, workout: Workout) -> "WorkoutDetail":
        rounds_detail: list[RoundDetail] = [RoundDetail.from_db(round) for round in workout.rounds]

        return cls(
            id=workout.id,
            user_id=workout.user_id,
            workout_type=workout.workout_type,
            name=workout.name,
            description=workout.description,
            rounds=rounds_detail,
        )
