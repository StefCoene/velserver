# Include some basic perl modules>
use Data::Dumper ;
$Data::Dumper::Sortkeys = 1 ; # Sort the keys in the output
$Data::Dumper::Deepcopy = 1 ; # Enable deep copies of structures
$Data::Dumper::Indent = 1 ;   # Output in a reasonable style (but no array indexes)

# To be able to open a socket to the Velbus server
use IO::Socket;

# high res timer
use Time::HiRes qw(usleep nanosleep);

# For communication with mysql
use DBI ;
use mysql ;

# Our own functions:
use Velbus::Velbus ;
use Velbus::Velbus_mysql ;
use Velbus::Velbus_data_protocol_auto ;
use Velbus::Velbus_data_protocol_memory ;
use Velbus::Velbus_data_protocol ;
use Velbus::Velbus_data ;
use Velbus::Velbus_helper ;
use Velbus::Velbus_openHAB ;
use Velbus::Velbus_log ;

sub init {
   # Read some config files
   &read_config("mysql") ;
   &read_config("velbus") ;
   &read_config("www") ;
   &read_config("openHAB") ;

   # open a connection to the mysql db
   $global{dbh} = &connect_to_db ;

   # Get all modules from the mysql db
   &get_all_modules_from_mysql ;
   
   foreach my $Type (sort keys %{$global{Cons}{ModuleTypes}}) {
      foreach my $MemoryMap (sort keys %{$global{Cons}{ModuleTypes}{$Type}{Memory}}) {
         if ( defined $global{Cons}{ModuleTypes}{$Type}{Memory}{$MemoryMap}{ModuleName} ) {
            # print "Type = $Type, MemoryMap = $MemoryMap\n" ;

            my ($start,$end) = split ":", $global{Cons}{ModuleTypes}{$Type}{Memory}{$MemoryMap}{ModuleName} ;
            $start = &hex_to_dec ($start) ;
            $end   = &hex_to_dec ($end) ;
            my $hex = &dec_to_4hex($start) ;
            $global{Cons}{ModuleTypes}{$Type}{Memory}{$MemoryMap}{Address}{"$hex"}{Type} = "ModuleNameStart" ;

            my $hex1 ; my $hex2 ;
            for ($i="$start"; $i <= "$end"; $i++) {
               my $hex = &dec_to_4hex($i) ;
               $hex =~ /(..)(..)/ ;
               $hex1 = $1 ;
               $hex2 = $2 ;
               $global{Cons}{ModuleTypes}{$Type}{Memory}{$MemoryMap}{Address}{"$hex1$hex2"}{Type} = "ModuleName" if ! defined $global{Cons}{ModuleTypes}{$Type}{Memory}{$MemoryMap}{Address}{"$hex1$hex2"}{Type} ;
            }
            $global{Cons}{ModuleTypes}{$Type}{Memory}{$MemoryMap}{Address}{"$hex1$hex2"}{Type} = "ModuleNameSave" ;

         }
      }
   }
}

return 1
