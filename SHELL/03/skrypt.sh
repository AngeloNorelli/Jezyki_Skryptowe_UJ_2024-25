#!/bin/bash

# Domyślne wartości
max_depth=32
hash_algo="md5sum"
replace_with_hardlinks=false
unsupported_algo=false
interactive=false

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
    echo "  --interactive               Asks you for replacing the file"
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
        --interactive)
            interactive=true
            ;;
        *)
            dirname="${1}"
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
declare -A files_dict

# Użycie pliku tymczasowego zamiast substytucji procesów
tmpfile=$(mktemp "$file.XXXXXXXXXX" )

# Sprawdzenie, czy udało się utworzyć plik tymczasowy
if [[ ! -f "$tmpfile" ]]; then
    echo "Błąd: Nie udało się utworzyć pliku tymczasowego. System plików może być tylko do odczytu." >&2
    exit 1
fi

find "$dirname" -maxdepth "$max_depth" -type f -not -name "$(basename "$tmpfile")" -print0 |\
xargs -0 stat --format='%s %n' |\
awk -F='' '{ depth=gsub("/", "/"); print depth, $1, $2 }' |\
sort -k1,1n -k2 |\
cut -d' ' -f2- > "$tmpfile"

# Gromadzenie plików
while read -r file_size file_path; do
    ((processed_files++))
    
    if [[ -n "${files_dict[$file_size]}" ]]; then
        files_dict[$file_size]="${files_dict[$file_size]}|$file_path"
    else
        files_dict[$file_size]="$file_path"
    fi
done < "$tmpfile"
rm "$tmpfile"

# Znajdowanie duplikatów na podstawie haszy oraz nazw
for files in "${files_dict[@]}"; do
    IFS='|' read -r -a possible_duplicates <<< "$files"

    if [[ ${#possible_duplicates[@]} -lt 2 ]]; then
        continue
    fi

    least_deep_file="${possible_duplicates[0]}"
    least_deep_dir=$(dirname "$least_deep_file")
    
    for duplicate in "${possible_duplicates[@]}"; do
        if [[ "$duplicate" != "$least_deep_file" ]]; then
            hash_least_deep_file=$("$hash_algo" "$least_deep_file" | awk '{print $1}')
            hash_duplicate=$("$hash_algo" "$duplicate" | awk '{print $1}')

            # Sprawdzenie plikow pod wzgledem hashy
            if [[ "$hash_least_deep_file" != "$hash_duplicate" ]]; then
                echo "File '$duplicate' has different hash then '$least_deep_file'." >&2
                continue
            fi

            # Sprawdzenie plikow przy uzyciu cmp
            if ! cmp -s "$least_deep_file" "$duplicate"; then
                echo "File '$duplicate' has different content then '$least_deep_file'." >&2
                continue
            fi

            # Po sprawdzeniach na pewno mamy doczynienia z duplikatem
            ((duplicate_files++))

            fs_least_deep_file=$(df -P "$least_deep_file" 2>/dev/null | awk 'NR==2 {print $1}')
            fs_duplicate=$(df -P "$duplicate" 2>/dev/null | awk 'NR==2 {print $1}')

            # Sprawdzenie, czy oba pliki sa w tym samym systemie plikowym
            if [[ "$fs_least_deep_file" != "$fs_duplicate" ]]; then
                echo "Can't create a hard link from '$fs_duplicate' to '$fs_least_deep_file': different filesystems." >&2
                continue
            fi

            # Sprawdzenie, czy mozna wpisywac do folderu
            if [ ! -w "$least_deep_dir" ]; then
                echo "No write access to the directory '$least_deep_dir'. Can't create a hard link for '$duplicate'." >&2
                continue
            fi

            if $replace_with_hardlinks; then
                if $interactive; then
                    read -p "Do you wonna remove '$duplicate' and make a hard link to '$least_deep_file'? (y/n)" response

                    if [[ ! "$response" =~ ^[Nn]$ ]]; then
                        continue
                    fi
                fi
                
                rm "$duplicate"
                ln "$least_deep_file" "$duplicate"
                ((replaced_duplicates++))
            fi
        fi
    done
done

# Generowanie raportu
echo "Liczba przetworzonych plikow: $processed_files"
echo "Liczba znalezionych duplikatow: $duplicate_files"
echo "Liczba zastapionych duplikatow: $replaced_duplicates"
