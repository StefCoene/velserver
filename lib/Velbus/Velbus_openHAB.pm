sub openHAB_config {
   if ( defined $global{Config}{openHAB} ) {
      foreach my $key (sort keys (%{$global{Config}{openHAB}}) ) {
         if ( $key =~ /^GROUP_(.+)$/ ) {
            my $group = $1 ;
            foreach my $item (split " ", $global{Config}{openHAB}{$key} ) {
               $global{openHAB}{config}{item}{$item}{Group}{$group} = "ConfigFile" ;
               $global{openHAB}{config}{$group}{item}{$item} = "ConfigFile" ;
            }
         }
      }
   }
}

sub openHAB_match_item {
   my $item_input  = $_[0] ;
   my %group ;
   foreach my $group (keys %{$global{openHAB}{config}}) {
      foreach my $item (keys %{$global{openHAB}{config}{$group}{item}}) {
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

sub openHAB () {
   my $openHAB ;

   $global{Config}{openHAB}{polling} = 600 if ! defined $global{Config}{openHAB}{polling} ;

   # Loop all module types
   foreach my $type (sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerType}})) {
      # Loop all modules
      print       "// $global{Cons}{ModuleTypes}{$type}{Type} ($type)<br>\n" ;
      $openHAB .= "// $global{Cons}{ModuleTypes}{$type}{Type} ($type)\n" ;

      foreach my $address ( sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerType}{$type}{ModuleList}}) ) {
         # Temperature on 1,2,4 Touch (channel 09) and OLED (channel 21)
         if ( ( $type eq "20" ) or
              ( $type eq "28" ) ) {
            if ( $type eq "20" ) {
               $channel = "09" ;
            } else {
               $channel = "21" ;
            }

            my $item = "Temperature_$address" ;
            $openHAB .= "Number $item \"$global{Vars}{Modules}{Address}{$address}{ModuleInfo}{TempSensor} [%.1f °C]\" " ;
            $openHAB .= "<temperature> " ;
            my $Group = &openHAB_match_item($item) ;
            if ( defined $Group ) {
               $openHAB .= "($Group) " ;
            }
            $openHAB .= "{http=\"" ;
            $openHAB .=        "<[$global{Config}{openHAB}{BASE_URL}?address=$address&type=Temperature&action=Get:$global{Config}{openHAB}{polling}:JSONPATH(\$.Temperature)]" ;
            $openHAB .= "\"}\n" ;

            my $item = "HeaterMode_$address" ;
            $openHAB .= "Number $item \"$global{Vars}{Modules}{Address}{$address}{ModuleInfo}{TempSensor} mode\" " ;
            $openHAB .= "<temperature> " ;
            my $Group = &openHAB_match_item($item) ;
            if ( defined $Group ) {
               $openHAB .= "($Group) " ;
            }
            $openHAB .= "{http=\"" ;
            $openHAB .=        "<[$global{Config}{openHAB}{BASE_URL}?address=$address&type=HeaterMode&action=Get:$global{Config}{openHAB}{polling}:JSONPATH(\$.Status)]" ;
            $openHAB .= " >[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&type=HeaterMode&action=Set&value=%2\$s]" ;
            $openHAB .= "\"}\n" ;

            my $item = "HeaterTemperature_$address" ;
            $openHAB .= "Number $item \"$global{Vars}{Modules}{Address}{$address}{ModuleInfo}{TempSensor} temperature target [%.1f °C]\" " ;
            $openHAB .= "<temperature> " ;
            my $Group = &openHAB_match_item($item) ;
            if ( defined $Group ) {
               $openHAB .= "($Group) " ;
            }
            $openHAB .= "{http=\"" ;
            $openHAB .=        "<[$global{Config}{openHAB}{BASE_URL}?address=$address&type=HeaterTemperature&action=Get:$global{Config}{openHAB}{polling}:JSONPATH(\$.Status)]" ;
            $openHAB .= " >[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&type=HeaterTemperature&action=Set&value=%2\$s]" ;
            $openHAB .= "\"}\n" ;
         }

         # Touch buttons + Input modules
         if ( ( $type eq "1E" ) or
              ( $type eq "1F" ) or
              ( $type eq "20" ) or
              ( $type eq "28" ) or
              ( $type eq "22" ) ) {

            my @Channel ;
            if (      $type eq "1E" ) { # VMBGP1
               @channel = ("01") ;
            } elsif ( $type eq "1F" ) { # VMBGP2
               @channel = ("01","02") ;
            } elsif ( $type eq "20" ) { # VMBGP4
               @channel = ("01","02","03","04","05","06","07","08") ;
            } elsif ( $type eq "28" ) { # VMBGPOD
               @channel = ("01","02","03","04","05","06","07","08") ;
            } elsif ( $type eq "22" ) { # VMB7IN
               @channel = ("01","02","03","04","05","06","07") ;
            } else {
            }

            foreach my $Channel (sort @channel) {
               my $item = "Button_$address"."_"."$Channel" ;
               my $Name = $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ;
               $Name .= " :: ". $item if defined $global{Config}{openHAB}{debug} ;
               $openHAB .= "Switch $item \"$Name\" " ;
               my $Group = &openHAB_match_item($item) ;
               if ( defined $Group ) {
                  $openHAB .= "($Group) " ;
               }
               $openHAB .= "{http=\"" ;
               $openHAB .=        "<[$global{Config}{openHAB}{BASE_URL}?address=$address&type=Switch&action=Get:$global{Config}{openHAB}{polling}:JSONPATH(\$.Status)]" ;
               $openHAB .= " >[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&type=Switch&action=Set&value=%2\$s]" ;
               $openHAB .= "\"}\n" ;

               my $item = "ButtonLong_$address"."_"."$Channel" ;
               my $Name = $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ;
               $Name .= " :: ". $item if defined $global{Config}{openHAB}{debug} ;
               $openHAB .= "Switch $item \"$Name\" " ;
               my $Group = &openHAB_match_item($item) ;
               if ( defined $Group ) {
                  $openHAB .= "($Group) " ;
               }
               $openHAB .= "{http=\"" ;
               $openHAB .=        "<[$global{Config}{openHAB}{BASE_URL}?address=$address&type=Switch&action=Get:$global{Config}{openHAB}{polling}:JSONPATH(\$.Status)]" ;
               $openHAB .= " >[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&type=Switch&action=Set&value=%2\$s]" ;
               $openHAB .= "\"}\n" ;
            }

            if ( defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{SubAddr} ) {
               foreach my $SubAddr (split ",", $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{SubAddr} ) {
                  foreach my $Channel (sort @channel) {
                     my $item = "Button_$SubAddr"."_"."$Channel" ;
                     my $SubChannel = &SubAddr_Channel ($address, $SubAddr, $Channel) ; # Calculate the 'real' channel address based on the channel and sub address
                     my $Name = $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$SubChannel}{Name}{value} ;
                     $Name .= " :: ". $item if defined $global{Config}{openHAB}{debug} ;
                     $openHAB .= "Switch $item \"$Name\" " ;
                     my $Group = &openHAB_match_item($item) ;
                     if ( defined $Group ) {
                        $openHAB .= "($Group) " ;
                     }
                     $openHAB .= "{http=\"" ;
                     $openHAB .=        "<[$global{Config}{openHAB}{BASE_URL}?address=$SubAddr&type=Switch&action=Get:$global{Config}{openHAB}{polling}:JSONPATH(\$.Status)]" ;
                     $openHAB .= " >[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$SubAddr&type=Switch&action=Set&value=%2\$s]" ;
                     $openHAB .= "\"}\n" ;

                     my $item = "ButtonLong_$SubAddr"."_"."$Channel" ;
                     my $SubChannel = &SubAddr_Channel ($address, $SubAddr, $Channel) ; # Calculate the 'real' channel address based on the channel and sub address
                     my $Name = $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$SubChannel}{Name}{value} ;
                     $Name .= " :: ". $item if defined $global{Config}{openHAB}{debug} ;
                     $openHAB .= "Switch $item \"$Name\" " ;
                     my $Group = &openHAB_match_item($item) ;
                     if ( defined $Group ) {
                        $openHAB .= "($Group) " ;
                     }
                     $openHAB .= "{http=\"" ;
                     $openHAB .=        "<[$global{Config}{openHAB}{BASE_URL}?address=$SubAddr&type=Switch&action=Get:$global{Config}{openHAB}{polling}:JSONPATH(\$.Status)]" ;
                     $openHAB .= " >[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$SubAddr&type=Switch&action=Set&value=%2\$s]" ;
                     $openHAB .= "\"}\n" ;
                  }
               }
            }
         }

         if ( defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo} ) {
            foreach my $Channel ( sort {$a cmp $b} keys (%{$global{Vars}{Modules}{Address}{$address}{ChannelInfo}}) ) {
               next if $Channel eq "00" ; # Channel 00 is used to store data about the module, so this Channel does not exist
               my $itemBase = $address."_".$Channel ;
               # Dimmer
               if ( $type eq "12" or $type eq "15" ) {
                  my $item = "Dimmer_$itemBase" ;
                  my $Name = $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ;
                  $Name .= " :: ". $item if defined $global{Config}{openHAB}{debug} ;
                  $Name .= " [%s %%]" ;
                  $openHAB .= "Dimmer $item \"$Name\" " ;
                  $openHAB .= "<slider> " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  $openHAB .= "{http=\"" ;
                  $openHAB .=        "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Dimmer&action=Get:$global{Config}{openHAB}{polling}:JSONPATH(\$.Status)]" ;
                  $openHAB .= " >[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Dimmer&action=Set&value=%2\$s]" ;
                  $openHAB .= "\"}\n" ;

               #  Blinds
               } elsif ( $type eq "03" or $type eq "09" or $type eq "1D" ) {
                  my $item = "Blind_$itemBase" ;
                  my $Name = $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ;
                  $Name .= " :: ". $item if defined $global{Config}{openHAB}{debug} ;
                  $Name .= " [%s %%]" ;
                  $openHAB .= "Rollershutter $item \"$Name\" " ;
                  $openHAB .= "<rollershutter> " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  $openHAB .= "{http=\"" ;
                  $openHAB .=       "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Blind&action=Get:$global{Config}{openHAB}{polling}:JSONPATH(\$.Status)]" ;
                  $openHAB .= " >[*:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Blind&action=Set&value=%2\$s]" ;
                  $openHAB .= "\"}\n" ;

               # Relay
               } elsif ( $type eq "02" or $type eq "08" or $type eq "10" or $type eq "11") {
                  my $item = "Relay_$itemBase" ;
                  my $Name = $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value} ;
                  $Name .= " :: ". $item if defined $global{Config}{openHAB}{debug} ;
                  $openHAB .= "Switch $item \"$Name\" " ;
                  $openHAB .= "<switch> " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  $openHAB .= "{http=\"" ;
                  $openHAB .=         "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Relay&action=Get:$global{Config}{openHAB}{polling}:JSONPATH(\$.Status)]" ;
                  $openHAB .=  " >[ON:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Relay&action=On] " ;
                  $openHAB .= " >[OFF:GET:$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Relay&action=Off]" ;
                  $openHAB .= "\"}\n" ;

               # VMB7IN: counters
               } elsif ( $type eq "22" ) {
                  my $item = "Counter_$itemBase" ;
                  $openHAB .= "Number $item \"$item [%.0f]\" " ;
                  $openHAB .= " <chart> " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  $openHAB .= "{http=\"" ;
                  $openHAB .=         "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Counter&action=GetCounter:$global{Config}{openHAB}{polling}:JSONPATH(\$.Status)]" ;
                  $openHAB .= "\"}\n" ;

                  my $item = "Divider_$itemBase" ;
                  $openHAB .= "Number $item \"$item [%.0f]\" " ;
                  $openHAB .= " <chart> " ;
                  my $Group = &openHAB_match_item($item) ;
                  if ( defined $Group ) {
                     $openHAB .= "($Group) " ;
                  }
                  $openHAB .= "{http=\"" ;
                  $openHAB .=         "<[$global{Config}{openHAB}{BASE_URL}?address=$address&channel=$Channel&type=Counter&action=GetDivider:$global{Config}{openHAB}{polling}:JSONPATH(\$.Status)]" ;
                  $openHAB .= "\"}\n" ;

               } else {
                  print "$address :: $Channel = $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value}<br>\n" ;
               }
            }
         }
      }
   }

   if ( -f $global{Config}{openHAB}{ITEM_FILE} ) {
      if ( -w $global{Config}{openHAB}{ITEM_FILE} ) {
         open ITEM_FILE, ">$global{Config}{openHAB}{ITEM_FILE}" ;
         print  ITEM_FILE"$openHAB\n" ;
         close ITEM_FILE ;
      } else {
         print "Warning: $global{Config}{openHAB}{ITEM_FILE} not writable!<br>\n" ;
      }
   }
   $openHAB =~ s/</&lt;/g ; # Prepare for html output
   $openHAB =~ s/>/&gt;/g ; # Prepare for html output
   $openHAB =~ s/\n/<br>\n/g ; # Prepare for html output
   print "$openHAB\n" ;
}

return 1 ;
