FROM python@sha256:eeed7cac682f9274d183f8a7533ee1360a26acb3616aa712b2be7896f80d8c5f as builder
# FROM python:3 as builder

WORKDIR /usr/src/app

COPY pyproject.toml poetry.lock ./

RUN python -m pip install --no-cache-dir poetry==1.1.13 \
    && poetry install

FROM gcr.io/distroless/python3@sha256:c472650ee9b43ce1bb7efa2960c95c046fa44f7258ae22f9ceb3d3f49f26d010
# FROM gcr.io/distroless/python3:latest

EXPOSE 5000

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

WORKDIR /app
COPY . /app

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
