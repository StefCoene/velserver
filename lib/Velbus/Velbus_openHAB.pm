# Parse the options in etc/openHAB.cfg and find the GROUP_ options.
# These options are a list of regular expressions of items.
# Store the result in $global{openHAB}{config}: items matched to group(s)
sub openHAB_config {
   if ( defined $global{Config}{openHAB} ) {
      foreach my $key (sort keys (%{$global{Config}{openHAB}}) ) {
         if ( $key =~ /^GROUP_(.+)$/ ) {
            my $group = $1 ;
            foreach my $item (split " ", $global{Config}{openHAB}{$key} ) {
               $global{openHAB}{config}{item}{$item}{Group}{$group} = "ConfigFile" ;
            }
         }
      }
   }
}

# Take an item as input and returns a list of groups that matches the item.
# Returns undef when no group is matched.
sub openHAB_match_item {
   my $item_input  = $_[0] ;
   my %group ;
   foreach my $item (keys %{$global{openHAB}{config}{item}}) {
      foreach my $group (keys %{$global{openHAB}{config}{item}{$item}{Group}}) {
         if ( $item =~ /^%(.+)/i ) {
            my $match = $1 ;
            if ( $item_input =~ /$match/i ) {
               $group{$group} = "yes" ;
            }
         } elsif ( $item eq "*" ) {
            $group{$group} = "yes" ;
         } elsif ( $item_input eq $item ) {
            $group{$group} = "yes" ;
         }
      }
   }
   if ( %group ) {
      my $group = join ",", sort keys %group ;
      return $group ;
   } else {
      return undef ;
   }
}

