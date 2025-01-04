#!/usr/bin/perl
use strict;
use warnings;

# Parsowanie argumentow
my %options = map { $_ => 1 } grep { /^-/ } @ARGV;
my $file = (grep { !/^-/ } @ARGV)[0] || '-';

# Wczytanie pliku lub stdin
open(my $fh, ($file eq '-') ? '<-' : '<', $file) or die "Nie można otworzyć pliku: $!";
my @lines = <$fh>;
close($fh);

# Przetwarzanie opcji
if($options{'-c'}) {
    my $bytes = length(join('', @lines));
    print "$bytes $file\n";
}

if($options{'-m'}) {
    my $chars = length(join('', @lines));
    print "$chars $file\n";
}

if($options{'-l'}) {
    my $lines = scalar @lines;
    print "$lines $file\n";
}

if($options{'-w'}) {
    my $words = 0;
    foreach my $line (@lines) {
        my @words_in_line = $line =~ /\S+/g;
        $words += scalar @words_in_line;
    }
    print "$words $file\n";
}

if ($options{'-p'}) {
    if ($options{'-i'}) {
        foreach (@lines) {
            tr/A-Z/a-z/;
        }
    }

    my %word_count;
    foreach my $line (@lines) {
        foreach my $word ($line =~ /([^\s]+)/g) {
            $word_count{$word}++;
        }
    }

    my @top_words = sort { $word_count{$b} <=> $word_count{$a} || $a cmp $b } keys %word_count;
    @top_words = @top_words[0..9] if @top_words > 10;

    foreach my $word (@top_words) {
        (my $sanitized_word = $word) =~ tr/a-zA-Z/?/c;
        print "$sanitized_word $word_count{$word}\n";
    }
}