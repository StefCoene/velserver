#!/usr/bin/perl 

# This process will run as a daemon and will connects to the bus via (local or remote) velserv (or othre TCPIP implementation).
# The packets are analysed and processed.

use lib "/home/velbus/velserver/lib" ;

our %global ; # Variable shared by all functions where we store all data
$global{BaseDir} = "/home/velbus/velserver" ;

use strict;

use Velbus ;
&init () ;

my $sock ;

while (1) {
   # Connected socket? Try to read from it.
   if (defined $sock and $sock->connected) {
      my $recv_data;

      $sock->recv($recv_data,10240) ;

      if ( $recv_data and $recv_data ne "" ) {
         chomp($recv_data) ;
         &process_raw_message ($recv_data) ;

      # Nothing returned? Discard socket so we can reconnect.
      } else {
         print "Nothing received? Undef socket.\n" ;
         &log("logger",&timestamp . " Nothing received? Undef socket.") ;
         undef $sock ;
      }

   # No socket or socket exist but it's not connected? Open a new one.
   } else {
      sleep 1 ;
      $sock = &open_socket ;
      if ( ! defined $sock ) {
         print "No connection to $global{Config}{velbus}{HOST} port $global{Config}{velbus}{PORT}\n" ;
         &log("logger",&timestamp . " No connection to $global{Config}{velbus}{HOST} port $global{Config}{velbus}{PORT}") ;
      } else {
         print "Connected to $global{Config}{velbus}{HOST} port $global{Config}{velbus}{PORT}\n" ;
         &log("logger",&timestamp . " Connected to $global{Config}{velbus}{HOST} port $global{Config}{velbus}{PORT}") ;
      }
   }
}
