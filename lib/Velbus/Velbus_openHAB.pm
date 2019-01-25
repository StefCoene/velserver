# Parse the options in etc/openHAB.cfg and find the GROUP_ options.
# These options are a list of regular expressions of items.
# Store the result in $global{openHAB}{config}: items matched to group(s)
sub openHAB_parse_config {
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

# Create the items file for openHAB
sub openHAB_config () {
   my $openHAB ;

   $openHAB = &openHAB_loop ("write_config") ;

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
sub openHAB_status () {
   &openHAB_loop ("status") ;
}

# Push the status of 1 item to openHAB
sub openHAB_status_push {
   my $item = $_[0] ;
   my %return = &www_service ;

   if ( defined $return{Status} ) {
      # If we have no info, do nothing
      if ( $return{Status} eq "" or
           $return{Status} eq "NO_INFO" or
           $return{Status} eq "NO_MODULE" ) {
      } else {
         &openHAB_update_state ($item,$return{Status}) ;
      }
   }
}

# Loop modules, channels, ...
# Used to update openHAB config file and push status to openHAB
sub openHAB_loop () {
   my $LoopType = $_[0] ;
   my $openHAB ;

   # Loop all found module types
   foreach my $ModuleType (sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerType}})) {
      #next if ! defined $global{Cons}{ModuleTypes}{$ModuleType}{Type} ; # This is used to skip the virtual module types used to represent the temperature of the touch panels

      $openHAB .= "// ModuleType: $global{Cons}{ModuleTypes}{$ModuleType}{Type} ($ModuleType)\n" ;

      # Loop all found modules for the type
      foreach my $Address ( sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerType}{$ModuleType}{ModuleList}}) ) {
         $openHAB .= "// Found Module: $global{Vars}{Modules}{Address}{$Address}{ModuleInfo}{ModuleName} ($Address)\n" ;

         # All possible channels
         foreach my $Channel ( sort {$a cmp $b} keys (%{$global{Cons}{ModuleTypes}{$ModuleType}{Channels}}) ) {
            if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Type} ) {
               # We set $ChannelType to the list of items we want to add
               # Per default is this the Type of channel
               my $ChannelType = $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Type} ;

               my $ChannelTypeComment ;

               # For ThermostatChannel, get the address assigned to the temperature. If this address is FF, the thermostat is not used and we have to skip this channel
               if ( $ChannelType eq "ThermostatChannel" ) {
                  if ( defined $global{Vars}{Modules}{Address}{$Address}{ModuleInfo}{ThermostatAddr} and
                               $global{Vars}{Modules}{Address}{$Address}{ModuleInfo}{ThermostatAddr} eq "FF" ) {
                     $ChannelTypeComment = "Skip ThermostatChannel $Channel: ThermostatAddr = $global{Vars}{Modules}{Address}{$Address}{ModuleInfo}{ThermostatAddr}" ;
                     undef $ChannelType ;
                  }
               }

               # There is only 1 Channel of type Temperature. We use this channel to add the Thermostat Control items
               if ( $ChannelType eq "Temperature" ) {
                  # If no ThermostatAddr is assigned, we have no Thermostat and we have to skip the Thermostat Controls
                  # If this address is FF, the thermostat is not used and we have to skip this channel
                  if ( defined $global{Vars}{Modules}{Address}{$Address}{ModuleInfo}{ThermostatAddr} ) {
                     if ( $global{Vars}{Modules}{Address}{$Address}{ModuleInfo}{ThermostatAddr} eq "FF" ) {
                        $ChannelTypeComment = "Skip Thermostat Controls: ThermostatAddr = $global{Vars}{Modules}{Address}{$Address}{ModuleInfo}{ThermostatAddr}" ;
                     } else {
                        # When we have a ThemostatAddr we add the Thermostat Controls:
                        $ChannelType .= " ThermostatCoHeMode ThermostatMode ThermostatTarget" ;
                     }
                  } else {
                     $ChannelTypeComment = "Skip Thermostat Controls: No ThermostatAddr" ;
                  }

               # Extra item: long pressed button
               } elsif ( $ChannelType eq "Button" ) {
                  $ChannelType .= " ButtonLong" ;

               } elsif ( $ChannelType eq "ButtonCounter" ) {
                  # ButtonCounter used as Counter
                  if ( defined $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Divider}{value} and $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Divider}{value} ne "Disabled" ) {
                     $ChannelType = "Divider CounterRaw Counter CounterCurrent" ;
                  # ButtonCounter used as Button: VMB7IN when Divider = Disabled or no Divider
                  } else {
                     $ChannelType = "Button ButtonLong" ;
                  }
               }

               # Loop all ChannelTypes
               $openHAB .= "// $ChannelTypeComment\n" if defined $ChannelTypeComment ;
               foreach my $Type (split " ", $ChannelType) {
                  $openHAB .= &openHAB_loop_item ($LoopType, $Type, $ModuleType, $Address, $Channel) ;
               }
            }
         }
      }
   }

   return $openHAB ;
}

