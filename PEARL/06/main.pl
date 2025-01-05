#!/usr/bin/perl
use strict;
use warnings;
use lib '.';
use Modul;

# Sprawdzenie argumentow
if (@ARGV < 4) {
    die "Use: perl main.pl <XLSX file> <CSV file> <rows> <cols>\n";
}

my ($xlsx_file, $csv_file, $rows, $cols) = @ARGV;

# Inicjalizacja tablicy
Modul::init($rows, $cols);

# Wczytanie danych z pliku XLSX
Modul::addReadXLS($xlsx_file);

# Zapisanie danych do pliku CSV
Modul::saveCSV($csv_file);

print STDERR  "Data saved to '$csv_file'\n";