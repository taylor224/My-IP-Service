FROM python:3.12-bookworm

ARG USERNAME=server
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

WORKDIR /usr/src/app

COPY . .

RUN apt-get update && \
    apt-get install -y build-essential libpcre3-dev && \
    apt-get clean;

ENV PIP_NO_CACHE_DIR false
RUN pip install poetry uwsgi
ADD poetry.lock .
ADD pyproject.toml .

RUN poetry config virtualenvs.create false && poetry install --no-dev --no-interaction --no-ansi --no-root

COPY . .

USER $USERNAME

CMD ["uwsgi", "--chdir", "/usr/src/app", "--pythonpath", "/usr/src/app", "--wsgi-file", "server.py", "--http", "0.0.0.0:3000", "--callable", "app"]