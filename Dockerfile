FROM python:3-slim-buster

ARG ENV_FILE

ENV ENV_FILE=${ENV_FILE} \
    PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VERSION=1.1.13


# System deps:
RUN apt-get update && apt-get upgrade -y && apt-get install gcc -y
RUN apt-get install google-chrome-stable -y
RUN pip install "poetry==$POETRY_VERSION"

# Copy only requirements to cache them in docker layer
WORKDIR /app
COPY poetry.lock pyproject.toml /app/


# Project initialization:
RUN poetry config virtualenvs.create false \
  && poetry install --no-interaction --no-ansi

# Creating folders, and files for a project:
COPY . /app/


CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]
