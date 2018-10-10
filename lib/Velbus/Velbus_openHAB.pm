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
#   TemperatureMode
#   Blind
#   Dimmer
#   TemperatureTarget
#   Relay
#   Button
#   Sensor
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
                  my $Name ;
                  if ( defined $global{Config}{openHAB}{INCLUDE_MODULENAME_IN_NAME} and
                     defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} and
                     $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} ne "" ) {
                     $Name = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} . " :: " ;
                  }
                  if ( defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} and
                               $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ne "" ) {
                     $Name .= $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ;
                  }
                  if ( defined $global{Config}{openHAB}{INCLUDE_ITEM_IN_NAME} ) {
                     $Name .= " (" . $item . ")" ;
                  }

                  $openHAB .= "Switch $item \"$Name\" " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  if ( $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Tag}{value} and
                       $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Tag}{value} ne '__NoTag__' ) {
                        $openHAB .= "[\"$global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Tag}{value}\"] " ;
                  }
                  $openHAB .= "{http=\"" ;
                  if ( defined $global{Config}{openHAB}{POLL_STATUS} ) {
                     $openHAB .=        "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Switch&action=Get:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)] " ;
                  }
                  $openHAB .= ">[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Switch&action=Set&value=%2\$s]" ;
                  $openHAB .= "\", autoupdate=\"false\"}\n" ;

                  # Long pressed button
                  my $item = "ButtonLong_$itemBase" ;
                  my $Name ;
                  if ( defined $global{Config}{openHAB}{INCLUDE_MODULENAME_IN_NAME} and
                     defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} and
                     $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} ne "" ) {
                     $Name = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} . " :: " ;
                  }
                  if ( defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} and
                               $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ne "" ) {
                     $Name .= $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ;
                  }
                  $Name .= " (Long)" ;
                  if ( defined $global{Config}{openHAB}{INCLUDE_ITEM_IN_NAME} ) {
                     $Name .= " (" . $item . ")" ;
                  }

                  $openHAB .= "Switch $item \"$Name\" " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  if ( $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Tag}{value} and
                       $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Tag}{value} ne '__NoTag__' ) {
                        $openHAB .= "[\"$global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Tag}{value}\"] " ;
                  }
                  $openHAB .= "{http=\"" ;
                  if ( defined $global{Config}{openHAB}{POLL_STATUS} ) {
                     $openHAB .=        "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Switch&action=Get:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)] " ;
                  }
                  $openHAB .= ">[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Switch&action=Set&value=%2\$s]" ;
                  $openHAB .= "\", autoupdate=\"false\"}\n" ;
               }
               if ( $Type eq "Sensor" ) {
                  my $item = "Sensor_$itemBase" ;
                  my $Name ;
                  # Since the name of a sensor is fixed, we always use the name of the module
                  if ( defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} and
                               $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} ne "" ) {
                     $Name = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} . " :: " ;
                  }
                  $Name .= $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} ;
                  if ( defined $global{Config}{openHAB}{INCLUDE_ITEM_IN_NAME} ) {
                     $Name .= " (" . $item . ")" ;
                  }

                  $openHAB .= "Switch $item \"$Name\" " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  $openHAB .= "{http=\"" ;
                  if ( defined $global{Config}{openHAB}{POLL_STATUS} ) {
                     $openHAB .=        "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Switch&action=Get:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)] " ;
                  }
                  $openHAB .= ">[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Switch&action=Set&value=%2\$s]" ;
                  $openHAB .= "\", autoupdate=\"false\"}\n" ;
               }
               if ( $Type eq "SensorNumber" ) {
                  my $item = "Sensor_$itemBase" ;
                  my $Name ;
                  if ( defined $global{Config}{openHAB}{INCLUDE_MODULENAME_IN_NAME} and
                     defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} and
                     $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} ne "" ) {
                     $Name = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} . " :: " ;
                  }
                  if ( defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} and
                               $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ne "" ) {
                     $Name .= $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ;
                  }
                  if ( defined $global{Config}{openHAB}{INCLUDE_ITEM_IN_NAME} ) {
                     $Name .= " (" . $item . ")" ;
                  }

                  $Name .= $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} ;
                  if ( defined $global{Config}{openHAB}{INCLUDE_ITEM_IN_NAME} ) {
                     $Name .= " (" . $item . ")" ;
                  }

                  $openHAB .= "Number $item \"$Name\" " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  $openHAB .= "{http=\"" ;
                  if ( defined $global{Config}{openHAB}{POLL_STATUS} ) {
                     $openHAB .=        "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Switch&action=Get:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)] " ;
                  }
                  #$openHAB .= ">[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Switch&action=Set&value=%2\$s]" ;
                  $openHAB .= "\", autoupdate=\"false\"}\n" ;
               }
               if ( $Type eq "Temperature" ) {
                  # Get the current temperature
                  my $item = "Temperature_$address" ;
                  my $Name ;
                  if ( defined $global{Config}{openHAB}{INCLUDE_MODULENAME_IN_NAME} and
                     defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} and
                     $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} ne "" ) {
                     $Name = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} . " :: " ;
                  }
                  if ( defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} and
                               $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ne "" ) {
                     $Name = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{TempSensor} ;
                  }
                  if ( defined $global{Config}{openHAB}{INCLUDE_ITEM_IN_NAME} ) {
                     $Name .= " (" . $item . ")" ;
                  }

                  $openHAB .= "Number $item \"$Name [%.1f °C]\" " ;
                  $openHAB .= "<temperature> " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  if ( defined $global{Config}{openHAB}{POLL_STATUS} ) {
                     $openHAB .= "{http=\"" ;
                     $openHAB .=        "<[$global{Config}{openHAB}{BASE_URL}?address=$address&type=Temperature&action=Get:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)] " ;
                     $openHAB .= "\"}\n" ;
                  } else {
                     $openHAB .= "\n" ;
                  }

                  # Touch + Input modules: heater control
                  if ( ( $ModuleType eq "1E" ) or
                       ( $ModuleType eq "1F" ) or
                       ( $ModuleType eq "20" ) or
                       ( $ModuleType eq "28" ) ) {

                     # Get/Set the heating or cooling
                     my $item = "TemperatureCoHeMode_$address" ;
                     $openHAB .= "Number $item \"$Name  Cool/Heat mode\" " ;
                     $openHAB .= "<temperature> " ;
                     my $Group = &openHAB_match_item($item) ;
                     if ( defined $Group ) {
                        $openHAB .= "($Group) " ;
                     }
                     $openHAB .= "{http=\"" ;
                     if ( defined $global{Config}{openHAB}{POLL_STATUS} ) {
                        $openHAB .=        "<[$global{Config}{openHAB}{BASE_URL}?address=$address&type=TemperatureCoHeMode&action=Get:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)] " ;
                     }
                     $openHAB .= ">[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&type=TemperatureCoHeMode&action=Set&value=%2\$s]" ;
                     $openHAB .= "\"}\n" ;

                     # Get/Set the heater mode
                     my $item = "TemperatureMode_$address" ;
                     $openHAB .= "Number $item \"$Name  mode\" " ;
                     $openHAB .= "<temperature> " ;
                     my $Group = &openHAB_match_item($item) ;
                     if ( defined $Group ) {
                        $openHAB .= "($Group) " ;
                     }
                     $openHAB .= "{http=\"" ;
                     if ( defined $global{Config}{openHAB}{POLL_STATUS} ) {
                        $openHAB .=        "<[$global{Config}{openHAB}{BASE_URL}?address=$address&type=TemperatureMode&action=Get:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)] " ;
                     }
                     $openHAB .= ">[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&type=TemperatureMode&action=Set&value=%2\$s]" ;
                     $openHAB .= "\"}\n" ;

                     # Get/Set the target temperature
                     my $item = "TemperatureTarget_$address" ;

                     my $Name = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{TempSensor} ;
                     $Name .= " :: ". $item if defined $global{Config}{openHAB}{INCLUDE_ITEM_IN_NAME} ;
                     $openHAB .= "Number $item \"$Name temperature target [%.1f °C]\" " ;
                     $openHAB .= "<temperature> " ;
                     my $Group = &openHAB_match_item($item) ;
                     if ( defined $Group ) {
                        $openHAB .= "($Group) " ;
                     }
                     $openHAB .= "{http=\"" ;
                     if ( defined $global{Config}{openHAB}{POLL_STATUS} ) {
                        $openHAB .=        "<[$global{Config}{openHAB}{BASE_URL}?address=$address&type=TemperatureTarget&action=Get:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)] " ;
                     }
                     $openHAB .= ">[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&type=TemperatureTarget&action=Set&value=%2\$s]" ;
                     $openHAB .= "\"}\n" ;
                  }
               }
               if ( $Type eq "Dimmer" ) {
                  my $item = "Dimmer_$itemBase" ;
                  my $Name ;
                  if ( defined $global{Config}{openHAB}{INCLUDE_MODULENAME_IN_NAME} and
                     defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} and
                     $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} ne "" ) {
                     $Name = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} . " :: " ;
                  }
                  if ( defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} and
                               $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ne "" ) {
                     $Name .= $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ;
                  }
                  if ( defined $global{Config}{openHAB}{INCLUDE_ITEM_IN_NAME} ) {
                     $Name .= " (" . $item . ")" ;
                  }
                  $Name .= " [%s %%]" ;
                  $openHAB .= "Dimmer $item \"$Name\" " ;
                  $openHAB .= "<slider> " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  if ( $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Tag}{value} and
                       $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Tag}{value} ne '__NoTag__' ) {
                        $openHAB .= "[\"$global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Tag}{value}\"] " ;
                  }
                  $openHAB .= "{http=\"" ;
                  if ( defined $global{Config}{openHAB}{POLL_STATUS} ) {
                     $openHAB .=        "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Dimmer&action=Get:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)] " ;
                  }
                  $openHAB .= ">[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Dimmer&action=Set&value=%2\$s]" ;
                  $openHAB .= "\"}\n" ;
               }
               if ( $Type eq "Blind" ) {
                  my $item = "Blind_$itemBase" ;
                  my $Name ;
                  if ( defined $global{Config}{openHAB}{INCLUDE_MODULENAME_IN_NAME} and
                     defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} and
                     $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} ne "" ) {
                     $Name = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} . " :: " ;
                  }
                  if ( defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} and
                               $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ne "" ) {
                     $Name .= $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ;
                  }
                  if ( defined $global{Config}{openHAB}{INCLUDE_ITEM_IN_NAME} ) {
                     $Name .= " (" . $item . ")" ;
                  }

                  $Name .= " [%s %%]" ;
                  $openHAB .= "Rollershutter $item \"$Name\" " ;
                  $openHAB .= "<rollershutter> " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  $openHAB .= "{http=\"" ;
                  if ( defined $global{Config}{openHAB}{POLL_STATUS} ) {
                     $openHAB .=       "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Blind&action=Get:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)] " ;
                  }
                  $openHAB .= ">[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Blind&action=Set&value=%2\$s]" ;
                  $openHAB .= "\"}\n" ;
               }
               if ( $Type eq "Relay" ) {
                  my $item = "Relay_$itemBase" ;
                  my $Name ;
                  if ( defined $global{Config}{openHAB}{INCLUDE_MODULENAME_IN_NAME} and
                     defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} and
                     $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} ne "" ) {
                     $Name = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} . " :: " ;
                  }
                  if ( defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} and
                               $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ne "" ) {
                     $Name .= $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ;
                  }
                  if ( defined $global{Config}{openHAB}{INCLUDE_ITEM_IN_NAME} ) {
                     $Name .= " (" . $item . ")" ;
                  }
                  $openHAB .= "Switch $item \"$Name\" " ;
                  $openHAB .= "<switch> " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  if ( $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Tag}{value} and
                       $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Tag}{value} ne '__NoTag__' ) {
                        $openHAB .= "[\"$global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Tag}{value}\"] " ;
                  }
                  $openHAB .= "{http=\"" ;
                  if ( defined $global{Config}{openHAB}{POLL_STATUS} ) {
                     $openHAB .=         "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Relay&action=Get:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)] " ;
                  }
                  $openHAB .=  ">[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Relay&action=Set&value=%2\$s] " ;
                  $openHAB .= "\"}\n" ;
               }
               if ( $Type eq "ButtonCounter" and
                     defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Divider}{value} and
                     $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Divider}{value} ne "Disabled" ) {
                  my $item = "CounterRaw_$itemBase" ;
                  my $Name ;
                  if ( defined $global{Config}{openHAB}{INCLUDE_MODULENAME_IN_NAME} and
                     defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} and
                     $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} ne "" ) {
                     $Name = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} . " :: " ;
                  }
                  if ( defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} and
                               $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ne "" ) {
                     $Name .= $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ;
                  }
                  if ( defined $global{Config}{openHAB}{INCLUDE_ITEM_IN_NAME} ) {
                     $Name .= " (" . $item . ")" ;
                  }
                  $openHAB .= "Number $item \"$Name (raw) [%.0f]\" " ;
                  $openHAB .= " <chart> " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  if ( defined $global{Config}{openHAB}{POLL_STATUS} ) {
                     $openHAB .= "{http=\"" ;
                     $openHAB .=         "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Counter&action=GetCounterRaw:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)] " ;
                     $openHAB .= "\"}\n" ;
                  } else {
                     $openHAB .= "\n" ;
                  }

                  my $item = "CounterCurrent_$itemBase" ;
                  my $Name ;
                  if ( defined $global{Config}{openHAB}{INCLUDE_MODULENAME_IN_NAME} and
                     defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} and
                     $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} ne "" ) {
                     $Name = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} . " :: " ;
                  }
                  if ( defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} and
                               $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ne "" ) {
                     $Name .= $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ;
                  }
                  if ( defined $global{Config}{openHAB}{INCLUDE_ITEM_IN_NAME} ) {
                     $Name .= " (" . $item . ")" ;
                  }
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
                  if ( defined $global{Config}{openHAB}{POLL_STATUS} ) {
                     $openHAB .= "{http=\"" ;
                     $openHAB .=         "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Counter&action=GetCounterCurrent:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)] " ;
                     $openHAB .= "\"}\n" ;
                  } else {
                     $openHAB .= "\n" ;
                  }

                  my $item = "Counter_$itemBase" ;
                  my $Name ;
                  if ( defined $global{Config}{openHAB}{INCLUDE_MODULENAME_IN_NAME} and
                     defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} and
                     $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} ne "" ) {
                     $Name = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} . " :: " ;
                  }
                  if ( defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} and
                               $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ne "" ) {
                     $Name .= $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ;
                  }
                  if ( defined $global{Config}{openHAB}{INCLUDE_ITEM_IN_NAME} ) {
                     $Name .= " (" . $item . ")" ;
                  }
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
                  if ( defined $global{Config}{openHAB}{POLL_STATUS} ) {
                     $openHAB .= "{http=\"" ;
                     $openHAB .=         "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Counter&action=GetCounter:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)] " ;
                     $openHAB .= "\"}\n" ;
                  } else {
                     $openHAB .= "\n" ;
                  }

                  my $item = "Divider_$itemBase" ;
                  my $Name ;
                  if ( defined $global{Config}{openHAB}{INCLUDE_MODULENAME_IN_NAME} and
                     defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} and
                     $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} ne "" ) {
                     $Name = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName} . " :: " ;
                  }
                  if ( defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} and
                               $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ne "" ) {
                     $Name .= $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ;
                  }
                  if ( defined $global{Config}{openHAB}{INCLUDE_ITEM_IN_NAME} ) {
                     $Name .= " (" . $item . ")" ;
                  }
                  $openHAB .= "Number $item \"$Name (divider) [%.0f]\" " ;
                  $openHAB .= " <chart> " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  if ( defined $global{Config}{openHAB}{POLL_STATUS} ) {
                     $openHAB .= "{http=\"" ;
                     $openHAB .=         "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Counter&action=GetDivider:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)] " ;
                     $openHAB .= "\"}\n" ;
                  } else {
                     $openHAB .= "\n" ;
                  }
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

