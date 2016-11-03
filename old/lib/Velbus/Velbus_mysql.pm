
# Mysql related sub functions to get the data out of the mysql database

# Get all modules from the mysql database
sub get_all_modules_from_mysql {
   my %data = &fetch_data ($global{dbh},"select * from modules","address" ) ;

   foreach my $address (sort keys %data ) {
      my $type   = $data{$address}{type} ; # Handier var
      my $status = $data{$address}{status} ; # Handier var

      %{$global{Vars}{Modules}{Address}{$address}{ModuleInfo}} = %{$data{$address}} ; # List of all modules
      %{$global{Vars}{Modules}{PerStatus}{$status}{$address}} = %{$data{$address}} ; # List of all modules per status
      %{$global{Vars}{Modules}{PerType}{$type}{$address}} = %{$data{$address}} ; # List of all modules per type
   }

   &get_all_modules_info_from_mysql ;
}

# Loop all found modules and load the extra info from the mysql database
sub get_all_modules_info_from_mysql {
   foreach my $address (sort keys (%{$global{Vars}{Modules}{PerStatus}{Found}}) ) {
      my %data = &fetch_data ($global{dbh},"select * from modules_info where `address`='$address'","data" ) ;
      foreach my $data (sort keys (%data)) {
         $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{$data} = $data{$data}{value} ;
         # Sub addresses are also kept in 'SubAddr' for easy access
         if ( $data =~ /^SubAddr/ ) {
            # TODO: save type per sub address, sometimes info is transmitted with the sub address like COMMAND_MODULE_STATUS
            push @{$global{Vars}{Modules}{Address}{$address}{ModuleInfo}{SubAddr}}, $data{$data}{value} ;
         }
      }

      my %datatemp = &fetch_data ($global{dbh},"select * from modules_channel_info where `address`='$address'" ) ;
      foreach my $key (sort keys (%datatemp)) {
         my $date    = $datatemp{$key}{date} ;    # Handier var
         my $address = $datatemp{$key}{address} ; # Handier var
         my $channel = $datatemp{$key}{channel} ; # Handier var
         my $data    = $datatemp{$key}{data} ;    # Handier var
         my $value   = $datatemp{$key}{value} ;   # Handier var
         $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$channel}{$data} = $value ;
      }
   }
}

return 1 ;
