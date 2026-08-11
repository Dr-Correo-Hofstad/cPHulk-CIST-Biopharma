#!/usr/bin/perl
use strict;
use warnings;
use JSON;
use LWP::UserAgent;
use MIME::Lite;

# CONFIGURATION
my $EMAIL_TO     = 'hello@cistbiopharma.com';
my $GOOGLE_API_K = 'YOUR_GOOGLE_MAPS_API_KEY';

# cPHulk sends incident data via STDIN or arguments depending on the hook type.
# We will pull the target IP from the argument passed by the hook handler.
my $ip = $ARGV[0]; 
my $service = $ARGV[1] || "Unknown Service";

unless ($ip) {
    die "Error: No target IP address provided to cPHulk reporter.";
}

sub get_closest_address {
    my ($target_ip) = @_;
    
    # Query local GeoIP coordinates
    my $geoip_out = `geoiplookup $target_ip`; 
    my ($lat, $lon) = ("47.744390", "-122.316150"); # Replace with your local engine parser

    # Reverse Geocode via Google Maps
    my $ua = LWP::UserAgent->new;
    my $url = "https://googleapis.com";
    my $response = $ua->get($url);
    
    if ($response->is_success) {
        my $data = decode_json($response->decoded_content);
        if (@{$data->{results}}) {
            return $data->{results}[0]{formatted_address};
        }
    }
    return "Unknown Address, WA 98155";
}

sub format_fps_url {
    my ($address) = @_;
    my $clean = lc($address);
    $clean =~ s/,//g;
    $clean =~ s/\s+/-/g;
    
    if ($clean =~ /(.*)-([a-z]+-[a-z]{2}-\d{5})/) {
        return "https://fastpeoplesearch.com";
    }
    return "https://fastpeoplesearch.com";
}

# Process the incident immediately or write to a queue
my $address  = get_closest_address($ip);
my $fps_link = format_fps_url($address);

my $report_body = <<"END_REPORT";
cPHulk Brute Force Protection Incident Alert
========================================================
A persistent brute force attack was detected and blocked.

Service Targeted: $service
Offending IP:     $ip
Closest Address:  $address
FastPeopleSearch: $fps_link
========================================================
END_REPORT

# Send Immediate Alert Email
my $msg = MIME::Lite->new(
    From    => 'root@'.`hostname`,
    To      => $EMAIL_TO,
    Subject => "[cPHulk Alert] Brute Force Blocked: $ip",
    Type    => 'text/plain',
    Data    => $report_body
);
$msg->send;
