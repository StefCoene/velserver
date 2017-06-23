#!/usr/bin/perl 

use lib "/home/velbus/velserver/lib" ;
our %global ;
$global{BaseDir} = "/home/velbus/velserver" ;

&init () ;
# Connect to the Velbus server and monitor the bus.
# All packets are analysed and printed on STDOUT.
# All packets are logged in the database (only for mysql and if enabled in the config file)

use strict;
use POSIX qw/strftime/;

use Velbus ;

my $sock = &open_socket ;

our %global ; # Variable shared by all functions where we store all data

while (1) {
   # wait for data
   my $recv_data;
   $sock->recv($recv_data,10240);
   chomp($recv_data);

   &process_raw_message ($recv_data) ;
}
