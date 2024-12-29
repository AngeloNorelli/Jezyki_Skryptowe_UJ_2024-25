#!/usr/bin/perl
use strict;
use warnings;

# inicjalizacja tablicy asocjacyjnej
my %zwierzeta_count;

# wczytanie danych
while (my $zwierze = <STDIN>) {
    chomp $zwierze;
    $zwierzeta_count{$zwierze}++;
}

# wypisanie wyniku
foreach my $zwierze (sort keys %zwierzeta_count) {
    print "$zwierze $zwierzeta_count{$zwierze}\n";
}