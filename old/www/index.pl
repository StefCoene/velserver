#!/usr/bin/perl

use lib "/data/Velbus/perl/lib" ;

use strict;
use POSIX qw/strftime/;

use Velbus ;

my $sock = &open_socket ;

our %global ; # Variable shared by all functions where we store all data

use Velbus ;
use Velbus::Velbus_www ;

use CGI ;
use CGI::Session ;

$global{cgi}{CGI} = new CGI ;
my $session  = CGI::Session->load() ;

print $session->header() ;

%{$global{cgi}{params}} = $global{cgi}{CGI}->Vars; # Get all supplied parameters in a hash
$global{cgi}{url} = $global{cgi}{CGI}->url(-path_info=>1,-query=>1);
 
# Starten van html output
# includen van de nodige files: css en javascript
print $global{cgi}{CGI}->start_html (
   -title=>"Velbus",
   -style=>[
      {'src'=>"https://cdn.datatables.net/1.10.12/css/jquery.dataTables.min.css"},
   ],
   -script=>[
      { -type=>'text/javascript',
        -src=>'include/jquery-min.js'},
      { -type=>'text/javascript',
        -src=>'include/toggle.js'},
      { -type=>'text/javascript',
        -src=>'include/script.pl'},
      { -type=>'text/javascript',
        -src=>'https://cdn.datatables.net/1.10.12/js/jquery.dataTables.min.js'},
   ]
) ;

print "<p>\n" ;
print "<a href=?action=print_modules>Modules on bus</a> || " ;
print "<a href=?action=print_velbus_protocol>Velbus protocol</a> || " ;
print "<a href=?action=scan>Scan the bus</a> || " ;
print "<a href=?action=status>Get status of all modules and channels</a> || " ;
print "</p>\n" ;
if ( defined $global{cgi}{params}{action} ) {
   if ( $global{cgi}{params}{action} eq "print_velbus_protocol" ) {
      &www_print_velbus_protocol ;
   }
   if ( $global{cgi}{params}{action} eq "print_modules" ) {
      &www_print_modules ;
   }
   if ( $global{cgi}{params}{action} eq "scan" ) {
      &www_scan ;
   }
   if ( $global{cgi}{params}{action} eq "status" ) {
      &www_status ;
   }
}

print $global{cgi}{CGI}->end_html() ;
