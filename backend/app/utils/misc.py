from enum import Enum


class WodBoardEnum(Enum):
    @classmethod
    def values(cls):
        return list(map(lambda item: item.value, cls))