# Subfunction of openHAB_loop
# This will generate the item file or will push the status to openHAB for 1 item and its actions.
sub openHAB_loop_item () {
   my $LoopType    = $_[0] ; # This is status or write_config
   my $ChannelType = $_[1] ;
   my $ModuleType  = $_[2] ;
   my $Address     = $_[3] ;
   my $Channel     = $_[4] ;

   my $openHAB ; # Only usefull when $LoopType = write_config

   if ( defined $global{Cons}{ChannelTypes}{$ChannelType} ) {
      if ( defined $global{Cons}{ChannelTypes}{$ChannelType}{Module}{$ModuleType}{Action}{Get} ) {
         my $item = $ChannelType."_".$Address."_".$Channel ;
         if ( $LoopType eq "status" ) {
            # Simulate a service request so set the needed cgi parameters.
            $global{cgi}{params}{Item} = $ChannelType . "_" . $Address . "_" . $Channel ;
            $global{cgi}{params}{Action}  = "Get" ;
            &openHAB_status_push ($item) ;

         } else {
            my $Name ;

            # Add module name if requested
            if ( ( $ChannelType eq "LightSensor" or
                   $ChannelType eq "Sensor" ) or
                 ( defined $global{Config}{openHAB}{INCLUDE_MODULENAME_IN_NAME} and
                   defined $global{Vars}{Modules}{Address}{$Address}{ModuleInfo}{ModuleName} and
                           $global{Vars}{Modules}{Address}{$Address}{ModuleInfo}{ModuleName} ne "" ) ) {
                $Name = $global{Vars}{Modules}{Address}{$Address}{ModuleInfo}{ModuleName} . " :: " ;
            }

            if ( $ChannelType eq "ThermostatChannel" ) {
               my $TemperatureChannel = $global{Cons}{ModuleTypes}{$ModuleType}{TemperatureChannel} ; # Channel is fixed per ModuleType for Temperature sensor
               $Name .= $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$TemperatureChannel}{Name}{value} . " :: " . $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} ; # Add Name of Temperature sensor
            # Add channel name if one is available
            } elsif ( defined $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Name}{value} and
                              $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Name}{value} ne "" ) {
               $Name .= $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Name}{value} ;
            # Add default name if one is available
            } elsif ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} ) {
               $Name .= $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} ;
            }

            $Name .= " :: " . $global{Cons}{ChannelTypes}{$ChannelType}{openHAB}{Append2Name} if defined $global{Cons}{ChannelTypes}{$ChannelType}{openHAB}{Append2Name} ; # It's possible we have to append something to the name

            # Add item name in name if requested
            if ( defined $global{Config}{openHAB}{INCLUDE_ITEM_IN_NAME} ) {
               $Name .= " (" . $item . ")" ;
            }

            # Four Counter, add format if possible.
            if ( $ChannelType eq "CounterCurrent" ) {
               if ( defined $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Unit}{value} ) {
                  if ( $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Unit}{value} eq "kWh" ) {
                     $Name .= " [%.0f W/s]" ;
                  } else {
                     $Name .= " [%.0f " . $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Unit}{value} . "/s]";
                  }
               }
            } elsif ( $ChannelType eq "Counter" ) {
               if ( defined $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Unit}{value} ) {
                  if ( $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Unit}{value} eq "kWh" ) {
                     $Name .= " [%.0f kWh]" ;
                  } else {
                     $Name .= " [%.0f " . $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Unit}{value} . "]" ;
                  }
               }
            } else {
               $Name .= " $global{Cons}{ChannelTypes}{$ChannelType}{openHAB}{ItemStateFormat}" if defined $global{Cons}{ChannelTypes}{$ChannelType}{openHAB}{ItemStateFormat} ; # Add item state format
            }

            $openHAB .= "$global{Cons}{ChannelTypes}{$ChannelType}{openHAB}{ItemType} $item" ; # Add correct itemp type
            $openHAB .= " \"$Name\" " if defined $Name ;
            $openHAB .= "<$global{Cons}{ChannelTypes}{$ChannelType}{openHAB}{ItemIcon}> " if defined $global{Cons}{ChannelTypes}{$ChannelType}{openHAB}{ItemIcon} ; # Add correct item icon

            # Add to group if needed
            my $Group = &openHAB_match_item($item) ;
            if ( defined $Group ) {
               $openHAB .= "($Group) " ;
            }

            # Add channel tag if one is available
            if ( $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Tag}{value} and
                 $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Tag}{value} ne '__NoTag__' ) {
                  $openHAB .= "[\"$global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Tag}{value}\"] " ;
            }

            # Add the http binding rules
            my $http_url = "$global{Config}{openHAB}{BASE_URL}?Item=$item" ;

            my $http ;
            # Memo is something special. We have to a POST instead of GET because a GET gives errors in OH when it contains non-alphanumeric characters.
            # We also have never POLLING for Memo.
            # Remark: we keep the GET for all other items because that's easier to trigger from a browser then doing a POST.
            # Remark: the end user is reponsible to clear the message by sending an empty string or the text CLEAR.
            if ( $ChannelType eq "Memo" ) {
               $http .= ">[*:POST:$http_url&Action=Set:default]" ;
            } else {
               # If polling is enabled, add it to the http binding
               if ( defined $global{Config}{openHAB}{POLL_STATUS} ) {
                  $http .= "<[$http_url&Action=Get:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)] " ;
               }

               # If there is a Set defined, add it to the http binding
               if ( defined $global{Cons}{ChannelTypes}{$ChannelType}{Module}{$ModuleType}{Action}{Set} ) {
                  $http .= ">[*:GET:$http_url&Action=Set&Value=%2\$s]" ;
               }
            }

            if ( defined $http ) {
               #$openHAB .= "{http=\"" . $http. "\"}" ;
               # TODO: more testing needed
               # In openhab items are automatically updated by commands. This is currently not the task of the bindings. But when a binding is unable to execute the command the item is set anyway and displays an incorrect status.
               # Only by adding autoupdate="false" to the item configuration this behaviour can be disabled per item. In this case you have to update the item manually by rule because the bindings do not do this.
               $openHAB .= "{http=\"" . $http. "\", autoupdate=\"false\"}" ;
            }
            $openHAB .= "\n" ;
         }
      } else {
         $openHAB = "// ERROR: ChannelType $ChannelType defined but no Get support\n" ;
      }
   } else {
      $openHAB = "// ERROR: ChannelType $ChannelType not defined in Velbus_data_channels.pm\n" ;
   }
   return $openHAB ;
}

return 1 ;
