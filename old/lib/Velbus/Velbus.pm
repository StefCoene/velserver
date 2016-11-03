# process messages on the bus
sub process_message {
   my @hex = @_ ;

   my $STX  = shift @hex ;
   my $prio = shift @hex ;
   my $address = shift @hex ;
   my $ETX      = pop @hex ;
   my $checksum = pop @hex ;

   if ( $STX eq "0F" ) {
      if ( $ETX eq "04" ) { # Only process valid packages
         my $date = `date` ; chomp $date ;
         print "$date  " ;
         if ( $prio eq "F8" ) {
            print "HI ";
         } elsif ( $prio eq "FB" ) {
            print "lo " ;
         } else {
            print "$prio " ;
         }

         # Searching module type. This will only work when the modules responded to a scan.
         # TODO: when an unknown module is found: trigger a scan
         my $ModuleType = ".." ;
         if ( defined $global{Vars}{Modules}{Address}{$address} and
                      $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} ne '' ) {
            $ModuleType = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type}
         }
         print "$address = $ModuleType : " ;

         my $RTR_size = shift @hex ;

         if ( $RTR_size eq "40" ) {
            print "Scan" ;
            &do_query ($global{dbh},"insert into `modules` (`address`, `status`, `date`) VALUES (?, ?, NOW() ) ON DUPLICATE KEY UPDATE `status`=values(status)", $address, "Start scan") ;

         } else {
            my $MessageType = shift @hex ;
            my $message     = join " ", @hex ;


            &do_query ($global{dbh},"insert into `messages` (`date`, `address`, `prio`, `type`, `rtr_size`, `raw`) VALUES (NOW(), ?, ?, ?, ?, ? )", $address, $prio, $MessageType, $RTR_size, $message) ;

            if ( defined $global{Cons}{ModuleTypes}{$ModuleType} and
                 defined $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$MessageType} and
                 defined $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$MessageType}{Name} ) {
               print "$MessageType ($global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$MessageType}{Name}) :: " ;
            } else {
               print "$MessageType (Unknown) :: " ;
            }

            print "$message : " ;

            if ( $MessageType eq "FF" ) { # Module type: antwoord op Scan
               if ( defined $global{Cons}{ModuleTypes}{$hex[0]}{Type} ) {
                  print "address $address, type = $global{Cons}{ModuleTypes}{$hex[0]}{Type} $global{Cons}{ModuleTypes}{$hex[0]}{Info}  " ;
               } else {
                  print "address $address, type = unknown $hex[0]  " ;
               }
               &do_query ($global{dbh},"insert into `modules` (`address`, `type`, `status`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `type`=values(type), `status`=values(status)", $address, $hex[0], "Found") ;
               $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} = $hex[0] ;
               &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value)", $address, "Serial1", $hex[1]) ;
               &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value)", $address, "Serial2", $hex[2]) ;
               &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value)", $address, "BuildYear", $hex[4]) ;
               &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value)", $address, "BuildWeek", $hex[5]) ;

            } elsif ( $MessageType eq "B0" ) { # Module subtype: antwoord op Scan
               print "address $address, extra info " ;
               &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value)", $address, "SubAddr1", $hex[3]) if $hex[3] ne "FF" ;
               &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value)", $address, "SubAddr2", $hex[4]) if $hex[4] ne "FF" ;
               &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value)", $address, "SubAddr3", $hex[5]) if $hex[5] ne "FF" ;
               &do_query ($global{dbh},"insert into `modules_info` (`address`, `data`, `value`, `date`) VALUES (?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value)", $address, "SubAddr4", $hex[6]) if $hex[6] ne "FF" ;

            } elsif ( $MessageType eq "D8" ) {
               print "Realtime clock status : " ;
               my $dag = hex ($hex[0]) ;
               my $uur = hex ($hex[1]) ; $uur = "0" . $uur if $uur < 10 ;
               my $min = hex ($hex[2]) ; $min = "0" . $min if $min < 10 ;
               print "dag = $global{Cons}{Days}{$dag}, tijd = $uur:$min" ;

            } elsif ( $MessageType eq "B7" ) {
               print "Date sync : " ;
               my $dag = hex ($hex[0]) ;
               my $maa = hex ($hex[1]) ;
               my $jaar = hex ("$hex[2]$hex[3]") ;
               print "dag = $dag, maand = $maa, jaar = $jaar" ;

            } elsif ( $MessageType eq "E6" ) { # Temperature status
               my $temperature = sprintf ("%.2f",&temperature($hex[0], $hex[1])) ;
               print "Temperature = $temperature" ;

            # Name of channel
            } elsif ( $MessageType eq "F0"
                   or $MessageType eq "F1" 
                   or $MessageType eq "F2" ) {

               my $channel = shift @hex;
               if ( $MessageType eq "F0" ) {
                  $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$channel}{name} = "" ;
#print "\nSCNE address = $address, channel = $channel, name = RESET\n" ;
               }

               foreach my $hex (@hex) {
                  next if $hex eq "FF" ;
                  my $test = chr hex $hex ;
                  print "$test" ;
                  $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$channel}{name} .= $test ;
