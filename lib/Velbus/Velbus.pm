use HTTP::Request::Common;
use LWP::UserAgent ;

# process messages on the bus
# This is the most complicate function that does all the hard work. It is used by logger.pl to process and store all messages on the bus
sub process_message {
   my @hex = @_ ;

   my %message ; # Info about the message

   $message{Raw} = join " ", @hex ;

   # Message format:
   $message{STX}      = shift @hex ;
   $message{prio}     = shift @hex ;
   $message{address}  = shift @hex ;
   $message{RTR_size} = shift @hex ;

   $message{ETX}      = pop @hex ;
   $message{checksum} = pop @hex ;

   $message{ModuleType}  = "??" ;
   $message{MessageType} = "??" ;

   if ( $message{STX} ne "0F" ) { # Only process valid packages
      push @{$message{text}}, "Not a valid packet: STX: $message{STX} != 0F" ;
   } elsif ( $message{ETX} ne "04" ) { # Only process valid packages
      push @{$message{text}}, "Not a valid packet: ETX: $message{ETX} != 04" ;
   } else {
      # Prio
      if ( $message{prio} eq "F8" ) {
         $message{prio} = "HI ";
      } elsif ( $message{prio} eq "FB" ) {
         $message{prio} = "lo " ;
      } else {
         push @{$message{text}}, "Not a valid prio: $message{prio}" ;
      }

      # RTR_size = 40 > Scan message
      if ( $message{RTR_size} eq "40" ) {
         push @{$message{text}}, "Scan" ;
         #my $sql = "insert into `modules` (`address`, `status`, `date`) VALUES (?, ?, NOW() ) ON DUPLICATE KEY UPDATE `status`=values(status), `date`=values(date)" ;
         my $sql = "replace into `modules` (`address`, `type`, `status`, `date`) VALUES (?, '', ?, CURRENT_TIMESTAMP )" ;
         &do_query ($global{dbh},$sql, $message{address}, "Start scan") ;
         $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{address} = $message{address} ;

      } else {
         $message{MessageType} = shift @hex ;

         if ( $message{MessageType} eq "FF" ) { # Module type: answer to a Scan
            $message{ModuleType} = shift @hex ;

            if ( defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Type} ) {
               push @{$message{text}}, "address $message{address}, type = $global{Cons}{ModuleTypes}{$message{ModuleType}}{Type} $global{Cons}{ModuleTypes}{$message{ModuleType}}{Info}" ;
            } else {
               push @{$message{text}}, "address $message{address}, type = unknown $message{ModuleType}" ;
            }

            &do_query ($global{dbh},"replace into `modules` (`address`, `type`, `status`, `date`) VALUES (?, ?, ?, CURRENT_TIMESTAMP)", $message{address}, $message{ModuleType}, "Found") ;
            $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} = $message{ModuleType} ;

            # The numbers in $file{Cons}{ModuleType}{$message{ModuleType}}{SerialLow} are in DATABYTE numbers, so we have to unshift hex untill they match
            unshift @hex ,"" ; unshift @hex ,"" ; unshift @hex ,"" ; 

            if ( defined $file{Cons}{ModuleType}{$message{ModuleType}}{SerialLow} ) {
               &update_modules_info ($message{address}, "Serial1",   $hex[$file{Cons}{ModuleType}{$message{ModuleType}}{SerialLow}]) ;
            }
            if ( defined $file{Cons}{ModuleType}{$message{ModuleType}}{SerialHigh} ) {
               &update_modules_info ($message{address}, "Serial2",   $hex[$file{Cons}{ModuleType}{$message{ModuleType}}{SerialHigh}]) ;
            }
            if ( defined $file{Cons}{ModuleType}{$message{ModuleType}}{MemoryMap} ) {
               &update_modules_info ($message{address}, "MemoryMap", $hex[$file{Cons}{ModuleType}{$message{ModuleType}}{MemoryMap}]) ;
               $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{MemoryMap} = $hex[$file{Cons}{ModuleType}{$message{ModuleType}}{MemoryMap}] ;
            }
            if ( defined $file{Cons}{ModuleType}{$message{ModuleType}}{Buildyear} ) {
               &update_modules_info ($message{address}, "BuildYear", $hex[$file{Cons}{ModuleType}{$message{ModuleType}}{Buildyear}]) ;
            }
            if ( defined $file{Cons}{ModuleType}{$message{ModuleType}}{BuildWeek} ) {
               &update_modules_info ($message{address}, "BuildWeek", $hex[$file{Cons}{ModuleType}{$message{ModuleType}}{BuildWeek}]) ;
            }

         } else {
            # 1/2: Parse address and search for the module type.
            # If the address is 00 we have a broadcast message and so we don't have a module type
            if ( $message{address} eq "00" ) {
            } else {
               # Searching module type. This will only work when the modules responded to a scan.
               # TODO: when an unknown module is found: trigger a scan
               if ( defined $global{Vars}{Modules}{Address}{$message{address}} and
                            $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} ne '' ) {
                  $message{addressMaster} = $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{address} ; # This is the master address, used for a VMBGPOD because it has sub addresses. We use this when updating the database.
                  $message{ModuleType}    = $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} ;
               } else {
                  $message{addressMaster} = $message{address} ;
                  push @{$message{text}}, "No module type found for this address" ;
               }
            }

            # 2/2: Search the name of the message.
            # This depends if it's a broadcast message or not.
            # It also depends on the type of module.
            $message{MessageName} .= "Unknown" ;
            if ( $message{address} eq "00" ) { # 00 -> broadcast message, name is independent of the type
               if ( defined $global{Cons}{MessagesBroadCast}{$message{MessageType}}{Name} ) {
                  $message{MessageName} = $global{Cons}{MessagesBroadCast}{$message{MessageType}}{Name} ;
               }
            } else {
               if ( defined $global{Cons}{ModuleTypes}{$message{ModuleType}} and
                    defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}} and
                    defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Name} ) {
                  $message{MessageName} = $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Name} ;
               }
            }

            if ( $message{MessageType} eq "B0" ) { # Module subtype: answer to a Scan
               if ( defined $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} ) {
                  push @{$message{text}}, "address $message{address}, module type: $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type}" ;
                  # The touch modules have a special address for the temperature sensor
                  if ( $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} eq "28" ) { # VMBGPOD
                     push @{$message{text}},                  "SubAddr1 = $hex[3]" ;
                     &update_modules_info ($message{address}, "SubAddr1", $hex[3]) ;
                     push @{$message{text}},                  "SubAddr2 = $hex[4]" ;
                     &update_modules_info ($message{address}, "SubAddr2", $hex[4]) ;
                     push @{$message{text}},                  "SubAddr3 = $hex[5]" ;
                     &update_modules_info ($message{address}, "SubAddr3", $hex[5]) ;
                     push @{$message{text}},                  "SubAddr4 = $hex[6]" ;
                     &update_modules_info ($message{address}, "SubAddr4", $hex[6]) ;
                     push @{$message{text}},                  "TemperatureAddr = $hex[6]" ;
                     &update_modules_info ($message{address}, "TemperatureAddr", $hex[6]) ;
                  }

                  if ( ( $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} eq "1E" ) or # VMBGP1D
                       ( $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} eq "1F" ) or # VMBGP2D
                       ( $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} eq "20" ) or # VMBGP4D
                       ( $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} eq "2D" ) ) { # VMBGP4PIR
                     push @{$message{text}},                  "SubAddr1 = $hex[3]" ;
                     &update_modules_info ($message{address}, "SubAddr1", $hex[3]) ;
                     push @{$message{text}},                  "TemperatureAddr = $hex[3]" ;
                     &update_modules_info ($message{address}, "TemperatureAddr", $hex[3]) ;
                  }
               } else {
                  push @{$message{text}}, "address $message{address}, no module info found for this address" ;
               }

            } elsif ( $message{MessageType} eq "D8" ) { # Realtime clock update
               push @{$message{text}}, "Realtime clock status:" ;
               my $day  = hex ($hex[0]) ;
               my $hour = hex ($hex[1]) ; $hour = "0" . $hour if $hour < 10 ;
               my $min  = hex ($hex[2]) ; $min =  "0" . $min  if $min  < 10 ;
               push @{$message{text}}, "day = $global{Cons}{Days}{$day}, time = $hour:$min" ;

            } elsif ( $message{MessageType} eq "B7" ) { # Realtime clock update
               push @{$message{text}}, "Date sync:" ;
               my $day  = hex ($hex[0]) ;
               my $mon  = hex ($hex[1]) ;
               my $year = hex ("$hex[2]$hex[3]") ;
               push @{$message{text}}, "day = $day, month = $mon, year = $year" ;

            } elsif ( $message{MessageType} eq "E6" ) { # Temperature status
               my $temperature = sprintf ("%.2f",&hex_to_temperature($hex[0], $hex[1])) ;

               my $ModuleType = $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} ;
               my $TemperatureChannel = $global{Cons}{ModuleTypes}{$ModuleType}{TemperatureChannel} ;
               &update_modules_channel_info ($message{address}, $TemperatureChannel, "Temperature", $temperature) ;

               push @{$message{text}}, "Temperature = $temperature" ;
               &openHAB_update_state ("Temperature_$message{addressMaster}_$TemperatureChannel", $temperature) ;

            #} elsif ( $message{MessageType} eq "A9" ) {
            #my $Channel = &hex_to_dec (shift @hex ) ; # 9 -> sensor 1, 12 -> sensor 14
            #my $bin = &hex_to_bin (shift @hex) ; # We also need the message in binary format
            #foreach my $hex (@hex) {
               #$dec = &hex_to_dec($hex) ;
               #print "$hex   $dec\n" ;
               #}
            #print "bin = $bin\n" ;

            } elsif ( $message{MessageType} eq "F0" # Name of channel
                   or $message{MessageType} eq "F1"
                   or $message{MessageType} eq "F2" ) {

               my $hex = shift @hex ;
               my $Channel = &channel_hex_to_id($hex,$message{address},"Name") ;

               # For 2C = VMBPIRO, only the sensor name is returned and this as Channel 01. But this is in reality channel 09. The other channels have fixed names.
               if ( $message{ModuleType} eq "2C" ) {
                  $Channel = "09" ;
               }

               # Reset the name
               if ( $message{MessageType} eq "F0" ) {
                  $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{Name}{value} = "" ;
               }

               # Parsing the characters
               foreach my $hex (@hex) {
                  next if $hex eq "FF" ;
                  my $test = chr hex $hex ;
                  $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{Name}{value} .= $test ; # Append the name
               }

               # Save the name
               if ( $message{MessageType} eq "F2" ) {
                  if ( defined $message{ModuleType} ) {
                     push @{$message{text}}, "Channel $Channel, Name = $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{Name}{value}" ;
                     &update_modules_channel_info ($message{address}, $Channel, "Name", $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{Name}{value}) ;
                  }
               }

            } elsif ( $message{MessageType} eq 'CC' or # COMMAND_MEMORY_DATA
                      $message{MessageType} eq 'FE' ) { # COMMAND_MEMORY_DATA
               my $memory = shift @hex ; $memory .=  shift @hex ;


               $memoryDec = &hex_to_dec ($memory) ; # Memory in decimal so we can loop the 4 returned memory blocks
               foreach $hex (@hex) {
                  my $memory = &dec_to_4hex($memoryDec) ; # Memory location in hex

                  my $bin = &hex_to_bin ($hex) ; # Memory content in binary format
                  my $dec = &hex_to_dec ($hex) ; # Memory content in decimal
                  my $char = chr hex $hex ;     # Memory content in char

                  # MemoryKey: configured based on the build of the module.
                  my $MemoryKey = &module_find_MemoryKey ($message{address}, $message{ModuleType}) ;;

                  if ( defined $MemoryKey ) {
                     # See if we have a Type defined for the memory
                     if ( defined  $global{Cons}{ModuleTypes}{$message{ModuleType}}{Memory}{$MemoryKey}{Address}{$memory}{ModuleName} ) {
                        my $number = $global{Cons}{ModuleTypes}{$message{ModuleType}}{Memory}{$MemoryKey}{Address}{$memory}{ModuleName} ;
                        my $command ;
                        if ( $number =~ /(\d+):(.+)/ ) {
                           $number = $1 ;
                           $command = $2 ;
                        }

                        if ( $command eq "Start" ) {
                           # Reset our ModuleName
                           delete $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{ModuleNameAddress} ;
                        }

                        ${$global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{ModuleNameAddress}}[$number] = $char if $hex ne "FF" ;

                        if ( $command eq "Save" ) {
                           my $ModuleName = join '', @{$global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{ModuleNameAddress}} ;
                           &update_modules_info ($message{address}, "ModuleName", $ModuleName) ;
                           push @{$message{text}}, "ModuleName=$global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{ModuleName}" ;
                        }
                     } elsif ( defined  $global{Cons}{ModuleTypes}{$message{ModuleType}}{Memory}{$MemoryKey}{Address}{$memory}{SensorName} ) {
                        my $number = $global{Cons}{ModuleTypes}{$message{ModuleType}}{Memory}{$MemoryKey}{Address}{$memory}{SensorName} ;
                        my $command ;
                        if ( $number =~ /(\d+):(.+)/ ) {
                           $number = $1 ;
                           $command = $2 ;
                        }

                        if ( $command eq "Start" ) {
                           # Reset our SensorName
                           delete $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{SensorNameAddress} ;
                        }

                        ${$global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{SensorNameAddress}}[$number] = $char if $hex ne "FF" ;

                        if ( $command eq "Save" ) {
                           my $SensorName = join '', @{$global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{SensorNameAddress}} ;
                           my $SensorChannel = $global{Cons}{ModuleTypes}{$message{ModuleType}}{Memory}{$MemoryKey}{SensorChannel} ;
                           &update_modules_channel_info ($message{address}, $SensorChannel, "Name", $SensorName) ;
                           push @{$message{text}}, "SensorName=$global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{SensorName}" ;
                        }
                     } else {
                        # No type: loop possible Match keys
                        my %info ;
                        foreach my $key (keys %{$global{Cons}{ModuleTypes}{$message{ModuleType}}{Memory}{$MemoryKey}{Address}{"$memory"}{Match}}) {
                           my $Value ; my $Channel ; my $SubName ;

                           foreach my $Matchkey (keys %{$global{Cons}{ModuleTypes}{$message{ModuleType}}{Memory}{$MemoryKey}{Address}{"$memory"}{Match}{$key}}) {
                              my $Match ; # We set this variable if we have a match

                              # Regular exression is always binary based match
                              if ( $Matchkey =~ /^%(.+)$/ ) {
                                 my $regex = $1 ;
                                 if ( $bin =~ /$regex/ ) {
                                    $Match = "yes" ;
                                 }

                              # The rest is a hex match or a bin match
                              } elsif ( $Matchkey eq $hex[$byte] or
                                       $Matchkey eq $bin ) {
                                 $Match = "yes" ;
                              }

                              # If we have match, process the information
                              if ( $Match ) {
                                 if ( defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Memory}{$MemoryKey}{Address}{"$memory"}{Match}{$key}{$Matchkey}{Value} ) {
                                    $Value = $global{Cons}{ModuleTypes}{$message{ModuleType}}{Memory}{$MemoryKey}{Address}{"$memory"}{Match}{$key}{$Matchkey}{Value} ;
                                    if ( $Value eq "PulsePerUnits" ) {
                                       if ( $bin eq "00000000" ) {
                                          $Value = "Disabled" ;
                                       } else {
                                          $Value = &bin_to_dec($bin) ;
                                          $Value *= 100 ;
                                       }
                                    }
                                 }
                                 if ( defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Memory}{$MemoryKey}{Address}{"$memory"}{Match}{$key}{$Matchkey}{Channel} ) {
                                    $Channel = $global{Cons}{ModuleTypes}{$message{ModuleType}}{Memory}{$MemoryKey}{Address}{"$memory"}{Match}{$key}{$Matchkey}{Channel} ;
                                 }
                                 if ( defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Memory}{$MemoryKey}{Address}{"$memory"}{Match}{$key}{$Matchkey}{SubName} ) {
                                    $SubName = $global{Cons}{ModuleTypes}{$message{ModuleType}}{Memory}{$MemoryKey}{Address}{"$memory"}{Match}{$key}{$Matchkey}{SubName} ;
                                 }
                              }
                           }

                           $info{$Channel}{$SubName} = $Value if defined $Channel and defined $SubName and defined $Value ;
                        }

                        # print Dumper {%info} ;
                        foreach my $Channel (sort keys (%info) ) {
                           foreach my $SubName (sort keys (%{$info{$Channel}}) ) {
                              push @{$message{text}}, "$Channel, $SubName = $info{$Channel}{$SubName}" ;
                              &update_modules_channel_info ($message{addressMaster}, $Channel, $SubName, $info{$Channel}{$SubName}) ;
                           }
                        }

                     }
                  } else {
                     push @{$message{text}}, "No data for memory = $memory, MemoryKey=$MemoryKey, hex = $hex, bin = $bin, char = $char" ;
                  }
                  $memoryDec ++ ;
               }

            } else {
               # If we have process information for this module type and message, process the message.
               if ( defined $global{Cons}{ModuleTypes}{$message{ModuleType}} and
                    defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}} and
                    defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data} ) {
                  my %Process = %{$global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}} ;

                  my %info ;
                  my %openHAB_update_state ;

                  # Parse the message byte per byte
                  if ( defined $Process{Data}{PerByte} ) {
                     my $Channel = "00" ; # Default value

                     foreach my $byte (0..8) { # Loop the 8 possible bytes
                        # Only process when there is information about this byte
                        if ( defined $Process{Data}{PerByte}{$byte} ) {
                           my $bin  = &hex_to_bin ($hex[$byte]) ; # We also need the message in binary format

                           # Search for a name
                           my $Name ;
                           if ( defined $Process{Data}{PerByte}{$byte}{Name} ) {
                              $Name = $Process{Data}{PerByte}{$byte}{Name} ;
                           }

                           # Loop the possbile values for the byte
                           foreach my $key (sort keys(%{$Process{Data}{PerByte}{$byte}{Match}})) {
                              my $Match ; # We set this variable if we have a match

                              # Regular exression is always binary based match
                              if ( $key =~ /^%(.+)$/ ) {
                                 my $regex = $1 ;
                                 if ( $bin =~ /$regex/ ) {
                                    $Match = "yes" ;
                                 }

                              # The rest is a hex match or a bin match
                              } elsif ( $key eq $hex[$byte] or
                                        $key eq $bin ) {
                                 $Match = "yes" ;
                              }

                              # If we have match, process the information
                              if ( $Match ) {
                                 my $Value ; # To store the value of the message. This can be data found in the message or stored in {Info}
                                 my $SubName ;

                                 if ( defined $Process{Data}{PerByte}{$byte}{Match}{$key}{Info} ) {
                                    $Value =  $Process{Data}{PerByte}{$byte}{Match}{$key}{Info} ;
                                 }
                                 if ( defined  $Process{Data}{PerByte}{$byte}{Match}{$key}{Channel} ) {
                                    $Channel = $Process{Data}{PerByte}{$byte}{Match}{$key}{Channel} ;
                                 }
                                 if ( defined  $Process{Data}{PerByte}{$byte}{Match}{$key}{Name} ) {
                                    $SubName = $Process{Data}{PerByte}{$byte}{Match}{$key}{Name} ;
                                 }

                                 # Do we have to convert the message
                                 if ( defined $Process{Data}{PerByte}{$byte}{Match}{$key}{Convert} ) {
                                    # Calculate the procent
                                    if ( $Process{Data}{PerByte}{$byte}{Match}{$key}{Convert} eq "Procent" ) {
                                       $Name = "Procent" if ! defined $Name ;
                                       $Value = hex $hex[$byte] ;
                                    }

                                    # Calculate the temperature from the message
                                    if ( $Process{Data}{PerByte}{$byte}{Match}{$key}{Convert} eq "Temperature" ) {
                                       $Name = "Temperature" if ! defined $Name ;
                                       $Value = &hex_to_temperature ($hex[$byte]) ;
                                    }

                                    # Simple Counter: first byte is divider + Channel
                                    if ( $Process{Data}{PerByte}{$byte}{Match}{$key}{Convert} eq "Divider" ) {
                                       $bin =~ /(......)(..)/ ;
                                       $Divider = $1 ;
                                       $Channel = $2 ;

                                       $Channel = &bin_to_dec($Channel) ; $Channel ++ ;
                                       $Channel = "0" . $Channel if $Channel < 10 ; # This is always true since the channel is 1, 2, 3 or 4

                                       $Divider = &bin_to_dec($Divider) ;
                                       $Divider *= 100 ;

                                       $info{$Channel}{Divider} = $Divider ;
                                       $Name = "Counter" if ! defined $Name ;
                                    }

                                    # Simple Counter
                                    if ( $Process{Data}{PerByte}{$byte}{Match}{$key}{Convert} eq "Counter" ) {
                                       $info{$Channel}{Counter} .= $hex[$byte] ;
                                    }

                                    # Button pressed or Sensor triggered on touch or an other input
                                    if ( $Process{Data}{PerByte}{$byte}{Match}{$key}{Convert} eq "Channel" ) {
                                       $Channel = $hex[$byte] ;
                                       next if $Channel eq "00" ; # If Channel is 00, that means the byte is useless
                                       $Channel = &channel_hex_to_id($Channel,$message{address},"ConvertChannel") ; # Convert it to a number
                                       $info{$Channel}{Button} = $Value ;
                                    }
                                 }

                                 # Do we have to update the state in openHAB
                                 if ( defined $Process{Data}{PerByte}{$byte}{Match}{$key}{openHAB} ) {
                                    my $openHAB = $Process{Data}{PerByte}{$byte}{Match}{$key}{openHAB} ; # Handier var

                                    if ( $openHAB =~ "(.+):Button" ) {
                                       my $action = $1 ;
                                       my $Type = $global{Cons}{ModuleTypes}{$message{ModuleType}}{Channels}{$Channel}{Type} ;
                                       # A Button is tricky: we have to do something on RELEASED, but we need to know if it was a short or a long press
                                       # For a 7IN (=ButtonCounter) we also have to check the Divider value
                                       if ( $Type eq "Button" or
                                          ( $Type eq "ButtonCounter" and
                                             defined $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{Divider}{value} and
                                                     $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{Divider}{value} eq "Disabled" ) ) {
                                          if ( $action eq "RELEASED" ) {
                                             if ( $global{openHAB}{ButtonState}{$message{addressMaster}}{$Channel} eq "PRESSED" ) {
                                                # PRESSED: send ON + OFF
                                                $openHAB_update_state{"Button_$message{addressMaster}_$Channel"} = "ON OFF" ;
                                             } else {
                                                # LONGPRESSED: send OFF
                                                $openHAB_update_state{"ButtonLong_$message{addressMaster}_$Channel"} = "OFF" ;
                                             }
                                          } else {
                                             $global{openHAB}{ButtonState}{$message{addressMaster}}{$Channel} = $action ; # remember type: PRESSED or LONGPRESSED
                                             if ( $action eq "PRESSED" ) {
                                                # Don't send ON yet, wait for RELEASED. Because for a LONGPRESSED, there is also a PRESSED message first
                                             } elsif ( $action eq "LONGPRESSED" ) {
                                                $openHAB_update_state{"ButtonLong_$message{addressMaster}_$Channel"} = "ON" ;
                                             }
                                          }
                                       } elsif ( $Type eq "Sensor" ) {
                                          if ( $action eq "RELEASED" ) {
                                             $openHAB_update_state{"Sensor_$message{addressMaster}_$Channel"} = "OFF" ;
                                          } else {
                                             $openHAB_update_state{"Sensor_$message{addressMaster}_$Channel"} = "ON" ;
                                          }
                                       }
                                    } elsif ( $openHAB =~ /:/ ) {
                                       my @openHAB = split ":", $openHAB ;
                                       if ( $Channel eq "00" ) {
                                          $openHAB_update_state{"$openHAB[1]_$message{addressMaster}"} = $openHAB[0] ;
                                       } else {
                                          $openHAB_update_state{"$openHAB[1]_$message{addressMaster}_$Channel"} = $openHAB[0] ;
                                       }
                                    } else {
                                       if ( $Channel eq "00" ) {
                                          $openHAB_update_state{"$openHAB"."_"."$message{addressMaster}"} = $Value if defined $Value ;
                                       } else {
                                          $openHAB_update_state{"$openHAB"."_"."$message{addressMaster}_$Channel"} = $Value if defined $Value ;
                                       }
                                    }
                                 }
   
                                 push @{$info{$Channel}{$Name}{List}},    $Value if defined $Value ;
                                 push @{$info{$Channel}{$SubName}{List}}, $Value if defined $SubName ;
                              }
                           }
                        }
                     }

                  # Parse the message in total
                  } elsif ( defined $Process{Data}{PerMessage} ) {
                     if ( $Process{Data}{PerMessage}{Convert} eq "SensorText" or
                          $Process{Data}{PerMessage}{Convert} eq "MemoText") {
                        my $hex = shift @hex ;
                        my $Channel = &channel_hex_to_id($hex,$message{address},"SensorText") ; # This is useless for MemoText, but needed for SensorText

                        # First byte is the start of the text
                        my $start = shift @hex ;
                        $start = &hex_to_dec($start) ;
                        $start *= 1 ;

                        # start of text so reset the data
                        if ( $start eq "0" ) {
                           delete $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{valueArray}  ;
                           $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{valueStore} = "yes" ;
                        }

                        # Maximum of characters. For now, we have Sensor with 15 and Memo with 63 characters
                        my $MaxChars ;
                        if ( $Process{Data}{PerMessage}{Convert} eq "SensorText" ) {
                           $MaxChars = 15 ;
                        } else {
                           $MaxChars = 63 ;
                        }

                        # Parsing the characters: loop the remaining message
                        foreach my $hex (@hex) {

                           # If this is set, that means we saw the start of the message and the message is not yet stored
                           if ( defined $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{valueStore} ) {

                              # Ending with zero value or max number of characters is reached: text is complete
                              if ( $hex eq "00" or $start eq $MaxChars ) {
                                 delete $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{valueStore} ; # Remember that we have stored the message so we can ignore the remaining characters

                                 # Convert the text stored in hash to string
                                 $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{value} = "" ; # Reset the value
                                 foreach my $key (sort {$a <=> $b} keys %{$global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{valueArray}} ) {
                                    $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{value} .= $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{valueArray}{$key} ;
                                 }

                                 # Save the data
                                 if ( $Process{Data}{PerMessage}{Convert} eq "SensorText" ) {
                                    &update_modules_channel_info ($message{address}, $Channel, "value", $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{value}) ;
                                    $openHAB_update_state{"Sensor_$message{addressMaster}_$Channel"} = $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{value} ;
                                    $info{$Channel}{Button} = $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{value} ;
                                 } else {
                                    $info{$Channel}{Memo} = $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{value} ;
                                 }
  
                              } else {
                                 my $char = chr hex $hex ;
                                 if ( $Process{Data}{PerMessage}{Convert} eq "SensorText" ) {
                                    if ( $char =~ /[\d\.]/ ) { # Only use the numeric and the dot characters
                                       $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{valueArray}{$start} = $char ;
                                    }
                                 } else {
                                    $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{valueArray}{$start} = $char ;
                                 }
                              }
                              $start ++ ;
                           }
                        }
                     }
                  }

                  #print "\n" ; # Debugging
                  #print Dumper {%info} ; # Debugging

                  # Loop all found info and store in the database
                  foreach my $Channel (sort keys (%info) ) {
                     foreach my $Name (sort keys (%{$info{$Channel}}) ) {
                        if ( $info{$Channel}{$Name}{List}) {
                           my $temp = join ";", @{$info{$Channel}{$Name}{List}} ;
                           push @{$message{text}}, "$Channel, $Name = $temp" ;
                           &update_modules_channel_info ($message{addressMaster}, $Channel, $Name, $temp) ;
                        } elsif ( $Name eq "Divider" ) {
                           $openHAB_update_state{"Divider_$message{addressMaster}_$Channel"} = $info{$Channel}{Divider} ;
                           push @{$message{text}}, "$Channel, Divider = $Divider" ;
                           &update_modules_channel_info ($message{addressMaster}, $Channel, $Name, $info{$Channel}{Divider}) ;
                           $openHAB_update_state{"Divider_$message{addressMaster}_$Channel"} = $info{$Channel}{Divider} ;
                        } elsif ( $Name eq "Counter" ) {
                           my $CounterRaw = &hex_to_dec ($info{$Channel}{Counter}) ;
                           my $Counter = $CounterRaw / $info{$Channel}{Divider} ;
   
                           push @{$message{text}}, "$Channel, Counter = $Counter, CounterRaw = $CounterRaw" ;
                           &update_modules_channel_info ($message{addressMaster}, $Channel, "CounterRaw", $CounterRaw) ;
                           &update_modules_channel_info ($message{addressMaster}, $Channel, "Counter", $Counter) ;
                           $openHAB_update_state{"CounterRaw_$message{addressMaster}_$Channel"} = $CounterRaw ;
                           $openHAB_update_state{"Counter_$message{addressMaster}_$Channel"} = $Counter ;

                           # Using the current epoch seconds and the previous value, we can calculate the change per second of the counter
                           if ( defined $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{CounterPrevious}{value} ) { # Only do something if we have a previous value
                              my $time = time ; # Current time in seconds
                              # Number of seconds between now and the previous update of the counter + Counter change
                              my $TimeElapsed    = $time    - $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{CounterPreviousTime}{value} ;
                              next if $TimeElapsed == 0 ;
                              my $CounterElapsed = $Counter - $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{CounterPrevious}{value} ;

                              # Calculate counter change
                              my $CounterCurrent ;
                              if ( $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{Unit}{value} eq "kWh" ) {
                                 $CounterCurrent = ( $CounterElapsed / $TimeElapsed ) * 1000 * 60 * 60 ; # Current in W per hour
                              } else {
                                 $CounterCurrent = ( $CounterElapsed / $TimeElapsed ) * 60 * 60 ; # For m3 and liter: per hour
                              }

                              push @{$message{text}}, "$Channel, CounterCurrent = $CounterCurrent" ;
                              &update_modules_channel_info ($message{addressMaster}, $Channel, "CounterCurrent", $CounterCurrent) ;
                              $openHAB_update_state{"CounterCurrent_$message{addressMaster}_$Channel"} = $CounterCurrent ;
                           }

                           # Remember the counter and epoch seconds
                           $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{CounterPrevious}{value}     = $Counter ;
                           $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{CounterPreviousTime}{value} = time ;
                        } else {
                           push @{$message{text}}, "$Channel, $Name = $info{$Channel}{$Name}" ;
                           &update_modules_channel_info ($message{addressMaster}, $Channel, $Name, $info{$Channel}{$Name}) ;
                        }
                     }
                  }

                  # Post the updates to openHAB.
                  # This must be done AFTER the database updates
                  foreach my $key (keys %openHAB_update_state) {
                     foreach my $state (split " ", $openHAB_update_state{$key} ) {
                        &openHAB_update_state ($key, $state) ;
                     }
                  }
               } else {
                  push @{$message{text}}, "No process info for message ($message{Raw})" ;
               }
            }
         }
      }
   }

   my $text = join "\n    ", @{$message{text}} ;

   print         &timestamp . " $message{prio} $message{address}($message{addressMaster})=$message{ModuleType} $message{MessageType}=$message{MessageName}\n    $text\n" ;
   &log("logger",&timestamp . " $message{prio} $message{address}($message{addressMaster})=$message{ModuleType} $message{MessageType}=$message{MessageName}\n    $text") ;

   if ( defined $global{Config}{velbus}{ENABLE_RAWMESSAGE_LOGGING} ) {
      &log("raw","$message{address} : $message{prio} : $message{MessageType} : $message{RTR_size} : $message{Raw}") ;
   }
}

