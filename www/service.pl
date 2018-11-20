#!/usr/bin/perl

# 1. item is updated by clicking in openHAB interface
# 2. service.pl is called via the http binding
# 3. service.pl checks the current state and if it differs calls the appropriate function to post a message to the velbus
# 4. logger.pl picks up the response to this message and use the REST API of openHAB to inform openhab that something changed
# 4bis. logger.pl also updates the database
# 5. item is updated in openHAB
# 6. service.pl is called via the http binding
# 7. service.pl checks the current state and if it differs calls the appropriate function to post a message to the velbus
#      !!!!! if logger.pl is too slow in updating the database, service.pl is unaware of this change and will repost the velbus message

use lib "/home/velbus/velserver/lib" ;

use strict;
use POSIX qw/strftime/;

our %global ; # Variable shared by all functions where we store all data
$global{BaseDir} = "/home/velbus/velserver" ;

use Velbus ;
&init ;

my $sock = &open_socket ;

use Velbus::Velbus_www ;

use CGI ;
use CGI::Session ;
use JSON ;

$global{cgi}{CGI} = new CGI ;
my $session  = CGI::Session->load() ;

%{$global{cgi}{params}} = $global{cgi}{CGI}->Vars; # Get all supplied parameters in a hash

my %json = &www_service ;

if ( defined $global{cgi}{params}{html} ) {
   print $session->header() ;
   foreach my $key (sort keys %json) {
      print "$key: $json{$key}<br />\n" ;
   }
} else {
   print $session->header(-type=>'application/json') ;
   print encode_json(\%json) ;
}
 
