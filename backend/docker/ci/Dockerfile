FROM python:3.12-slim

WORKDIR /app

# Set env variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update \
  && apt-get install -y gcc python3-dev musl-dev libmagic1 libffi-dev netcat-traditional \
  build-essential libpq-dev

COPY poetry.lock pyproject.toml /app/

# Install and configure poetry
RUN pip3 install poetry
RUN poetry config virtualenvs.create false
RUN poetry install

COPY . /app

# Copy entrypoint.sh
COPY ./docker/ci/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
