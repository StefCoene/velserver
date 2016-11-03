# process messages on the bus
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

   $message{ModuleType} = "??" ;
   $message{MessageType} ;

   if ( $message{STX} ne "0F" ) { # Only process valid packages
      $message{text} .= "Not a valid packet: STX: $message{STX} != 0F" ;
   } else {
      if ( $message{ETX} ne "04" ) { # Only process valid packages
         $message{text} .= "Not a valid packet: ETX: $message{ETX} != 04" ;
      } else {
         # Prio
         if ( $message{prio} eq "F8" ) {
            $message{prio} = "HI ";
         } elsif ( $message{prio} eq "FB" ) {
            $message{prio} = "lo " ;
         }

         # Parse address and search for Module type
         if ( $message{address} eq "00" ) {
         } else {
            # Searching module type. This will only work when the modules responded to a scan.
            # TODO: when an unknown module is found: trigger a scan
            if ( defined $global{Vars}{Modules}{Address}{$message{address}} and
                         $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} ne '' ) {
                $message{ModuleType} = $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} ;
            }
         }

         # RTR_size = 40 > Scan message
         if ( $message{RTR_size} eq "40" ) {
            $message{text} .= "Scan" ;
            &do_query ($global{dbh},"insert into `modules` (`address`, `status`, `date`) VALUES (?, ?, NOW() ) ON DUPLICATE KEY UPDATE `status`=values(status), `date`=values(date)", $message{address}, "Start scan") ;

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

            if ( $message{MessageType} eq "FF" ) { # Module type: antwoord op Scan
               if ( defined $global{Cons}{ModuleTypes}{$hex[0]}{Type} ) {
                  $message{text} .= "address $message{address}, type = $global{Cons}{ModuleTypes}{$hex[0]}{Type} $global{Cons}{ModuleTypes}{$hex[0]}{Info}  " ;
               } else {
                  $message{text} .= "address $message{address}, type = unknown $hex[0]  " ;
               }
               &do_query ($global{dbh},"insert into `modules` (`address`, `type`, `status`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `type`=values(type), `status`=values(status), `date`=values(date)", $message{address}, $hex[0], "Found") ;
               $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} = $hex[0] ;
               &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, "Serial1", $hex[1]) ;
               &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, "Serial2", $hex[2]) ;
               &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, "BuildYear", $hex[4]) ;
               &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, "BuildWeek", $hex[5]) ;

            } elsif ( $message{MessageType} eq "B0" ) { # Module subtype: antwoord op Scan
               $message{text} .= "address $message{address}, extra info " ;
               &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, "SubAddr1", $hex[3]) if $hex[3] ne "FF" ;
               &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, "SubAddr2", $hex[4]) if $hex[4] ne "FF" ;
               &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, "SubAddr3", $hex[5]) if $hex[5] ne "FF" ;
               &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, "SubAddr4", $hex[6]) if $hex[6] ne "FF" ;

            } elsif ( $message{MessageType} eq "D8" ) { # Realtime clock update
               $message{text} .= "Realtime clock status : " ;
               my $day  = hex ($hex[0]) ;
               my $hour = hex ($hex[1]) ; $hour = "0" . $hour if $hour < 10 ;
               my $min  = hex ($hex[2]) ; $min =  "0" . $min  if $min  < 10 ;
               $message{text} .= "day = $global{Cons}{Days}{$day}, tijd = $hour:$min" ;

            } elsif ( $message{MessageType} eq "B7" ) { # Realtime clock update
               $message{text} .= "Date sync : " ;
               my $day  = hex ($hex[0]) ;
               my $mon  = hex ($hex[1]) ;
               my $year = hex ("$hex[2]$hex[3]") ;
               $message{text} .= "day = $day, month = $mon, year = $year" ;

            } elsif ( $message{MessageType} eq "E6" ) { # Temperature status
               my $temperature = sprintf ("%.2f",&hex_to_temperature($hex[0], $hex[1])) ;
               &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, "Temperature", $temperature) ;
               $message{text} .= "Temperature = $temperature" ;

            # Name of channel
            } elsif ( $message{MessageType} eq "F0"
                   or $message{MessageType} eq "F1" 
                   or $message{MessageType} eq "F2" ) {

               my $channel = shift @hex;
               if ( $message{MessageType} eq "F0" ) {
                  $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$channel}{Name}{value} = "" ;
               }

               foreach my $hex (@hex) {
                  next if $hex eq "FF" ;
                  my $test = chr hex $hex ;
                  $message{text} .= "$test" ;
                  $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$channel}{Name}{value} .= $test ;
               }
               if ( $message{MessageType} eq "F2" ) {
                  if ( defined $message{ModuleType} and 
                       ( ( $message{ModuleType} eq "28" and $channel eq "21" ) or
                         ( $message{ModuleType} eq "20" and $channel eq "09" ) )
                      ) {
                     &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, "TempSensor", $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$channel}{Name}{value}) ;
                  }
                  &do_query ($global{dbh},"insert into `modules_channel_info` (`address`, `channel`, `data`, `value`, `date`) VALUES (?, ?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, $channel, "Name", $global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$channel}{Name}{value}) ;
               }

            } else {
               if ( defined $global{Cons}{ModuleTypes}{$message{ModuleType}} and
                    defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}} and
                    defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data} ) {

                  my $Channel = "00" ;
                  my %info ;
                  foreach my $byte (0..8) { # Loop the 8 possible bytes
                     # Only process when there is a byte
                     if ( defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte} ) {
                        my $bin  = &hex_to_bin ( $hex[$byte] ) ;

                        # Search for a name
                        my $Name ;
                        if ( defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Name} ) {
                           $Name = $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Name} ;
                        }

                        # Loop the possbile values for the byte
                        foreach my $key (sort keys(%{$global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}})) {
                           # Calculate the procent
                           if ( $key eq "Procent" ) {
                              $Name = "Procent" if ! defined $Name ;
                              push @{$info{$Channel}{$Name}}, hex $hex[$byte] ;

                           } elsif ( $key eq "Temperature" ) {
                              $Name = "Temperature" if ! defined $Name ;
                              push @{$info{$Channel}{$Name}}, &hex_to_temperature ($hex[$byte]) ;

                           # Regular exression is always binary based match
                           } elsif ( $key =~ /^%(.+)$/ ) {
                              my $regex = $1 ;
                              if ( $bin =~ /$regex/ ) {
                                 my $SubName ;
                                 if ( defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{Name} ) {
                                    $SubName = $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{Name} ;
                                 }
                                 if ( defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{Channel} ) {
                                    $Channel = $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{Channel} ;
                                 }
                                 if ( defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{Info} ) {
                                    my $Info = $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{Info} ;
                                    push @{$info{$Channel}{$Name}}, $Info ;
                                    push @{$info{$Channel}{$SubName}}, $Info if defined $SubName ;
                                 }
                              }

                           # The rest is a hex match or a bin match
                           } elsif ( $key eq $hex[$byte] or $key eq $bin ) {
                              if ( defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{Channel} ) {
                                 $Channel = $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{Channel} ;
                              }
                              if ( defined $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{Info} ) {
                                 my $Info = $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Data}{$byte}{Match}{$key}{Info} ;
                                 push @{$info{$Channel}{$Name}}, $Info ;
                              }
                           }
                        }  
                     }
                  }

                  #print "\n" ; # Debugging
                  #print Dumper {%info} ; # Debugging

                  # Loop al found info and stored in the database
                  $message{text} .= "\n" ;
                  foreach my $Channel (sort keys (%info) ) {
                     foreach my $Name (sort keys (%{$info{$Channel}}) ) {
                        my $temp = join ";", @{$info{$Channel}{$Name}} ;
                        $message{text} .= "$Channel, $Name = $temp\n ";
                        &do_query ($global{dbh},"insert into `modules_channel_info` (`address`, `channel`, `data`, `value`, `date`) VALUES (?, ?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value), `date`=values(date)", $message{address}, $Channel, $Name, $temp) ;
                     }
                  }
               } else {
                  $message{text} .= "ModuleType = $message{ModuleType},  MessageType=$message{MessageType}: no Data info" ;
               }
            }
         }
      }
   }
   my $date = `date` ; chomp $date ;
   print "$date $message{prio} $message{address}=$message{ModuleType} $message{MessageType} = $message{MessageName} :: $message{text}\n" ;

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

   my @message = ("0x$command", $channel) ;
   &print_sock ($sock,$prio,"0x$address",$rtr,@message) ;
   #usleep (20000) ;
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
         if ( $global{Cons}{ModuleTypes}{$type}{Messages}{'EF'} ) {
            &get_module_info ($sock, $address, $type, $channel, 'EF') ;
         }
         if ( $global{Cons}{ModuleTypes}{$type}{Messages}{'FA'} ) {
            &get_module_info ($sock, $address, $type, $channel, 'FA') ;
         }
      }
   } else {
      if ( $global{Cons}{ModuleTypes}{$type}{Messages}{'EF'} ) {
         if ( $type eq "28" or
              $type eq "20" ) { # Touch met OLED: channel FF will request the names of all channels
            &get_module_info ($sock, $address, $type, '0xFF', 'EF') ;
         } else {
            &get_module_info ($sock, $address, $type, '', 'EF') ;
         }
      }
      if ( $global{Cons}{ModuleTypes}{$type}{Messages}{'FA'} ) {
         &get_module_info ($sock, $address, $type, '', 'FA') ;
      }
   }

   if ( ( $type eq "1D" ) or # Blind
        ( $type eq "10" ) or # Relay
        ( $type eq "11" ) or # Relay
        ( $type eq "12" ) ) { # Dimmer
   } 

   if ( $type eq "28" ) { # Touch
   }

   return $output ;
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

sub set_dim_value {
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
