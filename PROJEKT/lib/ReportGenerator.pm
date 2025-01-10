#!/usr/bin/perl
package ReportGenerator;
use strict;
use warnings;

sub generate_report {
    my ($logs) = @_;
    my %report = (
        total_requests => 0,
        total_size => 0,
        status_codes => {},
    );

    foreach my $log (@$logs) {
        $report{total_requests}++;
        $report{total_size} += $log->{size} // 0;
        if (defined $log->{status} && $log->{status} =~ /^\d+$/) {
            $report{status_codes}{$log->{status}}++;
        } else {
            $report{status_codes}{'unknown'}++;
        }
    }

    return \%report;
}

1;