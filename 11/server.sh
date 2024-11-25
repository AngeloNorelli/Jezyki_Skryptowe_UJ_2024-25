#!/bin/bash

PORT=6789
COUNTER_FILE="counter.txt"

# Obsługa argumentów
while getopts ":p:" opt; do
    case $opt in
        p) PORT="$OPTARG" ;;
        *) echo "Invalid option" >&2; exit 1 ;;
    esac
done

# Sprawdzenie, czy port jest zajęty
if lsof -i TCP:"$PORT" >/dev/null 2>&1; then
    echo "Port $PORT is unavailable"
    exit 1
fi

# Wczytanie licznika
if [[ -f "$COUNTER_FILE" ]]; then
    COUNTER=$(<"$COUNTER_FILE")
else
    COUNTER=0
fi

# Zapis licznika na dysku przy wyjściu
trap 'echo "$COUNTER" > "$COUNTER_FILE"' EXIT

# Obsługa zapytań
handle_request() {
    local query
    read query
    echo $query
    case "$query" in
        "?")
            echo "$COUNTER"
            ;;
        "INC")
            COUNTER=$((COUNTER + 1))
            ;;
    esac
}

# Uruchomienie serwera
socat TCP-LISTEN:"$PORT",reuseaddr,fork SYSTEM:"bash -c 'handle_request'"