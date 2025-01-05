#!/usr/bin/perl
package Modul;

use strict;
use warnings;
use Spreadsheet::ParseXLSX;

# Zmienne modulowe
my @array;
my ($rows, $cols);

# Inicjalizacja tablicy
sub init{
    my ($n, $m) = @_;
    $rows = $n;
    $cols = $m;
    @array = map { [ (0) x $m ] } (1 .. $n);    # tworzenie tablicy wypelnionej zerami
}

# Dodawanie danych z pliku XLSX
sub addReadXLS {
    my ($file_path) = @_;
    my $parser = Spreadsheet::ParseXLSX->new;
    my $workbook = $parser->parse($file_path);

    if (!defined $workbook) {
        die "Can't open XLSX file: " . $parser->error();
    }

    for my $sheet ($workbook->worksheets()) {
        my ($row_min, $row_max) = $sheet->row_range();
        my ($col_min, $col_max) = $sheet->col_range();

        $row_max = $rows - 1 if $row_max >= $rows;
        $col_max = $cols - 1 if $col_max >= $cols;

        for my $row ($row_min .. $row_max) {
            for my $col ($col_min .. $col_max) {
                my $cell = $sheet->get_cell($row, $col);
                next unless $cell;

                next if defined $cell->{Formula};

                my $value = $cell->unformatted();
                if (defined $value && $value =~ /^-?\d+(\.\d+)?$/) {
                    $array[$row][$col] += $value;
                }
            }
        }
    }
}

sub saveCSV {
    my ($filename) = @_;

    open my $fh, '>', $filename or die "Can't open file '$filename': $!";
    for my $row (@array) {
        my $line = join(';', @$row);
        print $fh "$line\n";
    }
    close $fh;
}

1;