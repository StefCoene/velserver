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
            }
            if ( defined $file{Cons}{ModuleType}{$message{ModuleType}}{Buildyear} ) {
               &update_modules_info ($message{address}, "BuildYear", $hex[$file{Cons}{ModuleType}{$message{ModuleType}}{Buildyear}]) ;
            }
            if ( defined $file{Cons}{ModuleType}{$message{ModuleType}}{BuildWeek} ) {
               &update_modules_info ($message{address}, "BuildWeek", $hex[$file{Cons}{ModuleType}{$message{ModuleType}}{BuildWeek}]) ;
            }

         } else {
            my %ChannelInfo ; # To collect the information per channel

            # 1/2: Parse address and search for the module type.
            # If the address is 00 we have a broadcast message and so we don't have a module type
            if ( $message{address} eq "00" ) {
            } else {
               # Searching module type. This will only work when the modules responded to a scan.
               # TODO: when an unknown module is found: trigger a scan
               if ( defined $global{Vars}{Modules}{Address}{$message{address}} and
                            $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} ne '' ) {
                  $message{ModuleType}    = $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} ;
               } else {
                  push @{$message{text}}, "No module type found for this address" ;
               }
            }

            # 2/2: Search the name of the message.
            # This depends if it's a broadcast message or not.
            # It also depends on the type of module.
            $message{MessageName} .= "Unknown :: " ;
            #if ( $message{address} eq "00" ) { # 00 -> broadcast message, name is independent of the type
               if ( defined $global{Cons}{MessagesBroadCast}{$message{MessageType}}{Name} ) {
                  $message{MessageName} = $global{Cons}{MessagesBroadCast}{$message{MessageType}}{Name} ;
                  #}
            } else {
               if ( defined $global{Cons}{ModuleTypes}{$message{ModuleType}} and
                    defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}} and
                    defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Name} ) {
                  $message{MessageName} = $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Name} ;
               }
            }

            if ( $message{MessageType} eq "B0" ) { # Module subtype: answer to a Scan
               if ( defined $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} ) {
                  my $ModuleType = $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} ;
                  push @{$message{text}}, "address $message{address}, module type: $ModuleType" ;
                  # When we have multiple addresses, we get them in @hex
                  shift @hex ; shift @hex ; shift @hex ; # Throw away what we do not need

                  # Save all addresses
                  my $counter = 1 ;
                  foreach my $SubAddr (@hex) {
                     push @{$message{text}},                  "SubAddr$counter = $SubAddr" ;
                     &update_modules_info ($message{address}, "SubAddr$counter", $SubAddr) ;
                     $global{Vars}{Modules}{SubAddress}{$SubAddr}{MasterAddress} = $message{address} ; # Remember the master address for this subaddress
                     $global{Vars}{Modules}{SubAddress}{$SubAddr}{ChannelOffset} = $counter * 8 ; # Calculate the channel offset

                     $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{"SubAddr$counter"} = $SubAddr ; # Remember the sub address for the master address
                     $counter ++ ;
                  }

                  # If this is a touch with a Thermostat, store the address used for the Thermostat
                  if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{ThermostatAddr} ) {
                     my $ThermostatAddr = $global{Cons}{ModuleTypes}{$ModuleType}{ThermostatAddr} ; # This is 0 or 3, depending on the type of touch and indicates what address is for the Thermostat
                     $ThermostatAddr = $hex[$ThermostatAddr] ;
                     push @{$message{text}},                  "ThermostatAddr = $ThermostatAddr" ;
                     &update_modules_info ($message{address}, "ThermostatAddr", $ThermostatAddr) ;
                     $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{ThermostatAddr} = $ThermostatAddr ;
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

            } elsif ( $message{MessageType} eq "E6" ) { # Temperature
               my $temperature = sprintf ("%.2f",&hex_to_temperature($hex[0], $hex[1])) ;

               my $ModuleType = $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} ;
               my $TemperatureChannel = $global{Cons}{ModuleTypes}{$ModuleType}{TemperatureChannel} ;
               &update_modules_channel_info ($message{address}, $TemperatureChannel, "Temperature", $temperature) ;

               $ChannelInfo{$message{address}}{$TemperatureChannel}{Temperature}{Value} = $temperature ;

            } elsif ( $message{MessageType} eq "F0" # Name of channel
                   or $message{MessageType} eq "F1"
                   or $message{MessageType} eq "F2" ) {

               my $hex = shift @hex ;
               my ($dummy,$Channel) = &channel_convert($message{address},$hex,"Name") ;

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
                  my $MemoryKey = &module_find_MemoryKey ($message{address}, $message{ModuleType}) ;

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
                        my ($Channel,$number,$command) = split ":", $global{Cons}{ModuleTypes}{$message{ModuleType}}{Memory}{$MemoryKey}{Address}{$memory}{SensorName} ;

                        if ( $command eq "Start" ) {
                           # Reset our SensorName
                           delete $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{SensorNameAddress}{$Channel} ;
                        }

                        ${$global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{SensorNameAddress}{$Channel}}[$number] = $char if $hex ne "FF" ;

                        if ( $command eq "Save" ) {
                           my $SensorName = join '', @{$global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{SensorNameAddress}{$Channel}} ;
                           &update_modules_channel_info ($message{address}, $Channel, "Name", $SensorName) ;
                           push @{$message{text}}, "SensorName=$SensorName" ;
                        }
                     } elsif ( defined  $global{Cons}{ModuleTypes}{$message{ModuleType}}{Memory}{$MemoryKey}{Address}{$memory}{Unit} ) {
                        my ($Channel,$number,$command) = split ":", $global{Cons}{ModuleTypes}{$message{ModuleType}}{Memory}{$MemoryKey}{Address}{$memory}{Unit} ;

                        if ( $command eq "Start" ) {
                           # Reset our Unit
                           delete $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{UnitAddress}{$Channel} ;
                        }

                        ${$global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{UnitAddress}{$Channel}}[$number] = $char if $hex ne "00" and $hex ne "FF" ;

                        if ( $command eq "Save" ) {
                           my $Unit = join '', @{$global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{UnitAddress}{$Channel}} ;
                           &update_modules_channel_info ($message{address}, $Channel, "Unit", $Unit) ;
                           push @{$message{text}}, "Unit=$Unit" ;
                        }

                     } else {
                        # No type: loop possible Match keys
                        my %MemoryInfo ;
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

                           $MemoryInfo{$Channel}{$SubName} = $Value if defined $Channel and defined $SubName and defined $Value ;
                        }

                        foreach my $Channel (sort keys (%MemoryInfo) ) {
                           foreach my $SubName (sort keys (%{$MemoryInfo{$Channel}}) ) {
                              push @{$message{text}}, "$Channel, $SubName = $MemoryInfo{$Channel}{$SubName}" ;
                              &update_modules_channel_info ($message{address}, $Channel, $SubName, $MemoryInfo{$Channel}{$SubName}) ;
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

                  my $ByteCount = $#hex ; $ByteCount ++ ; # Count the number of hex in the message

                  # Parse the message byte per byte
                  if ( defined $Process{Data}{PerByte} or defined $Process{Data}{"PerByte:$ByteCount"} ) {
                     my $PerByte = "PerByte" ;
                     if ( defined $Process{Data}{"PerByte:$ByteCount"} ) {
                        $PerByte = "PerByte:$ByteCount" ;
                     }

                     my $Channel = "00" ; # Default value
                     if ( defined $Process{Data}{Channel} ) {
                        $Channel = $Process{Data}{Channel} ;
                     }

                     # Search for a name
                     my $Name ;
                     if ( defined $Process{Data}{Name} ) {
                        $Name = $Process{Data}{Name} ;
                     }

                     foreach my $byte (0..8) { # Loop the 8 possible bytes
                        # Only process when there is information about this byte
                        if ( defined $Process{Data}{$PerByte}{$byte} ) {
                           my $bin  = &hex_to_bin ($hex[$byte]) ; # We also need the message in binary format

                           # Search for a name
                           if ( defined $Process{Data}{$PerByte}{$byte}{Name} ) {
                              $Name = $Process{Data}{$PerByte}{$byte}{Name} ;
                           }

                           # Loop the possbile values for the byte
                           foreach my $key (sort keys(%{$Process{Data}{$PerByte}{$byte}{Match}})) {
                              my $BinValue = $bin ; # By default we start with the value in binary
                              my $MatchTxt ; # We set this variable if we have a match

                              # Regular exression is always binary based match
                              if ( $key =~ /^%(.+)$/ ) {
                                 my $regex = $1 ;
                                 # If we have a sub-match in the regex
                                 if ( $regex =~ /\(/ ) {
                                    if ( $bin =~ /$regex/ ) {
                                       $BinValue = $1 ; # Save the match!
                                       $MatchTxt = "regex_bin: $bin =~ $regex, BinValue=$BinValue" ;
                                    }
                                 } else {
                                    if ( $bin =~ /$regex/ ) {
                                       $MatchTxt = "regex_bin: $bin =~ $regex" ;
                                    }
                                 }

                              # The rest is a hex match or a bin match
                              } elsif ( $key eq $hex[$byte] or
                                        $key eq $bin ) {
                                 $MatchTxt = "eq: $key eq $hex[$byte]|$bin" ;
                              }

                              # If we have match, process the information
                              if ( $MatchTxt ) {
                                 my $Value ; # To store the value of the message. This can be data found in the message or stored in {Value}

                                 if ( defined  $Process{Data}{$PerByte}{$byte}{Match}{$key}{Value} ) {
                                    $Value = $Process{Data}{$PerByte}{$byte}{Match}{$key}{Value} ;
                                 }
                                 if ( defined  $Process{Data}{$PerByte}{$byte}{Match}{$key}{Channel} ) {
                                    $Channel = $Process{Data}{$PerByte}{$byte}{Match}{$key}{Channel} ;
                                 }
                                 if ( defined  $Process{Data}{$PerByte}{$byte}{Match}{$key}{Name} ) {
                                    $Name = $Process{Data}{$PerByte}{$byte}{Match}{$key}{Name} ;
                                 }

                                 # Do we have to convert the message
                                 if ( defined $Process{Data}{$PerByte}{$byte}{Match}{$key}{Convert} ) {
                                    # Convert to decimal on the matched part of the bit formatted message
                                    if ( $Process{Data}{$PerByte}{$byte}{Match}{$key}{Convert} eq "Decimal" ) {
                                       $Name = "Decimal" if ! defined $Name ;
                                       $Value = &bin_to_dec ($BinValue) ;
                                       push @{$ChannelInfo{$message{address}}{$Channel}{$Name}{ValueList}}, $Value ;
                                       &log("logger_match","address=$message{address}: byte=$byte, key=$key, Convert eq Decimal") ;
                                    }

                                    # Calculate the temperature from the message
                                    if ( $Process{Data}{$PerByte}{$byte}{Match}{$key}{Convert} eq "Temperature" ) {
                                       $Name = "Temperature" if ! defined $Name ;
                                       $Value = &hex_to_temperature ($hex[$byte]) ;
                                       push @{$ChannelInfo{$message{address}}{$Channel}{$Name}{ValueList}}, $Value ;
                                       &log("logger_match","address=$message{address}: byte=$byte, key=$key, Convert eq Temperature") ;
                                    }

                                    # Simple Counter: first byte is divider + Channel
                                    if ( $Process{Data}{$PerByte}{$byte}{Match}{$key}{Convert} eq "Divider" ) {
                                       $bin =~ /(......)(..)/ ; # The byte contains $Value and $Channel
                                       $Value = $1 ;
                                       $Channel = $2 ;

                                       $Channel = &bin_to_dec($Channel) ; $Channel ++ ;
                                       $Channel = "0" . $Channel if $Channel < 10 ; # This is always true since the channel is 1, 2, 3 or 4

                                       $Value = &bin_to_dec($Value) ;
                                       $Value *= 100 ;

                                       $Name = "Divider" ;
                                       push @{$ChannelInfo{$message{address}}{$Channel}{$Name}{ValueList}}, $Value ;
                                       &log("logger_match","address=$message{address}: byte=$byte, key=$key, Convert eq Divider") ;
                                    }

                                    # Simple Counter
                                    if ( $Process{Data}{$PerByte}{$byte}{Match}{$key}{Convert} eq "Counter" ) {
                                       $Name = "CounterHex" ;
                                       $ChannelInfo{$message{address}}{$Channel}{$Name}{Value} .= $hex[$byte] ; # We have to append the Value for the counter
                                       &log("logger_match","address=$message{address}: byte=$byte, key=$key, Convert eq Counter") ;
                                    }

                                    # Button pressed or Sensor triggered on touch or an other input
                                    if ( $Process{Data}{$PerByte}{$byte}{Match}{$key}{Convert} eq "Channel" ) {
                                       $Channel = $hex[$byte] ;
                                       next if $Channel eq "00" ; # If Channel is 00, that means the byte is useless
                                       ($message{address},$Channel) = &channel_convert($message{address},$Channel,"ConvertChannel") ; # Convert it to a number
                                       if ( $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{ChannelOffset} ) {
                                          $Channel += $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{ChannelOffset} ;
                                       }
                                       $Channel = "0" . $Channel if $Channel < 10 and $Channel !~ /^0/ ;
                                       push @{$ChannelInfo{$message{address}}{$Channel}{$Name}{ValueList}}, $Value if defined $Value ;
                                       &log("logger_match","address=$message{address}: byte=$byte, key=$key, Channel=$Channel, Name=$Name, Value=$Value Convert eq Channel") ;
                                    }

                                    # This is used to convert the status of Channels from a byte format to a status per Channel
                                    # Used in processing ED message of Touch en PIR sensors
                                    # The place in the byte determines the channel and 0=released, 1=pressed
                                    #    00100000 -> CH6 pressed, the rest is released
                                    if ( $Process{Data}{$PerByte}{$byte}{Match}{$key}{Convert} =~ /ChannelBitStatus:(\d)/ ) {
                                       my $Max = $1 ; # The number of bits=channels
                                       my @bin = split //, $bin ;
                                       foreach my $bit (1..$Max) {
                                          my @Channel = (0,0,0,0,0,0,0,0) ;
                                          $Channel[-$bit] = 1 ; # Flip the correct bit, start counting from the right
                                          $Channel = join "", @Channel ;

                                          my $address ;
                                          ($address,$Channel) = &channel_convert($message{address},$Channel,"ChannelBitStatus") ; # Convert it to a number, no &bin_to_hex needed
                                          if ( $bin[$bit] eq "1" ) {
                                             $Value = "ON" ;
                                          } else {
                                             $Value = "OFF" ;
                                          }
                                          &log("logger_match","address=$message{address}: bit=$bit, bin=$bin[$bit], key=$key, Channel=$Channel, Name=$Name, Value=$Value Convert eq ChannelBitStatus") ;
                                          push @{$ChannelInfo{$address}{$Channel}{$Name}{ValueList}}, $Value ;
                                       }
                                    }

                                    # This is a special case were we have multiple channels in 1 byte.
                                    # When a bit is 1, the location determines the channel. so 00001001 -> channel 4 and 1
                                    # This is used for Type=ThermostatChannel
                                    if ( $Process{Data}{$PerByte}{$byte}{Match}{$key}{Convert} eq "ChannelBit" ) {
                                       my @bin = split //, $bin ;
                                       foreach my $bit (0..7) {
                                          if ( $bin[$bit] eq "1" ) {
                                             my @Channel = (0,0,0,0,0,0,0,0) ;
                                             $Channel[$bit] = 1 ; # Flip the correct bit
                                             $Channel = join "", @Channel ;

                                             my $address ;
                                             ($address,$Channel) = &channel_convert($message{address},$Channel,"ChannelBit") ; # Convert it to a number, no &bin_to_hex needed
                                             $Channel += $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{ChannelOffset} ; # Take into count the offset
                                             $Channel = "0" . $Channel if $Channel < 10 and $Channel !~ /^0/ ;
                                             &log("logger_match","address=$message{address}: byte=$byte, key=$key, Channel=$Channel, Name=$Name, Value=$Value Convert eq ChannelBit") ;
                                             push @{$ChannelInfo{$address}{$Channel}{$Name}{ValueList}}, $Value ;
                                          }
                                       }
                                    }

                                 # Do we have a channel?
                                 # TODO: is there a message that we don't have a Channel??
                                 } elsif ( defined $Channel ) {
                                    # TODO What if we don't have a Value?
                                    if ( defined $Process{Data}{$PerByte}{$byte}{Match}{$key}{Value} ) {
                                       $Value = $Process{Data}{$PerByte}{$byte}{Match}{$key}{Value} ;
                                       push @{$ChannelInfo{$message{address}}{$Channel}{$Name}{ValueList}}, $Value ;

                                       # Do we have to update the state in openHAB
                                       if ( defined $Process{Data}{$PerByte}{$byte}{Match}{$key}{openHAB} ) {
                                          $ChannelInfo{$message{address}}{$Channel}{$Name}{openHAB} = $Process{Data}{$PerByte}{$byte}{Match}{$key}{openHAB} ;
                                       }

                                       &log("logger_match","address=$message{address}: key=$key, MatchTxt=$MatchTxt, Value=$Value, Channel=$Channel, Name=$Name") ;
                                    } else {
                                       &log("logger_match","address=$message{address}: key=$key, MatchTxt=$MatchTxt, NO VALUE, Channel=$Channel, Name=$Name") ;
                                    }
                                 } else {
                                    &log("logger_match","address=$message{address}: key=$key, MatchTxt=$MatchTxt, Value=$Value, NO CHANNEL, Name=$Name") ;
                                 }
                              }
                           }
                        }
                     }
                  }

                  # Parse the message in total
                  if ( defined $Process{Data}{PerMessage} ) {
                     if ( $Process{Data}{PerMessage}{Convert} eq "SensorNumber" or
                          $Process{Data}{PerMessage}{Convert} eq "MemoText") {
                        my $hex = shift @hex ;
                        my ($dummy,$Channel) = &channel_convert($message{address},$hex,"SensorNumber") ; # This is useless for MemoText (it has no channel), but needed for SensorNumber

                        # First byte is the start of the text
                        my $start = shift @hex ;
                        $start = &hex_to_dec($start) ;
                        $start *= 1 ;

                        # Start of text so reset the data
                        if ( $start eq "0" ) {
                           delete $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{valueArray}  ;
                           $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{valueStore} = "yes" ;
                        }

                        # Maximum of characters. For now, we have Sensor with 15 and Memo with 63 characters.
                        my $MaxChars ;
                        if ( $Process{Data}{PerMessage}{Convert} eq "SensorNumber" ) {
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
                                 if ( $Process{Data}{PerMessage}{Convert} eq "SensorNumber" ) {
                                    &update_modules_channel_info ($message{address}, $Channel, "SensorNumber", $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{value}) ;
                                    $ChannelInfo{$message{address}}{$Channel}{Sensor}{Value} = $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{value} ;
                                 } else {
                                    $ChannelInfo{$message{address}}{$Channel}{Memo}{Value}   = $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{value} ;
                                 }

                              } else {
                                 my $char = chr hex $hex ;
                                 if ( $Process{Data}{PerMessage}{Convert} eq "SensorNumber" ) {
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
                     if ( $Process{Data}{PerMessage}{Convert} eq "LightSensor" ) {
                        shift @hex ;
                        my $high = shift @hex ;
                        my $low  = shift @hex ;
                        my $LightSensor = &hex_to_dec ($high . $low) ;

                        $ChannelInfo{$message{address}}{'99'}{LightSensor}{Value} = $LightSensor ;
                     }
                  }

               } else {
                  push @{$message{text}}, "No process info for message ($message{Raw}): ModuleType=$message{ModuleType}, MessageType=$message{MessageType}" ;
               }
            }

            # Ok, we have something to process
            if ( %ChannelInfo) {
               #print Dumper \%ChannelInfo ;
               # 1/3: Loop %ChannelInfo and make {Value} if {ValueList} exist
               foreach my $address (sort keys (%ChannelInfo) ) {
                  foreach my $Channel (sort keys (%{$ChannelInfo{$address}}) ) {
                     foreach my $Name (sort keys (%{$ChannelInfo{$address}{$Channel}}) ) {
                        if ( $ChannelInfo{$address}{$Channel}{$Name}{Value}) {
                        } elsif ( $ChannelInfo{$address}{$Channel}{$Name}{ValueList}) {
                           $ChannelInfo{$address}{$Channel}{$Name}{Value} = join ";", @{$ChannelInfo{$address}{$Channel}{$Name}{ValueList}} ;
                        }
                     }
                  }
               }

               # 2/3: Loop %ChannelInfo and process the data
               my %openHAB ; # To store the information that will be pushed to openHAB
               foreach my $address (sort keys (%ChannelInfo) ) {
                  foreach my $ChannelLoop (sort keys (%{$ChannelInfo{$address}}) ) {
                     foreach my $Name (sort keys (%{$ChannelInfo{$address}{$ChannelLoop}}) ) {
                        my $Value = $ChannelInfo{$address}{$ChannelLoop}{$Name}{Value} ;

                        my $Channel ; # This is the 'real' Channel
                        # When we have to update Name=ThermostatChannel, we have to increment the Channel with the TemperatureChannel
                        if ( $Name eq "ThermostatChannel" ) {
                           $Channel = $ChannelLoop + $global{Cons}{ModuleTypes}{$message{ModuleType}}{TemperatureChannel} ;
                        } else {
                           $Channel = $ChannelLoop ;
                        }

                        my $ChannelType = $global{Cons}{ModuleTypes}{$message{ModuleType}}{Channels}{$Channel}{Type} ;
                        my $openHABtext ;

                        # Do some calculations for the Counter and send all related information to openHAB
                        if ( $Name eq "CounterHex" ) {
                           my $CounterRaw = &hex_to_dec ($Value) ; # CounterRaw in decimal
                           my $Counter = $CounterRaw / $ChannelInfo{$address}{$ChannelLoop}{Divider}{Value} ; # Usable Counter

                           push @{$message{text}}, "Ch=".$address."_$Channel: ChannelType=$ChannelType, Name=CounterRaw, Value=$CounterRaw, openHAB=\$Value" ;
                           push @{$message{text}}, "Ch=".$address."_$Channel: ChannelType=$ChannelType, Name=Counter, Value=$Counter, openHAB=\$Value" ;
                           &update_modules_channel_info ($message{address}, $Channel, "CounterRaw", $CounterRaw) ;
                           &update_modules_channel_info ($message{address}, $Channel, "Counter", $Counter) ;
                           $openHAB{$address}{$Channel}{CounterRaw}{Value} = $CounterRaw ;
                           $openHAB{$address}{$Channel}{Counter}{Value}    = $Counter ;

                           # Using the current epoch seconds and the previous value, we can calculate the change per second of the counter
                           if ( defined $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{CounterPrevious}{value} ) { # Only do something if we have a previous value
                              my $time = time ; # Current time in seconds
                              # Number of seconds between now and the previous update of the counter + Counter change
                              my $TimeElapsed    = $time    - $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{CounterPreviousTime}{value} ;
                              my $CounterElapsed = $Counter - $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{CounterPrevious}{value} ;

                              # Make sure we don't divide by 0!
                              if ( $TimeElapsed != 0 ) {
                                 # Calculate counter change
                                 my $CounterCurrent ;
                                 if ( $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{Unit}{value} eq "kWh" ) {
                                    $CounterCurrent = ( $CounterElapsed / $TimeElapsed ) * 1000 * 60 * 60 ; # in kW per hour
                                 } else {
                                    $CounterCurrent = ( $CounterElapsed / $TimeElapsed ) * 60 * 60 ; # For m3 and liter: per hour
                                 }

                                 push @{$message{text}}, "Ch=".$address."_$Channel: ChannelType=$ChannelType, Name=CounterCurrent, Value=$CounterCurrent, openHAB=\$Value" ;
                                 &update_modules_channel_info ($message{address}, $Channel, "CounterCurrent", $CounterCurrent) ;
                                 $openHAB{$address}{$Channel}{CounterCurrent}{Value} = $CounterCurrent ;
                              }
                           }

                           # Remember the counter and epoch seconds
                           $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{CounterPrevious}{value}     = $Counter ;
                           $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{CounterPreviousTime}{value} = time ;

                        # Sensor type of VMB4AN
                        } elsif ( $Name eq "SensorType" ) {
                           push @{$message{text}}, "Ch=".$address."_$Channel: SensorType=$Value" ;
                           &update_modules_channel_info ($message{address}, $Channel, $Name, $Value) ;

                        } else {
                           # For some $Name, we push the Value always to openHAB
                           # Divider: before $ChannelType eq "ButtonCounter" !!!
                           if ( $Name eq "Divider" or
                                $Name eq "Temperature" or
                                $Name eq "ThermostatTarget" ) {
                              $openHAB{$address}{$Channel}{$Name}{Value} = $Value ;
                              $openHABtext .= ", openHAB=\$Value" ;

                           # For a 7IN (=ButtonCounter) we also have to check the Divider value to see if the channel is a button or a counter
                           } elsif ( $ChannelType eq "ButtonCounter" and
                                 defined $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{Divider}{value} and
                                         $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{Divider}{value} ne "Disabled" ) {
                              # Divider is set -> input is NOT a button, but a counter. The data is already processed so do nothing.

                           # This is for $Name = ThermostatCoHeMode | ThermostatMode
                           } elsif ( defined $ChannelInfo{$address}{$ChannelLoop}{$Name}{openHAB} ) {
                              $openHAB{$address}{$Channel}{$Name}{Value} = $ChannelInfo{$address}{$ChannelLoop}{$Name}{openHAB} ;
                              $openHABtext .= ", openHAB=$ChannelInfo{$address}{$ChannelLoop}{$Name}{openHAB}" ;

                           # For some $ChannelType, we push the Value always to openHAB
                           } elsif ( $ChannelType eq "Dimmer" or
                                     $ChannelType eq "Blind" or
                                     $ChannelType eq "SensorNumber" or
                                     $ChannelType eq "LightSensor" or
                                     $ChannelType eq "Relay" ) {
                              $openHAB{$address}{$Channel}{$ChannelType}{Value} = $Value ;
                              $openHABtext .= ", openHAB=\$Value" ;

                           # A Button is tricky: we have to do something on released, but we need to know if it was a short or a long press
                           } elsif ( $ChannelType eq "Button"  or
                                     $ChannelType eq "ButtonCounter" ) {

                              if ( $Value eq "ON" ) {
                                 $openHAB{$address}{$Channel}{Button}{Value} = $Value ;
                                 $openHABtext .= ", openHAB Button=\$Value" ;
                                 # Mhhh, what ButtonLong? We don't know for sure so we don't update it
                              } elsif ( $Value eq "OFF" ) {
                                 $openHAB{$address}{$Channel}{Button}{Value} = $Value ;
                                 $openHABtext .= ", openHAB Button=\$Value" ;
                                 $openHAB{$address}{$Channel}{ButtonLong}{Value} = $Value ;
                                 $openHABtext .= ", openHAB ButtonLong=\$Value" ;
                              } elsif ( $Value eq "released" ) {
                                 if ( $global{openHAB}{ButtonState}{$message{address}}{$Channel} eq "pressed" ) {
                                    # pressed: send ON + OFF
                                    $openHAB{$address}{$Channel}{Button}{Value} = "ON OFF" ;
                                    $openHABtext .= ", openHAB Button=ON OFF" ;
                                 } else {
                                    # longpressed: send OFF
                                    $openHAB{$address}{$Channel}{ButtonLong}{Value} = "OFF" ;
                                    $openHABtext .= ", openHAB ButtonLong=OFF" ;
                                 }
                              } else {
                                 $global{openHAB}{ButtonState}{$message{address}}{$Channel} = $Value ; # remember type: pressed or longpressed
                                 if ( $Value eq "pressed" ) {
                                    # Don't send ON yet, wait for released. Because for a longpressed, there is also a pressed message first
                                 } elsif ( $Value eq "longpressed" ) {
                                    $openHAB{$address}{$Channel}{ButtonLong}{Value} = "ON" ;
                                    $openHABtext .= ", openHAB ButtonLong=ON" ;
                                 }
                              }

                           # A Sensor or ThermostatChannel is almost the same as a Button, except that we don't have longpressed
                           } elsif ( $Name eq "Sensor"  or
                                     $Name eq "ThermostatChannel" ) {

                              my $openHABaddress ;
                              # When we have to update ThermostatChannel, we have to switch to the master addres of the module!!!
                              if ( $Name eq "ThermostatChannel" and defined $global{Vars}{Modules}{SubAddress}{$address}{MasterAddress} ) {
                                 $openHABaddress = $global{Vars}{Modules}{SubAddress}{$address}{MasterAddress} ;
                              } else {
                                 $openHABaddress = $address ;
                              }

                              if ( $Value eq "ON" or
                                   $Value eq "OFF" ) {
                                 $openHAB{$openHABaddress}{$Channel}{$Name}{Value} = $Value ;
                                 $openHABtext .= ", openHAB=\$Value" ;
                              } elsif ( $Value eq "released" ) {
                                 $openHAB{$openHABaddress}{$Channel}{$Name}{Value} = "OFF" ;
                                 $openHABtext .= ", openHAB=OFF" ;
                              } else { # pressed | longpressed
                                 $openHAB{$openHABaddress}{$Channel}{$Name}{Value} = "ON" ;
                                 $openHABtext .= ", openHAB=ON" ;
                              }

                           # Dubbel????
                           #} elsif ( defined $ChannelInfo{$address}{$ChannelLoop}{$Name}{openHAB} ) {
                           #   $openHAB{$address}{$Channel}{$ChannelType}{Value} = $ChannelInfo{$address}{$ChannelLoop}{$Name}{openHAB} ;
                           #   $openHABtext .= ", openHAB=$ChannelInfo{$address}{$ChannelLoop}{$Name}{openHAB}" ;

                           } else {
                              # Store the update in the database
                              &update_modules_channel_info ($message{address}, $Channel, $Name, $Value) ;
                           }

                           push @{$message{text}}, "Ch=".$address."_$Channel: ChannelType=$ChannelType, Name=$Name, Value=$Value$openHABtext" ;
                        }
                     }
                  }
               }

               # 3/3: Post the update to openHAB and store the update in the database.
               if ( %openHAB ) {
                  #print Dumper \%openHAB ;
                  foreach my $address (sort keys (%openHAB) ) {
                     foreach my $Channel (sort keys (%{$openHAB{$address}}) ) {
                        foreach my $Name (sort keys (%{$openHAB{$address}{$Channel}}) ) {
                           my $Sleep = 0 ;
                           # Value can be 'ON OFF' to simulate a button press
                           foreach my $Value (split " ", $openHAB{$address}{$Channel}{$Name}{Value}) {
                              # Store the info in the database
                              &update_modules_channel_info ($address, $Channel, $Name, $Value) ;

                              # Push the info to openHAB
                              my $item = $Name."_".$address."_".$Channel ;
                              &openHAB_update_state ($item, $Value) ;
                              if ( $Sleep > 0 ) {
                                 usleep (20000) ;
                              }
                              $Sleep ++ ;
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }

   my $text = join "\n    ", @{$message{text}} ;

   print         &timestamp . " $message{prio} $message{address}=$message{ModuleType} $message{MessageType}=$message{MessageName}\n    $text\n" ;
   &log("logger",&timestamp . " $message{prio} $message{address}=$message{ModuleType} $message{MessageType}=$message{MessageName}\n    $text") ;

   if ( defined $global{Config}{velbus}{LOGPERADDRESS} ) {
      &log("logger_per_address_$message{address}",&timestamp . " $message{prio} $message{address}=$message{ModuleType} $message{MessageType}=$message{MessageName}\n    $text") ;
   }

   if ( defined $global{Config}{velbus}{LOGPERMODULE} ) {
      &log("logger_per_ModuleType_$message{ModuleType}",&timestamp . " $message{prio} $message{address}=$message{ModuleType} $message{MessageType}=$message{MessageName}\n    $text") ;
   }

   if ( defined $global{Config}{velbus}{ENABLE_RAWMESSAGE_LOGGING} or
        defined $global{Config}{velbus}{LOGRAWMESSAGE} ) {
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
            push @message, $channel ;
         } else {
            ($address,$channel) = &channel_convert($address,$channel,"MakeMessage") ;
            push @message, "0x".$channel ;
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
      $address = "0x".$address ;

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

      if ( defined $global{Cons}{ModuleTypes}{$type}{Memory}{$MemoryKey}{StatusAddress} ) {
         my @memory = split ";", $global{Cons}{ModuleTypes}{$type}{Memory}{$MemoryKey}{StatusAddress} ;
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
      if ( defined $global{Cons}{ModuleTypes}{$type}{AllChannelStatus} ) { # For some modules, using FF means all channels
         $channels[0] = "0x$global{Cons}{ModuleTypes}{$type}{AllChannelStatus}" ;
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
      if ( $global{Cons}{ModuleTypes}{$type}{Messages}{'FA'} ) { # FA = COMMAND_RELAY_STATUS_REQUEST | COMMAND_MODULE_STATUS_REQUEST
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
}

# Convert channel number to channel bit.
#   Channel 3 = 1000 -> 8
# Find the correct sub address for modules with multiple addresses like touch panels
# Parameters:
# 1: address
# 2: channel
# 3: type -> not used, informational
#     - MakeMessage
#     - SimulateButtonPressed
sub channel_convert_OLD () {
   my $address = $_[0] ;
   my $channel = $_[1] ;
   my $type    = $_[2] ;

   my $ModuleType = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} ;

   &log("channel_convert_OLD",&timestamp . " address=$address, channel=$channel, type=$type, ModuleType=$ModuleType") ;

   # We have to rewrite the address based on the channel.
   # This will not work for Type=ThermostatChannel. But since this function is only used when making a message and we never send something to channels with Type=ThermostatChannel, we don't care.

   # When the channel > 8 and we have sub addresses, calculate the correct address and channel
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

   &log("channel_convert_OLD",&timestamp . "    NEW: address=$address, channel=$channel") ;

   # Used:
   #    VMB4AN=32
   if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{ChannelNumbers} and
        defined $global{Cons}{ModuleTypes}{$ModuleType}{ChannelNumbers}{MakeMessage} and
        defined $global{Cons}{ModuleTypes}{$ModuleType}{ChannelNumbers}{MakeMessage}{Convert} and
                $global{Cons}{ModuleTypes}{$ModuleType}{ChannelNumbers}{MakeMessage}{Convert} eq "hex" ) {
      &log("channel_convert_OLD",&timestamp . "    ChannelNumbers MakeMessage Convert = hex") ;
      $channel = &hex_to_dec ($channel) ;
   } else {
      $channel -- ;
      $channel = "1" . "0" x $channel ;
      $channel = &bin_to_hex ($channel) ;
   }

   &log("channel_convert_OLD",&timestamp . "    return: address=$address, channel=$channel") ;

   return ($address,$channel) ;
}

# Used by logger.pl for converting the channel hex value to the correct channel id
# 1: address
# 2: channel
# 3: type:
#     - Name: message that contains the name of a channel
#     - SensorNumber: message AC = transmitting sensor as text
#     - ChannelBit/ChannelBitStatus: channel is in bit!
#     - ConvertChannel: when parsing a message, we have to decode the channel
#     - MakeMessage
#     - SimulateButtonPressed
sub channel_convert () {
   my $address = $_[0] ; # Optional
   my $channel = $_[1] ;
   my $type    = $_[2] ;

   my $ModuleType = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} ;

   &log("channel_convert",&timestamp . " address=$address, channel=$channel, type=$type, ModuleType=$ModuleType") ;

   # If we have a fixed mapping for $ModuleType and $type
   # Used (see Velbus_data_protocol_channels.pm) for:
   #   VMB4AN=32 channel: 9 -> sensor 1 = Ch9, 12 -> sensor 14 = Ch12 ?????
   #   VMB1BL=03 & Name
   #   VMB2BL=09 & Name
   #   touch panels & Name (for temperature channel)
   #   VMBPIRO=2C & Name
   #   VMBMETEO=31 & SensorNumber
   if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{ChannelNumbers} and
        defined $global{Cons}{ModuleTypes}{$ModuleType}{ChannelNumbers}{$type} and
        defined $global{Cons}{ModuleTypes}{$ModuleType}{ChannelNumbers}{$type}{Map} and
        defined $global{Cons}{ModuleTypes}{$ModuleType}{ChannelNumbers}{$type}{Map}{$channel} ) {
      &log("channel_convert",&timestamp . "    ChannelNumbers $type Map") ;
      $channel = $global{Cons}{ModuleTypes}{$ModuleType}{ChannelNumbers}{$type}{Map}{$channel} ;

   # Convert to hex. Used for:
   #   VMBMETEO=31 & Name
   #   VMB4AN=32 & Name
   #   Touch panels & Name
   #   VMB4AN=32 & MakeMessage
   } elsif ( defined $global{Cons}{ModuleTypes}{$ModuleType}{ChannelNumbers} and
             defined $global{Cons}{ModuleTypes}{$ModuleType}{ChannelNumbers}{$type} and
             defined $global{Cons}{ModuleTypes}{$ModuleType}{ChannelNumbers}{$type}{Convert} and
                     $global{Cons}{ModuleTypes}{$ModuleType}{ChannelNumbers}{$type}{Convert} eq "hex" ) {
      &log("channel_convert",&timestamp . "    ChannelNumbers $type Convert = hex") ;
      $channel = &hex_to_dec ($channel) ;

   } else {
      if ( $type eq "Name" ) {
         $channel = &hex_to_bin ($channel) ;
         $channel =~ /(0*)$/ ; # Filter out last 0's
         $channel = ($1 =~ tr/0//); # Count last 0's
         $channel ++ ;

      } elsif ( $type eq "SensorNumber" ) {
         $channel = &hex_to_dec ($channel) ;

      # Channel is already in bit!
      } elsif ( $type eq "ChannelBit" or $type eq "ChannelBitStatus" ) {
         $channel =~ /(0*)$/ ; # Filter out last 0's
         $channel = ($1 =~ tr/0//); # Count last 0's
         $channel ++ ;

      # Button pressed or Sensor triggered
      } elsif ( $type eq "ConvertChannel" ) {
         $channel = &hex_to_bin ($channel) ;
         $channel =~ /(0*)$/ ; # Filter out last 0's
         $channel = ($1 =~ tr/0//); # Count last 0's
         $channel ++ ;

         # If this is a SubAddress, replace the address with the master address and calculate the correct channel.
         if ( defined $global{Vars}{Modules}{SubAddress}{$address} and defined $global{Vars}{Modules}{SubAddress}{$address}{ChannelOffset} ) {
            &log("channel_convert",&timestamp . "    type=$type: address = $global{Vars}{Modules}{SubAddress}{$address}{MasterAddress}, channel += $global{Vars}{Modules}{SubAddress}{$address}{ChannelOffset}") ;
            $channel += $global{Vars}{Modules}{SubAddress}{$address}{ChannelOffset} ; # Before changing the $address!!!!
            $address  = $global{Vars}{Modules}{SubAddress}{$address}{MasterAddress} ;
         }
      
      } elsif ( $type eq "MakeMessage" or $type eq "SimulateButtonPressed" ) {
         # We have to rewrite the address based on the channel.
         # This will not work for Type=ThermostatChannel. But since this function is only used when making a message and we never send something to channels with Type=ThermostatChannel, we don't care.

         # When the channel > 8 and we have sub addresses, calculate the correct address and channel
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

         &log("channel_convert",&timestamp . "    type=$type address=$address, channel=$channel") ;

         $channel -- ;
         $channel = "1" . "0" x $channel ;
         $channel = &bin_to_hex ($channel) ;
      }
   }

   $channel = "0" . $channel if $channel < 10 and $channel !~ /^0/ ;

   &log("channel_convert",&timestamp . "    return: address=$address, channel=$channel") ;

   return ($address,$channel) ;
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
   ($address,$channel) = &channel_convert($address,$channel,"SimulateButtonPressed") ;
   # DATABYTE2 = Channel just pressed
   # DATABYTE3 = Channel just released
   # DATABYTE4 = Channel long pressed
   &send_message ($sock, $address, "00", "", $channel, "00", "00" ) ; # Channel just pressed
   usleep (20000) ;
   &send_message ($sock, $address, "00", "", "00", $channel, "00" ) ; # Channel just released
}

# Simulate a long button press by sending 'Channel just pressed', sleep 20 ms, send 'Channel long pressed', sleep 20 ms, send 'Channel just release'
# 1: socket
# 2: address
# 3: channel
sub button_long_pressed {
   my $sock    = $_[0] ;
   my $address = $_[1] ;
   my $channel = $_[2] ;
   my $value   = $_[3] ;
   ($address,$channel) = &channel_convert($address,$channel,"SimulateButtonPressed") ;
   # DATABYTE2 = Channel just pressed
   # DATABYTE3 = Channel just released
   # DATABYTE4 = Channel long pressed
   &send_message ($sock, $address, "00", "", $channel, "00", "00" ) ; # Channel just pressed
   usleep (20000) ;
   &send_message ($sock, $address, "00", "", "00", "00", $channel ) ; # Channel long pressed
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

# Define a custom color for a palette.
# To be used with edge-lit touch panels.
# 1: socket
# 2: address
# 3: palette: 0 - 31
# 4: brightness
# 5: red
# 6: green
# 7: blue
sub edge_color {
   my$sock       = $_[0] ;
   my $address    = $_[1] ;
   my $palette    = $_[2] ;
   my $brightness = $_[3] ;
   my $red        = $_[4] ;
   my $green      = $_[5] ;
   my $blue       = $_[6] ;

   $palette = &dec_to_hex ($palette) ;
   $brightness = &hex_to_bin (&dec_to_hex ($brightness)) ;
   $brightness =~ s/^./0/g ; # set the first bit to 0 to specify that we want a RGB-color
   $brightness = &bin_to_hex ($brightness) ;

   &send_message ($sock, $address, "D4", undef, $palette, $brightness, $red, $green, $blue) ;

   return "$palette, $brightness, $red, $green, $blue" ;
}

# Set a color on 1 of more edges of an edge-lit touch panel.
# 1: socket
# 2: address
# 3: palette: 0 - 31
# 4: state: 0 | 1 | 2
# 5: edge: LIRB
sub edge_lit {
   my $sock    = $_[0] ;
   my $address = $_[1] ;
   my $palette = $_[2] ;
   my $state   = $_[3] ;
   my $edge    = $_[4] ;

   # background/feedback color
   # xxxxxxx0       do not apply to background color
   # xxxxxxx1       apply to background color
   # xxxxxx0x       do not apply to continuous feedback color
   # xxxxxx1x       apply to continuous feedback color
   # xxxxx0xx       do not apply to slow blinking feedback color
   # xxxxx1xx       apply to slow blinking feedback color
   # xxxx0xxx       do not apply to fast blinking feedback color
   # xxxx1xxx       apply to fast blinking feedback color
   # 0xxxxxxx       Default color palette
   # 1xxxxxxx       Custom color palette
   my $hex2 = &bin_to_hex("11111111") ;

   # Page/edge
   # xxxxxxx0             do not apply to left edge
   # xxxxxxx1             apply to left edge
   # xxxxxx0x             do not apply to top edge
   # xxxxxx1x             apply to top edge
   # xxxxx0xx             do not apply to right edge
   # xxxxx1xx             apply to right edge
   # xxxx0xxx             do not apply to bottom edge
   # xxxx1xxx             apply to bottom edge
   # 1111xxxx             Apply to all button pages (only for feedback light)
   my @hex3bits  = ("1","1","1","1","0","0","0","0") ;
   $hex3bits[7] = "1" if $edge =~ /L/ ;
   $hex3bits[6] = "1" if $edge =~ /T/ ;
   $hex3bits[5] = "1" if $edge =~ /R/ ;
   $hex3bits[4] = "1" if $edge =~ /B/ ;
   my $hex3 = &bin_to_hex (join "", @hex3bits) ;

   # blink/priority/color palette index 
   # 0xxxxxxx         Background not blinking/Feedback not blinking
   # 1xxxxxxx         Background blinking/Feedback blinking
   # x00xxxxx         Default color palette & feedback blinking mode
   # x01xxxxx         Custom color with lowest priority
   # x10xxxxx         Custom color with mid priority
   # x11xxxxx         Custom color with highest priority
   my @hex4bits = ("0","0","0") ; # These are the first 3 bits: not blinking + default color palette
   if ( $state eq "2" ) { # ON
      $hex4bits[1] = "1" ; # Priority
      $hex4bits[2] = "1" ; # Priority
   } elsif ( $state eq "1" ) { # Blink
      $hex4bits[0] = "1" ; # Background blinking/Feedback blinking
      $hex4bits[1] = "1" ; # Priority
      $hex4bits[2] = "1" ; # Priority
   } else { # $state eq "0"
   }
   my $hex4bits = join "", @hex4bits ;

   $palette = &hex_to_bin(&dec_to_hex ($palette)) ;
   $palette =~ s/^...//g ; # We only need the last 5 bits

   $hex4bits .= $palette ; # Add the palette to our bit string
   my $hex4 = &bin_to_hex ($hex4bits) ; # Convert to hex

   &send_message ($sock, $address, "D4", undef, $hex2, $hex3, $hex4) ;
   return "$hex2, $hex3, $hex4" ;
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

   # When we receive CLEAR as text, we send an empty message to clear the LED.
   if ( defined $text and $text eq "CLEAR" ) {
      $text = "" ;
   }
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
