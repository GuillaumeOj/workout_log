#!/bin/sh
poetry run python manage.py makemigrations --no-input
poetry rn python manage.py migrate --no-input
exec "$@"
