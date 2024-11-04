#!/bin/bash

# Domyślne wartości
max_depth=""
hash_algo="md5sum"
replace_with_hardlinks=false
unsupported_algo=false

# Zmienne statystyczne
processed_files=0
duplicate_files=0
replaced_duplicates=0

# Funkcja wyświetlająca pomoc
show_help() {
    echo "Usage: $0 [options] DIRNAME"
    echo ""
    echo "Options:"
    echo "  --replace-with-hardlinks    Replace duplicate files with hardlinks"
    echo "  --max-depth=N               Set the maximum depth for directory traversal"
    echo "  --hash-algo=ALGO            Set hashing algorithm (default: md5sum)"
    echo "  --help                      Show this help message"
    exit 0
}

# Sprawdzanie opcji linii poleceń
while [[ $# -gt 0 ]]; do
    case "$1" in
        --replace-with-hardlinks)
            replace_with_hardlinks=true
            shift
            ;;
        --max-depth=*)
            max_depth="${1#*=}"
            shift
            ;;
        --hash-algo=*)
            hash_algo="${1#*=}"
            if ! command -v "$hash_algo" &> /dev/null; then
                unsupported_algo=true
            fi
            shift
            ;;
        --help)
            show_help
            ;;
        *)
            dirname="$1"
            shift
            ;;
    esac
done

# Sprawdzenie, czy podniesiono flage niewspieranego algorytmu
if $unsupported_algo; then
    echo "$hash_algo not supported" >&2
    exit 1
fi

# Sprawdzamy czy podano katalog do przeszukania
if [[ -z "$dirname" ]]; then
    echo "Error: No directory specified." >&2
    show_help
fi

# Zbieranie plików wg wielkości i hasha
declare -A files_by_size
declare -A files_by_hash

find_args=("$dirname")

# Dodawanie opcji do find w odpowiedniej kolejności
if [[ -n "$max_depth" ]]; then
    find_args+=(-maxdepth "$max_depth")
fi

find_args+=(-type f)

# Gromadzenie plików wg rozmiaru
while IFS= read -r file; do
    ((processed_files++))
    size=$(stat -c%s "$file")
    files_by_size["$size"]+="$file"$'\n'
done < <(find "${find_args[@]}")

# Znajdowanie duplikatów na podstawie haszy
for size in "${!files_by_size[@]}"; do
    files=($(echo "${files_by_size[$size]}" | tr '\n' ' '))
    if (( ${#files[@]} > 1 )); then
        for file in "${files[@]}"; do
            hash=$("$hash_algo" "$file" | awk '{print $1}')
            files_by_hash["$size:$hash"]+="$file"$'\n'
        done
    fi
done

# Zastępowanie duplikatów hardlinkami, jeśli opcja została włączona
for key in "${!files_by_hash[@]}"; do
    files=($(echo "${files_by_hash[$key]}" | tr '\n' ' '))
    if (( ${#files[@]} > 1 )); then
        reference_file="${files[0]}"
        duplicates_count=$(( ${#files[@]} - 1 ))
        ((duplicate_files+=duplicates_count))
        
        if $replace_with_hardlinks; then
            for ((i = 1; i < ${#files[@]}; i++)); do
                file="${files[$i]}"
                cmp -s "$reference_file" "$file"
                if [[ $? -eq 0 ]]; then
                    # Zapytanie o potwierdzenie, jeśli włączona opcja interactive
                    if $interactive; then
                        read -p "Replace '$file' with hardlink to '$reference_file'? (y/n) " answer
                        if [[ $answer != "y" ]]; then
                            continue
                        fi
                    fi
                    ln -f "$reference_file" "$file" 2>/dev/null || echo "Cannot create hardlink for file $file" >&2
                    ((replaced_duplicates++))
                fi
            done
        fi
    fi
done

# Generowanie raportu
echo "Liczba przetworzonych plikow: $processed_files"
echo "Liczba znalezionych duplikatow: $duplicate_files"
echo "Liczba zastapionych duplikatow: $replaced_duplicates"
