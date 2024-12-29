#!/bin/bash

# Inicjalizacja zmiennych
output_file=""
input_file=""
declare -A options
noFilename=0

# Funkcja wypisujaca opcje
print_options() {
    for opt in $(echo "${!options[@]}" | tr ' ' '\n' | sort); do
        if [[ $opt == "i" ]]; then
            echo "-i present and set to \"${options[$opt]}\""
        elif [[ $opt == "o" ]]; then
            echo "-o present and set to \"${options[$opt]}\""
        else
            echo "-$opt present"
        fi
    done
}

# Parsowanie przez opcje
while getopts ":qabcdefghjklmnprstuvyxwz:i:o:" opt; do
    case $opt in
        [a-hj-npr-z])
            options[$opt]="present"
            ;;
        q)
            echo "Unsupported option: -q"
            exit 1
            ;;
        i|o)
            if [[ -n ${OPTARG} && ${OPTARG:0:1} != "-" ]]; then
                options[$opt]=$OPTARG
                echo $OPTARG
            elif [[ ${OPTARG} == "-q" ]]; then
                echo "Unsupported option: -q"
                exit 1
            else
                noFilename=1
            fi
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            exit 1
            ;;
        :)
            echo "-i -o options require a filename"
            exit 1
            ;;
    esac
done

# Przesuniecie indeksu przez sprawdzone opcje i ich argumenty
shift $((OPTIND - 1))

# Sprawdzenie, czy opcja -i lub -o ma blad
if [ $noFilename == 1 ]; then
    echo "-i -o options require a filename"
    exit 1 
fi

# Wypisanie opcji w kolejnosci alfabetycznej
print_options

# Wypisanie argumentow, jesli takowe istnieja
if [ $# -gt 0 ]; then
    echo "Arguments are:"
    count=1
    for arg in "$@"; do
        echo "\$$count=$arg"
        count=$((count + 1))
    done
fi
