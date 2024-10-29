#!/bin/bash

# Funkcja do wyswietlania --help
show_help() {
    echo "Usage: $0 [options] [arguments]"
    echo
    echo "Options:"
    echo "  -a -b ... -z    Option a, b .. z"
    echo "  -i <filename>   Option i requires a filename"
    echo "  -o <filename>   Option o requires a filename"
    echo "  -q              Unsupported option"
    echo "  --help          Display this help and exit"
}

# Parsowanie opcji przez 
PARSED_OPTIONS=$(getopt -o abcdefghjklmnpstuvwxyzi:o:rq --long help -- "$@")
if [[ $? -ne 0 ]]; then
    # echo "Failed to parse options." >&2
    exit 1
fi

# Ewaluacja sprawdzonych opcji
eval set -- "$PARSED_OPTIONS"

# Delkaracja zmiennych
declare -A options
isQ=0
noFilename=0

# Parsowanie wszystkich opcji
while true; do
    case "$1" in
        -[a-hj-npr-z])
            options["$1"]="present"
            shift
            ;;
        -i|-o)
            if [[ -n $2 && $2 != -* ]]; then
                options["$1"]="$2"
                shift 2
            elif [ $2 == "-q" ]; then
                echo "Unsupported option: -q"
                exit 1
            else
                noFilename=1
                shift
            fi
            ;;
        --help)
            show_help
            exit 0
            ;;
        -q)
            isQ=1
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Invalid option: $1"
            exit 1
            ;;
    esac
done

# Sprawdzenie, czy wystapila opcja -q
if [ $isQ == 1 ]; then
    echo "Unsupported option: -q"
    exit 1
fi

# Sprawdzenie, czy opcja -i lub -o ma blad
if [ $noFilename == 1 ]; then
    echo "-i -o options require a filename"
    exit 1
fi

# Wypisanie wszystkich opcji
for opt in $(echo "${!options[@]}" | tr ' ' '\n' | sort); do
    if [[ $opt == "-i" ]]; then
        echo "$opt present and set to \"${options[$opt]}\""
    elif [[ $opt == "-o" ]]; then
        echo "$opt present and set to \"${options[$opt]}\""
    else
        echo "$opt present"
    fi
done

# Wypisanie wszystkich argumentow
if [ $# -gt 0 ]; then
    echo "Arguments are:"
    count=1
    for arg in "$@"; do
        echo "\$$count=$arg"
        count=$((count + 1))
    done
fi
