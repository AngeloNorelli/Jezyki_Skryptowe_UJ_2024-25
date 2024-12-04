#!/bin/bash

PORT=6789
COUNTER_FILE="counter.txt"
PID_FILE="./tmp/server.pid"

# Obsługa argumentów
while getopts ":p:" opt; do
    case $opt in
        p) 
            PORT="$OPTARG" 
            ;;
        *) 
            echo "Invalid option" >&2; 
            exit 1 
            ;;
    esac
done

# Sprawdzenie, czy port jest zajęty
if lsof -iTCP:$PORT -sTCP:LISTEN &>/dev/null; then
    echo "Port $PORT is unavailable"
    exit 1
fi

# Wczytanie licznika
if [[ -f "$COUNTER_FILE" ]]; then
    COUNTER=$(<"$COUNTER_FILE")
else
    COUNTER=0
    echo "$COUNTER" > "$COUNTER_FILE"
fi

# Uruchomienie socat
socat TCP-LISTEN:$PORT,reuseaddr,fork SYSTEM:"bash serverworker.sh" &
SOCAT_PID=$!
echo "$SOCAT_PID" > "$PID_FILE"
echo "Server started on port: $PORT, with PID: $SOCAT_PID" >&2


# Czekaj na zakończenie socat
wait "$SOCAT_PID"