# Put a message on the bus
# 1: socket
# 2: address
# 3: commando
# 4: channel
sub send_message () {
   my $sock    = shift @_ ;
   my $address = shift @_ ;
   my $command = shift @_ ;
   my $channel = shift @_ ;
   my @other   = @_ ;

   $address =~ s/^0x//g ;
   $command =~ s/^0x//g ;

   if ( defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} ) {
      my $type = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} ;

      # Find prio for the command
      my $prio ;
      if ( defined $global{Cons}{ModuleTypes}{$type}{Messages}{$command}{Prio} and
                   $global{Cons}{ModuleTypes}{$type}{Messages}{$command}{Prio} =~ /High/i ) {
         $prio    = "0xF8" ;
      } else {
         $prio    = "0xFB" ;
      }

      my $rtr     = "0x00" ; # Only for scan this is not 0x00

      my @message ;

      push @message, "0x$command" ;

      if ( defined $channel and $channel ne "" ) {
         if ( $channel =~ /^0x/ ) {
            push @message, "$channel" ;
         } else {
            ($channel,$address) = &channel_number_to_id ($channel,$address,"MakeMessage") ;
            push @message, "0x$channel" ;
         }
      }

      foreach my $other (@other) {
         if ( $other =~ /^0x/ ) {
            push @message, $other ;
         } else {
            push @message, "0x".$other ;
         }
      }

      my $message = join " ", @message ;
      my $Name = $global{Cons}{ModuleTypes}{$type}{Messages}{$command}{Name} ; # Name of command
      $address = "0x$address" ;

      &log("message","prio=$prio, address=$address (type=$type), rtr=$rtr, command=$command, message = $message, $Name") ;

      &print_sock ($sock,$prio,$address,$rtr,@message) ;
      usleep (50000) ;
   }
}

