# Include some basic perl modules
use Data::Dumper ;
$Data::Dumper::Sortkeys = 1 ; # Sort the keys in the output
$Data::Dumper::Deepcopy = 1 ; # Enable deep copies of structures
$Data::Dumper::Indent = 1 ;   # Output in a reasonable style (but no array indexes)

use Hash::Merge qw( merge );

# To be able to open a socket to the Velbus server
use IO::Socket ;

use Convert::Color ;

# high resolution timer
use Time::HiRes qw(usleep) ;

use JSON ;

# For communication with the database
use DBI ;
use database ;

# Our own functions:
use Velbus::Velbus ;
use Velbus::Velbus_database ;
use Velbus::Velbus_helper ;
#use Velbus::Velbus_data_protocol_auto ;
#use Velbus::Velbus_data_protocol_memory ;
#use Velbus::Velbus_data_protocol_messages ;
#use Velbus::Velbus_data_protocol_channels ;
#use Velbus::Velbus_data_channels ;
#use Velbus::Velbus_data ;
use Velbus::Velbus_openHAB ;
use Velbus::Velbus_log ;

# Read some config files and set default values if needed
sub read_all_configs {
   $global{Config} = {} ;
   &read_config("mysql") ;
   &read_config("velbus") ;
   &read_config("www") ;
   &read_config("openHAB") ;
   &read_config("velserver") ;

   if ( defined $global{Config}{mysql} ) {
      # Default settings
      $global{Config}{mysql}{NAME} = "velbus"    if ! defined $global{Config}{mysql}{NAME} ;
      $global{Config}{mysql}{HOST} = "localhost" if ! defined $global{Config}{mysql}{HOST} ;
      $global{Config}{mysql}{USER} = "velbus"    if ! defined $global{Config}{mysql}{USER} ;
      $global{Config}{mysql}{PASS} = "velbus"    if ! defined $global{Config}{mysql}{PASS} ;
      $global{Config}{mysql}{PORT} = "3306"      if ! defined $global{Config}{mysql}{PORT} ;
   } else {
      $global{Config}{SQLite}{dbdir}  = $global{BaseDir} . "/db" ;
      $global{Config}{SQLite}{dbfile} = $global{BaseDir} . "/db/database.dbf" ;
      mkdir ("$global{Config}{SQLite}{dbdir}") if ! -d $global{Config}{SQLite}{dbdir} ;
   }

   $global{Config}{velserver}{PROTOCOLFILE} = "$global{BaseDir}/lib/Velbus/protocol.json" if ! defined $global{Config}{velserver}{PROTOCOLFILE} ;
   $global{Config}{velserver}{WEBSERVERPORT} = "80" if ! defined $global{Config}{velserver}{WEBSERVERPORT} ;

   $global{Config}{velbus}{HOST} = "localhost"    if ! defined $global{Config}{velbus}{HOST} ;
   $global{Config}{velbus}{PORT} = "3788"         if ! defined $global{Config}{velbus}{PORT} ;

   $global{Config}{openHAB}{REST_URL}  = "http://localhost:8080/rest/items"      if ! defined $global{Config}{openHAB}{REST_URL} ;
   # 60000 milliseconds = 1 minute
   $global{Config}{openHAB}{POLLING}   = 60000                                   if ! defined $global{Config}{openHAB}{POLLING} ;
   $global{Config}{openHAB}{BASE_URL}  = "http://localhost/velserver/service.pl" if ! defined $global{Config}{openHAB}{BASE_URL} ;
   $global{Config}{openHAB}{ITEM_FILE} = "/etc/openhab2/items/velbus.items"      if ! defined $global{Config}{openHAB}{ITEM_FILE} ;
   # When POLLING = 0, we don't have to poll from openHAB
   if ( $global{Config}{openHAB}{POLLING} eq "0" ) {
   } else {
      $global{Config}{openHAB}{POLL_STATUS} = "YES" ;
   }
}

sub init {
   my $option = shift ;
   &read_all_configs ;

   &download_protocol_file ;
   &read_protocol_file ;

   # open a connection to the database
   $global{dbh} = &connect_to_db ($option) ;

   # Get all modules from the database
   &get_all_modules_from_database ;
}

# Download the protocol file if it's not found
sub download_protocol_file {
   if ( -f $global{Config}{velserver}{PROTOCOLFILE} ) {
      #print "Protocol file found: $global{Config}{velserver}{PROTOCOLFILE}\n" ;
   } else {
      my $output = `wget https://raw.githubusercontent.com/StefCoene/moduleprotocol/master/out/protocol.json -O $global{Config}{velserver}{PROTOCOLFILE} 2>&1` ;
      my $return = $? ;
      if ( $return eq "0" ) {
         #print "Protocol file download: $global{Config}{velserver}{PROTOCOLFILE}\n" ;
      } else {
         print "ABORT: Protocol file NOT downloaded:\n" ;
         print "command: wget https://raw.githubusercontent.com/StefCoene/moduleprotocol/master/out/protocol.json -O $global{Config}{velserver}{PROTOCOLFILE}\n" ;
         print "return code: $return\n" ;
         print "output:\n$output\n" ;
         exit ;
      }
   }
}

# Read the protocol file
sub read_protocol_file {
   if ( -f $global{Config}{velserver}{PROTOCOLFILE} ) {
      open (FILE,"<", $global{Config}{velserver}{PROTOCOLFILE}) ;
      my @lines = <FILE>;
      close FILE ;
      my $json = join "", @lines ;

      eval {
         $global{Cons} = decode_json($json) ; # Knalt er nogal hard uit als er iets is met de json string
      } ;
      if ( defined $global{Cons} ) {
         #print "Protocol file parsed successful\n" ;
      } else {
         print "ABORT: json syntax error in Protocol file $global{Config}{velserver}{PROTOCOLFILE}\n" ;
      }
   } else {
      print "ABORT: Protocol file NOT found: $global{Config}{velserver}{PROTOCOLFILE}\n" ;
   }
}

return 1
