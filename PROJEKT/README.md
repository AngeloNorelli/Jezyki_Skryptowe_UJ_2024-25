# Log Analyzer

## Opis
Narzędzie do analizy logów serwera, które umożliwia parsowanie i filtrowanie danych, tworzenie raportów statystycznych oraz eksport wyników w różnych formatach (tekst lub CSV).

## Użycie
```bash
./log_analyzer.sh <log_file> [date] [ip]
```

* `<log_file>` - Ścieżka do pliku logów.
* `[date]` - Opcjonalny filtr daty (format: YYYY-MM-DD).
* `[ip]` - Opcjonalny filtr IP.

## Przykład
```bash
./log_analyzer.sh logs/logfile.log 2023-10-01 192.168.1.1
```

## Moduły Perl
* `LogParser.pm` - Moduł do parsowania logów.
* `ReportGenerator.pm` - Moduł do generowania raportów.
* `Exporter.pm` - Moduł do eksportowania wyników.

## Przykładowe pliki wyjściowe
* example_output/report.txt
* example_output/report.csv