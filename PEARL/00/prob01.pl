#!/usr/bin/perl
use strict;
use warnings;

# tworzenie tablicy @zwierzeta
my @zwierzeta = ("kot", "pies", "papuga", "kanarek", "ryba");

# wypisanie pierwszego zwierzeta z tablicy
print "$zwierzeta[0]\n";

# wypisanie liczbe zwierza w tablicy
print scalar(@zwierzeta) . "\n";

# zmiana drugiego zwierzeta w tablicy na "kanarek"
$zwierzeta[1] = "kanarek";

# dodanie do tablicy "zaba" na koncu tablicy
push(@zwierzeta, "zaba");

# wypisanie liczbe zwierza w tablicy
print scalar(@zwierzeta) . "\n";

# usuniecie ostatniego zwierzeta z tablicy
pop(@zwierzeta);

# wypisanie liczbe zwierza w tablicy
print scalar(@zwierzeta) . "\n";

# wypisanie wszystkich zwierzat z tablicy przy urzuciu foreach
foreach my $zwierze (@zwierzeta) {
    print "$zwierze\n";
}

# wypisanie wszystkich zwierzat z tablicy przy urzuciu for
for (my $i = 0; $i < scalar(@zwierzeta); $i++) {
    print "$i $zwierzeta[$i]\n";
}

# wypisanie zwierzat z tablicy od 2 do 4
my @podtablica = @zwierzeta[1..3];
foreach my $zwierze (@podtablica) {
    print "$zwierze\n";
}