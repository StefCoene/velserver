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
      $message{text} .= "Not a valid packet: STX: $message{STX} != 0F" ;
   } elsif ( $message{ETX} ne "04" ) { # Only process valid packages
      $message{text} .= "Not a valid packet: ETX: $message{ETX} != 04" ;
   } else {
      # Prio
      if ( $message{prio} eq "F8" ) {
         $message{prio} = "HI ";
      } elsif ( $message{prio} eq "FB" ) {
         $message{prio} = "lo " ;
      }

      # Parse address and search for Module type.
      # If the address is 00 we have a broadcast message and so we don't have a module type
      if ( $message{address} eq "00" ) {
      } else {
         # Searching module type. This will only work when the modules responded to a scan.
         # TODO: when an unknown module is found: trigger a scan
         if ( defined $global{Vars}{Modules}{Address}{$message{address}} and
                      $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} ne '' ) {
            $message{addressMaster} = $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{address} ; # This is the master address, used for a VMBGPOD because it has sub addresses. We use this when updating the mysql DB.
            $message{ModuleType}    = $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} ;
         } else {
            $message{addressMaster} = $message{address} ;
         }
      }

      # RTR_size = 40 > Scan message
      if ( $message{RTR_size} eq "40" ) {
         $message{text} .= "Scan" ;
         my $sql = "insert into `modules` (`address`, `status`, `date`) VALUES (?, ?, NOW() ) ON DUPLICATE KEY UPDATE `status`=values(status), `date`=values(date)" ;
         &do_query ($global{dbh},$sql, $message{address}, "Start scan") ;
         $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{address} = $message{address} ;

      } else {
         $message{MessageType} = shift @hex ;

         # Print message type and hex and if found, print the Name.
         # This depends if it's a broadcast message or not.
         # It also depends on the type of module.
         $message{MessageName} .= "Unknown" ;
         if ( $message{address} eq "00" ) {
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

         if ( $message{MessageType} eq "FF" ) { # Module type: answer to a Scan
            if ( defined $global{Cons}{ModuleTypes}{$hex[0]}{Type} ) {
               $message{text} .= "address $message{address}, type = $global{Cons}{ModuleTypes}{$hex[0]}{Type} $global{Cons}{ModuleTypes}{$hex[0]}{Info}" ;
            } else {
               $message{text} .= "address $message{address}, type = unknown $hex[0]" ;
            }
            &do_query ($global{dbh},"insert into `modules` (`address`, `type`, `status`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `type`=values(type), `status`=values(status), `date`=values(date)", $message{addressMaster}, $hex[0], "Found") ;
            &log("mysql","module found: address=$message{address}, type=$hex[0]") ;
            $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} = $hex[0] ;
            &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, "Serial1", $hex[1]) ;
            &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, "Serial2", $hex[2]) ;
            &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, "MemoryMap", $hex[3]) ;
            &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, "BuildYear", $hex[4]) ;
            &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, "BuildWeek", $hex[5]) ;
            &log("mysql","module info: address=$message{address}, Serial1=$hex[1], Serial2=$hex[2], MemoryMap=$hex[3], BuildYear=$hex[4], BuildWeek=$hex[5]") ;

         } elsif ( $message{MessageType} eq "B0" ) { # Module subtype: answer to a Scan
            $message{text} .= "address $message{address}, extra info" ;
            if ( defined $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} ) {
               # The touch modules have a special address for the temperature sensor
               if ( $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} eq "28" ) { # VMBGPOD
                  &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, "TemperatureAddr", $hex[6]) ;
                  &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, "SubAddr1", $hex[3]) ;
                  &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, "SubAddr2", $hex[4]) ;
                  &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, "SubAddr3", $hex[5]) ;
                  &log("mysql","module info: address=$message{address}, TemperatureAddr=$hex[6]") ;
                  &log("mysql","module info: address=$message{address}, SubAddr1=$hex[3], SubAddr2=$hex[4], SubAddr3=$hex[5]") ;
               }

               if ( ( $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} eq "1E" ) or # VMBGP1D
                    ( $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} eq "1F" ) or # VMBGP2D
                    ( $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} eq "20" ) ) { # VMBGP4D
                  &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, "TemperatureAddr", $hex[3]) ;
                  &log("mysql","module info: address=$message{address}, TemperatureAddr=$hex[3]") ;
               }
            }

         } elsif ( $message{MessageType} eq "D8" ) { # Realtime clock update
            $message{text} .= "Realtime clock status:" ;
            my $day  = hex ($hex[0]) ;
            my $hour = hex ($hex[1]) ; $hour = "0" . $hour if $hour < 10 ;
            my $min  = hex ($hex[2]) ; $min =  "0" . $min  if $min  < 10 ;
            $message{text} .= " day = $global{Cons}{Days}{$day}, tijd = $hour:$min" ;

         } elsif ( $message{MessageType} eq "B7" ) { # Realtime clock update
            $message{text} .= "Date sync:" ;
            my $day  = hex ($hex[0]) ;
            my $mon  = hex ($hex[1]) ;
            my $year = hex ("$hex[2]$hex[3]") ;
            $message{text} .= " day = $day, month = $mon, year = $year" ;

         } elsif ( $message{MessageType} eq "E6" ) { # Temperature status
            my $temperature = sprintf ("%.2f",&hex_to_temperature($hex[0], $hex[1])) ;
            &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, "Temperature", $temperature) ;
            &log("mysql","module data: address=$message{address}, Temperature=$temperature") ;
            $message{text} .= "Temperature = $temperature" ;
            &openHAB_update_state ("Temperature_$message{addressMaster}", $temperature) ;

         # Name of channel
         } elsif ( $message{MessageType} eq "F0"
                or $message{MessageType} eq "F1" 
                or $message{MessageType} eq "F2" ) {

            my $hex = shift @hex ;
            my $Channel = &channel_id_to_number($hex,$message{ModuleType}) ;

            if ( $message{MessageType} eq "F0" ) {
               $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{Name}{value} = "" ; # Reset the name
            }

            foreach my $hex (@hex) {
               next if $hex eq "FF" ;
               my $test = chr hex $hex ;
               $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{Name}{value} .= $test ; # Append the name
            }

            if ( $message{MessageType} eq "F2" ) {
               if ( defined $message{ModuleType} and 
                    ( ( $message{ModuleType} eq "1E" and $Channel eq "09" ) or
                      ( $message{ModuleType} eq "1F" and $Channel eq "09" ) or
                      ( $message{ModuleType} eq "20" and $Channel eq "09" ) or
                      ( $message{ModuleType} eq "28" and $Channel eq "33" ) )
                   ) {
                     # Channel 21 (and channel 03/05/09 (VMBGP1D/VMBGP2D/VMBGP4D) are virtual channels whose name is the temperature sensor name of the touch display.
                     &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, "TempSensor", $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{Name}{value}) ;
                     &log("mysql","module TempSensor: address=$message{address}, TempSensor=$global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{Name}{value}") ;
               }
               &do_query ($global{dbh},"insert into `modules_channel_info` (`address`, `channel`, `data`, `value`, `date`) VALUES (?, ?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, $Channel, "Name", $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{Name}{value}) ;
               &log("mysql","module channel name: address=$message{address}, Channel=$Channel, name=$global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{Name}{value}") ;
               $message{text} .= "Channel $Channel name = $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{Name}{value}" ;
            }

         } else {
            # If we have process information for this module type and message, process the message
            if ( defined $global{Cons}{ModuleTypes}{$message{ModuleType}} and
                 defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}} and
                 defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data} ) {

               my %info ;
               my %openHAB_update_state ;

               my $Channel = "00" ;

               foreach my $byte (0..8) { # Loop the 8 possible bytes
                  # Only process when there is information about this byte
                  if ( defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte} ) {
                     my $bin  = &hex_to_bin ($hex[$byte]) ; # We also need the message in binary format

                     # Search for a name
                     my $Name ;
                     if ( defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Name} ) {
                        $Name = $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Name} ;
                     }

                     # Loop the possbile values for the byte
                     foreach my $key (sort keys(%{$global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}})) {
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

                           if ( defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{Info} ) {
                              $Value = $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{Info} ;
                           }
                           if ( defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{Channel} ) {
                              $Channel = $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{Channel} ;
                           }
                           if ( defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{Name} ) {
                              $SubName = $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{Name} ;
                           }

                           # Do we have to convert the message
                           if ( defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{Convert} ) {
                              # Calculate the procent
                              if ( $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{Convert} eq "Procent" ) {
                                 $Name = "Procent" if ! defined $Name ;
                                 $Value = hex $hex[$byte] ;
                              }

                              # Calculate the temperature from the message
                              if ( $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{Convert} eq "Temperature" ) {
                                 $Name = "Temperature" if ! defined $Name ;
                                 $Value = &hex_to_temperature ($hex[$byte]) ;
                              }

                              # Simple Counter: first byte is divider + Channel
                              if ( $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{Convert} eq "Divider" ) {
                                 $bin =~ /(......)(..)/ ;
                                 $Channel = $2 ;
                                 $Divider = $1 ;

                                 $Channel = &bin_to_hex($Channel) ; $Channel ++ ;
                                 $Channel = "0" . $Channel if $Channel =~ /^.$/ ;
                                 $Divider = &bin_to_dec($Divider) ;
                                 $Divider *= 100 ;
                                 $info{$Channel}{Divider} = $Divider ;
                                 $Name = "Counter" if ! defined $Name ;
                              }

                              # Simple Counter
                              if ( $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{Convert} eq "Counter" ) {
                                 $info{$Channel}{Counter} .= $hex[$byte] ;
                              }

                              # Button pressed on touch or an other input
                              if ( $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{Convert} eq "Channel" ) {

                                 $Channel = $hex[$byte] ;
                                 next if $Channel eq "00" ; # If Channel is 00, that means the byte is useless
                                 $Channel = &channel_id_to_number ($Channel) ; # Convert it to a number
                                 $Channel += $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{SubAddrMulti} if defined $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{SubAddrMulti} ; # If the button is on a sub address (from a VMBGPOD), add the sub address ofset to the channel
                                 $info{$Channel}{Button} = $Value ;
                              }
                           }

                           # Do we have to update the state in openHAB
                           if ( defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{openHAB} ) {
                              my $openHAB = $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{openHAB} ; # Handier var

                              if ( $openHAB =~ "(.+):Button" ) { # A Button is tricky: we have to do something on RELEASED, but we need to know if it was a short or a long predd
                                 my $action = $1 ;
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

               #print "\n" ; # Debugging
               #print Dumper {%info} ; # Debugging

               # Loop all found info and store in the database
               $message{text} .= "\n" ;
               foreach my $Channel (sort keys (%info) ) {
                  foreach my $Name (sort keys (%{$info{$Channel}}) ) {
                     if ( $info{$Channel}{$Name}{List}) {
                        my $temp = join ";", @{$info{$Channel}{$Name}{List}} ;
                        $message{text} .= "  $Channel, $Name = $temp\n" ;
                        &do_query ($global{dbh},"insert into `modules_channel_info` (`address`, `channel`, `data`, `value`, `date`) VALUES (?, ?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{addressMaster}, $Channel, $Name, $temp) ;
                        &log("mysql","module channel info: address=$message{address}, addressMaster=$message{addressMaster}, Channel=$Channel, $Name=$temp") ;
                     } elsif ( $Name eq "Divider" ) {
                        $openHAB_update_state{"Divider_$message{addressMaster}_$Channel"} = $info{$Channel}{Divider} ;
                     } elsif ( $Name eq "Counter" ) {
                        my $CounterRaw = &hex_to_dec ($info{$Channel}{Counter}) ;
                        my $Counter = $CounterRaw / $info{$Channel}{Divider} ;
                        $message{text} .= "  $Channel, Counter = $Counter, CounterRaw = $CounterRaw\n" ;
                        $openHAB_update_state{"Counter_$message{addressMaster}_$Channel"} = $Counter ;
                        &do_query ($global{dbh},"insert into `modules_channel_info` (`address`, `channel`, `data`, `value`, `date`) VALUES (?, ?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{addressMaster}, $Channel, "Counter", $Counter) ;
                        &log("mysql","module channel name: address=$message{address}, addressMaster=$message{addressMaster}, Channel=$Channel, Counter=$Counter") ;
                        &do_query ($global{dbh},"insert into `modules_channel_info` (`address`, `channel`, `data`, `value`, `date`) VALUES (?, ?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{addressMaster}, $Channel, "CounterRaw", $CounterRaw) ;
                        &log("mysql","module channel name: address=$message{address}, addressMaster=$message{addressMaster}, Channel=$Channel, CounterRaw=$CounterRaw") ;
                        $openHAB_update_state{"CounterRaw_$message{addressMaster}_$Channel"} = $CounterRaw ;
                     } else {
                        $message{text} .= "  $Channel, $Name = $info{$Channel}{$Name}\n" ;
                        &do_query ($global{dbh},"insert into `modules_channel_info` (`address`, `channel`, `data`, `value`, `date`) VALUES (?, ?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{addressMaster}, $Channel, $Name, $info{$Channel}{$Name}) ;
                        &log("mysql","module channel name: address=$message{address}, addressMaster=$message{addressMaster}, Channel=$Channel, $Name=$info{$Channel}{$Name}") ;
                     }
                  }
               }

               # Post the updates to openHAB.
               # This must be done AFTER the mysql updates
               foreach my $key (keys %openHAB_update_state) {
                  foreach my $state (split " ", $openHAB_update_state{$key} ) {
                     &openHAB_update_state ($key, $state) ;
                  }
               }

            } else {
               my $temp = join " ", @hex ;
               $message{text} .= "no Data info for message $temp" ;
            }
         }
      }
   }

   my $date = `date` ; chomp $date ; # Get a date stamp
   print "$date $message{prio} $message{address}($message{addressMaster})=$message{ModuleType} $message{MessageType}=$message{MessageName} :: $message{text}\n" ;

   &do_query ($global{dbh},"insert into `messages` (`date`, `raw`, `address`, `prio`, `type`, `rtr_size`) VALUES (NOW(), ?, ?, ?, ?, ? )", $message{Raw}, $message{address}, $message{prio}, $message{MessageType}, $message{RTR_size}) ;
}

# Query status of module
# 1: socket
# 2: address
# 3: module type
sub get_module_info () {
   my $sock    = $_[0] ;
   my $address = $_[1] ;
   my $type    = $_[2] ;
   my $channel = $_[3] ;
   my $command = $_[4] ;

   my $prio ;
   if ( defined $global{Cons}{ModuleTypes}{$type}{Messages}{$command}{Priority} and
                $global{Cons}{ModuleTypes}{$type}{Messages}{$command}{Priority} =~ /High/i ) {
      $prio    = "0xF8" ;
   } else {
      $prio    = "0xFB" ;
   }

   $rtr     = "0x00" ;

   $channel = &channel_number_to_id ($channel,$type) ;
   my @message = ("0x$command", $channel) ;
   &print_sock ($sock,$prio,"0x$address",$rtr,@message) ;
   usleep (50000) ;
}

# Get status and name
# 
# 1: socket
# 2: address
# 3: module type
# 4: channel (optional)
sub get_status () {
   my $sock    = $_[0] ;
   my $address = $_[1] ;
   my $type    = $_[2] ;
   my $channel = $_[3] ; # Optional

   my $output ;
   if ( defined $channel ) {
      $output .= "address = $address, type = $type, channel = $channel<br>\n" ;
   } else {
      $output .= "address = $address, type = $type<br>\n" ;
   }

   # Getting a list of possible channels of the specific module
   my @channels ;
   if ( defined $channel ) {
      $channels[0] = $channel ;
   } elsif ( defined $global{Cons}{ModuleTypes}{$type}{Channels} ) {
      @channels = sort keys %{$global{Cons}{ModuleTypes}{$type}{Channels}} ;
   }
   if ( @channels ) {
      foreach my $channel (@channels) {
         if ( $global{Cons}{ModuleTypes}{$type}{Messages}{'EF'} ) { # EF = COMMAND_CHANNEL_NAME_REQUEST
            &get_module_info ($sock, $address, $type, $channel, 'EF') ;
         }
         if ( $global{Cons}{ModuleTypes}{$type}{Messages}{'FA'} ) { # FA = COMMAND_RELAY_STATUS_REQUEST
            &get_module_info ($sock, $address, $type, $channel, 'FA') ;
         }
      }
   } else {
      if ( $global{Cons}{ModuleTypes}{$type}{Messages}{'EF'} ) { # EF = COMMAND_CHANNEL_NAME_REQUEST
         if ( $type eq "1E" or
              $type eq "1F" or
              $type eq "20" or
              $type eq "28" ) { # Touch with OLED + VMBGP1D/VMBGP2D/VMBGP4D: channel FF will request the names of all channels
            &get_module_info ($sock, $address, $type, '0xFF', 'EF') ;
         } else {
            &get_module_info ($sock, $address, $type, '', 'EF') ;
         }
      }
      if ( $global{Cons}{ModuleTypes}{$type}{Messages}{'FA'} ) { # FA = COMMAND_RELAY_STATUS_REQUEST
         &get_module_info ($sock, $address, $type, '', 'FA') ;
      }
   }

   return $output ;
}

# Convert channel number to channel bit. 3 = 1000 -> 8
# Used by commands.pl & scripts
sub channel_number_to_id () {
   my $channel = $_[0] ;
   my $type    = $_[1] ;
   if ( defined $global{Cons}{ModuleTypes}{$type}{ChannelNaming} and
                $global{Cons}{ModuleTypes}{$type}{ChannelNaming} eq "dec" ) {
   } else {
      $channel -- ;
      my $test = "1" . "0" x $channel ;
      $channel = &bin_to_dec ($test) ;
   }
   return $channel ;
}

# Convert channnel bit to channel number. 8 -> 1000 = 3
# Used by logger.pl
sub channel_id_to_number () {
   my $channel = $_[0] ;
   my $type    = $_[1] ; # Optional
   #print "IN  $channel $type\n" ;
   if ( defined $type and
        defined $global{Cons}{ModuleTypes}{$type}{ChannelNaming} and
                $global{Cons}{ModuleTypes}{$type}{ChannelNaming} eq "dec" ) {
      $channel = &hex_to_dec ($channel) ;
   } else {
      $channel = &hex_to_bin ($channel) ;
      $channel =~ /(0*)$/ ; # Filter out last 0's
      $channel = ($1 =~ tr/0//); # Count last 0's
      $channel ++ ;
   }
   $channel = "0" . $channel if $channel < 10 ;
   #print "OUT $channel $type\n" ;
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

sub button_set {
   my $sock = $_[0] ;
   # Dimmer: 0x04 = channel 3, 0x1A = 26%
   my $address = "0x" . $_[1] ;
   my $channel = "0x" . $_[2] ;
   my $value   = $_[3] ;
   my $prio    = "0xF8"; # High
   my $rtr     = "0x00";

   if ( $value eq "ON" ) {
      # DATABYTE2 = Channel just pressed
      # DATABYTE3 = Channel just released
      # DATABYTE4 = Channel long pressed
      @message = ("0x00", "$channel", "0x00", "0x00") ; # COMMAND_PUSH_BUTTON_STATUS
      &print_sock ($sock,$prio,$address,$rtr,@message) ;
      @message = ("0x00", "0x00", "$channel", "0x00") ; # COMMAND_PUSH_BUTTON_STATUS
      &print_sock ($sock,$prio,$address,$rtr,@message) ;
   }
}

sub dim_value {
   my $sock = $_[0] ;
   # Dimmer: 0x04 = channel 3, 0x1A = 26%
   my $address = "0x" . $_[1] ;
   my $channel = "0x" . $_[2] ;
   my $value   = $_[3] ;
   my $prio    = "0xF8"; # High
   my $rtr     = "0x00";

   $value = sprintf ("%02X",$value) ;

   @message = ("0x07", "$channel", "0x$value", "0x00", "0x00") ; # COMMAND_SET_DIMVALUE
   &print_sock ($sock,$prio,$address,$rtr,@message) ;
}

sub relay_off {
   my $sock = $_[0] ;
   my $address = "0x" . $_[1] ;
   my $channel = "0x" . $_[2] ;
   my $prio    = "0xF8"; # High
   my $rtr     = "0x00";

   @message = ("0x01", "$channel") ; # COMMAND_SWITCH_RELAY_OFF
   &print_sock ($sock,$prio,$address,$rtr,@message) ;
}

sub relay_on {
   my $sock = $_[0] ;
   my $address = "0x" . $_[1] ;
   my $channel = "0x" . $_[2] ;
   my $prio    = "0xF8"; # High
   my $rtr     = "0x00";

   @message = ("0x02", "$channel") ; # COMMAND_SWITCH_RELAY_ON
   &print_sock ($sock,$prio,$address,$rtr,@message) ;
}

sub blind_stop {
   my $sock = $_[0] ;
   my $address = "0x" . $_[1] ;
   my $channel = "0x" . $_[2] ;
   my $prio    = "0xF8"; # High
   my $rtr     = "0x00";

   @message = ("0x04", "$channel") ; # COMMAND_BLIND_OFF
   &print_sock ($sock,$prio,$address,$rtr,@message) ;
}

sub blind_up {
   my $sock = $_[0] ;
   my $address = "0x" . $_[1] ;
   my $channel = "0x" . $_[2] ;
   my $prio    = "0xF8"; # High
   my $rtr     = "0x00";

   @message = ("0x05", "$channel", "0x00", "0x00", "0x00") ; # COMMAND_BLIND_UP
   &print_sock ($sock,$prio,$address,$rtr,@message) ;
}

sub blind_down {
   my $sock = $_[0] ;
   my $address = "0x" . $_[1] ;
   my $channel = "0x" . $_[2] ;
   my $prio    = "0xF8"; # High
   my $rtr     = "0x00";

   @message = ("0x06", "$channel", "0x00", "0x00", "0x00") ; # COMMAND_BLIND_DOWN
   &print_sock ($sock,$prio,$address,$rtr,@message) ;
}

sub blind_pos {
   my $sock = $_[0] ;
   my $address  = "0x" . $_[1] ;
   my $channel  = "0x" . $_[2] ;
   my $position = $_[3] ;
   my $prio    = "0xF8"; # High
   my $rtr     = "0x00";

   $position = sprintf ("%02X",$position) ;

   @message = ("0x1C", "$channel", "0x$position") ; # COMMAND_BLIND_POSN
   &print_sock ($sock,$prio,$address,$rtr,@message) ;
}

sub set_temperature {
   my $sock = $_[0] ;
   my $address = "0x" . $_[1] ;
   my $temperature = $_[2] ;
   $temperature = &temperature_to_hex ($temperature) ;

   $prio    = "0xFB"; # Low
   $rtr     = "0x00";
   @message = ("0xE4", "0x00", "0x$temperature") ;
   &print_sock ($sock,$prio,$address,$rtr,@message) ;
}

sub set_temperature_mode {
   my $sock = $_[0] ;
   # COMMAND_SWITCH_TO_COMFORT_MODE (DB) = 1
   # COMMAND_SWITCH_TO_DAY_MODE     (DC) = 2
   # COMMAND_SWITCH_TO_NIGHT_MODE   (DD) = 3
   # COMMAND_SWITCH_TO_SAFE_MODE    (DE) = 4
   my $address = "0x" . $_[1] ;
   my $mode = $_[2] ;

   if ( $mode =~ /1/ ) {
      $mode = "DB" ;
   } elsif ( $mode =~ /2/ ) {
      $mode = "DC" ;
   } elsif ( $mode =~ /3/ ) {
      $mode = "DD" ;
   } elsif ( $mode =~ /4/ ) {
      $mode = "DE" ;
   }
   $prio    = "0xFB"; # Low
   $rtr     = "0x00";
   @message = ("0x$mode", "0x00", "0x00") ;
   &print_sock ($sock,$prio,$address,$rtr,@message) ;
}

sub test () {
   my $sock = $_[0] ;
   $address = "0x36";
   $prio    = "0xF8"; # High
   $prio    = "0xFB"; # Low
   $rtr     = "0x00";
   @message = ("0xDC", "0x00", "0x00") ;
   &print_sock ($sock,$prio,$address,$rtr,@message) ;
}

# Query the temp of a touch
# Never used
sub query_temperature () {
   my $sock = $_[0] ;
   my $address = $_[1] ;
   $prio    = "0xFB";
   $rtr     = "0x00";
   @message = ("0xE5", "0x00") ;
   &print_sock ($sock,$prio,$address,$rtr,@message) ;
}

sub scan () {
   my $sock = $_[0] ;
   foreach my $addr (1..255) {
      &print_sock ($sock,"0xFB","$addr","0x40") ;
      usleep (20000) ;
   }
}

sub broadcast_datetime () {
   my $sock = $_[0] ;

   ($global{Tijd}{sec},$global{Tijd}{min},$global{Tijd}{hour},$global{Tijd}{mday},$global{Tijd}{mon},$global{Tijd}{year},$global{Tijd}{wday},$global{Tijd}{yday},$global{Tijd}{isdst}) = localtime(time) ;

   # For Velbus is 0 = monday, but in perl 0 = synday
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
