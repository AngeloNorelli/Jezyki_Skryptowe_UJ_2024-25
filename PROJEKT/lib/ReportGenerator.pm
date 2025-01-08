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
        $report{status_codes}{$log->{status}}++;
    }

    return \%report;
}

1;