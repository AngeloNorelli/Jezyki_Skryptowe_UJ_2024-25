Problem PERL01
W ramach tego problemu piszemy 2 programy: łamacz haseł i wc. Wysyłamy jako zzipowane pliki wc.pl i haslo.pl

Wc
Piszemy wariany programu "wc".Po wywołaniu

./wc.pl plik robi to samo co po ./wc.pl - < plik
Program może przyjmować opcje np -c -m -l -i -w -p, przy czym zakładamy, że ostatnim elementerm ARGV jest zawsze przekazany plik (chyba, że dane przekazane przez stdin)
./wc.pl -m plik drukuje to samo i w tym samym formacie co wc -m plik, np "43 ../PERL00/prob01.pl" lub "43 -"
./wc.pl -l plik drukuje to samo i w tym samym formacie co wc -l plik
./wc.pl -c plik drukuje to samo i w tym samym formacie co wc -c plik
./wc.pl -w plik drukuje to samo i w tym samym formacie co wc -w plik
./wc.pl -p plik drukuje 10 linii zawaierających "slowo count", gdzie slowo to najczesciej wystepujace slowa. Ze slow drukujemy tylko bajty odpowiadajace [a-zA-Z]. Wszystkie inne bajty drukujemy jako '?'. count to liczba wystapien. Slowo to niepusty, maksymalny ciag kolejnych bajtow ograniczony z obu stron spacją, tabulacją lub znakiem końca linii (0x0A lub 0x0D 0x0A - można założyć, że po 0x0D jest 0x0A, bo testujemy tylko na plikach tekstowych). Drukujemy te slowa tak, że count jest nierosnące. Remisy rozstrzygujemy poronujac leksykogragicznie "slowo" (najpierw leksykograficznie mniejsze). Porownujemy ciagki znakow juz po zastapieniu znakow przez '?'
W powyzszym jesli slowo "Wacpan!" wystapi 10 razy, a "Wacpan," też 10 razy i słowa załapią się do top 10, to powinny być 2 wpisy typu "Wacpan? 10", bo "Wacpan!" i "Wacpan," to różne słowa, występują 2 razy jako "Wacpan?" bo operacja zastepowania znakow spoza [a-zA-Z] nie jest iniekcja.
-i sprawia, że w liczeniu slow do -i nalezy potraktować znaki [a-z] ( i tylko te) równe znakom [A-Z]. Dla uproszczenia: najpierw zamieniamy w tekście wyrazy na lower case. W raporcie listujemy słowo z zamienionymi literami (w szczególności możliwe jest, że w pliku wystepuje Ala 10 razy, 10 razy aLa, a w zestawieniu jest "ala 20")
W "prawdziwym" programie tego typu musielibyśmy poważnie się zastanowić nad poprawną obsługą Unicode i tego by Ł potraktorać jak wielką wersję "ł", tak samo wszelkie słowa z kropkami, kreskami w różnych językach. Czy w językach typu japoński, chiński są wielkie litery? Może jest do tego jakiś pakiet w CPAN który robi za nas czarną robotę w takiej sytuacji? Oczywiście tego nie piszemy, tylko chciałem napisać co różni nietrudne w sumie ćwiczenie od projektu na serio.

Łamacz haseł
Napisać program do łamania prostych szyfrów substytucyjnych monoalfabetowych. Niech plik tekstowy (obszerny fragment "Potopu" H. Sienkiewicza) w formacie ASCII (polskie litery zastąpione przez bezogonkowe odpowiedniki) w języku polskim będzie zaszyfrowany poprzez kolejno:

zamianę wszystkich małych liter na wielkie (usuwamy litery spoza [a-zA-Z] w szczególnosci te z ogonkami).
usunięcie wszstkich znaków oprócz spacji i wielkich liter (także znaków końca linii)
przekształcenie każdej litery i spacji x na f(x), gdzie f jest permutacją (nieznaną zbioru znaków [A-Z\ ]
Przez "dekryptaż" rozumiemy podanie 27 znakow - ciagu na ktory zostanie zaszyfrowany ABCDEFGHIJKLMNOPRSTUVWXYZ_, gdzie '_' oznacza spację (drukujemy spację jako '_').

Program powinien wczytać plik tekstowy podany pierwszy argument wiersza linii poleceń. Program powinien złamać szyfr metodą częstotliwościową (częstotliwości znajdujemy w sieci, albo ściągamy tekst Potopu i robimy samodzielnie analizę). Jeśli okaże się że wpróbce tekstu mamy litery występujące z podobną częstotliwością (np jedna 30k razy a druda 29.5k razy, to mamy sytuację wątpliwą - wowczas sprawdzamy obie możliwości i powinno wystarczyć wybranie tego wariantu gdzie występują popularne słowa większą ilość razy. Do wyszukania popularnych słów można użyć prościutkiego skryptu w bashu lub "wc" powyżej