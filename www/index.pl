#!/usr/bin/perl

use lib "/home/velbus/velserver/lib" ;

use strict;

our %global ; # Variable shared by all functions where we store all data
$global{BaseDir} = "/home/velbus/velserver" ;

use Velbus ;
&init ;

use Velbus::Velbus_www ;

use CGI ;
use CGI::Session ;

$global{cgi}{CGI} = new CGI ;
%{$global{cgi}{params}} = $global{cgi}{CGI}->Vars; # Get all supplied parameters in a hash
$global{cgi}{url} = $global{cgi}{CGI}->url(-path_info=>1,-query=>1);

my $session  = CGI::Session->load() ;

print $session->header() ;

print &www_index ;