#print "\nSCNE address = $address, channel = $channel, name = $test = $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$channel}{name}\n" ;
               }
               if ( $MessageType eq "F2" ) {
#print "\nSCNE address = $address, channel = $channel, SAVE = $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$channel}{name}\n" ;
                  &do_query ($global{dbh},"insert into `modules_channel_info` (`address`, `channel`, `data`, `value`, `date`) VALUES (?, ?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value)", $address, $channel, "name", $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$channel}{name}) ;
               }

            } else {
               if ( defined $global{Cons}{ModuleTypes}{$ModuleType} and
                  defined $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$MessageType} and
                  defined $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$MessageType}{Data} ) {

                  my $Channel = "00" ;
                  my %info ;
                  foreach my $byte (0..8) {
                     my $bin  = &hex_to_binary ( $hex[$byte] ) ;
                     if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$MessageType}{Data}{$byte} ) {
                        my $Name ;
                        if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$MessageType}{Data}{$byte}{Name} ) {
                           $Name = $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$MessageType}{Data}{$byte}{Name} ;
                        }
                        foreach my $key (sort keys(%{$global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$MessageType}{Data}{$byte}{Match}})) {
                           if ( $key eq "Value" ) {
                              $Name = "Value" if ! defined $Name ;
                              push @{$info{$Channel}{$Name}}, hex $hex[$byte] ;
                           } elsif ( $key =~ /^%(.+)/ ) {
                              my $regex = $1 ;
                              if ( $bin =~ /$regex/ ) {
                                 if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$MessageType}{Data}{$byte}{Match}{$key}{Channel} ) {
                                    $Channel = $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$MessageType}{Data}{$byte}{Match}{$key}{Channel} ;
                                 }
                                 if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$MessageType}{Data}{$byte}{Match}{$key}{Info} ) {
                                    my $Info = $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$MessageType}{Data}{$byte}{Match}{$key}{Info} ;
                                    push @{$info{$Channel}{$Name}}, $Info if defined $Channel ;
                                 }
                              }
                           } elsif ( $key eq $hex[$byte] or $key eq $bin ) {
                              if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$MessageType}{Data}{$byte}{Match}{$key}{Channel} ) {
                                 $Channel = $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$MessageType}{Data}{$byte}{Match}{$key}{Channel} ;
                              }
                              if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$MessageType}{Data}{$byte}{Match}{$key}{Info} ) {
                                 my $Info = $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$MessageType}{Data}{$byte}{Match}{$key}{Info} ;
                                 push @{$info{$Channel}{$Name}}, $Info if defined $Channel ;
                              }
                           }
                        }  
                     }
                  }

                  print "\n" ; # Debugging
                  print Dumper {%info} ; # Debugging

                  foreach my $Channel (sort keys (%info) ) {
                     foreach my $Name (sort keys (%{$info{$Channel}}) ) {
                        my $temp = join ";", @{$info{$Channel}{$Name}} ;
                        &do_query ($global{dbh},"insert into `modules_channel_info` (`address`, `channel`, `data`, `value`, `date`) VALUES (?, ?, ?, ?, NOW() ) ON DUPLICATE KEY UPDATE `value`=values(value)", $address, $Channel, $Name, $temp) ;
                     }
                  }
               }
            }
         }
      } else {
         print "Not a valid packet: ETX: $ETX != 04" ;
      }

   } else {
      print "Not a valid packet: STX: $STX != 0F" ;
   }

   print "\n" ;
}

