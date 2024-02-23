import logging
from contextlib import asynccontextmanager

import daiquiri
from fastapi import FastAPI

from app.database import drop_db, init_db
from app.routers import search, users, workouts

daiquiri.setup(level=logging.INFO)


@asynccontextmanager
async def lifespan(app: FastAPI):
    del app

    init_db()
    yield

    # TODO: should be removed when migrations are setup
    drop_db()


app = FastAPI(lifespan=lifespan)


@app.get("/")
async def pong() -> dict[str, str]:
    return {"ping": "pong!"}


app.include_router(users.router)
app.include_router(workouts.router)
app.include_router(search.router)

# This should be imported here to use custom errors handlers
from app.errors import *  # noqa: F401, F403, E402
