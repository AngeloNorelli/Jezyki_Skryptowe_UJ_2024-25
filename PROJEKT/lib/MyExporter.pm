#!/usr/bin/perl
package MyExporter;
use strict;
use warnings;
use Text::CSV;

sub export_to_text {
    my ($report, $file_path) = @_;
    open my $fh, '>', $file_path or die "Cannot open file '$file_path': $!\n";
    print $fh "Total Requests: $report->{total_requests}\n";
    print $fh "Total Size: $report->{total_size}\n";
    print $fh "Status Codes:\n";
    foreach my $status (keys %{$report->{status_codes}}) {
        print $fh "  $status: $report->{status_codes}{$status}\n";
    }
    close $fh;
}

sub export_to_csv {
    my ($report, $file_path) = @_;
    my $csv = Text::CSV->new({ binary => 1, eol => $/ });
    open my $fh, '>', $file_path or die "Cannot open file '$file_path': $!\n";
    $csv->print($fh, ["Metric", "Value"]);
    $csv->print($fh, ["Total Requests", $report->{total_requests}]);
    $csv->print($fh, ["Total Size", $report->{total_size}]);
    foreach my $status (keys %{$report->{status_codes}}) {
        $csv->print($fh, ["Status $status", $report->{status_codes}{$status}]);
    }
    close $fh;
}

1;