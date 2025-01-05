# Problem PERL06
W tym problemie piszemy moduł perla, korzystamy z modułu `Spreadsheet::ParseXLSX` a nie np. `Spreadsheet::XLSX` (nie ma nowych wersji od 10+ lat), `Text::CSV` (chyba, że ktoś woli ręcznie joinować tablicę danych przy pomocy separatora). Różne moduły do parsowania excela są bardzo podobne do siebie.

## Moduł do napisania
Moduł ma za zadanie udostępnić funkcje:

- `init(n,m)` - inicjalizujemy tablicę `n` na `m`-elementową (zerami) - przechowywana jako zmienna wewnątrz modułu, jeśli jest już zainicjalizowana, to zerujemy.
- `addReadXLS(filename)` - należy wczytać plik **XLS**. Dla każdego worksheetu, wczytujemy komórki z pierwszych `n` wierszy i pierwszych `m` kolumn przy czym każdą liczbę wczytanej z komówrki `(n,m)` dodajemy do tabliczy zainicjalizowanej funkcją `init`. Czyli funkcja ta ma wysumować dane z poszczególnych kart pliku **XLS**. Nie będzie niespodzianek typu że w komórce jest coś innego niż liczba. Ewenualne komórki zawierające treść spoza pierwszych `n` wierszyi `m` kolumn **ignorujemy**.
- `saveCSV(filename)` - zapis tablicy trzymanej w module do pliku do formatu **CSV**. Separator średnik, brak owijania zawartości w cudzysłowy. Plik ma mieć `n` wierszy i `m` kolumn

Informacja dodatkowa: plik z modułem można zapisać w jednym z katalogów w **@INC**. Wtedy będzie dostępny dla wszystkich. Instalacja cpan powyżej instaluje moduł local::lib, który tworzy katalog ~/perl5. Tam też można wgrywać własne moduły i dla naszego użytkownika będą dostępne. Nie wymaga to roota. Nie trzeba tego robić w tym zadaniu - wystarczy moduł trzymać w tym samym katalogu co `main.pl`

Moduł zapisujemy do osobnego pliku `Modul.pm`. Tworzymy nastepnie plik `main.pl` w którym importujemy modul. Plik "`main.pl`" powinien zainicjalizować tablicę `n` na `m`, wczytać plik z `$ARGV[0]` i zapisać do **CSV** do pliku z `$ARGV[1]`. Wartość `n` i `m` odczytujemy z `$ARGV[2]` i `$ARGV[3]`

Moduł będzie importowany też przez testerkę (ze swoim własnym odpowiednikiem pliku `main.pl`)

## Przydatne informacje
Jak wypisać wszystkie pola obieku?
```perl
use Data::Dumper;

#...
print Dumper($sheet);
```
## Rozmaite hinty
Moduł zaczynamy tak: 
```perl
dd# Print the CSV line to the file

# Modul.pm
package Modul;
use strict;
use warnings;
....
```
a kończymy tak:
```perl
1;
```
można w pliku `Module.pm` zdefiniować sobie modułowe zmienne. (`my` - zmienne prywatne, dostępne tylko z wewnątrz modułu, "`our`" - daje zmienną typu "`public`"):
```perl
my @array;
my ($rows, $cols);
Dostęp do zmiennych i funkcji modułowych:

Modul::array
Modul::init(5,5)
Import modulu Modul.pm

use lib '.';
use Modul;
```

W pliku z modułem piszemy metody, w tym niezbędne settery, gettery (w tym zadaniu żadnego set/get chyba nie potrzebujemy...), ale te metody z treści zadania już tak
```perl
sub init {
....
}

sub addReadXLS {
    my ($filename) = @_;  #bez () mamy scalar context i dostaniemy liczbę argumentów, a nie filename....
....
```

Na stronie o tej jest dokumentacja do Spreadsheet::ParseXLSX. Jak widać to minimalny pakiet który ma za zadanie zaimportować plik XLSX w formacie w którym można go przetwarzać innymi modułami. Zgodnie z poleceniem zapoznajemy się z "Spreadsheet::ParseExcel, Spreadsheet::ParseExcel::Workbook, Spreadsheet::ParseExcel::Worksheet, and Spreadsheet::ParseExcel::Cell.". W naszym przypadku ładowanie pliku to:
```perl
my $parser = Spreadsheet::ParseXLSX->new();
my $workbook = $parser->parse($filename);
```  

To zawiera zakładki w Excelu:
```perl
$workbook->worksheets();
```

Defined-or operator. Jeśli $sheet->get_name jest 'undef' to poniższe przyjmie wartość "Unknown sheet". A jak nie jest to $sheet->get_name(). Przy okazji: $sheet jest elementem $workbook->worksheets();
Nazwa zakładki:
```perl
$sheet->get_name() // 'Unknown sheet';
```
Tak można wydobyć komórkę:
```perl
my $cell = $sheet->get_cell($row, $col);
```
A tak tekst z komórki (to jest zawartość pola "surowa zawartość" - nie to co się pojawia w komórce, ale to co zostaje sformatowane dopiero w celu pojawienia się w komórce. Ten tekst w excelu nie jest nigdize widoczny. można też $cell->{Value}, $cell->{Formula}, etc...
```perl
$val=($cell->unformatted());
```

Magiczna linia do wypisania wiersza pliku CSV:
```perl     
my $line = join(';', @$row);
```

Alternatywnie przy pomocy Text::CSV:
```perl
my $csv = Text::CSV->new({ sep_char => ';' });
for my $row (@array) {
  $csv->combine(@$row);
  print $fh $csv->string(), "\n";   #fh to plik otwarty gdzieś wcześniej...
}
```
## Format rozwiązania
Plik *zip (nazwa obojętna), zawierający main.pl oraz Modul.pm - dokładnie takie nazwy