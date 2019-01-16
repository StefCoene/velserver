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

our %global ; # Variable shared by all functions where we store all data
$global{BaseDir} = "/home/velbus/velserver" ;

use Velbus ;
&init ;

use Velbus::Velbus_www ;

use CGI ;
use CGI::Session ;
use JSON ;

$global{cgi}{CGI} = new CGI ;
my $session  = CGI::Session->load() ;

# When doing POST for Memo text, the content has to be used as Value. This can be found in ->param with $param = POSTDATA.
# But we also need to parse rest of the parameters supplied in the url. These can be found with ->url_param.
foreach my $param ($global{cgi}{CGI}->param()) {
   if ( $param eq "POSTDATA" ) {
      $global{cgi}{params}{Value} = $global{cgi}{CGI}->param($param) ;
   }
}

foreach my $param ($global{cgi}{CGI}->url_param()) {
   $global{cgi}{params}{$param} = $global{cgi}{CGI}->url_param($param) ;
}

my %json = &www_service ;

if ( exists $global{cgi}{params}{html} ) {
   print $session->header() ;
   foreach my $key (sort keys %json) {
      print "$key: $json{$key}<br />\n" ;
   }
} else {
   print $session->header(-type=>'application/json') ;
   print encode_json(\%json) ;
}
