# Problem SHELL02
Napisać dwa programy, które wypiszą wszystkie przekazane argumenty linii poleceń. Programy robią to samo, ale różnią się rodzajem obsługiwanych argumentów.

## Program 1
Pierwszy (użyć getopts - to jest funkcja basha "built-in" - info Bash Reference Manual). Program można wywołać tak: `./arg1 -a -d -o output -i input arg1 arg2 arg3.... argN`. Jednoliterowe opcje znajdują się przed argumentami, których może być dowolna ilość. Jednoliterowe opcje mogą być dowolną literką poza 'q'. W przypadku 'i' oraz 'o' mamy obowiązek podania argumentu będącego jednym słowem po `-i` lub po `-o`.

W sytuacji kiedy podano `-q`, niezależnie od pozostałych argumentów i opcji, drukujemy `"Unsupported option: -q"` i kończymy wykonanie programu

W przypadku kiedy po `-i` lub -o nie ma argumentu drukujemy `"-i -o options require a filename"` i kończymy wykonanie programu.

Jeśli podano `-q` to już obecność bądź nie argumentów do `-i -o` jest bez znaczenia - komunikat o `-q` ma priorytet

W sytuacji kiedy nie ma `-q` a po `-i` oraz `-o` jeśli są następują argumenty należy wydrukować przekazane opcje, następnie linię `"Arguments are:"` i następnie wydrukować podane argumenty `arg1`, `arg2`,... `argN` wg formatu poniżej. Jeśli żadnych argumentów `arg1,....,argN` nie ma, nie drukujemy też `"Arguments are:"`

Kolejność drukowanych opcji jest alfabetyczna. Argumenty drukujemy w kolejności przekazania.

### Przykład 1
```bash
lacki@andy2:~/skrypty/ZAD02$ ./arg1 -c -b  -r       
-b present
-c present
-r present
```

### Przykład 2
```bash
lacki@andy2:~/skrypty/ZAD02$ ./arg1 -c -b  -r  -i
-i -o options require a filename
```

### Przykład 3
```bash
lacki@andy2:~/skrypty/ZAD02$ ./arg1 -c -b  -r  -i ooo aaa ala ma kota 
-b present
-c present
-i present and set to "ooo"
-r present
Arguments are:
$1=aaa
$2=ala
$3=ma
$4=kota
```

### Przykład 4
```bash
lacki@andy2:~/skrypty/ZAD02$ ./arg1 -c -b  -r  -i -o ooo aaa ala ma kota 
-i -o options require a filename
```

### Przykład 5
```bash
lacki@andy2:~/skrypty/ZAD02$ ./arg1 -c -b  -r  -q -i -o ooo aaa ala ma kota 
Unsupported option: -q
```
## Program 2
Drugi program (getopt zamiast getopts) obsługuje ponadto umie wydrukować help wykorzystując długą opcję `--help`

Jeśli --help jest obecne gdziekolwiek jako opcje podane przed argumentami arg1,...,argN, wówczas program wyświetla help (priorytet wyższy niż -q)