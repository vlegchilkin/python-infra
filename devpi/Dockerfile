FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get -y install gcc procps
RUN python -m pip install --upgrade pip

RUN mkdir -p /devpi/server

WORKDIR devpi

RUN pip install "devpi-server>=6.10.0" "devpi-client>=7.0.2" "devpi-web>=4.2.1"

EXPOSE 3141

COPY --chmod=555 entrypoint.sh ./entrypoint.sh
CMD ["./entrypoint.sh"]