# Get all possible info from a module
# 1: socket
# 2: address
# 3: module type
# 4: channel (optional)
sub get_status () {
   my $sock    = $_[0] ;
   my $address = $_[1] ;
   my $type    = $_[2] ;
   my $channel = $_[3] ; # Optional

   my $output ; # Some informational text we return
   if ( defined $channel ) {
      $output .= "address = $address, type = $type, channel = $channel<br>\n" ;
   } else {
      $output .= "address = $address, type = $type<br>\n" ;
   }

   # Get module name if no channel name is requested
   if ( ! defined $channel ) {
      # MemoryKey: configured based on the build of the module.
      my $MemoryKey = &module_find_MemoryKey ($address, $type) ;

      if ( defined $global{Cons}{ModuleTypes}{$type}{Memory}{$MemoryKey}{SensorNameAddress} ) {
         my @memory = split ";", $global{Cons}{ModuleTypes}{$type}{Memory}{$MemoryKey}{SensorNameAddress} ;
         foreach my $memory (@memory) {
            $memory =~ /(..)(..)/ ;
            my $hex1 = $1 ;
            my $hex2 = $2 ;
            &send_message ($sock, $address, 'FD', undef, $hex1 ,$hex2) ;
         }
      }
      if ( defined $global{Cons}{ModuleTypes}{$type}{Memory}{$MemoryKey}{ModuleNameAddress} ) {
         my @memory = split ";", $global{Cons}{ModuleTypes}{$type}{Memory}{$MemoryKey}{ModuleNameAddress} ;
         foreach my $memory (@memory) {
            $memory =~ /(..)(..)/ ;
            my $hex1 = $1 ;
            my $hex2 = $2 ;
            &send_message ($sock, $address, 'FD', undef, $hex1 ,$hex2) ;
         }
      }
   }

   # Getting a list of possible channels of the specific module
   my @channels ;
   if ( defined $channel ) {
      $channels[0] = $channel ; # Channel given as parameter
   } elsif ( defined $global{Cons}{ModuleTypes}{$type}{Channels} ) {
      # Touch with OLED + VMBGP1D/VMBGP2D/VMBGP4D: channel FF will request the names of all channels (message type EF)
      if ( ( $global{Cons}{ModuleTypes}{$type}{Messages}{'EF'} ) and
            ( $type eq "1E" or # VMBGP1D
              $type eq "1F" or # VMBGP2D
              $type eq "20" or # VMBGP2D
              $type eq "2D" or # VMBGP4PIR
              $type eq "32" or # VMB4AN
              $type eq "28" ) ) {
         $channels[0] = "0xFF" ;
      } else {
         @channels = sort keys %{$global{Cons}{ModuleTypes}{$type}{Channels}} ;
      }
   }

   if ( $type eq '22' ) { # VMB7IN
      &get_status_VMB7IN ($sock, $address) ;
   }

   # Loop the channels and get names, status, ...
   foreach my $channel (@channels) {
      if ( $global{Cons}{ModuleTypes}{$type}{Messages}{'EF'} ) { # EF = COMMAND_CHANNEL_NAME_REQUEST
         &send_message ($sock, $address, 'EF', $channel) ;
      }
      if ( $global{Cons}{ModuleTypes}{$type}{Messages}{'FA'} ) { # FA = COMMAND_RELAY_STATUS_REQUEST
         &send_message ($sock, $address, 'FA', $channel) ;
      }
   }

   return $output ;
}

