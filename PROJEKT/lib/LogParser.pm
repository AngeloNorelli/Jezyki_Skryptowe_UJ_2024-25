#!/usr/bin/perl
package LogParser;
use strict;
use warnings;
use JSON;

sub parse_log {
    my ($file_path) = @_;
    open my $fh, '<', $file_path or die "Cannot open file '$file_path': $!\n";
    my @logs;
    while (my $line = <$fh>) {
        chomp $line;
        my %log = parse_line($line);
        push @logs, \%log;
    }
    close $fh;
    return \@logs;
}

sub parse_line {
    my ($line) = @_;
    my %log;
    if ($line =~ /(\d+\.\d+\.\d+\.\d+) - - \[(.*?)\] "(.*?)" (\d+) (\d+) "(.*?)" "(.*?)"/) {
        $log{ip} = $1;
        $log{date} = $2;
        $log{request} = $3;
        $log{status} = $4;
        $log{size} = $5;
        $log{referrer} = $6;
        $log{user_agent} = $7;
    }
    return %log;
}

sub filter_by_date {
    my ($logs, $date) = @_;
    # Convert the input date from YYYY-MM-DD to DD/Mon/YYYY
    if ($date =~ /(\d{4})-(\d{2})-(\d{2})/) {
        my $year = $1;
        my $month = $2;
        my $day = $3;
        my @months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
        $date = sprintf("%02d/%s/%04d", $day, $months[$month - 1], $year);
    }
    my @filtered_logs = grep { defined $_->{date} && $_->{date} =~ /\Q$date\E/ } @$logs;
    return \@filtered_logs;
}

sub write_logs_to_json {
    my ($logs, $file_path) = @_;
    open my $fh, '>', $file_path or die "Cannot open file '$file_path': $!\n";
    print $fh to_json($logs, { pretty => 1 });
    close $fh;
}

sub read_logs_from_json {
    my ($file_path) = @_;
    open my $fh, '<', $file_path or die "Cannot open file '$file_path': $!\n";
    local $/; # Enable 'slurp' mode
    my $json_text = <$fh>;
    close $fh;
    my $logs = from_json($json_text);
    return $logs;
}

1;