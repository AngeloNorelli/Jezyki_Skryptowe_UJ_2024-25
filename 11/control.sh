#!/bin/bash

PORT=6789
TEMP_DIR="./tmp"
CONF_FILE="./tmp/server.conf"
SERVER_SCRIPT="./server.sh"
PID_FILE="./tmp/server.pid"

# Funkcja pobierająca port
get_port() {
    if [[ -n "$1" ]]; then
        mkdir $TEMP_DIR && touch $CONF_FILE
        echo "$1" > "$CONF_FILE"
        echo "$1"
    elif [[ -f "$CONF_FILE" ]]; then
        cat "$CONF_FILE"
    else
        mkdir $TEMP_DIR && touch $CONF_FILE
        echo "$PORT" > "$CONF_FILE"
        echo "$PORT"
    fi
}

# Start serwera
start_server() {
    local port
    port=$(get_port "$1")

    if [[ -f "$PID_FILE" ]] && kill -0 $(<"$PID_FILE") 2>/dev/null; then
        exit 0
    fi

    ./server.sh -p "$port" &
    server_pid=$!
    sleep 0.1

    socat_pid=$(pgrep -P "$server_pid" socat)  # Znajdź PID procesu socat
    if [[ -n "$socat_pid" ]]; then
        echo "$socat_pid" > "$PID_FILE"
        echo "Server started on port $port with PID $socat_pid" >&2
    else
        echo "Failed to start server" >&2
        kill "$server_pid" 2>/dev/null
    fi
}

# Stop serwera
stop_server() {
    if [[ -f "$PID_FILE" ]] && kill -0 $(<"$PID_FILE") 2>/dev/null; then
        kill $(<"$PID_FILE") && rm -r "$TEMP_DIR"
    fi
}

# Restart serwera
restart_server() {
    stop_server
    start_server "$1"
}

# Status serwera
server_status() {
    if [[ -f "$PID_FILE" ]] && kill -0 $(<"$PID_FILE") 2>/dev/null; then
        cat "$PID_FILE"
    fi
}

# Obsługa argumentów
case "$1" in
    start)
        start_server "$2"
        ;;
    stop)
        stop_server
        ;;
    restart)
        restart_server "$2"
        ;;
    status)
        server_status
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status} [port]" >&2
        exit 1
        ;;
esac