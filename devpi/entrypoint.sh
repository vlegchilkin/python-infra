#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function kill_devpi() {
    _PID=$(pgrep devpi-server)
    echo "ENTRYPOINT: Sending SIGTERM to PID $_PID"
    kill -SIGTERM "$_PID"
}

if [ "${1:-}" == "bash" ]; then
    exec "$@"
fi

if [ ! -d "$DEVPI_SERVER_ROOT" ]; then
    echo "ENTRYPOINT: Creating devpi-server root"
    mkdir -p "$DEVPI_SERVER_ROOT"
fi

initialize=no
if [ ! -f "$DEVPI_SERVER_ROOT/.serverversion" ]; then
    initialize=yes
    echo "ENTRYPOINT: Initializing server root $DEVPI_SERVER_ROOT"
    devpi-init --serverdir "$DEVPI_SERVER_ROOT"
fi

echo "ENTRYPOINT: Starting devpi-server"
devpi-server --host 0.0.0.0 --port 3141 --serverdir "$DEVPI_SERVER_ROOT" "$@" &

timeout 10 bash -c 'until printf "" 2>>/dev/null >>/dev/tcp/$0/$1; do sleep 1; done' localhost 3141

echo "ENTRYPOINT: Installing signal traps"
trap kill_devpi SIGINT SIGTERM

if [ "$initialize" == "yes" ]; then
    echo "ENTRYPOINT: Initializing devpi-server"
    devpi use http://localhost:3141
    devpi login root --password=''
    echo "ENTRYPOINT: Setting root password to $DEVPI_ROOT_PASSWORD"
    devpi user -m root "password=$DEVPI_ROOT_PASSWORD"
    echo -n "$DEVPI_ROOT_PASSWORD" > "$DEVPI_SERVER_ROOT/.root_password"
    devpi index -c root/local bases=root/pypi volatile=True
    devpi logoff
fi

echo "ENTRYPOINT: Watching devpi-server"
PID=$(pgrep devpi-server)

if [ -z "$PID" ]; then
    echo "ENTRYPOINT: Could not determine PID of devpi-server!"
    exit 1
fi

set +e

while : ; do
    kill -0 "$PID" > /dev/null 2>&1 || break
    sleep 2s
done

echo "ENTRYPOINT: devpi-server died, exiting..."