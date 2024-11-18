# Problem SHELL10
W tym zadaniu zajmujemy się napisz 6 programów, które analizują plik dziennika Apache *(np. te [logi](./logfile.log))*. Każdy program powinien być zapisany jako osobny skrypt Bash, plik do zadania `N`, powinien nazywać się `taskN`, a więc `task1, task2, ...` .

## Zadanie 1
Pierwszy program powinien liczyć całkowitą liczbę żądań w pliku dziennika. Będzie wywoływane tak: `./task1 logfile.log`. Output to liczba całkowita

```
12314
```

## Zadanie 2
Drugi program powinien liczyć unikalne adresy IP, które wysłały żądania. Można go wywołać tak: `./task2 logfile.log`. Drukujemy 10 najbardziej popularnych adresów, w kolejności od najbardziej do najmniej popularnego, po czym następuje spacja i występuje całkowita liczba zapytań typu **GET** lub **POST** w formacie. Sortujemy po drugiej kolumnie malejąco, w drugiej kolejności po pierwszej.

```
1.2.3.4 1234
1.2.3.3 1233
127.0.0.1 123
1.2.3.2 12
1.2.3.1 11
192.168.0.1 10
8.8.8.8 9
8.8.4.4 8
1.2.3.5 7
1.2.3.9 6
```
## Zadanie 3
Trzeci program powinien wyświetlać najbardziej żądane strony ("strona" to ciąg znaków występujący zaraz po GET lub POST, może być obrazkiem może być nawet "/"). Można go wywołać tak: ./task3 logfile.log. Format żądanie, spacja, liczba żądań. Sortujemy malejąco po drugiej kolumnie, w przypadku remisu porównujemy pierwszą kolumnę.

```
/index.html 150
/about.html 120
/contact.html 95
/services.html 85
/blog/post1.html 70
/blog/post2.html 65
/pricing.html 55
/portfolio.html 40
/faq.html 30
/terms.html 25
```

## Zadanie 4
Piąty program powinien liczyć żądania złożone w każdej godzinie. Można go wywołać tak: ./task5 logfile.log Godziny z różnych dni kumulujemy do jednej pozycji. Drukujemy 24 linie w formacie . Liczbie N odpowiadają żądania złożone między N:00:00 a N:23:59. Tym razem nie sortujemy po liczbie zapytań a po godzinie

```
00 35
01 40
02 20
03 15
04 10
05 8
06 12
07 25
08 30
09 45
10 50
11 60
12 55
13 70
14 85
15 90
16 100
17 80
18 75
19 60
20 50
21 40
22 30
23 25
```

## Zadanie 5
Szukamy spamerów skrypt uruchamiany jako `./task5 <plik> N` szuka użytkowników, którzy między czasem `M:00:00` a `(M+1):00:00` złożyli więcej niż `N` zapytań dla pewnego `M:00:00`. Drukujemy w kolumnach: `IP użytkownika,M:00:00-(M+1):00:00,dzień` w formacie jak w logach,liczba zapytań. Kolumny rozdzielamy spacją. Sortujemy malejąco po ostatniej kolumnie, dla równych ilości - sortujemy po pierwszej. Drukujemy nie więcej niż 10 linii, startując od najwyżej sytuowanych. Uwaga, ostatnia linia odpowiada 23:00:00-24:00:00, nie 23:00:00-00:00:00.

```
192.168.1.10 13:00:00-14:00:00 01/Nov/2024 120
203.0.113.45 09:00:00-10:00:00 01/Nov/2024 105
198.51.100.22 17:00:00-18:00:00 02/Nov/2024 98
192.0.2.15 15:00:00-16:00:00 01/Nov/2024 87
198.51.100.5 20:00:00-21:00:00 02/Nov/2024 85
```

## Zadanie 6
Szukamy skanerów, czyli użytkowników którzy chodzą po stronie jak leci, albo odpytują serwer wg zadanej listy - w celu scrapowania strony, albo szukają stron typu wp-login w różnych podkatalogach. Na potrzeby tego zadania określamy ile unikalnych żądań wykonano z różnych IP. Czyli jeśli IP weszło 4 razy na stronę /index.php 2 razy na /wp-login.php i po 1 razie na /aaa.html /b.html, wówczas zaliczamy tylko /aaa.html i /bbb.html i dla IP wynik wynosi 2. Zwracamy listę IP, liczba unikalnych wejść, oddzielonych spacją. Koejność malejąca po liczbie unikalnych żądań, w drugiej kolejności po IP. Drukujemy max 10 najwyższych wyników.

```
192.168.1.10 15
203.0.113.45 12
198.51.100.22 9
192.0.2.15 9
198.51.100.5 6
```