# Log Analyzer

## Opis
Narzędzie do analizy logów serwera, które umożliwia parsowanie i filtrowanie danych, tworzenie raportów statystycznych oraz eksport wyników w różnych formatach (tekst lub CSV).

## Wymagania
Aby uruchomić program, należy zainstalować:
1. **Perl**: Trzeba sprawdzić, czy jest zainstalowany Perl przez komendę:
    ```bash
    perl -v
    ```
2. **Moduły Perl**:
    * `Getopt::Long`
    * `JSON`
    * `Text::CSV`

    Te moduły można zainstalować za pomocą poleceń `cpan`:
    ```bash
    cpan Getopt::Long
    cpan JSON
    cpan Text::CSV
    ```

## Uruchomienie
```bash
./log_analyzer
```

Skrypt jest interaktywny i poprosi o:

* Ścieżkę do pliku logów.
* Opcjonalne filtry (data, IP, User Agent, URL, status).
* Nazwę pliku do zapisu raportu (bez rozszerzenia).
* Format eksportu (text/csv).

## Moduły Perl
* [`LogParser.pm`](./lib/LogParser.pm) - Moduł do parsowania logów.
* [`ReportGenerator.pm`](./lib/ReportGenerator.pm) - Moduł do generowania raportu.
* [`MyExporter.pm`](./lib/MyExporter.pm) - Moduł do eksportowania wyników.

## Przykładowy wynik programu
```
Total Requests: 10000
Total Size: 2747282505
Status Codes:
  206: 45
  404: 205
  301: 163
  403: 2
  500: 1
  200: 8912
  416: 2
  unknown: 670
```