# Get the counter type from the VMB7IN module
# 1: socket
# 2: address
sub get_status_VMB7IN () {
   my $sock    = $_[0] ;
   my $address = $_[1] ;

   my @channel ;
   if ( defined $channel and $channel ne "" ) {
      $channels[0] = $channel ;
   } else {
      $channels = ("01", "02", "03", "04") ;
   }

   # Request counter type: kWh, m3, liter:
   &send_message ($sock, $address, 'FD', undef, '03' ,'FE') ;

   # Request counter divider
   &send_message ($sock, $address, 'FD', undef, '00', 'E4') ; # Channel 1
   &send_message ($sock, $address, 'FD', undef, '00', 'E9') ; # Channel 2
   &send_message ($sock, $address, 'FD', undef, '00', 'EE') ; # Channel 3
   &send_message ($sock, $address, 'FD', undef, '00', 'F3') ; # Channel 4
}

# Convert channel number and address to channel bit. 
#   Channel 3 = 1000 -> 8
# Used by commands.pl & scripts
# 1: channel
# 2: address
# 3: type -> not used, informational
#     - MakeMessage
#     - ButtonPressed
sub channel_number_to_id () {
   my $channel = $_[0] ;
   my $address = $_[1] ;

   if ( $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} eq "1E" or # VMBGP1D
        $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} eq "1F" or # VMBGP2D
        $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} eq "20" or # VMBGP2D
        $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} eq "2D" or # VMBGP4PIR
        $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} eq "28" ) { # VMBGPOD
      if ( $channel > 24 and defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{SubAddr3} ) {
         $address = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{SubAddr3} ;
         $channel -= 24 ;
      } elsif ( $channel > 16 and defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{SubAddr2} ) {
         $address = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{SubAddr2} ;
         $channel -= 16 ;
      } elsif ( $channel > 8 and defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{SubAddr1} ) {
         $address = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{SubAddr1} ;
         $channel -= 8 ;
      }
   }
   $channel -- ;
   $channel = "1" . "0" x $channel ;
   $channel = &bin_to_hex ($channel) ;
   return ($channel,$address) ;
}

