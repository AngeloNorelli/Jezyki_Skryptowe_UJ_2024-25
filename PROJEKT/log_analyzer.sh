#!/bin/bash

# Sciezki do modulow Perl
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PASER=$SCRIPT_DIR/parser.pl
REPORTER=$SCRIPT_DIR/reporter.pl

# help
show_help() {
    cat <<EOF
Usage: $0 [OPTIONS]
Analyze server logs.

Options:
  -f <file>     Path to log file (required).
  -d <range>    Date range in format YYYY-MM-DD:YYYY-MM-DD.
  -s <status>   Filter by HTTP status code (e.g., 404).
  -o <file>     Output file for the report.
  -r <format>   Report format: text or csv (default: text).
  -h            Show this help message.

Examples:
  $0 -f logfile.log -d 2015-05-17:2015-05-18 -s 404 -o report.csv -r csv
EOF
}

# Domyslne wartosci
LOG_FILE=""
DATE_RANGE=""
STATUS_CODE=""
OUTPUT_FILE=""
REPORT_FORMAT="text"

# Parsowanie argumentow
while getopts "f:d:s:o:r:h" opt; do
  case $opt in
    f)
      LOG_FILE=$OPTARG
      ;;
    d)
      DATE_RANGE=$OPTARG
      ;;
    s)
      STATUS_CODE=$OPTARG
      ;;
    o)
      OUTPUT_FILE=$OPTARG
      ;;
    r)
      REPORT_FORMAT=$OPTARG
      ;;
    h)
      show_help
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Sprawdzenie czy podano plik logow
if [[ -z "$LOG_FILE" || ! -f "$LOG_FILE" ]]; then
  echo "Error: Log file is required." >&2
  exit 1
fi

# Wywolanie modulu do analizy logow
