ARG PYTHON_VERSION=3.12
FROM python:${PYTHON_VERSION}-slim

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get -y install build-essential

RUN useradd -m worker
USER worker

ENV PYTHONFAULTHANDLER=1 \
  PYTHONBREAKPOINT=0 \
  PYTHONUNBUdockerFFERED=1 \
  PYTHONHASHSEED=random \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  POETRY_VIRTUALENVS_CREATE=false \
  PATH="/home/worker/.local/bin:${PATH}"

WORKDIR /app

COPY --chown=worker entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

ARG SERVER_PORT="8080"
EXPOSE ${SERVER_PORT}

ENTRYPOINT ["./entrypoint.sh"]
CMD ["python"]