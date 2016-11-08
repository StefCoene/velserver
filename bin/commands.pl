#!/usr/bin/perl 

use lib "/data/velserver/lib" ;
our %global ;
$global{Config}{BaseDir} = "/data/velserver" ;

use Getopt::Long ;
&GetOptions ('option=s' => \$global{opts}{option} ,
             'help' => \$global{opts}{help} ) or &print_help ;

# Print help en exit dan
sub print_help {
   print "Possible options:

   -o = 
      test = for testing new functionality
      status = get status off all modules
      date = broadcast date and time
      scan = scan all modules on the bus
      blind = query blind status on address 0x01
   
" ;
   exit ;
}  

if ( defined $global{opts}{help} ) {
   &print_help ;
}  

use strict;
use POSIX qw/strftime/;

use Velbus ;

&init () ;

my $sock = &open_socket ;

if ( $global{opts}{option} eq "test" ) {
   &test($sock) ;
} elsif ( $global{opts}{option} eq "status" ) {
   &get_modules_status($sock) ;
} elsif ( $global{opts}{option} eq "date" ) {
   &broadcast_datetime($sock) ;
} elsif ( $global{opts}{option} eq "scan" ) {
   &scan($sock) ;
} elsif ( $global{opts}{option} eq "blind" ) {
   &get_module_status ($sock,"0x01","1D") ;
} else {
   &print_help ;
}