# Used by logger.pl for converting the channel hex value to the correct channel id
# 1: channel
# 2: address
# 3: type: Name or nothing
#     - SensorText: message AC = transmitting sensor as text
#     - Name
#     - ConvertChannel
sub channel_hex_to_id () {
   my $channel = $_[0] ;
   my $address = $_[1] ; # Optional
   my $type    = $_[2] ;

   my $ModuleType = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} ;

   if ( $type eq "Name" ) {
      if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{ChannelNumbers}{Name} and 
         $global{Cons}{ModuleTypes}{$ModuleType}{ChannelNumbers}{Name} eq "hex" ) {
         $channel = &hex_to_dec ($channel) ;
      } else {
         $channel = &hex_to_bin ($channel) ;
         $channel =~ /(0*)$/ ; # Filter out last 0's
         $channel = ($1 =~ tr/0//); # Count last 0's
         $channel ++ ;
      }

   # VMB4AN channel: 9 -> sensor 1, 12 -> sensor 14
   } elsif ( $type eq "SensorText" ) {
      $channel = 1 if $channel eq "9" ;
      $channel = 2 if $channel eq "10" ;
      $channel = 3 if $channel eq "11" ;
      $channel = 4 if $channel eq "12" ;

   # "ConvertChannel" -> Button pressed or Sensor triggered on touch or an other input
   } else {
      $channel = &hex_to_bin ($channel) ;
      $channel =~ /(0*)$/ ; # Filter out last 0's
      $channel = ($1 =~ tr/0//); # Count last 0's
      $channel ++ ;

      if ( defined $address and
           defined $global{Vars}{Modules}{Address}{$address} and
           defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{SubAddrMulti} ) {
         $channel += $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{SubAddrMulti} ;
      }

      if ( defined $address and $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{address}) {
         $address = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{address} ;
      }
   }

   $channel = "0" . $channel if $channel < 10 ;
   return $channel ;
}

