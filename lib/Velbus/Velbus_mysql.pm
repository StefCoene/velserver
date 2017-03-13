
# Mysql related sub functions to get the data out of the mysql database

# Get all modules from the mysql database
sub get_all_modules_from_mysql {
   my %data = &fetch_data ($global{dbh},"select * from `modules` where `status`='found'","address" ) ;

   foreach my $address (sort keys %data ) {
      my $type   = $data{$address}{type} ; # Handier var
      next if $type eq '' ;
      my $status = $data{$address}{status} ; # Handier var

      %{$global{Vars}{Modules}{Address}{$address}{ModuleInfo}} = %{$data{$address}} ; # List of all modules
      $global{Vars}{Modules}{PerStatus}{$status}{ModuleList}{$address} = "yes" ; # List of all modules per status
      $global{Vars}{Modules}{PerType}{$type}{ModuleList}{$address} = "yes" ; # List of alle modules per type module
   }

   &get_all_modules_info_from_mysql ;
}

# Loop all found modules and load the extra info from the mysql database
sub get_all_modules_info_from_mysql {
   foreach my $address (sort keys (%{$global{Vars}{Modules}{PerStatus}{Found}{ModuleList}}) ) {
      my %SubAddr ;

      my %data = &fetch_data ($global{dbh},"select * from `modules_info` where `address`='$address'","data" ) ;
      foreach my $data (sort keys (%data)) {
         # Sub addresses are kept in 'SubAddr' for easy access
         if ( $data =~ /^SubAddr/ and $data{$data}{value} ne "FF" ) {
            # TODO: save type per sub address, sometimes info is transmitted with the sub address like COMMAND_MODULE_STATUS
            my $SubAddr = $data{$data}{value} ; # Handier var
            $SubAddr{$SubAddr} = $data ;
         } else {
            # If there is an address for the temperature sensor, add this address to the list with type 'Temperature'
            if ( $data eq "TemperatureAddr" ) {
               $global{Vars}{Modules}{Address}{$data{$data}{value}}{ModuleInfo}{type} = "Temperature" ;
            }
         }
         $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{$data} = $data{$data}{value} ;
      }

      # Store a list of sub addresses in 1 variable
      if ( %SubAddr ) {
         my $SubAddr = join ",", sort keys  %SubAddr ;
         $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{SubAddr} = $SubAddr ;
      }

      my %datatemp = &fetch_data ($global{dbh},"select * from `modules_channel_info` where `address`='$address'" ) ;
      foreach my $key (sort keys (%datatemp)) {
         my $date    = $datatemp{$key}{date} ;    # Handier var
         my $address = $datatemp{$key}{address} ; # Handier var
         my $channel = $datatemp{$key}{channel} ; # Handier var
         my $data    = $datatemp{$key}{data} ;    # Handier var
         my $value   = $datatemp{$key}{value} ;   # Handier var
         $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$channel}{$data}{value} = $value ;
         $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$channel}{$data}{date}  = $date ;
      }

      # A VMBGPOD has multiple address. When the a button is pressed, it is submitted from the sub address and so we need to add '8' per subaddress to the channel.
      if ( %SubAddr ) {
         foreach my $SubAddr (sort keys %SubAddr) {
            %{$global{Vars}{Modules}{Address}{$SubAddr}{ModuleInfo}} = %{$global{Vars}{Modules}{Address}{$address}{ModuleInfo}} ;
            if ( $SubAddr{$SubAddr} =~ /SubAddr(\d+)/ ) {
               $global{Vars}{Modules}{Address}{$SubAddr}{ModuleInfo}{SubAddrMulti} = $1 * 8 ;
            }
         }
      }
   }
}

# Truncate the tables in de mysql database for a new start
sub clear_database {
   &do_query ($global{dbh},"TRUNCATE TABLE `modules`" ) ;
   &do_query ($global{dbh},"TRUNCATE TABLE `modules_info`" ) ;
   &do_query ($global{dbh},"TRUNCATE TABLE `modules_channel_info`" ) ;
}

sub update_modules_channel_info {
   my ($address, $channel, $data, $value) = @_ ;
   if ( defined $address and $address ne "" and
        defined $channel and $channel ne "" and
        defined $data    and $data    ne "" and
        defined $value   and $value   ne "") {
      &do_query ($global{dbh},"insert into `modules_channel_info` 
            (`address`, `channel`, `data`, `value`, `date`) 
               VALUES 
            (?, ?, ?, ?, NOW() ) 
            ON DUPLICATE KEY UPDATE 
               `value`=values(value), 
               `date`=values(date)
         ", 
         $address, 
         $channel, 
         $data, 
         $value
      ) ;
      &log("mysql","Address=$address, Channel=$channel, data=$data = $value") ;
      $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$channel}{$data}{value} = $value ;
      $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$channel}{$data}{date}  = $date ;
   } else {
      &log("mysql","ERROR: Address=$address, Channel=$channel, data=$data = $value") ;
   }
}

sub update_modules_info {
   my ($address, $data, $value) = @_ ;
   if ( defined $address and $address ne "" and
        defined $data    and $data    ne "" and
        defined $value   and $value   ne "") {
      &do_query ($global{dbh},"insert into `modules_info` 
            (`address`, `data`, `value`, `date`) 
               VALUES 
            (?, ?, ?, NOW() ) 
            ON DUPLICATE KEY UPDATE 
               `value`=values(value), 
               `date`=values(date)
         ", 
         $address, 
         $data, 
         $value
      ) ;
      &log("mysql","Address=$address, data=$data = $value") ;
      $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{$data} = $data{$data}{value} ;
   } else {
      &log("mysql","ERROR: Address=$address,                   data=$data = $value") ;
   }
}

return 1 ;
