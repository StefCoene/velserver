# Include some basic perl modules>
use Data::Dumper ;

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
use Velbus::Velbus_data_protocol ;
use Velbus::Velbus_data ;
use Velbus::Velbus_helper ;

&read_config("mysql") ;
&read_config("velbus") ;

# open a connection to the mysql db
$global{dbh} = &connect_to_db ;

# Get all modules from the mysql db
&get_all_modules_from_mysql ;

return 1
