# Problem SHELL01
Napisać program, drukuje ładnie sformatowaną tabelkę mnożenia od A do B. Tabelka mnożenia N x N składa się z N+1 x N+1 komórek. Komórka (1,1) jest pusta. W komórkach (1,2)...(1,N+1) oraz w (2,1)... (N+1,1) znajdują się liczby od A do B. W wadracie (2,2) - (N+1, N+1) znajdują się liczby będące wynikiem mnożenia pierwszych elementów wiersza i kolumny. Szerokość każdej komórki: 4 znaki.

Wartość A jest wczytywana z pierwszego argumentu linii poleceń, a B z drugiego. Jeśli jest podany tylko jeden argument, zakładamy, że A=1 a podano B. Jeśli B jest bez sensu, np mniejsze od A, nie drukujemy nic.

Oczekiwany poziom techniczny: odczytywanie argumentów linii, poleceń, wyrażenia warunkowe

### Przykład 1
```bash
 foo@bar:~$ ./skrypt 2 7
       2   3   4   5   6   7
   2   4   6   8  10  12  14
   3   6   9  12  15  18  21
   4   8  12  16  20  24  28
   5  10  15  20  25  30  35
   6  12  18  24  30  36  42
   7  14  21  28  35  42  49
```

### Przykład 2
```bash
 foo@bar:~$ ./skrypt 7
       1   2   3   4   5   6   7
   1   1   2   3   4   5   6   7
   2   2   4   6   8  10  12  14
   3   3   6   9  12  15  18  21
   4   4   8  12  16  20  24  28
   5   5  10  15  20  25  30  35
   6   6  12  18  24  30  36  42
   7   7  14  21  28  35  42  49
```

### Przykład 3
```bash
 foo@bar:~$ ./skrypt 7 4
(puste)
```