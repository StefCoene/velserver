# Some mysql related subfunctions

# Connect to the mysql database and returns the databse handler
sub connect_to_db {
   # Default settings
   $global{Config}{mysql}{NAME} = "velbus"    if ! defined $global{Config}{mysql}{NAME} ;
   $global{Config}{mysql}{HOST} = "localhost" if ! defined $global{Config}{mysql}{HOST} ;
   $global{Config}{mysql}{USER} = "velbus"    if ! defined $global{Config}{mysql}{USER} ;
   $global{Config}{mysql}{PASS} = "velbus"    if ! defined $global{Config}{mysql}{PASS} ;

   my $dbh = DBI->connect(
      "DBI:mysql:$global{Config}{mysql}{NAME}:$global{Config}{mysql}{HOST}:mysql_client_found_rows=1",
      $global{Config}{mysql}{USER},
      $global{Config}{mysql}{PASS},
         {
            AutoCommit=>1,
            mysql_auto_reconnect=>1
         }
      ) ;
   
   if ( defined $DBI::errstr ) {
      print "Connection problem: $DBI::errstr\n" ;
      return undef ;
   } else {
      return $dbh ;
   }
}

# Execute a query
sub do_query {
   my $dbh    = shift ;
   my $query  = shift ;
   my @values = @_ ;

   my $table_data = $dbh->prepare($query) ;
   $table_data->execute(@values) || return undef ;
   return $table_data ;
}

# Fetch some data from the database and return the data in hash format
# If a key is provided as third parameter, use this column as the key for the hash
sub fetch_data {
   my $dbh        = shift ;
   my $query      = shift ;
   my $return_key = shift ;
   my @values     = @_ ;

   my $table_data = $dbh->prepare($query) ;
   my @keys ;

   eval { $table_data->execute(@values) } ;
   if ( $@ ne "" ) {
      print "Error executing $query:\n" ;
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
}

return 1 ;
