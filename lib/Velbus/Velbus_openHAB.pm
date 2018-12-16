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

# Loop modules, channels, ...
# Used to update openHAB config file and push status to openHAB
sub openHAB_loop () {
   my $LoopType = $_[0] ;
   my $openHAB ;

   # Loop all module types
   foreach my $ModuleType (sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerType}})) {
      $openHAB .= "// $global{Cons}{ModuleTypes}{$ModuleType}{Type} ($ModuleType)\n" ;

      # Loop all found modules for the type
      foreach my $Address ( sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerType}{$ModuleType}{ModuleList}}) ) {
         # All possible channels
         $openHAB .= "// $global{Vars}{Modules}{Address}{$Address}{ModuleInfo}{ModuleName} ($Address)\n" ;
         foreach my $Channel ( sort {$a cmp $b} keys (%{$global{Cons}{ModuleTypes}{$ModuleType}{Channels}}) ) {
         # All found channels
         #foreach my $Channel ( sort {$a cmp $b} keys (%{$global{Vars}{Modules}{Address}{$Address}{ChannelInfo}}) ) {
            if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Type} ) {
               my $Type = $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Type} ;

               if ( $Type eq "Temperature" ) {
                  # Every touch has a temperature sensor
                  $Channel = $global{Cons}{ModuleTypes}{$ModuleType}{TemperatureChannel} ; # Channel is fixed for temperature sensor
                  $openHAB .= &openHAB_loop_item ($LoopType, $Type, $ModuleType, $Address, $Channel) ;

                  # If there is a TemperatureAddr and it's FF, we have a touch panel with the temperature sensor disable. So skip the temperature control items.
                  if ( defined $global{Vars}{Modules}{Address}{$Address}{ModuleInfo}{TemperatureAddr} and
                               $global{Vars}{Modules}{Address}{$Address}{ModuleInfo}{TemperatureAddr} eq "FF" ) {
                  } else {
                     # When we have a Temperature, we can have other stuff as well:
                     foreach my $ActionType ("TemperatureCoHeMode", "TemperatureMode", "TemperatureTarget" ) {
                        if ( defined $global{Cons}{ActionType}{$ActionType}{Module}{$ModuleType} ) {
                           $openHAB .= &openHAB_loop_item ($LoopType, $ActionType, $ModuleType, $Address, $Channel) ;
                        }
                     }
                  }

               } else {
                  # Calculate the real address. This is needed for touch panels where you can have sub addresses for pages and/or temperature sensor.
                  # When this sub address is FF, it's not used and we have to skip the correspondending channels
                  my ($channelReal,$addressReal)  = &channel_id_to_hex ($Channel, $Address) ;
                  next if $addressReal eq "FF" ;

                  if ( $Type eq "Blind" or
                       $Type eq "Button" or
                       $Type eq "Dimmer" or
                       $Type eq "Relay" or
                       $Type eq "Sensor" or
                       $Type eq "SensorText" or
                       $Type eq "SensorNumber" or
                       $Type eq "LightSensor" ) {

                     $openHAB .= &openHAB_loop_item ($LoopType, $Type, $ModuleType, $Address, $Channel) ;

                     # Short and long pressed button
                     if ( $Type eq "Button" ) {
                        $openHAB .= &openHAB_loop_item ($LoopType, "ButtonLong", $ModuleType, $Address, $Channel) ;
                     }
                  }

                  if ( $Type eq "ButtonCounter" ) {
                     if (defined $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Divider}{value} and $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Divider}{value} ne "Disabled" ) {
                     # ButtonCounter used as Counter
                        $openHAB .= &openHAB_loop_item ($LoopType, "Divider",        $ModuleType, $Address, $Channel) ;
                        $openHAB .= &openHAB_loop_item ($LoopType, "CounterRaw",     $ModuleType, $Address, $Channel) ;
                        $openHAB .= &openHAB_loop_item ($LoopType, "Counter",        $ModuleType, $Address, $Channel) ;
                        $openHAB .= &openHAB_loop_item ($LoopType, "CounterCurrent", $ModuleType, $Address, $Channel) ;
                     } else {
                     # ButtonCounter used as Button: VMB7IN when Divider = Disabled or no Divider
                        $openHAB .= &openHAB_loop_item ($LoopType, "Button",     $ModuleType, $Address, $Channel) ;
                        $openHAB .= &openHAB_loop_item ($LoopType, "ButtonLong", $ModuleType, $Address, $Channel) ;
                     }
                  }
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
   my $LoopType   = $_[0] ; # This is status or write_config
   my $Type       = $_[1] ;
   my $ModuleType = $_[2] ;
   my $Address    = $_[3] ;
   my $Channel    = $_[4] ;

   my $openHAB ; # Only usefull when $LoopType = write_config

   foreach my $Action (sort keys %{$global{Cons}{ActionType}{$Type}{Module}{$ModuleType}{Action}} ) {
      # Skip the Get action -> we use the Get action when we parse the Set action(s)
      # The only case we don't have a Set is type = Memo: TODO
      next if $Action !~ /^Get/ ;

      my $item ; # Create the openHAB item name
      if ( defined $global{Cons}{ActionType}{$Type}{Action}{$Action}{openHAB}{Type} ) {
         $item .= $global{Cons}{ActionType}{$Type}{Action}{$Action}{openHAB}{Type} ;
      } else {
         $item = $Type ;
      }
      $item .= "_".$Address ;
      $item .= "_".$Channel if $Channel ; # TODO: is there a case when we have no channel?

      if ( $LoopType eq "status" ) {
         # Simulate a service request so set the needed cgi parameters.
         $global{cgi}{params}{address} = $Address ;
         $global{cgi}{params}{channel} = $Channel ;
         $global{cgi}{params}{action}  = $Action ;
         $global{cgi}{params}{type}    = $Type ;
         &openHAB_status_push ($item) ;

      } else {
         my $Name ;
         # Add module name if requested
         if ( defined $global{Config}{openHAB}{INCLUDE_MODULENAME_IN_NAME} and
              defined $global{Vars}{Modules}{Address}{$Address}{ModuleInfo}{ModuleName} and
                      $global{Vars}{Modules}{Address}{$Address}{ModuleInfo}{ModuleName} ne "" ) {
             $Name = $global{Vars}{Modules}{Address}{$Address}{ModuleInfo}{ModuleName} . " :: " ;
         }
         # Add channel name if one is available
         if ( defined $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Name}{value} and
                      $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Name}{value} ne "" ) {
             $Name .= $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Name}{value} ;
         # Add default name if one is available
         } elsif ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} ) {
            $Name .= $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name} ;
         }

         $Name .= $global{Cons}{ActionType}{$Type}{Action}{$Action}{openHAB}{Append2Name} if defined $global{Cons}{ActionType}{$Type}{Action}{$Action}{openHAB}{Append2Name} ; # It's possible we have to append something to the name

         # Add item name in name if requested
         if ( defined $global{Config}{openHAB}{INCLUDE_ITEM_IN_NAME} ) {
            $Name .= " (" . $item . ")" ;
         }

         # Four Counter, add format if possible.
         if ( $Type eq "Counter" and $Action eq "GetCurrent" ) {
            if ( defined $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Unit}{value} ) {
               if ( $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Unit}{value} eq "kWh" ) {
                  $Name .= " [%.0f W/s]" ;
               } else {
                  $Name .= " [%.0f " . $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Unit}{value} . "/s]";
               }
            }
         } elsif ( $Type eq "Counter" and $Action eq "Get" ) {
            if ( defined $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Unit}{value} ) {
               if ( $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Unit}{value} eq "kWh" ) {
                  $Name .= " [%.0f kWh]" ;
               } else {
                  $Name .= " [%.0f " . $global{Vars}{Modules}{Address}{$Address}{ChannelInfo}{$Channel}{Unit}{value} . "]" ;
               }
            }
         } else {
            $Name .= " $global{Cons}{ActionType}{$Type}{Action}{$Action}{openHAB}{ItemStateFormat}" if defined $global{Cons}{ActionType}{$Type}{Action}{$Action}{openHAB}{ItemStateFormat} ; # Add item state format
         }

         $openHAB .= "$global{Cons}{ActionType}{$Type}{Action}{$Action}{openHAB}{ItemType} $item" ; # Add correct itemp type
         $openHAB .= " \"$Name\" " if defined $Name ;
         $openHAB .= "<$global{Cons}{ActionType}{$Type}{Action}{$Action}{openHAB}{ItemIcon}> " if defined $global{Cons}{ActionType}{$Type}{Action}{$Action}{openHAB}{ItemIcon} ; # Add correct item icon

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
         my $http_url = "$global{Config}{openHAB}{BASE_URL}?address=$Address&type=" ;
         # It's possible we overrule the action
         if ( defined $global{Cons}{ActionType}{$Type}{Action}{Get}{openHAB}{HttpType} ) {
            $http_url .= $$global{Cons}{ActionType}{$Type}{Action}{Get}{openHAB}{HttpType} ;
         } else {
            $http_url .= $Type ;
         }
         $http_url .= "&channel=$Channel" if defined $Channel ; # TODO: is there a case when we have no channel?

         my $http ;

         if ( defined $global{Config}{openHAB}{POLL_STATUS} ) {
            $http .= "<[$http_url&action=$Action:$global{Config}{openHAB}{POLLING}:JSONPATH(\$.Status)] " ;
         }
         foreach my $Action (sort keys %{$global{Cons}{ActionType}{$Type}{Module}{$ModuleType}{Action}} ) {
            if ( $Action eq "Set" ) {
               $http .= ">[*:GET:$http_url&action=Set&value=%2\$s]" ;
            }
         }
         if ( defined $http ) {
            #$openHAB .= "{http=\"" . $http. "\"}" ;
            # TODO: more testing needed
            # In openhab items are automatically updated by commands. This is currently not the task of the bindings. But when a binding is unable to execute the command the item is set anyway and displays an incorrect status.
            # Only by adding autoupdate="false" to the item configuration this behavior can be disabled per item. In this case you have to update the item manually by rule because the bindings do not do this.
            $openHAB .= "{http=\"" . $http. "\", autoupdate=\"false\"}" ;
         }
         $openHAB .= "\n" ;

      }
   }

   return $openHAB ;
}

return 1 ;
