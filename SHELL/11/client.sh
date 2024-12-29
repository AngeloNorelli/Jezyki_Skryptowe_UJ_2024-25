#!/bin/bash

HOST="localhost"
PORT="6789"

if [[ "$1" == "test1" ]]; then
    echo "?" | nc "$HOST" "$PORT"
    echo "INC" | nc "$HOST" "$PORT"
    echo "INC" | nc "$HOST" "$PORT"
    echo "?" | nc "$HOST" "$PORT"
    echo "INC" | nc "$HOST" "$PORT"
    echo "?" | nc "$HOST" "$PORT"
else
    echo "Usage: $0 test1"
fi