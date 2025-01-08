#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use lib 'lib';
use LogParser;
use ReportGenerator;
use MyExporter qw(export_to_text export_to_csv);
use JSON;

my $file;
my $filter_date;
my $filter_ip;
my $filter_user_agent;
my $filter_url;
my $parse;
my $generate_report;
my $export_text;
my $export_csv;

GetOptions(
    'file=s' => \$file,
    'filter-date=s' => \$filter_date,
    'filter-ip=s' => \$filter_ip,
    'filter-user-agent=s' => \$filter_user_agent,
    'filter-url=s' => \$filter_url,
    'parse' => \$parse,
    'generate-report' => \$generate_report,
    'export-text' => \$export_text,
    'export-csv' => \$export_csv,
) or die "Incorrect usage!\n";

if ($parse) {
    my $logs = LogParser::parse_log($file);
    LogParser::write_logs_to_json($logs, 'temp/parsed_logs.json');
}

if ($filter_date) {
    my $logs = LogParser::read_logs_from_json('temp/parsed_logs.json');
    my $filtered_logs = LogParser::filter_by_date($logs, $filter_date);
    LogParser::write_logs_to_json($filtered_logs, 'temp/parsed_logs.json');
}

if ($filter_ip) {
    my $logs = LogParser::read_logs_from_json('temp/parsed_logs.json');
    my $filtered_logs = LogParser::filter_by_ip($logs, $filter_ip);
    LogParser::write_logs_to_json($filtered_logs, 'temp/parsed_logs.json');
}

if ($filter_user_agent) {
    my $logs = LogParser::read_logs_from_json('temp/parsed_logs.json');
    my $filtered_logs = LogParser::filter_by_user_agent($logs, $filter_user_agent);
    LogParser::write_logs_to_json($filtered_logs, 'temp/parsed_logs.json');
}

if ($filter_url) {
    my $logs = LogParser::read_logs_from_json('temp/parsed_logs.json');
    my $filtered_logs = LogParser::filter_by_url($logs, $filter_url);
    LogParser::write_logs_to_json($filtered_logs, 'temp/parsed_logs.json');
}

if ($generate_report) {
    my $logs = LogParser::read_logs_from_json('temp/parsed_logs.json');
    my $report = ReportGenerator::generate_report($logs);
    open my $fh, '>', 'temp/report.json' or die "Cannot open file 'temp/report.json': $!\n";
    print $fh to_json($report, { pretty => 1 });
    close $fh;
}

if ($export_text) {
    my $report = read_report_from_file('temp/report.json');
    MyExporter::export_to_text($report, 'output/report.txt');
}

if ($export_csv) {
    my $report = read_report_from_file('temp/report.json');
    MyExporter::export_to_csv($report, 'output/report.csv');
}

sub read_report_from_file {
    my ($file_path) = @_;
    open my $fh, '<', $file_path or die "Cannot open file '$file_path': $!\n";
    local $/; # Enable 'slurp' mode
    my $json_text = <$fh>;
    close $fh;
    my $report = from_json($json_text);
    return $report;
}