# Get the status of modules
sub update_module_status () {
   my $sock = $_[0] ;

   my $output ;

   # If we have an address, query the module on that address
   if ( defined $global{cgi}{params}{address} ) {
      my $address = $global{cgi}{params}{address} ;

      # Only proceed if we have a module type for that address
      if ( defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} and $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} ne '' ) {
         my $type = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} ;

         # If we have a channel, query only that channel of the module
         if ( defined $global{cgi}{params}{channel} ) {
            my $channel = $global{cgi}{params}{channel} ;
            $output .= "<p>Query status of channel $channel module found on address $address, type $type</p>\n" ;
            $output .= &get_status ($sock,"$address","$type","$channel") ;
         } else {
            # If we don't have a channel, query all channels
            $output .= "<p>Query status of module found on address $address, type $type</p>\n" ;
            $output .= &get_status ($sock,"$address","$type") ;
         }
      } else {
         $output .= "<p>No module found on address $address</p>\n" ;
      }
   } else {
      # Loop all addresses if no address is specified
      foreach my $address (sort keys (%{$global{Vars}{Modules}{Address}})) {
         my $type = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} ;
         next if $type eq '' ; # Skip when we have no type
         $output .= "<p>Query status of module found on address $address, type $type</p>\n" ;
         $output .= &get_status ($sock,"$address","$type") ;
      }
   }

   return $output ;
}

