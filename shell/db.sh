#!/bin/bash

set +a
source .env
set -a

usage() {
    echo "Usage: $0 [create|start|stop|restart|destroy|status]"
    exit 1
}

if [ $# -eq 0 ] || [ $# -gt 1 ]; then
    usage
fi

case "$1" in
create)
    docker run -d \
        --name blog_db \
        -p "$LOCAL_PG_PORT":5432 \
        -e POSTGRES_USER="$LOCAL_PG_USER" \
        -e POSTGRES_PASSWORD="$LOCAL_PG_PASSWORD" \
        postgres:alpine
    ;;
start)
    docker start blog_db
    ;;
stop)
    docker stop blog_db
    ;;
restart)
    docker restart blog_db
    ;;
destroy)
    docker rm blog_db
    ;;
status)
    docker ps -a | grep blog_db
    ;;
*)
    usage
    ;;
esac