# Loop all modules and channels and push the status to openHAB
# The loop structure is the same as in &openHAB
sub openHAB_status_loop () {
   # Loop all module types
   foreach my $ModuleType (sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerType}})) {
      # Loop all found modules for the type
      foreach my $address ( sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerType}{$ModuleType}{ModuleList}}) ) {
         # All possible channels
         foreach my $Channel ( sort {$a cmp $b} keys (%{$global{Cons}{ModuleTypes}{$ModuleType}{Channels}}) ) {
            if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Type} ) {
               my $Type = $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Type} ;
               $global{cgi}{params}{address} = $address;
               $global{cgi}{params}{channel} = $Channel ;
               $global{cgi}{params}{action} = "Get" ;

               #next if $Channel eq "00" ; # Channel 00 is used to store data about the module, so this Channel does not exist
               my $itemBase = $address."_".$Channel ;

               # ButtonCounter is for VMB7IN, it's a Button when Divider = Disabled
               if ( $Type eq "Button" or
                    ( $Type eq "ButtonCounter" and
                       defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Divider}{value} and
                       $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Divider}{value} eq "Disabled" ) ) {
                  # Short pressed button
                  my $item = "Button_$itemBase" ;
                  $global{cgi}{params}{type} = "Switch" ;
                  &openHAB_status_push($item) ;

                  # Long pressed button
                  my $item = "ButtonLong_$itemBase" ;
                  &openHAB_status_push($item) ;
               }
               if ( $Type eq "Sensor" ) {
                  my $item = "Sensor_$itemBase" ;
                  $global{cgi}{params}{type} = "Switch" ;
                  &openHAB_status_push($item) ;
               }
               if ( $Type eq "Temperature" ) {
                  # Get the current temperature
                  my $item = "Temperature_$address" ;
                  $global{cgi}{params}{type} = "Temperature" ;
                  &openHAB_status_push($item) ;

                  # Touch + Input modules: heater control
                  if ( ( $ModuleType eq "1E" ) or
                       ( $ModuleType eq "1F" ) or
                       ( $ModuleType eq "20" ) or
                       ( $ModuleType eq "28" ) ) {

                     # Get/Set the heating or cooling
                     my $item = "TemperatureCoHeMode_$address" ;
                     $global{cgi}{params}{type} = "TemperatureCoHeMode" ;
                  &openHAB_status_push($item) ;

                     # Get/Set the heater mode
                     my $item = "TemperatureMode_$address" ;
                     $global{cgi}{params}{type} = "TemperatureMode" ;
                  &openHAB_status_push($item) ;

                     # Get/Set the target temperature
                     my $item = "TemperatureTarget_$address" ;
                     $global{cgi}{params}{type} = "TemperatureTarget" ;
                  &openHAB_status_push($item) ;
                  }
               }
               if ( $Type eq "Dimmer" ) {
                  my $item = "Dimmer_$itemBase" ;
                  $global{cgi}{params}{type} = "Dimmer" ;
                  &openHAB_status_push($item) ;
               }
               if ( $Type eq "Blind" ) {
                  my $item = "Blind_$itemBase" ;
                  $global{cgi}{params}{type} = "Blind" ;
                  &openHAB_status_push($item) ;
               }
               if ( $Type eq "Relay" ) {
                  my $item = "Relay_$itemBase" ;
                  $global{cgi}{params}{type} = "Relay" ;
                  &openHAB_status_push($item) ;
               }
               if ( $Type eq "ButtonCounter" and
                     defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Divider}{value} and
                     $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Divider}{value} ne "Disabled" ) {
                  my $item = "CounterRaw_$itemBase" ;
                  $global{cgi}{params}{type} = "Counter" ;
                  $global{cgi}{params}{action} = "GetCounterRaw" ;
                  &openHAB_status_push($item) ;

                  my $item = "CounterCurrent_$itemBase" ;
                  $global{cgi}{params}{action} = "GetCounterCurrent" ;
                  &openHAB_status_push($item) ;

                  my $item = "Counter_$itemBase" ;
                  $global{cgi}{params}{action} = "GetCounter" ;
                  &openHAB_status_push($item) ;

                  my $item = "Divider_$itemBase" ;
                  $global{cgi}{params}{action} = "GetDivider" ;
                  &openHAB_status_push($item) ;
               }
            }
         }
      }
   }
}

# Push the status of a channel to openHAB
sub openHAB_status_push {
   my $item = $_[0] ;
   my %return = &www_service ;

   if ( defined $return{Status} ) {
      # If we have no info, do nothing
      if ( $return{Status} eq "NO_INFO" or
           $return{Status} eq "NO_MODULE" ) {
      } else {
         # pressed and released -> ON and OFF
         if ( $return{Status} eq "longpressed" ) {
            $item =~ s/^Button/^ButtonLong/g ;
            $return{Status} = "ON" ;
         } elsif ( $return{Status} eq "pressed" ) {
            $return{Status} = "ON" ;
         } elsif ( $return{Status} eq "released" ) {
            $return{Status} = "OFF" 
         }
         &openHAB_update_state ($item,$return{Status}) ;
      }
   }
}

return 1 ;
