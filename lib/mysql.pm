# Some mysql related subfunctions

# Connect to the mysql database and returns the databse handler
sub connect_to_db {
   # Default settings
   $global{Config}{mysql}{name} = "velbus"    if ! defined $global{Config}{mysql}{name} ;
   $global{Config}{mysql}{host} = "localhost" if ! defined $global{Config}{mysql}{host} ;
   $global{Config}{mysql}{user} = "velbus"    if ! defined $global{Config}{mysql}{user} ;
   $global{Config}{mysql}{pass} = "velbus"    if ! defined $global{Config}{mysql}{pass} ;

   my $dbh = DBI->connect(
      "DBI:mysql:$global{Config}{mysql}{name}:$global{Config}{mysql}{host}:mysql_client_found_rows=1",
      $global{Config}{mysql}{user},
      $global{Config}{mysql}{pass},
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

sub disconnect {
   my $dbh = shift ;
   # disconnect from database
   $dbh->disconnect;
}

sub do_insert {
   my $dbh = shift ;
   my $query = shift ;
   my @values = @_ ;
   my $table_data = $dbh->prepare($query) ;
   $table_data->execute(@values) || return undef ;
   $inserted_id = $dbh->{'mysql_insertid'} ;
   return $inserted_id ;
}

# Execute a query
sub do_query {
   my $dbh = shift ;
   my $query = shift ;
   my @values = @_ ;
   my $table_data = $dbh->prepare($query) ;
   $table_data->execute(@values) || return undef ;
   return $table_data ;
}

# Fetch some data from the database and return the data in hash format
# If a key is provided as third parameter, use this column as the key for the hash
sub fetch_data {
   my $dbh =  shift ;
   my $query = shift ;
   my $return_key = shift ;
   my @values = @_ ;
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
