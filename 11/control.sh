#!/bin/bash

PORT=6789
CONF_FILE="$HOME/.config/server.conf"
PID_FILE="server.pid"
# Funkcja pobierająca port
get_port() {
    if [[ -n "$1" ]]; then
        echo "$1"
    elif [[ -f "$CONF_FILE" ]]; then
        cat "$CONF_FILE"
    else
        echo "$PORT"
    fi
}

# Obsługa argumentów
case "$1" in
    start)
        PORT=$(get_port "$2")
        if [[ -f "$PID_FILE" && -e /proc/$(<"$PID_FILE") ]]; then
            exit 0
        fi
        ./server.sh -p "$PORT" &
        echo $! > "$PID_FILE"
        ;;
    stop)
        if [[ -f "$PID_FILE" && -e /proc/$(<"$PID_FILE") ]]; then
            kill "$(cat "$PID_FILE")"
            rm -f "$PID_FILE"
        fi
        ;;
    restart)
        ./control.sh stop
        ./control.sh start "$2"
        ;;
    status)
        if [[ -f "$PID_FILE" && -e /proc/$(<"$PID_FILE") ]]; then
            cat "$PID_FILE"
        fi
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status} [port]" >&2
        exit 1
        ;;
esac