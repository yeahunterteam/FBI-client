#!/usr/bin/env perl
# 
# bitly.pl - a simple perl api client to the bit.ly URL shortening web service.
#
# Sean O'Donnell <sean@seanodonnell.com>
# 
# $Id: $
#
use strict;
use LWP::UserAgent;
use URI::Escape;

my $lwp = LWP::UserAgent->new;

$lwp->agent("Perl::Bitly/1.0");

# you must obtain an API Key from www.bit.ly
my $api_key = "0fdf4eaf24";

my $url = uri_escape($ARGV[0]);

my $api_src = "http://yhst.eu/yourls-api.php?signature=".$api_key."&action=shorturl&format=json&url=".$url;

my $response = $lwp->get($api_src);

if ($response->is_success)
{
    my $raw_data = $response->decoded_content;
    
    foreach my $line (split(/\n/,$raw_data))
    {
        if ($line =~ m/shorturl/i)
        {
            my @url_bitly = split(/([{}\s\"])shorturl/,$line);
            my @url_bitly = split(/\"/,$url_bitly[2]);
            $url_bitly[2] =~ s/\\//g;
            #print "\n\nurl: $url\nbitly: ". $url_bitly[2] ."\n";
            print $url_bitly[2];
            last;
        }
    }
}
