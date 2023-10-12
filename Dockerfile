FROM python@sha256:5624c7648b31ecd8b03eef4b0805f3ecd8b9703a7caf2480c0d3beb2a09968b4 as builder
# FROM python:3 as builder

WORKDIR /usr/src/app

COPY pyproject.toml poetry.lock ./

RUN python -m pip install --no-cache-dir poetry==1.1.13 \
    && poetry install

FROM gcr.io/distroless/python3@sha256:e3cc51b5d1d8385d645064a2ff75c77ab3c1219db378fc36e38e82a21b14bba1
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
