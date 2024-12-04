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

# Zapis licznika przy wyjściu
cleanup() {
    rm -f "$COUNTER_FILE"
    exit 0
}
trap 'echo "Sprzatam..." >&2 & cleanup' EXIT SIGINT SIGTERM

# Uruchomienie socat
socat TCP-LISTEN:$PORT,reuseaddr,fork SYSTEM:"bash serverworker.sh" &
SOCAT_PID=$!



# Czekaj na zakończenie socat
wait "$SOCAT_PID"