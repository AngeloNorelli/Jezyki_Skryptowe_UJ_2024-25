#!/bin/bash
COUNTER_FILE="counter.txt"

read cmd

case "$cmd" in
    "?")
        cat "$COUNTER_FILE"
        ;;
    "INC")
        counter=$(<"$COUNTER_FILE")
        echo "$((counter + 1))" > "$COUNTER_FILE"
esac