# Simulate a button press by sending 'Channel just pressed', sleep 20 ms, send 'Channel just release'
# 1: socket
# 2: address
# 3: channel
sub button_pressed {
   my $sock    = $_[0] ;
   my $address = $_[1] ;
   my $channel = $_[2] ;
   my $value   = $_[3] ;
   ($channel,$address) = &channel_number_to_id($channel,$address,"ButtonPressed") ;
   # DATABYTE2 = Channel just pressed
   # DATABYTE3 = Channel just released
   # DATABYTE4 = Channel long pressed
   &send_message ($sock, $address, "00", "", $channel, "00", "00" ) ; # Channel just pressed
   usleep (20000) ;
   &send_message ($sock, $address, "00", "", "00", $channel, "00" ) ; # Channel just released
}

# Set the value of a dimmer. value should be between 0 and 100.
# 1: socket
# 2: address
# 3: channel
# 4: value
sub dim_value {
   my $sock    = $_[0] ;
   my $address = $_[1] ;
   my $channel = $_[2] ;
   my $value   = $_[3] ;
   $value = sprintf ("%02X",$value) ;
   &send_message ($sock, $address, "07", $channel, $value, "00", "00" ) ;
}

# Switch off a relay
# 1: socket
# 2: address
# 3: channel
sub relay_off {
   my $sock    = $_[0] ;
   my $address = $_[1] ;
   my $channel = $_[2] ;
   &send_message ($sock, $address, "01", $channel) ;
}

# Switch on a relay
# 1: socket
# 2: address
# 3: channel
sub relay_on {
   my $sock    = $_[0] ;
   my $address = $_[1] ;
   my $channel = $_[2] ;
   &send_message ($sock, $address, "02", $channel) ;
}

# Stop a blind
# 1: socket
# 2: address
# 3: channel
sub blind_stop {
   my $sock    = $_[0] ;
   my $address = $_[1] ;
   my $channel = $_[2] ;
   &send_message ($sock, $address, "04", $channel) ; # COMMAND_BLIND_OFF
}

