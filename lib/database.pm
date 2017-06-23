# Some databes related subfunctions

# Connect to the database database and returns the database handler
sub connect_to_db {
   my $dbh ; # Our database handler
   my $option = shift ;

   # If we have a mysql config, we connect to the mysql database
   # Otherwise we ceate SQlite database
   if ( defined $global{Config}{mysql} ) {
      $dbh = DBI->connect(
         "DBI:mysql:$global{Config}{mysql}{NAME}:$global{Config}{mysql}{HOST}:mysql_client_found_rows=1",
         $global{Config}{mysql}{USER},
         $global{Config}{mysql}{PASS},
            {
               AutoCommit=>1,
               mysql_auto_reconnect=>1
            }
         ) ;
   } else {
      if ( $option =~ /readonly/ ) {
         $dbh = DBI->connect("dbi:SQLite:dbname=$global{Config}{SQLite}{dbfile}",undef,undef,
               { sqlite_open_flags => DBD::SQLite::OPEN_READONLY, }
            ) ;
      } else {
         $dbh = DBI->connect("dbi:SQLite:dbname=$global{Config}{SQLite}{dbfile}",undef,undef) ;
      }
   }

   if ( defined $DBI::errstr ) {
      print "Connection problem: $DBI::errstr\n" ;
      $dbh = undef ;
   } else {
      if ( defined $global{Config}{mysql} ) {
      } else {
         &sqlite_check_tables($dbh) ;
      }
   }
   return $dbh ;
}

# Execute a query
sub do_query {
   my $dbh    = shift ;
   my $query  = shift ;
   my @values = @_ ;

   #print "executing $query:\n" ;
   #print join (",", @values) . "\n" ;

   my $table_data = $dbh->prepare($query) ;
   if ( $table_data ) {
      eval { $table_data->execute(@values) } ;
      if ( $@ ne "" ) {
         print "Error executing $query:\n" ;
         print join (",", @values) . "\n" ;
         print "$@\n" ;
      }
   } else {
      print "Error executing $query:\n" ;
      print join (",", @values) . "\n" ;
   }
}

# Fetch some data from the database and return the data in hash format
# If a key is provided as third parameter, use this column as the key for the hash
sub fetch_data {
   my $dbh        = shift ;
   my $query      = shift ;
   my $return_key = shift ;
   my @values     = @_ ;

   my $table_data = $dbh->prepare($query) ;
   if ( $table_data ) {
      eval { $table_data->execute(@values) } ;
      if ( $@ ne "" ) {
         print "Error executing $query:\n" ;
         print join (",", @values) . "\n" ;
         print "$@\n" ;
         return undef ;
      } else {
         my %data ;
         my $counter = 0 ;
         while ( my $ref = $table_data->fetchrow_hashref() ) {
            if ( defined $return_key ) {
               $data{$ref->{$return_key}} = $ref ;
            } else {
               $data{$counter} = $ref ;
            }
            $counter ++ ;
         }
         $table_data->finish() ;
         return %data ;
      }
   } else {
      print "Error executing $query:\n" ;
      print join (",", @values) . "\n" ;
      return undef ;
   }
}

# Create the 3 tables in SQLite if they don't exist
sub sqlite_check_tables {
   my $dbh = shift ;

   my $SQL = "SELECT count(*) as count FROM modules" ;
   my %data = &fetch_data($dbh,$SQL) ;
   if ( $data{'0'} ) {
   } else {
      print "Create table modules\n" ;
      my $SQL = "CREATE TABLE `modules` (
            `address` varchar(2) NOT NULL,
            `name` varchar(16),
            `type` varchar(16),
            `status` varchar(16),
            `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`address`)
         )" ;
      &do_query($dbh,$SQL) ;
   }

   my $SQL = "SELECT count(*) as count FROM modules_channel_info" ;
   my %data = &fetch_data($dbh,$SQL) ;
   if ( $data{'0'} ) {
   } else {
      print "Create table modules_channel_info\n" ;
      my $SQL = "CREATE TABLE `modules_channel_info` (
            `address` varchar(2) NOT NULL,
            `channel` varchar(40) NOT NULL,
            `data` varchar(40) NOT NULL,
            `value` varchar(120) NOT NULL,
            `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`address`,`channel`,`data`)
         )" ;
      &do_query($dbh,$SQL) ;
   }

   my $SQL = "SELECT count(*) as count FROM modules_info" ;
   my %data = &fetch_data($dbh,$SQL) ;
   if ( $data{'0'} ) {
   } else {
      print "Create table modules_info\n" ;
      my $SQL = "CREATE TABLE `modules_info` (
            `address` varchar(2) NOT NULL,
            `data` varchar(40) NOT NULL,
            `value` varchar(120) NOT NULL,
            `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`address`,`data`)
         )" ;
      &do_query($dbh,$SQL) ;
   }
}

return 1 ;
