# Problem SHELL11

Skrypt server-klient + skrypt kontrolny dla usługi systemowej
W tym zadaniu tworzymy skrypt kontrolny w Bashu, który będzie zarządzał prostym serwerem napisanym również w Bashu. Serwer powinien nasłuchiwać na określonym porcie przy użyciu **socat** (lub **netcat**) i być sterowalnym przy pomocy skryptu kontrolnego. Oprócz tego tworzymy skrypt klienta, który wysyła zapytania do serwera i wypisuje odpowiedzi (**socat** lub **netcat**).

## Wymagania
1. **Nazwy plików** (wymagane dokładnie takie). Serwer: `server.sh`, skrypty zarządzający: `control.sh`, skrypt klienta: `client.sh`.
2. Skrypt kontrolny `control.sh` powinien obsługiwać polecenia **start**, **stop**, **restart**, oraz **status** dla serwera.
3. Skrypt `server.sh` powinien nasłuchiwać domyślnie na porcie **6789**. Należy udostępnić możliwość konfiguracji portu przełącznikiem `-p` przekazywanym do skryptu serwera (oraz `./control.sh start <numer portu>` powinno przekazać numer portu do skryptu serwera przełącznikiem `-p`). Ponadto skrypt kontrolny powinien odczytywać plik konfiguracyjny (jeśli istnieje) `~/.config/server.conf` i stamtąd odczytywać numer portu. 
    * Priorytety: 
        1. port przekazany jako `./control.start <numer_portu>`, 
        2. wartość z `~/.config/server.conf`, 
        3. 6789.
4. Plik konfiguracyjny zawiera tylko i wyłącznie liczbę - **numer portu**, np. plik zawiera dokładnie *"6543"* (a nie np *"port = 6543"*).
5. Wielokrotne wywołanie polecenia `start`, nawet z różnymi portami, nie powinno uruchamiać wielu instancji serwera: wykrywamy czy proces serwera działa. Jeśli proces serwera istnieje, kończymy działanie skryptu zarządzającego nic nie robiąc - nie pisać nic na ekran.
6. Skrypt serwera powinien sprawdzać dostępność wybranego portu i wyświetlać odpowiedni komunikat, jeśli serwer już działa lub port jest zajęty. Treść komunikata *"Port XXXX is unavailable"*.
7. Serwer, po otrzymaniu `"?"` po sieci drukuje liczbę `COUNTER` (tylko liczbę, żadnego tekstu poza nią).
8. Serwer, po otrzymaniu `"INC"` zwiększa liczbę `COUNTER o 1` (i nic nie drukuje)
9. Licznik zapisujemy na dysku w katalogu gdzie jest `server.sh`. Jeśli plik istnieje w momencie `control.sh start`, wczytujemy wartość countera. Zapisujemy wartość na dysku po każdym INC (alternatywnie zapisujemy przy zatrzymywaniu serwera - trzeba zrobić trap na odpowiednie sygnały, choć takie podejście **nie zadziała** przy `SIGKILL`).
10. **"Serwer"** z założenia ma być prościutki - nie trzeba przejmować się wieloma klientami obsługiwanymi równoczesnie itp
11. Po zakończeniu połaczenia przez usera, serwer kontynuuje pracę i czeka na kolejne połączenie na tym samym porcie. Do zatrzymania serwera służy `./control.sh stop`
12. `client.sh z` argumentem `"test1"` wysyła kolejno zapytania do serwera: `"?" "INC" "INC" "?" "INC" "?"`. Drukuje uzyskane odpowiedzi na **stdout** - jedna w każdej linii.
13. `control.sh` z argumentem `"status"` drukuje tylko i wyłącznie liczbę: numer procesu na którym uruchomiony jest serwer
14. Testerka będzie odpytywać serwer w taki sposób: 
    ```bash
    #!/bin/bash

    server_host="localhost"
    server_port="6789"  #przykladowa wartosc

    send_query() {
        local query="$1"
        echo "$query" | nc "$server_host" "$server_port"
    }

    send_query "?"
    send_query "INC"
    send_query "?"
    ```
## Wskazówki
* Użyj polecenia: 
    ```shell
    socat TCP-LISTEN:6789,reuseaddr,fork SYSTEM:"bash handler.sh \$1"
    ``` 
    do uruchomienia serwera, który nasłuchuje na wskazanym porcie, a skrypt handler czyta z **stdin** i zapisuje na **stdout** (następnie **socat** podpina to pod **port 6789**
* Możesz użyć polecenia `lsof` lub `netstat` do sprawdzenia, czy dany port jest już zajęty.
* Upewnij się, że skrypt działa prawidłowo w przypadku kolejnych wywołań poleceń `start`, `stop` i `restart`.
    * **Netcat**, **socat** wysyłają dane używając **TCP/UDP** na konkretne porty, np.: 
    ```bash
    echo -e "GET /index HTTP/1.1\r\nHost: example.com\r\nConnection: close\r\n\r\n" | nc example.com 80 , echo -e "GET /index HTTP/1.1\r\nHost: example.com\r\nConnection: close\r\n\r\n" | socat - TCP:example.com:80
    ```
    Specyfikacja HTTP wymaga **\r\n**. Idea stosowania **\r\n** bierze się z dalekopisów i jest historycznie starsza niz **\n**, mimo, że obecnie **\r\n** kojarzy się z Windowsami.

## Przykładowe użycie skryptu
```shell
foo@bar:~$ ./control.sh start     # Uruchamia serwer
foo@bar:~$ ./control.sh stop      # Zatrzymuje serwer
foo@bar:~$ ./control.sh restart   # Restartuje serwer
foo@bar:~$ ./client.sh test1
```