# Move a blind up
# 1: socket
# 2: address
# 3: channel
sub blind_up {
   my $sock    = $_[0] ;
   my $address = $_[1] ;
   my $channel = $_[2] ;
   &send_message ($sock, $address, "05", $channel, "00", "00", "00") ; # COMMAND_BLIND_UP
}

# Move a blind down
# 1: socket
# 2: address
# 3: channel
sub blind_down {
   my $sock    = $_[0] ;
   my $address = $_[1] ;
   my $channel = $_[2] ;
   &send_message ($sock, $address, "06", $channel, "00", "00", "00") ; # COMMAND_BLIND_DOWN
}

# Move a blind to a position. position should be between 0 and 100.
# 1: socket
# 2: address
# 3: channel
# 4: position
sub blind_pos {
   my $sock     = $_[0] ;
   my $address  = $_[1] ;
   my $channel  = $_[2] ;
   my $position = $_[3] ;
   $position = sprintf ("%02X",$position) ;
   &send_message ($sock, $address, "1C", $channel, $position) ; # COMMAND_BLIND_POS
}

# Set the temperature target: heating or cooling
# 1: socket
# 2: address
# 3: 0=heating, 1=cooling
sub set_temperature_cohe_mode {
   my $sock        = $_[0] ;
   my $address     = $_[1] ;
   my $temperature = $_[2] ;
   if ( $temperature eq 1 ) {
      &send_message ($sock, $address, "DF","00") ; # COMMAND_SET_COOLING_MODE
   } else {
      &send_message ($sock, $address, "E0","00") ; # COMMAND_SET_HEATING_MODE
   }
}

# Set the target temperature for a glass planel
# 1: socket
# 2: address
# 3: temperature
sub set_temperature {
   my $sock        = $_[0] ;
   my $address     = $_[1] ;
   my $temperature = $_[2] ;
   $temperature = &temperature_to_hex ($temperature) ;
   &send_message ($sock, $address, "E4", undef, "00", $temperature) ; # COMMAND_SET_TEMP
}

# Set the broadcast interval for the temperature of touch display
# 1: socket
# 2: address
# 3: timeout in seconds
sub set_temperature_interval {
   my $sock     = $_[0] ;
   my $address  = $_[1] ;
   my $interval = $_[2] ;
   $interval = &dec_to_hex ($interval) ;
   &send_message ($sock, $address, "E5", undef, $interval) ;
}

# Set the broadcast interval for temperature of all touch displays
# 1: socket
# 2: timeout in seconds
sub set_temperature_interval_all {
   my $sock     = $_[0] ;
   my $interval = $_[1] ;

   foreach my $ModuleType ("1E","1F","20","2D","28","2C") {
      foreach my $address (sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerType}{$ModuleType}{ModuleList}})) {
         &set_temperature_interval ($sock, $address, $interval) ;
      }
   }
}

# Set the temperature mode for a glass planel
# COMMAND_SWITCH_TO_COMFORT_MODE (DB) = 1
# COMMAND_SWITCH_TO_DAY_MODE     (DC) = 2
# COMMAND_SWITCH_TO_NIGHT_MODE   (DD) = 3
# COMMAND_SWITCH_TO_SAFE_MODE    (DE) = 4
# 1: socket
# 2: address
# 3: temperature
sub set_temperature_mode {
   my $sock    = $_[0] ;
   my $address = $_[1] ;
   my $mode    = $_[2] ;

   if ( $mode =~ /1/ ) {
      $mode = "DB" ;
   } elsif ( $mode =~ /2/ ) {
      $mode = "DC" ;
   } elsif ( $mode =~ /3/ ) {
      $mode = "DD" ;
   } elsif ( $mode =~ /4/ ) {
      $mode = "DE" ;
   }
   &send_message ($sock, $address, $mode, undef, "00", "00") ; # COMMAND_SET_TEMP
}

# Show a memo text on the OLED of a VMBGPOD
# To erase the text, just don't provide the third parameter
sub send_memo () {
   my $sock    = $_[0] ;
   my $address = $_[1] ;
   my $text    = $_[2] ;

   if ( $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} eq "28" ) { # VMBGPOD
      my @text = split "", $text ;
      unshift @text , "" ; # First element of tekst is lost due to $j starting a 1
   
      # We can send 64 characters and it's 5 characters / message. So we need 13 messages.
      foreach my $i (0..12) {
         my @message = ('00', '00', '00', '00', '00', '00') ; # Pre-fill the message with 00
         foreach my $j (1..5) { # Start from 1 because 0 is for the offset
            my $place = $i * 5 + $j ;
            next if $place > 64 ;
            my $char = &dec_to_hex (ord $text[$place]) ;
            $message[$j] = $char ;
         }  
         $message[0] = &dec_to_hex($i * 5) ; # First element is the offset of the character
         &send_message ($sock, $address, 'AC', 'FF', @message) ;
      }
   }
}

# Scan all the address. The result is a message from the module with the type.
sub scan () {
   my $sock = $_[0] ;
   foreach my $addr (1..255) {
      &print_sock ($sock,"0xFB","$addr","0x40") ;
      usleep (20000) ;
   }
}

# Brocadcast current date and time
sub broadcast_datetime () {
   my $sock = $_[0] ;

   ($global{Tijd}{sec},$global{Tijd}{min},$global{Tijd}{hour},$global{Tijd}{mday},$global{Tijd}{mon},$global{Tijd}{year},$global{Tijd}{wday},$global{Tijd}{yday},$global{Tijd}{isdst}) = localtime(time) ;

   # For Velbus 0 = monday, but in perl 0 = synday
   $global{Tijd}{wday} -- ;
   $global{Tijd}{wday} = 6 if $global{Tijd}{wday} eq "-1" ;

   my @message = ($global{Tijd}{wday},$global{Tijd}{hour},$global{Tijd}{min}) ;
   &print_sock ($sock,"0xFB","0x00","0x00","0xD8", @message) ;

   $global{Tijd}{year} += 1900 ;
   $global{Tijd}{mon} ++ ;
   my $year_hex = sprintf ("%02X",$global{Tijd}{year}) ; # Converting year to hex format
   $year_hex =~ /(.?.)(..)/ ; # Separating year in 2 parts
   my @message = ("$global{Tijd}{mday}","$global{Tijd}{mon}","0x$1", "0x$2") ;
   &print_sock ($sock,"0xFB","0x00","0x00","0xB7", @message) ;
}

return 1
