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
        $log{size} = $5 + 0;
        $log{referrer} = $6;
        $log{user_agent} = $7;
    }
    return %log;
}

sub filter_by_date {
    my ($logs, $date) = @_;
    
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

sub filter_by_ip {
    my ($logs, $ip) = @_;
    my @filtered_logs = grep { defined $_->{ip} && $_->{ip} eq $ip } @$logs;
    return \@filtered_logs;
}

sub filter_by_user_agent {
    my ($logs, $user_agent) = @_;
    my @filtered_logs = grep { defined $_->{user_agent} && $_->{user_agent} eq $user_agent } @$logs;
    return \@filtered_logs;
}

sub filter_by_url {
    my ($logs, $url) = @_;
    my @filtered_logs = grep { defined $_->{request} && $_->{request} =~ /\Q$url\E/ } @$logs;
    return \@filtered_logs;
}

sub filter_by_status {
    my ($logs, $status) = @_;
    my @filtered_logs = grep { defined $_->{status} && $_->{status} == $status } @$logs;
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
    local $/;
    my $json_text = <$fh>;
    close $fh;
    my $logs = from_json($json_text);
    return $logs;
}

1;