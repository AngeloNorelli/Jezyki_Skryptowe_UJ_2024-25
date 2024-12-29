#!/usr/bin/perl
use strict;
use warnings;

# sprawdzenie liczby argumentow
if (@ARGV != 3) {
    die "Use: $0 matrix1.txt matrix2.txt output.txt\n";
}

# wczytanie macierzy z pliku
my ($matrix1_file, $matrix2_file, $output_file) = @ARGV;
my @matrix1 = read_matrix($matrix1_file);
my @matrix2 = read_matrix($matrix2_file);

# sprawdzenie wymiarow macierzy
my $cols_matrix1 = scalar @{$matrix1[0]};
my $rows_matrix2 = scalar @matrix2;
if ($cols_matrix1 != $rows_matrix2) {
    die "Number of columns in the first matrix must be equal to the number of rows in the second matrix.\n";
}

# mnozenie macierzy
my @result = multiply_matrices(\@matrix1, \@matrix2);

# zapisanie wyniku do pliku
write_matrix($output_file, \@result);

# funkcja do wczytywania macierzy z pliku
sub read_matrix {
    my ($file) = @_;
    open my $fh, '<', $file or die "Cannot open file $file: $!\n";
    my @matrix;
    while (my $line = <$fh>) {
        chomp $line;
        my @row = split ' ', $line;
        push @matrix, \@row;
    }
    close $fh;
    return @matrix;
}

# funckja do mnozenia macierzy
sub multiply_matrices {
    my ($matrix1, $matrix2) = @_;
    my $rows_matrix1 = scalar @{$matrix1};
    my $cols_matrix2 = scalar @{$matrix2->[0]};
    my @result;
    for my $i (0..$rows_matrix1-1) {
        for my $j (0..$cols_matrix2-1) {
            my $sum = 0;
            for my $k (0..$cols_matrix1-1) {
                $sum += $matrix1->[$i][$k] * $matrix2->[$k][$j];
            }
            $result[$i][$j] = $sum;
        }
    }
    return @result;
}

# funkcja do zapisywania macierzy do pliku
sub write_matrix {
    my ($filename, $matrix) = @_;
    open my $fh, '>', $filename or die "Cannot open file $filename: $!";
    for my $row (@$matrix) {
        printf $fh "%8.3f " x scalar(@$row) . "\n", @$row;
    }
    close $fh;
}