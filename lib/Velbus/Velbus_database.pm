
# Mysql related sub functions to get the data out of the database

# Get all the modules on the bus
sub get_all_modules_from_database {
   my %data = &fetch_data ($global{dbh},"select * from `modules` where `status`='Found'","address" ) ;

   foreach my $address (sort keys %data ) {
      my $type   = $data{$address}{type} ; # Easier var
      next if $type eq '' ;
      my $status = $data{$address}{status} ; # Easier var

      $global{Vars}{Modules}{ModuleList}{$address} = "yes" ; # List of all found modules
      %{$global{Vars}{Modules}{Address}{$address}{ModuleInfo}} = %{$data{$address}} ; # List of all modules
      $global{Vars}{Modules}{PerType}{$type}{ModuleList}{$address} = "yes" ; # List of alle modules per type module
   }

   &get_all_modules_info_from_database ;
}

# Loop all found modules and load the extra info
sub get_all_modules_info_from_database {
   foreach my $address (sort keys (%{$global{Vars}{Modules}{ModuleList}}) ) {
      my %SubAddr ;

      my $ThermostatAddr ;

      # 1: Get the module information
      my %data = &fetch_data ($global{dbh},"select * from `modules_info` where `address`='$address'","data" ) ;
      foreach my $data (sort keys (%data)) {
         $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{$data} = $data{$data}{value} ;

         # Parse the SubAddress variable if it's valid
         if ( $data =~ /^SubAddr(\d+)/ and $data{$data}{value} ne "FF" ) {
            my $counter = $1 ;
            my $SubAddr = $data{$data}{value} ; # Easier var

            $SubAddr{$SubAddr} = $data ; # Remember a list of SubAddreses

            $global{Vars}{Modules}{SubAddress}{$SubAddr}{MasterAddress} = $address ; # Remember the master address for this SubAddress
            $global{Vars}{Modules}{SubAddress}{$SubAddr}{ChannelOffset} = $counter * 8 ; # Calculate the channel offset
         }

         # If there is an address for the Thermostat, add this address to the list with special type
         if ( $data eq "ThermostatAddr" and $data{$data}{value} ne "FF" ) {
            $ThermostatAddr = $data{$data}{value} ; # Easier var
         }
      }

      if ( %SubAddr ) {
         # Store a list of sub addresses in 1 variable, only used on website
         my $SubAddr = join ",", sort keys  %SubAddr ;
         $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{SubAddr} = $SubAddr ;
      }

      # 2: Get the channel information
      my %datatemp = &fetch_data ($global{dbh},"select * from `modules_channel_info` where `address`='$address'" ) ;
      foreach my $key (sort keys (%datatemp)) {
         my $date    = $datatemp{$key}{date} ;    # Easier var
         my $address = $datatemp{$key}{address} ; # Easier var
         my $channel = $datatemp{$key}{channel} ; # Easier var
         my $data    = $datatemp{$key}{data} ;    # Easier var
         my $value   = $datatemp{$key}{value} ;   # Easier var
         $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$channel}{$data}{value} = $value ;
         $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$channel}{$data}{date}  = $date ;
      }
   }
}

# Truncate the tables in the database for a new start
sub empty_database {
   &do_query ($global{dbh},"delete from `modules`" ) ;
   &do_query ($global{dbh},"delete from `modules_info`" ) ;
   &do_query ($global{dbh},"delete from `modules_channel_info`" ) ;
}

sub update_modules_channel_info {
   my ($address, $channel, $data, $value) = @_ ;
   if ( defined $address and $address ne "" and
        defined $channel and $channel ne "" and
        defined $data    and $data    ne "" and
        defined $value   and $value   ne "" ) {
      #&do_query ($global{dbh},"insert into `modules_channel_info` 
      #      (`address`, `channel`, `data`, `value`, `date`) 
      #         VALUES 
      #      (?, ?, ?, ?, NOW() ) 
      #      ON DUPLICATE KEY UPDATE 
      #         `value`=values(value), 
      #         `date`=values(date)
      #   ", 
      #   $address, 
      #   $channel, 
      #   $data, 
      #   $value
      #) ;
      &do_query ($global{dbh},"replace into `modules_channel_info` 
            (`address`, `channel`, `data`, `value`, `date`) 
               VALUES 
            (?, ?, ?, ?, CURRENT_TIMESTAMP ) 
         ", 
         $address, 
         $channel, 
         $data, 
         $value
      ) ;
      &log("database","Address=$address, Channel=$channel, data=$data = $value") ;
      $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$channel}{$data}{value} = $value ;
      $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$channel}{$data}{date}  = $date ;
   } else {
      &log("database","ERROR: Address=$address, Channel=$channel, data=$data = $value") ;
   }
}

sub update_modules_info {
   my ($address, $data, $value) = @_ ;
   if ( defined $address and $address ne "" and
        defined $data    and $data    ne "" and
        defined $value   and $value   ne "" ) {
      #&do_query ($global{dbh},"insert into `modules_info` 
      #      (`address`, `data`, `value`, `date`) 
      #         VALUES 
      #      (?, ?, ?, NOW() ) 
      #      ON DUPLICATE KEY UPDATE 
      #         `value`=values(value), 
      #         `date`=values(date)
      #   ", 
      #   $address, 
      #   $data, 
      #   $value
      #) ;
      &do_query ($global{dbh},"replace into `modules_info` 
            (`address`, `data`, `value`, `date`) 
               VALUES 
            (?, ?, ?, CURRENT_TIMESTAMP ) 
         ", 
         $address, 
         $data, 
         $value
      ) ;
      &log("database","Address=$address, data=$data = $value") ;
      $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{$data} = $value ;
   } else {
      &log("database","ERROR: Address=$address,                   data=$data = $value") ;
   }
}

return 1 ;
