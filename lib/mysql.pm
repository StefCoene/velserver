sub connect_to_db {
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
      return $dbh;
   }
}

sub disconnect {
   my $dbh = shift;
   # disconnect from database
   $dbh->disconnect;
}

sub do_insert {
   my $dbh = shift;
   my $query = shift;
   my @values = @_ ;
   my $table_data = $dbh->prepare($query);
   $table_data->execute(@values) || return undef ;
   $inserted_id = $dbh->{'mysql_insertid'} ;
   return $inserted_id ;
}

sub do_query {
   my $dbh = shift;
   my $query = shift;
   my @values = @_ ;
   my $table_data = $dbh->prepare($query);
   $table_data->execute(@values) || return undef ;
   return $table_data;
}

sub fetch_data {
   my $dbh =  $_[0] ;
   my $query = $_[1] ;
   my $return_key = $_[2] ;
   my $sth = $dbh->prepare("$query") ;
   my @keys ;

   eval { $sth->execute ; } ;
   if ( $@ ne "" ) {
      print "Error executing $query<br>\n----<br>\n$@----<br>\n" ;
      return undef ;
   } else {
      my %data ;
      my $counter = 0 ;
      while ( my $ref = $sth->fetchrow_hashref() ) {
         if ( defined $return_key ) {
            $data{$ref->{$return_key}} = $ref ;
         } else {
            $data{$counter} = $ref ;
         }
         $counter ++ ;
      }
      $sth->finish() ;
      return %data ;
   }
}

return 1 ;