# Items defined in Velbus_data_protocol.pm, these items needs to be created in the .items config file
#   HeaterMode
#   Blind
#   Dimmer
#   HeaterTemperature
#   Relay
#   Button
sub openHAB () {
   my $openHAB ;

   # Loop all module types
   foreach my $ModuleType (sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerType}})) {

      $openHAB .= "// $global{Cons}{ModuleTypes}{$ModuleType}{Type} ($ModuleType)\n" ;

      # Loop all found modules for the type
      foreach my $address ( sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerType}{$ModuleType}{ModuleList}}) ) {

         # All possible channels
         foreach my $Channel ( sort {$a cmp $b} keys (%{$global{Cons}{ModuleTypes}{$ModuleType}{Channels}}) ) {
         # All found channels
         #foreach my $Channel ( sort {$a cmp $b} keys (%{$global{Vars}{Modules}{Address}{$address}{ChannelInfo}}) ) {
            if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Type} ) {
               my $Type = $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Type} ;

               #next if $Channel eq "00" ; # Channel 00 is used to store data about the module, so this Channel does not exist
               my $itemBase = $address."_".$Channel ;

               # ButtonCounter is for VMB7IN, it's a Button when Divider = Disabled
               if ( $Type eq "Button" or
                    ( $Type eq "ButtonCounter" and
                       defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Divider}{value} and
                       $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Divider}{value} eq "Disabled" ) ) {
                  # Short pressed button
                  my $item = "Button_$itemBase" ;
                  my $Name = $item ;
                  $Name .= " (" . $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} .")" if defined $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} ;
                  $Name = $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} if defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} and $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ne "" ;
                  $Name .= " :: ". $item if defined $global{Config}{openHAB}{INCLUDE_AC_IN_NAME} ;
                  $openHAB .= "Switch $item \"$Name\" " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  $openHAB .= "{http=\"" ;
                  $openHAB .=        "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Switch&action=Get:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)]" ;
                  $openHAB .= " >[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Switch&action=Set&value=%2\$s]" ;
                  $openHAB .= "\", autoupdate=\"false\"}\n" ;

                  # Long pressed button
                  my $item = "ButtonLong_$itemBase" ;
                  my $Name = $item ;
                  $Name .= " (" . $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} .")" if defined $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} ;
                  $Name = $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} if defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} and $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ne "" ;
                  $Name .= " (Long) " ;
                  $Name .= " :: ". $item if defined $global{Config}{openHAB}{INCLUDE_AC_IN_NAME} ;
                  $openHAB .= "Switch $item \"$Name\" " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  $openHAB .= "{http=\"" ;
                  $openHAB .=        "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Switch&action=Get:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)]" ;
                  $openHAB .= " >[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Switch&action=Set&value=%2\$s]" ;
                  $openHAB .= "\", autoupdate=\"false\"}\n" ;
               }
               if ( $Type eq "Temperature" ) {
                  # Get the current temperature
                  my $item = "Temperature_$address" ;

                  my $Name = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{TempSensor} ;
                  $Name .= " :: ". $item if defined $global{Config}{openHAB}{INCLUDE_AC_IN_NAME} ;
                  $openHAB .= "Number $item \"$Name [%.1f °C]\" " ;
                  $openHAB .= "<temperature> " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  $openHAB .= "{http=\"" ;
                  $openHAB .=        "<[$global{Config}{openHAB}{BASE_URL}?address=$address&type=Temperature&action=Get:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Temperature)]" ;
                  $openHAB .= "\"}\n" ;

                  # Touch + Input modules: heater control
                  if ( ( $ModuleType eq "1E" ) or
                       ( $ModuleType eq "1F" ) or
                       ( $ModuleType eq "20" ) or
                       ( $ModuleType eq "28" ) ) {

                     # Get/Set the heater mode
                     my $item = "HeaterMode_$address" ;

                     my $Name = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{TempSensor} ;
                     $Name .= " :: ". $item if defined $global{Config}{openHAB}{INCLUDE_AC_IN_NAME} ;
                     $openHAB .= "Number $item \"$Name  mode\" " ;
                     $openHAB .= "<temperature> " ;
                     my $Group = &openHAB_match_item($item) ;
                     if ( defined $Group ) {
                        $openHAB .= "($Group) " ;
                     }
                     $openHAB .= "{http=\"" ;
                     $openHAB .=        "<[$global{Config}{openHAB}{BASE_URL}?address=$address&type=HeaterMode&action=Get:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)]" ;
                     $openHAB .= " >[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&type=HeaterMode&action=Set&value=%2\$s]" ;
                     $openHAB .= "\"}\n" ;

                     # Get/Set the target temperature
                     my $item = "HeaterTemperature_$address" ;

                     my $Name = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{TempSensor} ;
                     $Name .= " :: ". $item if defined $global{Config}{openHAB}{INCLUDE_AC_IN_NAME} ;
                     $openHAB .= "Number $item \"$Name temperature target [%.1f °C]\" " ;
                     $openHAB .= "<temperature> " ;
                     my $Group = &openHAB_match_item($item) ;
                     if ( defined $Group ) {
                        $openHAB .= "($Group) " ;
                     }
                     $openHAB .= "{http=\"" ;
                     $openHAB .=        "<[$global{Config}{openHAB}{BASE_URL}?address=$address&type=HeaterTemperature&action=Get:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)]" ;
                     $openHAB .= " >[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&type=HeaterTemperature&action=Set&value=%2\$s]" ;
                     $openHAB .= "\"}\n" ;
                  }
               }
               if ( $Type eq "Dimmer" ) {
                  my $item = "Dimmer_$itemBase" ;
                  my $Name = $item ;
                  $Name .= " (" . $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} .")" if defined $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} ;
                  $Name = $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} if defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} and $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ne "" ;
                  $Name .= " :: ". $item if defined $global{Config}{openHAB}{INCLUDE_AC_IN_NAME} ;
                  $Name .= " [%s %%]" ;
                  $openHAB .= "Dimmer $item \"$Name\" " ;
                  $openHAB .= "<slider> " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  if ( $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Tag}{value} and
                       $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Tag}{value} ne 'NotUsed' ) {
                        $openHAB .= "[\"$global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Tag}{value}\"] " ;
                  }
                  $openHAB .= "{http=\"" ;
                  $openHAB .=        "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Dimmer&action=Get:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)]" ;
                  $openHAB .= " >[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Dimmer&action=Set&value=%2\$s]" ;
                  $openHAB .= "\"}\n" ;
               }
               if ( $Type eq "Blind" ) {
                  my $item = "Blind_$itemBase" ;
                  my $Name = $item ;
                  $Name .= " (" . $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} .")" if defined $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} ;
                  $Name = $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} if defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} and $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ne "" ;
                  $Name .= " :: ". $item if defined $global{Config}{openHAB}{INCLUDE_AC_IN_NAME} ;
                  $Name .= " [%s %%]" ;
                  $openHAB .= "Rollershutter $item \"$Name\" " ;
                  $openHAB .= "<rollershutter> " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  $openHAB .= "{http=\"" ;
                  $openHAB .=       "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Blind&action=Get:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)]" ;
                  $openHAB .= " >[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Blind&action=Set&value=%2\$s]" ;
                  $openHAB .= "\"}\n" ;
               }
               if ( $Type eq "Relay" ) {
                  my $item = "Relay_$itemBase" ;
                  my $Name = $item ;
                  $Name .= " (" . $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} .")" if defined $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} ;
                  $Name = $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} if defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} and $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ne "" ;
                  $Name .= " :: ". $item if defined $global{Config}{openHAB}{INCLUDE_AC_IN_NAME} ;
                  $openHAB .= "Switch $item \"$Name\" " ;
                  $openHAB .= "<switch> " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  if ( $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Tag}{value} and
                       $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Tag}{value} ne 'NotUsed' ) {
                        $openHAB .= "[\"$global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Tag}{value}\"] " ;
                  }
                  $openHAB .= "{http=\"" ;
                  $openHAB .=         "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Relay&action=Get:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)]" ;
                  $openHAB .=  " >[ON:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Relay&action=On] " ;
                  $openHAB .= " >[OFF:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Relay&action=Off]" ;
                  $openHAB .= "\"}\n" ;
               }
               if ( $Type eq "ButtonCounter" and
                     defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Divider}{value} and
                     $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Divider}{value} ne "Disabled" ) {
                  my $item = "CounterRaw_$itemBase" ;
                  my $Name = $item ;
                  $Name .= " (" . $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} .")" if defined $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} ;
                  $Name = $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} if defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} and $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ne "" ;
                  $Name .= " :: ". $item if defined $global{Config}{openHAB}{INCLUDE_AC_IN_NAME} ;
                  $openHAB .= "Number $item \"$Name (raw) [%.0f]\" " ;
                  $openHAB .= " <chart> " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  $openHAB .= "{http=\"" ;
                  $openHAB .=         "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Counter&action=GetCounterRaw:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)]" ;
                  $openHAB .= "\"}\n" ;

                  my $item = "CounterCurrent_$itemBase" ;
                  my $Name = $item ;
                  $Name .= " (" . $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} .")" if defined $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} ;
                  $Name = $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} if defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} and $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ne "" ;
                  $Name .= " :: ". $item if defined $global{Config}{openHAB}{INCLUDE_AC_IN_NAME} ;
                  $openHAB .= "Number $item \"$Name (current) [%.0f" ;
                  if ( defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Unit}{value} ) {
                     if ( $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Unit}{value} eq "kWh" ) {
                        $openHAB .= " W/s" ;
                     } else {
                        $openHAB .= " " . $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Unit}{value} . "/s";
                     }
                  }
                  $openHAB .= "]\" " ;
                  $openHAB .= " <chart> " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  $openHAB .= "{http=\"" ;
                  $openHAB .=         "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Counter&action=GetCounterCurrent:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)]" ;
                  $openHAB .= "\"}\n" ;

                  my $item = "Counter_$itemBase" ;
                  my $Name = $item ;
                  $Name .= " (" . $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} .")" if defined $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} ;
                  $Name = $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} if defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} and $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ne "" ;
                  $Name .= " :: ". $item if defined $global{Config}{openHAB}{INCLUDE_AC_IN_NAME} ;
                  $openHAB .= "Number $item \"$Name [%.0f" ;
                  if ( defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Unit}{value} ) {
                     if ( $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Unit}{value} eq "kWh" ) {
                        $openHAB .= " kWh" ;
                     } else {
                        $openHAB .= " " . $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Unit}{value} ;
                     }
                  }
                  $openHAB .= "]\" " ;
                  $openHAB .= " <chart> " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  $openHAB .= "{http=\"" ;
                  $openHAB .=         "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Counter&action=GetCounter:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)]" ;
                  $openHAB .= "\"}\n" ;

                  my $item = "Divider_$itemBase" ;
                  my $Name = $item ;
                  $Name .= " (" . $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} .")" if defined $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} ;
                  $Name = $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} if defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} and $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ne "" ;
                  $Name .= " :: ". $item if defined $global{Config}{openHAB}{INCLUDE_AC_IN_NAME} ;
                  $openHAB .= "Number $item \"$Name (divider) [%.0f]\" " ;
                  $openHAB .= " <chart> " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  $openHAB .= "{http=\"" ;
                  $openHAB .=         "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Counter&action=GetDivider:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)]" ;
                  $openHAB .= "\"}\n" ;
               }
            }
         }
      }
   }

   # If the item file exists and is writable, update the item file
   if ( open ITEM_FILE, ">$global{Config}{openHAB}{ITEM_FILE}" ) {
      print ITEM_FILE "$openHAB\n" ;
      close ITEM_FILE ;
   } else {
      $openHAB = "Warning: $global{Config}{openHAB}{ITEM_FILE} not writable!\n" . $openHAB ;
   }

   return $openHAB ;
}

return 1 ;
