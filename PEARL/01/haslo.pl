#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw( min max );

# Typowe czestotliwosci liter w jezyku polskim (przybliżone)
my %polish_freq = (
    'A' => 0.0809, 'B' => 0.0163, 'C' => 0.0296, 'D' => 0.0364, 'E' => 0.0919,
    'F' => 0.0235, 'G' => 0.0209, 'H' => 0.0279, 'I' => 0.0747, 'J' => 0.0134,
    'K' => 0.0295, 'L' => 0.0352, 'M' => 0.0309, 'N' => 0.0731, 'O' => 0.0626,
    'P' => 0.0263, 'Q' => 0.0004, 'R' => 0.0523, 'S' => 0.0509, 'T' => 0.0440,
    'U' => 0.0279, 'V' => 0.0050, 'W' => 0.0273, 'X' => 0.0010, 'Y' => 0.0117,
    'Z' => 0.0182, '_' => 0.0200
);

# Wczytanie pliku
sub read_file {
    my ($file_path) = @_;
    open my $fh, '<', $file_path or die "Nie moge otworzyc pliku '$file_path': $!\n";
    my $text = do { local $/; <$fh> };
    close $fh;
    return $text;
}

# Obliczanie czestotliwosci liter w tekscie
sub get_letter_frequency {
    my ($text) = @_;
    my %count;
    my $total = 0;

    for my $char (split //, $text) {
        $count{$char}++;
        $total++;
    }

    # Zwrocenie czestotliwosci
    my %freq;
    for my $char (keys %count) {
        $freq{$char} = $count{$char} / $total;
    }
    return %freq;
}

# Łamanie szyfru na podstawie czestotliwosci
sub break_cipher {
    my ($text, %reference_freq) = @_;
    my %letter_freq = get_letter_frequency($text);

    # Sortowanie czestotliwosci liter w tekscie
    my @sorted_letter_freq = sort { $letter_freq{$b} <=> $letter_freq{$a} } keys %letter_freq;
    my @sorted_reference_freq = sort { $reference_freq{$b} <=> $reference_freq{$a} } keys %reference_freq;

    # Mapowanie liter na podstawie czestotliwosci
    my %mapping;
    my %used;
    for my $i (0 .. $#sorted_letter_freq) {
        my $letter = $sorted_reference_freq[$i];
        # Upewniamy sie, ze kazda litera jest mapowana na unikalny znak
        for my $possible (@sorted_letter_freq) {
            if (!$used{$possible}) {
                $mapping{$letter} = $possible;
                $used{$possible} = 1;
                last;
            }
        }
    }

    return %mapping;
}

# Funkcja do generowania ciagu zaszyfrowanych liter
sub generate_encryption_key {
    my %mapping = @_;
    
    # Ciag znaków, który będzie mapowany
    my @original_alphabet = ('A' .. 'Z', '_');  # Litery A-Z oraz spacja (reprezentowana jako '_')

    # Tworzymy wynikowy ciag
    my $result = '';
    for my $char (@original_alphabet) {
        # Jeśli spacja, to przypiszemy '_'
        if ($char eq '_') {
            $result .= $mapping{$char} || '_'; 
        } else {
            $result .= $mapping{$char} || '_';  # Jesli brak mapowania, to uzywamy '_'
        }
    }

    # Zamiast ' ' (spacji) w wyniku, wstawiamy '_'
    $result =~ s/ /_/g;

    return $result;
}

# Głowna funkcja
sub main {
    if (@ARGV != 1) {
        die "Uzycie: perl haslo.pl <plik_tekstowy>\n";
    }

    my $file_path = $ARGV[0];

    # Wczytanie i przetworzenie tekstu
    my $text = read_file($file_path);

    # Lamanie szyfru
    my %mapping = break_cipher($text, %polish_freq);
    my $encryption_key = generate_encryption_key(%mapping);

    # Wypisanie ciagu, który bedzie zaszyfrowany jako 'ABCDEFGHIJKLMNOPRSTUVWXYZ_'
    print "$encryption_key\n";
}

main();
