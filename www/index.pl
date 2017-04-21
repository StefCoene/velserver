#!/usr/bin/perl

use lib "/home/velbus/velserver/lib" ;

use strict;
use POSIX qw/strftime/;

our %global ; # Variable shared by all functions where we store all data
$global{Config}{BaseDir} = "/home/velbus/velserver" ;

use Velbus ;
&init ;

my $sock = &open_socket ;

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
print "<a href=?key=$global{cgi}{params}{key}&appl=print_modules>Modules on bus</a> || " ;
print "<a href=?key=$global{cgi}{params}{key}&appl=print_velbus_protocol>Velbus protocol</a> || " ;
print "<a href=?key=$global{cgi}{params}{key}&appl=print_velbus_messages>Velbus messages</a> || " ;
print "<a href=?key=$global{cgi}{params}{key}&appl=openHAB>openHAB config</a> || " ;
print "<a href=?key=$global{cgi}{params}{key}&appl=scan>Scan the bus || </a> " ;
print "<a href=?key=$global{cgi}{params}{key}&appl=clear_database>Clear mysql info</a> " ;
print "</p>\n" ;

if ( defined $global{cgi}{params}{appl} ) {
   if ( $global{cgi}{params}{appl} eq "print_modules" ) {
      if ( defined $global{cgi}{params}{action} ) {
         if ( $global{cgi}{params}{action} eq "status" ) {
            &www_update_module_status ;
         }
      }
      &www_print_modules ;
   }
   if ( $global{cgi}{params}{appl} eq "print_velbus_protocol" ) {
      &www_print_velbus_protocol ;
   }
   if ( $global{cgi}{params}{appl} eq "print_velbus_messages" ) {
      &www_print_velbus_messages ;
   }
   if ( $global{cgi}{params}{appl} eq "openHAB" ) {
      &www_openHAB ;
   }
   if ( $global{cgi}{params}{appl} eq "scan" ) {
      &www_scan ;
   }
   if ( $global{cgi}{params}{appl} eq "clear_database" ) {
      &www_clear_database ;
   }
   if ( $global{cgi}{params}{appl} eq "debug" ) {
      print "<pre>\n" ;
      print Dumper {%global} ;
      print "</pre>\n" ;
   }
}

print $global{cgi}{CGI}->end_html() ;
