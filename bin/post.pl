#!/usr/bin/perl

use HTTP::Request::Common;
use LWP::UserAgent ;

my $URL = "http://geuze:8080/rest/items/HeaterMode_36" ;
my $URL = "http://geuze:8080/rest/items/Switch_20_01" ;

# Create the browser that will post the information.
my $Browser = new LWP::UserAgent;

my $Page = $Browser->request(POST $URL,
   Content_Type => 'text/plain',
   Content => "ON"
) ;

my $data = $Page->content ;

print $data ;
