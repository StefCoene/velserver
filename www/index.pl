#!/usr/bin/perl

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

print &www_index ;
print $global{cgi}{CGI}->end_html() ;