# Query status of module
# 1: socket
# 2: address
# 3: module type
sub get_module_channel_status () {
   my $sock = $_[0] ;
   my $address = $_[1] ;
   my $module  = $_[2] ;
   $prio    = "0xFB";
   $rtr     = "0x00";
   my @message = ("0xFA", $module) ; # Request module status
   &print_sock ($sock,$prio,$address,$rtr,@message) ;
   #usleep (20000) ;
}

# Query name of module
# 1: socket
# 2: address
# 3: module type
sub get_module_channel_name () {
   my $sock = $_[0] ;
   my $address = $_[1] ;
   my $module   = $_[2] ;
   $prio    = "0xFB";
   $rtr     = "0x00";
   my @message = ("0xEF", $module) ; # Request module name
   &print_sock ($sock,$prio,$address,$rtr,@message) ;
   #usleep (20000) ;
}  

# Get status and name (via 2 subfunctions)
# Tested for blinds only
# 
# 1: socket
# 2: address
# 3: module type
# 4: channel (optional)
sub get_module_status () {
   my $sock = $_[0] ;
   my $address = $_[1] ;
   my $module  = $_[2] ;
   my $channel = $_[3] ;

   my @channels ;
   if ( defined $channels ) {
      $channels[0] = $channels ;
   } elsif ( defined $global{Cons}{ModuleTypes}{$module}{Channels} ) {
      @channels = sort keys %{$global{Cons}{ModuleTypes}{$module}{Channels}} ;
   }

   foreach my $channels (@channels) {
      &get_module_channel_status ($sock, $address, $channels) ;
      &get_module_channel_name   ($sock, $address, $channels) ;
   }
}

sub get_module_status_blind () {
   my $sock = $_[0] ;
   foreach my $address (sort keys %{$global{Vars}{Modules}{PerType}{'1D'}}) {
      &get_module_status ($sock,"0x$address","1D") ;
   }
}

sub get_module_status_relay () {
   my $sock = $_[0] ;
   foreach my $address (sort keys %{$global{Vars}{Modules}{PerType}{'10'}}) {
      &get_module_status ($sock,"0x$address","10") ;
   }
}

sub get_module_status_dimmer () {
   my $sock = $_[0] ;
   foreach my $address (sort keys %{$global{Vars}{Modules}{PerType}{'12'}}) {
      &get_module_status ($sock,"0x$address","12") ;
   }
}

# Get status of all modules
# Loop over known modules via subfunction
sub get_modules_status () {
   my $sock = $_[0] ;
   &get_module_status_blind  ($sock) ;
   &get_module_status_relay  ($sock) ;
   &get_module_status_dimmer ($sock) ;
}

sub test () {
   my $sock = $_[0] ;
   # Dimmer: 0x04 = channel 3, 0x1A = 26%
   #$address = "0x11";
   #$prio    = "0xF8"; # High
   #$rtr     = "0x00";
   #@message = ("0x07", "0x04", "0x1A", "0x00", "0x00") ;
   #&print_sock ($sock,$prio,$address,$rtr,@message) ;

   # Rolluik naar beneden
   $address = "0x03";
   $prio    = "0xF8"; # High
   $rtr     = "0x00";
   @message = ("0x06", "0x02", "0x00", "0x00", "0x00") ;
   &print_sock ($sock,$prio,$address,$rtr,@message) ;
}

# Query the temp of a touch
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

# Print something to the socket.
sub print_sock {
   my $sock = shift (@_) ;
   my @message = @_ ;
   #usleep (20000) ;
   print $sock &make_message(@message);
}

sub read_config {
   my $config = $_[0] ;
   my $file = "etc/".$config.".cfg" ;
   if ( -f $file ) {
      open (CONFIG, "<$file" ) ;
      while (<CONFIG>) {
         chomp;                  # no newline
         s/#.*//;                # no comments
         s/^\s+//;               # no leading white
         s/\s+$//;               # no trailing white
         next unless length;     # anything left?
         my ($var, $value) = split(/\s*=\s*/, $_, 2);
         $global{Config}{$config}{$var} = $value;
      }
      return 1
   }
   return 0
}

return 1
