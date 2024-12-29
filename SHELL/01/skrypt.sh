#!/bin/bash

# Sprawdzenie, czy pierwszy argument istnieje
if [ -z "$1" ]; then
    # echo "Użyj: $0 <od> [do]"
    exit 1
fi

# Sprawdzenie, czy tylko jeden argument został podany
if [ -z "$2" ]; then
    start=1
    end=$1
else
    start=$1
    end=$2
fi

# Sprawdzenie, czy podane wartości to liczby
if ! [[ "$start" =~ ^[0-9]+$ ]] || ! [[ "$end" =~ ^[0-9]+$ ]]; then
    # echo "Podaj poprawne liczby calkowite."
    exit 1
fi

# Sprawdzenie, czy peirwsza liczba jest mniejsza od drugiej
if ((start > end)); then
    # echo "Pierwsza wartość musi być mniejsza od drugiej."
    exit 1
fi

# Obliczanie szerokości komórki na podstawie N
max_value=$((end * end))
base_width=${#max_value}
if ((base_width + 1 < 4)); then
    cell_width=4
else
    cell_width=$((base_width + 1))
fi
# cell_width=4

# Wypisanie pierwszego wierszu
printf "%${cell_width}s" " "        # Pusta komórka
for ((i = start; i <= end; i++)); do
    printf "%${cell_width}d" $i
done
echo

# Generowanie tabliczki mnożenia
for ((i = start; i <= end; i++)); do
    printf "%${cell_width}d" $i     # Pierwsza kolumna
    for ((j = start; j <= end; j++)); do
        printf "%${cell_width}d" $((i * j))
    done
    echo
done