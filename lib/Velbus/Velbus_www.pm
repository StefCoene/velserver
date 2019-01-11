# Make an url based on the parameters supplied in the url and extra input parameters
sub www_make_url () {
   my %input ;
   foreach (@_) {
      my @split = split "=" ;
      next if $split[0] eq "" ;
      $input{$split[0]} = $split[1] if @split ;
   }

   my @url ;
   # Loop all CGI params
   foreach my $key (sort keys %{$global{cgi}{params}}) {
      next if $key eq "" ;
      # Overrule parameter if needed
      if ( defined $input{'*'} ) {
         if ( $input{'*'} eq '-' ) {
         } else {
            delete $input{$key} ;
         }
      } elsif ( defined $input{$key} ) {
         if ( $input{$key} eq '-' ) {
         } else {
            push @url, "$key=$input{$key}" ;
            delete $input{$key} ;
         }
      } else {
         push @url, "$key=$global{cgi}{params}{$key}" ;
      }
   }
   foreach my $key (sort keys %input) {
      next if $key eq "" ;
      if ( $input{$key} eq '-' ) {
      } else {
         push @url, "$key=$input{$key}" ;
      }
   }
   my $url = join "&", @url ;
   return $url ;
}

# Website with some basic menus
sub www_index () {
   my $content ;

   # Starten van html output
   # includen van de nodige files: css en javascript
   $content .= $global{cgi}{CGI}->start_html (
      -title=>"Velbus",
      -style=>[
         {'src'=>"include/jquery.dataTables.min.css"},
      ],
      -script=>[
         { -type=>'text/javascript',
           -src=>'include/jquery-3.3.1.min.js'},
         { -type=>'text/javascript',
           -src=>'include/script.js'},
         { -type=>'text/javascript',
           -src=>'include/jquery.dataTables.min.js'},
      ]
   ) ;

   $content .= "<p>\n" ;
   $content .= "<a href=?".&www_make_url("*=-","appl=scan_for_modules").">Scan the bus for modules</a> || " ;
   $content .= "<a href=?".&www_make_url("*=-","appl=print_found_modules").">Found modules</a> || " ;
   $content .= "<a href=?".&www_make_url("*=-","appl=print_channel_tags").">Channel tags</a> || " ;
   $content .= "<a href=?".&www_make_url("*=-","appl=generate_openHAB").">Generate openHAB items file</a> || " ;
   $content .= "<a href=?".&www_make_url("*=-","appl=empty_database").">Empty the database</a> " ;
   $content .= "<br />\n" ;

   $content .= "<a href=?".&www_make_url("*=-","appl=print_velbus_protocol").">Velbus protocol</a> || " ;
   $content .= "<a href=?".&www_make_url("*=-","appl=print_velbus_messages").">Velbus messages</a> || " ;
   $content .= "</p>\n" ;

   if ( $global{cgi}{params}{appl} eq "print_found_modules" ) {
      if ( defined $global{cgi}{params}{action} ) {
         if ( $global{cgi}{params}{action} eq "status" ) {
            $content .= &www_update_module_status ;
         }
      }
      $content .= &www_print_found_modules ;
   }
   if ( $global{cgi}{params}{appl} eq "print_channel_tags" ) {
      $content .= &www_print_channel_tags ;
   }
   if ( $global{cgi}{params}{appl} eq "print_velbus_protocol" ) {
      $content .= &www_print_velbus_protocol ;
   }
   if ( $global{cgi}{params}{appl} eq "print_velbus_messages" ) {
      $content .= &www_print_velbus_messages ;
   }
   if ( $global{cgi}{params}{appl} eq "generate_openHAB" ) {
      $content .= &www_generate_openHAB ;
   }
   if ( $global{cgi}{params}{appl} eq "scan_for_modules" ) {
      $content .= &www_scan_for_modules ;
   }
   if ( $global{cgi}{params}{appl} eq "empty_database" ) {
      $content .= &www_empty_database ;
   }
   if ( $global{cgi}{params}{appl} eq "empty_database_DO" ) {
      $content .= &www_empty_database ("DO") ;
   }
   if ( $global{cgi}{params}{appl} eq "debug" ) {
      $content .= "<pre>\n" ;
      $content .= Dumper {%global} ;
      $content .= "</pre>\n" ;
   }
   $content .= $global{cgi}{CGI}->end_html() ;
   return $content ;
}

# Webservice for remote access
sub www_service () {
   my $sock = &open_socket ;

   my %json ;

   # Save the original request parameters for debug purposes
   foreach (keys %{$global{cgi}{params}}) {
      $json{"Raw_$_"} = $global{cgi}{params}{$_} ;
   }

   # 1/2: Parse Item and search ChannelType, address and Channel
   if ( defined $global{cgi}{params}{Item} ) {
      $json{ReqItem} = $global{cgi}{params}{Item} ;

      if ( $json{ReqItem} =~ /(.+)_(..)_(..)$/ ) {
         $json{ReqChannelType} = $1 ;
         $json{ReqAddress}     = $2 ;
         $json{ReqChannel}     = $3 ;
      } else {
         $json{Error} = "Item param not correct" ;
      }
   }

   # 2/2: Set address if supplied as param
   if ( ! defined $json{ReqAddress} and defined $global{cgi}{params}{Address} ) {
      if ( $global{cgi}{params}{Address} =~ /^..$/ ) {
         $json{ReqAddress} = $global{cgi}{params}{Address} ;
      } else {
         $json{Error} = "Address param not correct" ;
      }
   }

   # 2/2: Set channel if supplied as param
   if ( ! defined $json{ReqChannel} and defined $global{cgi}{params}{Channel} ) {
      if ( $global{cgi}{params}{Channel} =~ /^..$/ ) {
         $json{ReqChannel} = $global{cgi}{params}{Channel} ;
      } else {
         $json{Error} = "Channel param not correct" ;
      }
   }

   # Parse options: find the moduletype based on the supplied address
   if ( defined $json{ReqAddress} ) {
      if ( defined $global{Vars}{Modules}{Address}{$json{ReqAddress}}{ModuleInfo}{type} and $global{Vars}{Modules}{Address}{$json{ReqAddress}}{ModuleInfo}{type} ne '' ) {
         $json{ModuleType} = $global{Vars}{Modules}{Address}{$json{ReqAddress}}{ModuleInfo}{type} ;
      }
   }

   # Get Action and Value if supplied
   $json{ReqAction} = $global{cgi}{params}{Action} if defined $global{cgi}{params}{Action} ;
   $json{ReqValue}  = $global{cgi}{params}{Value}  if defined $global{cgi}{params}{Value} ;

   ###############
   #my $test = Dumper \%{$global{Cons}{ChannelTypes}{$json{ReqChannelType}}} ;
   #$json{Debug_ChannelType} = "<pre>" . $test . "</pre>" ;

   # Put the time on the bus
   if ( defined $json{ReqAction} and $json{ReqAction} eq "TimeSync" ) {
      &broadcast_datetime($sock) ;

   # Set memo text: only for VMBGPOD
   } elsif ( defined $json{ReqAction} and $json{ReqAction} eq "Memo" ) {
      #my $test = Dumper \%{$global{Cons}{ChannelTypes}{Memo}} ;
      #$json{Debug_memo} = "<pre>" . $test . "</pre>" ;
      #
      # We need an address
      if ( ! defined $json{ReqAddress} ) {
         $json{Error} = "NO_ADDRESS" ;

      # Only ModuleType = 28 can receive Memo text
      } elsif ( defined $json{ModuleType} and $json{ModuleType} eq "28" ) {
         if ( defined $json{ReqValue} ) {
            &send_memo ($sock, $json{ReqAddress}, $json{ReqValue}) ;
            $json{Text} = $json{ReqValue} ;
         } else {
            &send_memo ($sock, $json{ReqAddress}) ; # Send nothing to clear the message
         }

      } elsif ( defined $json{ModuleType} ) {
         $json{Error} = "WRONG_MODULETYPE" ;

      } else {
         $json{Error} = "NO_MODULETYPE" ;
      }

   # The rest is for getting and setting an item
   } elsif ( defined $json{ReqChannelType} ) {

      # 1: if we have a ChannelType, it should be defined in $global{Cons}{ChannelTypes}
      if ( ! defined $global{Cons}{ChannelTypes}{$json{ReqChannelType}} ) {
         $json{Error} = "UNSUPPORTED_CHANNELTYPE" ;

      # 2: we need an address
      } elsif ( ! defined $json{ReqAddress} ) {
         $json{Error} = "NO_ADDRESS" ;

      # 3: We need a Channel
      } elsif ( ! defined $json{ReqChannel} ) {
         $json{Error} = "NO_CHANNEL" ;

      # 4: we need a module type (based on parameter address)
      } elsif ( ! defined $json{ModuleType} ) {
         $json{Error} = "NO_MODULETYPE" ;

      # 5: there should be at least a Get for the ChannelTpe and ModuleType
      } elsif ( ! defined $global{Cons}{ChannelTypes}{$json{ReqChannelType}}{Module}{$json{ModuleType}}{Action}{Get} ) {
         $json{Error} = "CHANNELTYPE_NOT_SUPPORTED_FOR_MODULETYPE" ;

      # 6: we also need an action
      } elsif ( ! defined $json{ReqAction} ) {
         $json{Error} = "NO_ACTION" ;

      # 7: the action should be supported for the ChannelType and ModuleType
      # This checks also that Action should be Get or Set
      } elsif ( ! defined $global{Cons}{ChannelTypes}{$json{ReqChannelType}}{Module}{$json{ModuleType}}{Action}{$json{ReqAction}} ) {
         $json{Error} = "ACTION_NOT_SUPPORTED_FOR_CHANNELTYPE_AND_MODULETYPE" ;

      # 8: If action = Set we need a value
      } elsif ( $json{ReqAction} eq "Set" and ! defined $json{ReqValue} ) {
         $json{Error} = "NO_VALUE_FOR_SET" ;

      } else {
         # Get the relevant data
         my %data = &fetch_data ($global{dbh},"select * from modules_channel_info where `address`=? and `channel`=?","data",$json{ReqAddress},$json{ReqChannel}) ;
         #my $data = Dumper \%data ;
         #$json{Debug_data} = "<pre>" . $data . "</pre>" ;

         # Get Name if we have one
         if ( $data{Name} ) {
            $json{Name} = $data{Name}{value} ;
         }

         # Get the data and add it to the json
         if ( $json{ReqAction} eq "Get" ) {
            if ( defined $data{$json{ReqChannelType}} ) {
               $json{Status} = $data{$json{ReqChannelType}}{value} ;
            } else {
               $json{Error} = "NO_VALUE_FOR_GET:$json{ReqChannelType}" ;
            }

         } else { # $json{ReqAction} eq "Set"
            # 1: Check the Value with Action=Set to make sure it's valid
            foreach my $Match (sort keys %{$global{Cons}{ChannelTypes}{$json{ReqChannelType}}{Set}{Match}} ) {
               if ( $json{ReqValue} =~ /^$Match$/ ) {
                  $json{ReqMatch} = $json{ReqValue} ;
                  if ( defined $global{Cons}{ChannelTypes}{$json{ReqChannelType}}{Set}{Match}{$Match}{Action} ) {
                     $json{Action} = $global{Cons}{ChannelTypes}{$json{ReqChannelType}}{Set}{Match}{$Match}{Action} ;
                  } else {
                     $json{Action} = $Match ;
                  }
               }
            }

            # 2: Some extra custom checks
            if ( defined $json{ReqMatch} ) {
               if ( $json{ReqChannelType} eq "Blind" and $json{Action} eq "POSITION" ) {
                  if ( $json{ReqValue} >= 0 and $json{ReqValue} <= 100 ) {
                     $json{Action} = "POSITION" ;
                  } elsif ( $json{ReqValue} eq "0" ) {
                     $json{ReqValue} = "UP" ;
                  } elsif ( $json{ReqValue} eq "100" ) {
                     $json{ReqValue} = "DOWN" ;
                  } else {
                     undef $json{Action} ;
                     $json{Error} = "VALUE_NOT_IN_RANGE_1" ;
                  }
               } elsif ( $json{ReqChannelType} eq "Dimmer" and $json{Action} eq "LEVEL" ) {
                  if ( $json{ReqValue} >= 0 and $json{ReqValue} <= 100 ) {
                     $json{Action} = "LEVEL" ;
                  } elsif ( $json{ReqValue} eq "ON" ) {
                     $json{ReqValue} = "100" ;
                  } elsif ( $json{ReqValue} eq "OFF" ) {
                     $json{ReqValue} = "0" ;
                  } else {
                     undef $json{Action} ;
                     $json{Error} = "VALUE_NOT_IN_RANGE_2" ;
                  }
               }
            } else {
               $json{Error} = "VALUE_NOT_IN_RANGE_3" ;
            }

            #     $SetAction -> $json{Action}
            #
            # 3: Only continue if we had no error
            if ( ! defined $json{Error} ) {
               # Get/Set Blind positoin
               if ( $json{ReqChannelType} eq "Blind" ) {
                  if (      $json{Action} eq "UP" ) {
                     &blind_up   ($sock, $json{ReqAddress}, $json{ReqChannel}) ;
                     $json{Status} = $json{Action} ;
                  } elsif ( $json{Action} eq "DOWN" ) {
                     &blind_down ($sock, $json{ReqAddress}, $json{ReqChannel}) ;
                     $json{Status} = $json{Action} ;
                  } elsif ( $json{Action} eq "STOP" ) {
                     &blind_stop ($sock, $json{ReqAddress}, $json{ReqChannel}) ;
                     $json{Status} = $json{Action} ;
                  } elsif ( $json{Action} eq "POSITION" ) {
                     &blind_pos  ($sock, $json{ReqAddress}, $json{ReqChannel}, $json{ReqValue}) ;
                     $json{Status} = $json{ReqValue} ;
                  } else {
                     $json{Error} = "INCORRECT_ACTION" ;
                  }

               } elsif ( $json{ReqChannelType} eq "Button" ) {
                  if ( $json{Action} eq "ON" ) {
                     &button_pressed ($sock, $json{ReqAddress}, $json{ReqChannel}) ;
                     $json{Status} = $json{ReqValue} ;
                  } elsif ( $json{Action} eq "OFF" ) {
                     # TODO
                  }

               } elsif ( $json{ReqChannelType} eq "ButtonLong" ) {
                  if ( $json{Action} eq "ON" ) {
                     &button_long_pressed ($sock, $json{ReqAddress}, $json{ReqChannel}) ;
                     $json{Status} = $json{ReqValue} ;
                  } elsif ( $json{Action} eq "OFF" ) {
                     # TODO
                  }

               } elsif ( $json{ReqChannelType} eq "Dimmer" ) {
                  &dim_value ($sock, $json{ReqAddress}, $json{ReqChannel}, $json{ReqValue}) ;
                  $json{Status} = $json{ReqValue} ;

               } elsif ( $json{ReqChannelType} eq "Memo" ) {
                  &send_memo ($sock, $json{ReqAddress}, $json{ReqValue}) ;
                  $json{Text} = $json{ReqValue} ;

               } elsif ( $json{ReqChannelType} eq "Relay" ) {
                  if ( $json{ReqValue} eq "ON" ) {
                     &relay_on ($sock, $json{ReqAddress}, $json{ReqChannel}) ;
                     $json{Status} = "ON" ;
                  } elsif ( $json{ReqValue} eq "OFF" ) {
                     &relay_off ($sock, $json{ReqAddress}, $json{ReqChannel}) ;
                     $json{Status} = "OFF" ;
                  }

               # Set heating or cooling: touch panels
               } elsif ( $json{ReqChannelType} eq "ThermostatCoHeMode" ) {
                  &set_temperature_cohe_mode ($sock, $json{ReqAddress}, $json{ReqValue}) ;
                  $json{Status} = $json{ReqValue} ;

               # Set the Heater mode: touch panels
               } elsif ( $json{ReqChannelType} eq "ThermostatMode" ) {
                  &set_temperature_mode ($sock, $json{ReqAddress}, $json{ReqValue}) ;
                  $json{Status} = $json{ReqValue} ;

               # Set the Cooler/Heater target temperature: touch panels
               } elsif ( $json{ReqChannelType} eq "ThermostatTarget" ) {
                  &set_temperature ($sock, $json{ReqAddress}, $json{ReqValue}) ;
                  $json{Status} = $json{ReqValue} ;

               } else {
                  $json{TODO} = "ChannelType=$json{ReqChannelType}" ;
               }
            }
         }
         $json{Status} = "" if ! defined $json{Status} ;
      }
   } else {
      $json{Error} = "Nothing to do?" ;
   }

   return %json ;
}

sub process_modules () {
   # Loop all module types
   foreach my $ModuleType (sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerType}})) {

      # Loop all modules
      foreach my $address ( sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerType}{$ModuleType}{ModuleList}}) ) {
         foreach my $Key (keys (%{$global{Vars}{Modules}{Address}{$address}{ModuleInfo}}) ) {
            if ( $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{$Key} ne "" ) {
               $global{Vars}{Modules}{PerType}{$ModuleType}{ModuleInfoKey}{$Key} = "" ; # To get a list of info per module
            }
         }

         # If the module has sub addresses, take them in consideration
         if ( defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo} ) {
            foreach my $Channel ( sort {$a cmp $b} keys (%{$global{Vars}{Modules}{Address}{$address}{ChannelInfo}}) ) {
               foreach my $Key ( sort {$a cmp $b} keys (%{$global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}}) ) {
                  if ( $Channel eq "00" ) { # Channel 00 contains info about the module itself
                     if ( $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{$Key}{value} ne "" ) {
                        $global{Vars}{Modules}{PerType}{$ModuleType}{ModuleInfoKey}{$Key} = "" ; # To get a list of info per module
                        $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{$Key} = $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{$Key}{value} ;
                     }
                  } else {
                     $global{Vars}{Modules}{PerType}{$ModuleType}{ChannelInfoKey}{$Key} = "" ; # To get a list of info per channel
                     $global{Vars}{Modules}{PerType}{$ModuleType}{ChannelList}{$Channel} = "" ; # To get a list of the channels
                  }
               }
            }
         }
      }
   }
}

sub www_print_found_modules () {
   my $html ;
   $html .= "<h1>All modules on bus (<a href=\"?".&www_make_url("action=status")."\">refresh status</a>)</h1>\n" ;

   my %data ;

   &process_modules ;

   my $table ;
   $table .= "<table border=1>\n" ;
   $table .= "<thead>\n" ;
   $table .= "  <tr>\n" ;
   $table .= "    <th>Address</th>\n" ;
   $table .= "    <th>Type</th>\n" ;
   $table .= "    <th>Info</th>\n" ;
   $table .= "    <th>Name</th>\n" ;
   $table .= "    <th>Build</th>\n" ;
   $table .= "    <th>MemoryKey</th>\n" ;
   #$table .= "    <th>MemoryMap</th>\n" ;
   $table .= "    <th>Date</th>\n" ;
   $table .= "    <th>Action</th>\n" ;
   $table .= "  </tr>\n" ;
   $table .= "</thead>\n" ;

   $table .= "<tbody>\n" ;

   my $mail_body ;
   $mail_body .= "Hi,\n" ;
   $mail_body .= "\n" ;
   $mail_body .= "This information will be used to further improve the velserver scripts. See https://github.com/StefCoene/velserver.\n" ;
   $mail_body .= "\n" ;
   $mail_body .= "If something is not working and/or everything is working fine, you can specify it in this email.\n" ;
   $mail_body .= "I don't have all modules so for some modules I have to rely on the protocol files to get them supported.\n" ;
   $mail_body .= "\n" ;
   $mail_body .= "\n" ;
   $mail_body .= "Stef Coene\n" ;
   $mail_body .= "\n" ;
   $mail_body .= "address;type;ModuleName;Build;MemoryKey;\n" ;

   foreach my $address ( sort {$a cmp $b} keys (%{$global{Vars}{Modules}{ModuleList}}) ) {
      my $ModuleType = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} ; # Easier var
      my $MemoryKey = &module_find_MemoryKey ($address, $ModuleType) ; # Easier var
      #my $MemoryMap = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{MemoryMap} ;
      $table .= "  <tr>\n" ;
      if ( defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{SubAddr} ) {
         $table .= "    <th>$address ($global{Vars}{Modules}{Address}{$address}{ModuleInfo}{SubAddr})</th>\n" ;
      } else {
         $table .= "    <th>$address</th>\n" ;
      }
      $mail_body .= "$address;" ;
      $table .= "    <td>$global{Cons}{ModuleTypes}{$ModuleType}{Type} ($ModuleType)</td>\n" ;
      $mail_body .= "$ModuleType;" ;
      $table .= "    <td>$global{Cons}{ModuleTypes}{$ModuleType}{Info}</td>\n" ;
      $table .= "    <td>$global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName}</td>\n" ;
      $mail_body .= "$global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName};" ;
      $table .= "    <td>$global{Vars}{Modules}{Address}{$address}{ModuleInfo}{BuildYear}$global{Vars}{Modules}{Address}{$address}{ModuleInfo}{BuildWeek}</td>\n" ;
      $mail_body .= "$global{Vars}{Modules}{Address}{$address}{ModuleInfo}{BuildYear}$global{Vars}{Modules}{Address}{$address}{ModuleInfo}{BuildWeek};" ;

      if ( defined $MemoryKey ) {
         $table .= "    <td>$MemoryKey</td>\n" ;
         $mail_body .= "$MemoryKey;" ;
      } else {
         $table .= "    <td>-</td>\n" ;
         $mail_body .= ";" ;
      }
      #if ( defined $MemoryMap ) {
      #   if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Memory}{$MemoryMap}{ModuleName}) {
      #      $table .= "    <td>$MemoryMap</td>\n" ;
      #      $mail_body .= "$MemoryMap;" ;
      #   } else {
      #      $table .= "    <td>$MemoryMap: not found?</td>\n" ;
      #      $mail_body .= "$MemoryMap not found;" ;
      #   }
      #} else {
      #   $table .= "    <td>No MemoryMap found!</td>\n" ;
      #   $mail_body .= ";" ;
      #}
      $table .= "    <td>$global{Vars}{Modules}{Address}{$address}{ModuleInfo}{'date'}</td>\n" ;
      $table .= "    <td><a href=\"?".&www_make_url("action=status","address=$address")."\">refresh status</a></td>\n" ;
      $table .= "  </tr>\n" ;
      $mail_body .= "\n" ;
   }

   $table .= "</tbody>\n" ;
   $table .= "</table>\n" ;

   $mail_body =~ s/\n/%0D%0A/g ;
   $html .= "<p>Do you want to help? Send me <a href=\"mailto:velserver\@docum.org?subject=velserver detected modules&body=$mail_body\">an email</a> with the content of this table. Especially if there is an issue with the MemoryKey column and module name detection.</p>\n" ;
   $html .= $table ;

   $html .= "<h1>Details per module type</h1>\n" ;
   foreach my $ModuleType (sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerType}})) {
      $html .= "<h2>$global{Cons}{ModuleTypes}{$ModuleType}{Type} ($ModuleType) $global{Cons}{ModuleTypes}{$ModuleType}{Info}</h2>\n" ;
      $html .= "<h3>Module info</h3>\n" ;

      $html .= "<table border=1>\n" ;
      $html .= "<thead>\n" ;
      $html .= "  <tr>\n" ;
      $html .= "    <th>Address</th>\n" ;
      foreach my $Key (sort keys %{$global{Vars}{Modules}{PerType}{$ModuleType}{ModuleInfoKey}} ) {
         $html .= "    <th>$Key</th>\n" ;
      }
      $html .= "    <th>Action</th>\n" ;
      $html .= "  </tr>\n" ;
      $html .= "</thead>\n" ;

      $html .= "<tbody>\n" ;

      foreach my $address ( sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerType}{$ModuleType}{ModuleList}}) ) {
         $html .= "  <tr>\n" ;
         $html .= "    <th>$address</th>\n" ;
         foreach my $Key (sort keys %{$global{Vars}{Modules}{PerType}{$ModuleType}{ModuleInfoKey}} ) {
            $html .= "    <td>$global{Vars}{Modules}{Address}{$address}{ModuleInfo}{$Key}</td>\n" ;
            #$html .= "    <td>$global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{value}<br />$global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{data}</td>\n" ;
         }
         $html .= "    <td><a href=\"?".&www_make_url("action=status","address=$address")."\">refresh status</a></td>\n" ;

         $html .= "  </tr>\n" ;
      }

      $html .= "</tbody>\n" ;
      $html .= "</table>\n" ;

      if ( %{$global{Vars}{Modules}{PerType}{$ModuleType}{ChannelInfoKey}} ) {
         $html .= "<h3>Channel info</h3>\n" ;
         $html .= "<table border=1>\n" ;
         $html .= "<thead>\n" ;
         $html .= "  <tr>\n" ;
         $html .= "    <th>Address</th>\n" ;
         $html .= "    <th>Channel</th>\n" ;
         foreach my $Key (sort keys %{$global{Vars}{Modules}{PerType}{$ModuleType}{ChannelInfoKey}} ) {
            $html .= "    <th>$Key</th>\n" ;
         }
         $html .= "    <th>Action</th>\n" ;
         $html .= "  </tr>\n" ;
         $html .= "</thead>\n" ;

         $html .= "<tbody>\n" ;

         foreach my $address ( sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerType}{$ModuleType}{ModuleList}}) ) {
            $html .= "  <tr>\n" ;
            $html .= "    <th rowspan=ROWSPAN>$address</th>\n" ;
            $ROWSPAN = 0 ;
            foreach my $Channel (sort keys %{$global{Vars}{Modules}{PerType}{$ModuleType}{ChannelList}} ) {
               $html .= "  <tr>\n" if $ROWSPAN ne "0" ;
               $html .= "    <td>$Channel</td>\n" ;
               foreach my $Key (sort keys %{$global{Vars}{Modules}{PerType}{$ModuleType}{ChannelInfoKey}} ) {
                  $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{$Key}{value} =~ s/;/<br \/>/g ;
                  $html .= "    <td>$global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{$Key}{value}<br />$global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{$Key}{date}</td>\n" ;
               }
               $html .= "    <td><a href=\"?".&www_make_url("action=status","address=$address","channel=$Channel")."\">refresh status</a></td>\n" ;

               $html .= "  </tr>\n" if $ROWSPAN ne "0" ;
               $ROWSPAN ++ ;
            }
            $html .= "  </tr>\n" ;
            $html =~ s/ROWSPAN/$ROWSPAN/g ;
         }

         $html .= "</tbody>\n" ;
         $html .= "</table>\n" ;
      }
   }

   #$html .= "<pre>\n" ;
   #$html .= Dumper \%{$global{Vars}{Modules}{PerType}} ;
   #$html .= Dumper \%{$global{Vars}} ;
   #$html .= Dumper \%data ;
   #$html .= "</pre>\n" ;
   return $html ;
}

sub www_print_channel_tags () {
   my $html ;
   $html .= "<h1>All modules and channels on the bus</h1>\n" ;

   my %data ;

   # Processing the selected tags
   foreach my $param (sort keys %{$global{cgi}{params}} ) {
      if ( $param =~ /Tag::(..)::(..)/ ) {
         my $Address  = $1 ;
         my $Channel = $2 ;
         &update_modules_channel_info ($Address, $Channel, "Tag", $global{cgi}{params}{$param}) ;
      }
   }

   $html .= $global{cgi}{CGI}->start_form() ;
   $html .= $global{cgi}{CGI}->submit() ;
   $html .= $global{cgi}{CGI}->hidden(-name=>'appl',$global{cgi}{params}{appl}) ;

   # Loop all module types
   foreach my $ModuleType (sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerType}})) {

      # Loop all modules
      foreach my $address ( sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerType}{$ModuleType}{ModuleList}}) ) {
         foreach my $Key (keys (%{$global{Vars}{Modules}{Address}{$address}{ModuleInfo}}) ) {
            if ( $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{$Key} ne "" ) {
               $global{Vars}{Modules}{PerType}{$ModuleType}{ModuleInfoKey}{$Key} = "" ; # To get a list of info per module
            }
         }

         # If the module has sub addresses, take them in consideration
         if ( defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo} ) {
            foreach my $Channel ( sort {$a cmp $b} keys (%{$global{Vars}{Modules}{Address}{$address}{ChannelInfo}}) ) {
               foreach my $Key ( sort {$a cmp $b} keys (%{$global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}}) ) {
                  if ( $Channel eq "00" ) { # Channel 00 contains info about the module itself
                     if ( $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{$Key}{value} ne "" ) {
                        $global{Vars}{Modules}{PerType}{$ModuleType}{ModuleInfoKey}{$Key} = "" ; # To get a list of info per module
                        $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{$Key} = $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{$Key}{value} ;
                     }
                  } else {
                     $global{Vars}{Modules}{PerType}{$ModuleType}{ChannelInfoKey}{$Key} = "" ; # To get a list of info per channel
                     $global{Vars}{Modules}{PerType}{$ModuleType}{ChannelList}{$Channel} = "" ; # To get a list of the channels
                  }
               }
            }
         }
      }
   }

   foreach my $ModuleType (sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerType}})) {
      $html .= "<h2>$global{Cons}{ModuleTypes}{$ModuleType}{Type} ($ModuleType) $global{Cons}{ModuleTypes}{$ModuleType}{Info}</h2>\n" ;

      if ( %{$global{Vars}{Modules}{PerType}{$ModuleType}{ChannelInfoKey}} ) {
         $html .= "<h3>Channel tags</h3>\n" ;
         $html .= "<table border=1>\n" ;
         $html .= "<thead>\n" ;
         $html .= "  <tr>\n" ;
         $html .= "    <th>Address</th>\n" ;
         $html .= "    <th>Module Name</th>\n" ;
         $html .= "    <th>Channel</th>\n" ;
         $html .= "    <th>Channel Name</th>\n" ;
         $html .= "    <th>Tag</th>\n" ;
         $html .= "  </tr>\n" ;
         $html .= "</thead>\n" ;

         $html .= "<tbody>\n" ;

         foreach my $address ( sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerType}{$ModuleType}{ModuleList}}) ) {
            $html .= "  <tr>\n" ;
            $html .= "    <th rowspan=ROWSPAN>$address</th>\n" ;
            $html .= "    <th rowspan=ROWSPAN>$global{Vars}{Modules}{Address}{$address}{ModuleInfo}{ModuleName}</th>\n" ;
            $ROWSPAN = 0 ;
            foreach my $Channel (sort keys %{$global{Vars}{Modules}{PerType}{$ModuleType}{ChannelList}} ) {
               $html .= "  <tr>\n" if $ROWSPAN ne "0" ;
               $html .= "    <td>$Channel</td>\n" ;
               $html .= "    <td>$global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{value}<br />$global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Name}{date}</td>\n" ;

               $html .= "    <td>" ;
               if ( $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Type} eq "Relay" or
                    $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Type} eq "Button" or
                    $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Type} eq "Dimmer" ) {
                  if ( ! defined $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Tag}{value} or
                       $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Tag}{value} eq "" ) {
                     $global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Tag}{value} = '__NoTag__' ;
                  }
                  $html .= $global{cgi}{CGI}->scrolling_list(
                        -name=>"Tag::$address::$Channel",
                        -size=>1,
                        -values=>['Lighting', 'Switchable', '__NoTag__'],
                        -default=>[$global{Vars}{Modules}{Address}{$address}{ChannelInfo}{$Channel}{Tag}{value}]
                     ) ;
               } else {
                  $html .= "&nbsp;" ;
               }
               $html .= "</td>\n" ;

               $html .= "  </tr>\n" if $ROWSPAN ne "0" ;
               $ROWSPAN ++ ;
            }
            $html .= "  </tr>\n" ;
            $html =~ s/ROWSPAN/$ROWSPAN/g ;
         }

         $html .= "</tbody>\n" ;
         $html .= "</table>\n" ;
      }
   }

   $html .= $global{cgi}{CGI}->end_form() ;
   return $html ;
}

sub www_print_velbus_messages () {
   $html .= "<h1>Velbus messages</h1>\n" ;
   if ( defined $global{cgi}{params}{Message} ) {
      $html .= &www_print_velbus_messages_print_message($global{cgi}{params}{Message}) ;
   } else {
      $html .= &www_print_velbus_messages_print_messages ;
   }
   return $html ;
}

sub www_print_velbus_messages_print_message () {
   my $Message = $_[0] ;
   my $html ;
   my %data =&www_process_messages ;
   if ( defined $data{BroadCast}{$Message} ) {
      $html .= "<h2>Broadcast message: $Message</h2>\n" ;
      $Info = $data{BroadCast}{$Message}{Info} ;
      $Info =~ s/;/<br \/>/g ;
      $Name = $data{BroadCast}{$Message}{Name} ;
      $Name =~ s/;/<br \/>/g ;
      $Prio = $data{BroadCast}{$Message}{Prio} ;

      $html .= "<table border=1 class=\"\">\n" ;
      $html .= "<thead>\n" ;
      $html .= "  <tr>\n" ;
      $html .= "    <th>Message</th>\n" ;
      $html .= "    <th>Name</th>\n" ;
      $html .= "    <th>Info</th>\n" ;
      $html .= "    <th>Prio</th>\n" ;
      $html .= "  </tr>\n" ;
      $html .= "</thead>\n" ;

      $html .= "<tbody>\n" ;
      $html .= "  <tr>\n" ;
      $html .= "    <td>$Message</td>\n" ;
      $html .= "    <td>$Name</td>\n" ;
      $html .= "    <td>$Info</td>\n" ;
      $html .= "    <td>$Prio</td>\n" ;
      $html .= "  </tr>\n" ;
      $html .= "</thead>\n" ;
      $html .= "</table>\n" ;

   } elsif ( defined $data{Module}{$Message} ) {
      $html .= "<h2>Non-broadcast message: $Message</h2>\n" ;
      my $Name = join ";", sort keys %{$data{Module}{$Message}{Name}} ;
      $Name =~ s/;/<br \/>/g ;
      my $Info = join ";", sort keys %{$data{Module}{$Message}{Info}} ;
      $Info =~ s/;/<br \/>/g ;
      my $Prio = join ";", sort keys %{$data{Module}{$Message}{Prio}} ;

      $html .= "<table border=1 class=\"\">\n" ;
      $html .= "<thead>\n" ;
      $html .= "  <tr>\n" ;
      $html .= "    <th>Message</th>\n" ;
      $html .= "    <th>Modules</th>\n" ;
      $html .= "    <th>Name</th>\n" ;
      $html .= "    <th>Info</th>\n" ;
      $html .= "    <th>Prio</th>\n" ;
      $html .= "  </tr>\n" ;
      $html .= "</thead>\n" ;

      $html .= "<tbody>\n" ;
      $html .= "  <tr>\n" ;
      $html .= "    <td>$Message</td>\n" ;
      $html .= "    <td>" ;
      foreach my $ModuleType (sort keys %{$data{Module}{$Message}{ModuleType}} ) {
         $html .= &link_ModuleType($ModuleType) . "<br />" ;
      }
      $html .= "</td>\n" ;
      $html .= "    <td>$Name</td>\n" ;
      $html .= "    <td>$Info</td>\n" ;
      $html .= "    <td>$Prio</td>\n" ;
      $html .= "  </tr>\n" ;
      $html .= "</thead>\n" ;
      $html .= "</table>\n" ;

      foreach my $ModuleType (sort keys %{$data{Module}{$Message}{ModuleType}} ) {
         if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Data} ) {
            $html .= "<h3>" . &link_ModuleType($ModuleType) ."</h3>\n" ;
            foreach my $byte (sort keys %{$global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Data}}) {
               if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Data}{$byte}{Name} ) {
                  $html .= "<h4>byte: $byte = $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Data}{$byte}{Name}</h4>\n" ;
               } else {
                  $html .= "<h4>byte: $byte</h4>\n" ;
               }
               if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Data}{$byte}{Match} ) {
                  foreach my $Match (sort keys %{$global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Data}{$byte}{Match}}) {
                     $html .= "Match: $Match\n" ;
                     foreach my $Key (sort keys %{$global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Data}{$byte}{Match}{$Match}}) {
                        $html .= " -> $Key: $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Data}{$byte}{Match}{$Match}{$Key}\n" ;
                     }
                     $html .= "<br />\n" ;
                  }
               }
               #$html .= "<pre>\n" ;
               #$html .= Dumper \%{$global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Data}{$byte}} ;
               #$html .= "</pre>\n" ;
            }
         } else {
            $html .= "<h3>" . &link_ModuleType($ModuleType) .": not supported</h3>\n" ;
         }
      }
   } elsif ( defined $Message ) {
      $html .= "<h2>No info found for: $Message</h2>\n" ;
   }

   $html .= "<pre>\n" ;
   #$html .= Dumper \%global ;
   #$html .= Dumper \%{$data{Module}{$Message}} ;
   $html .= "</pre>\n" ;
   return $html ;
}

sub www_print_velbus_messages_print_messages () {
   my $html ;

   my %data = &www_process_messages ;

   $html .= "<h2>Broadcast messages</h2>\n" ;
   $html .= "<table border=1 class=\"datatable\">\n" ;
   $html .= "<thead>\n" ;
   $html .= "  <tr>\n" ;
   $html .= "    <th>Message</th>\n" ;
   $html .= "    <th>Name</th>\n" ;
   $html .= "    <th>Info</th>\n" ;
   $html .= "    <th>Prio</th>\n" ;
   $html .= "  </tr>\n" ;
   $html .= "</thead>\n" ;

   $html .= "<tbody>\n" ;
   foreach my $Message (sort  {$a cmp $b} keys %{$data{BroadCast}}) {
      my $Name = $data{BroadCast}{$Message}{Name} ; # Easier var
      my $Info = $data{BroadCast}{$Message}{Info} ; # Easier var
      my $Prio = $data{BroadCast}{$Message}{Prio} ; # Easier var
      $html .= "  <tr>\n" ;
      $html .= "    <th><a href=?".&www_make_url("appl=print_velbus_messages", "Message=$Message").">$Message</a></th>\n" ;
      $Name =~ s/COMMAND_//g ;
      $html .= "    <td>$Name</td>\n" ;
      $Info =~ s/;/<br \/>/g ;
      $html .= "    <td>$Info</td>\n" ;
      $html .= "    <td>$Prio</td>\n" ;
      $html .= "  </tr>\n" ;
   }
   $html .= "</tbody>\n" ;
   $html .= "</table>\n" ;

   foreach my $MessageType (sort keys %{$data{PerType}}) {
      $html .= "<h2>Module messages: type $MessageType</h2>\n" ;
      $html .= "<table border=1 class=\"datatable\">\n" ;
      $html .= "<thead>\n" ;
      $html .= "  <tr>\n" ;
      $html .= "    <th>Message</th>\n" ;
      $html .= "    <th>Name</th>\n" ;
      $html .= "    <th>Module</th>\n" ;
      $html .= "    <th>Info</th>\n" ;
      $html .= "    <th>Prio</th>\n" ;
      $html .= "  </tr>\n" ;
      $html .= "</thead>\n" ;

      $html .= "<tbody>\n" ;
      foreach my $Message (sort @{$data{PerType}{$MessageType}}) {
         my $Name = join ";", sort keys %{$data{Module}{$Message}{Name}} ;
         $Name =~ s/;/<br \/>/g ;
         my $Info = join ";", sort keys %{$data{Module}{$Message}{Info}} ;
         $Info =~ s/;/<br \/>/g ;
         my $Prio = join ";", sort keys %{$data{Module}{$Message}{Prio}} ;

         $html         .= "  <tr>\n" ;
         $html         .= "    <th><a href=?".&www_make_url("appl=print_velbus_messages", "Message=$Message").">$Message</a></th>\n" ;
         $Name =~ s/COMMAND_//g ;
         $html         .= "    <td>$Name</td>\n" ;
         $html         .= "    <td>\n" ;
         foreach my $ModuleType (sort keys %{$data{Module}{$Message}{ModuleType}} ) {
            $html .= "<a href=?" . &link_ModuleType($ModuleType) . "<br />" ;
         }
         $html         .= "    </td>\n" ;
         $html         .= "    <td>$Info</td>\n" ;
         $html         .= "    <td>$Prio</td>\n" ;
         $html         .= "  </tr>\n" ;
      }
      $html .= "</tbody>\n" ;
      $html .= "</table>\n" ;
   }

   return $html ;
}

sub www_print_velbus_protocol () {
   my $html ;
   $html .= "<h1>Velbus protocol</h1>\n" ;
   $html .= "<p>This is a list of all modules based on the published protocol files. For each module, the protocol pdf file is converted to txt and parsed. The script can found in bin/pdf2txt.pl and the result is lib/Velbus/Velbus_data_protocol_auto.pm.<br />The Channels column is based on Velbus_data_protocol_channels.pm.</p>\n" ;
   if ( defined $global{cgi}{params}{ModuleType} ) {
      $html .= &www_print_velbus_protocol_print_moduleType($global{cgi}{params}{ModuleType}) ;
   } else {
      $html .= &www_print_velbus_protocol_print_modules ;
   }
   return $html ;
}

sub www_print_velbus_protocol_print_moduleType () {
   my $ModuleType = $_[0] ;
   $html .= "<h2>$global{Cons}{ModuleTypes}{$ModuleType}{Type} ($ModuleType): $global{Cons}{ModuleTypes}{$ModuleType}{Info}</h2>\n" ;

   if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Channels} ) {
      $html .= "<h3>Available channels on module (manual defined in lib/Velbus/Velbus_data_protocol.pm)</h3>\n" ;
      $html .= "<table border=1 class=\"datatable\">\n" ;
      $html .= "<thead>\n" ;
      $html .= "  <tr>\n" ;
      $html .= "    <th>Channel</th>\n" ;
      $html .= "    <th>Name</th>\n" ;
      $html .= "  </tr>\n" ;
      $html .= "</thead>\n" ;

      $html .= "<tbody>\n" ;
      foreach my $Channel ( sort {$a cmp $b} keys (%{$global{Cons}{ModuleTypes}{$ModuleType}{Channels}}) ) {
         $html .= "  <tr>\n" ;
         $html .= "    <th>$Channel</th>\n" ;
         $html .= "    <td>$global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Name}</td>\n" ;
         $html .= "  </tr>\n" ;
      }
      $html .= "</tbody>\n" ;
      $html .= "</table>\n" ;
   } else {
      $html .= "<h3>No channels on module (manual defined in lib/Velbus/Velbus_data_protocol.pm)</h3>\n" ;
   }

   if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Messages} ) {
      $html .= "<h3>Possible messages (read from lib/Velbus/Velbus_data_protocol_auto.pm)</h3>\n" ;
      $html .= "<table border=1 class=\"datatable\">\n" ;
      $html .= "<thead>\n" ;
      $html .= "  <tr>\n" ;
      $html .= "    <th>Message</th>\n" ;
      $html .= "    <th>Name</th>\n" ;
      $html .= "    <th>Info</th>\n" ;
      $html .= "    <th>Prio</th>\n" ;
      $html .= "  </tr>\n" ;
      $html .= "</thead>\n" ;

      $html .= "<tbody>\n" ;
      my $html2 ;
      my %Messages ;

      foreach my $Message ( sort {$a cmp $b} keys (%{$global{Cons}{ModuleTypes}{$ModuleType}{Messages}}) ) {
         $html .= "  <tr>\n" ;
         $html .= "    <th>$Message</th>\n" ;
         $html .= "    <td>$global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Name}</td>\n" ;
         $html .= "    <td>$global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Info}</td>\n" ;
         $html .= "    <td>$global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Prio}</td>\n" ;
         $html .= "  </tr>\n" ;

         if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Data} ) {
            $html2 .= "<h4>Databytes for message $Message ($global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Name}: $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Info})</h4>\n" ;
            $html2 .= "<table border=1 class=\"datatable\">\n" ;
            $html2 .= "<thead>\n" ;
            $html2 .= "  <tr>\n" ;
            $html2 .= "    <th>DataByte</th>\n" ;
            $html2 .= "    <th>Name</th>\n" ;
            $html2 .= "    <th>Type</th>\n" ;
            $html2 .= "    <th>Parser: result</th>\n" ;
            $html2 .= "  </tr>\n" ;
            $html2 .= "</thead>\n" ;

            $html2 .= "<tbody>\n" ;
            foreach my $DataByte (  sort {$a cmp $b} keys (%{$global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Data}}) ) {
               $html2 .= "  <tr>\n" ;
               $html2 .= "    <th>$DataByte</th>\n" ;
               $html2 .= "    <td>$global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Data}{$DataByte}{Name}</td>\n" ;
               $html2 .= "    <td>$global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Data}{$DataByte}{Type}</td>\n" ;
               $html2 .= "    <td>\n" ;
               foreach my $Parser ( sort {$a cmp $b} keys (%{$global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Data}{$DataByte}{Match}}) ) {
                  $html2 .= "$Parser: $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Data}{$DataByte}{Match}{$Parser}{Value}<br />\n" ;
               }
               $html2 .= "    </td>\n" ;
               $html2 .= "  </tr>\n" ;
            }
            $html2 .= "</tbody>\n" ;
            $html2 .= "</table>\n" ;
         }
      }
      $html .= "</tbody>\n" ;
      $html .= "</table>\n" ;
      $html .= $html2 if defined $html2 ;
   } else {
      $html .= "<h3>No messages (read from lib/Velbus/Velbus_data_protocol_auto.pm)</h3>\n" ;
   }

   return $html ;
}

sub www_print_velbus_protocol_print_modules () {
   my $html ;
   $html .= "<table border=1 data-paging=false class=\"datatable\">\n" ;
   $html .= "<thead>\n" ;
   $html .= "  <tr>\n" ;
   $html .= "    <th>Type</th>\n" ;
   $html .= "    <th>Module</th>\n" ;
   $html .= "    <th>Version</th>\n" ;
   $html .= "    <th>Memory</th>\n" ;
   $html .= "    <th>Module name</th>\n" ;
   $html .= "    <th>Channels</th>\n" ;
   $html .= "  </tr>\n" ;
   $html .= "</thead>\n" ;

   foreach my $ModuleType (sort {$a cmp $b} keys (%{$global{Cons}{ModuleTypes}})) {
      $html .= "  <tr>\n" ;
      $html .= "    <td>$ModuleType</td>\n" ;
      $html .= "    <td>" . &link_ModuleType($ModuleType) . "</td>\n" ;
      $html .= "    <td><a href=\"protocol/$global{Cons}{ModuleTypes}{$ModuleType}{File}\">$global{Cons}{ModuleTypes}{$ModuleType}{Version}</a></td>\n" ;
      $html .= "    <td>" ;
      if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{MemoryMatch} ) {
         foreach my $Key (sort keys %{$global{Cons}{ModuleTypes}{$ModuleType}{MemoryMatch}}) {
            $html .= "$global{Cons}{ModuleTypes}{$ModuleType}{MemoryMatch}{$Key}{Build}: $global{Cons}{ModuleTypes}{$ModuleType}{MemoryMatch}{$Key}{Version}<br>\n" ;
         }
      }
      $html .= "    </td>" ;
      my $ModuleName ;
      if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Memory} ) {
         foreach my $Key (sort keys %{$global{Cons}{ModuleTypes}{$ModuleType}{Memory}}) {
            $ModuleName .= $Key . " " ;
         }
      }
      if ( defined $ModuleName ) {
         $html .= "    <td>$ModuleName</td>\n" ;
      } else {
         $html .= "    <td>-</td>\n" ;
      }
      if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Channels} ) {
         $html .= "    <td>Yes</td>\n" ;
      } else {
         $html .= "    <td>-</td>\n" ;
      }
      $html .= "  </tr>\n" ;
   }

   $html .= "<tbody>\n" ;
   $html .= "</tbody>\n" ;
   $html .= "</table>\n" ;
   return $html ;
}

sub www_generate_openHAB () {
   &openHAB_parse_config () ;
   my $openHAB = &openHAB_config () ;
   $openHAB =~ s/</&lt;/g ;    # Prepare for html output
   $openHAB =~ s/>/&gt;/g ;    # Prepare for html output
   $openHAB =~ s/\n/<br>\n/g ; # Prepare for html output
   return "$openHAB\n" ;
}

sub www_scan_for_modules () {
   my $html = "<p>Scanning for modules</p>\n" ;
   my $sock = &open_socket ;
   &scan($sock) ;
   $html .= "<p><a href=?".&www_make_url("*=-","appl=print_found_modules").">Check the Found modules page and trigger an update of all module</a></p>\n" ;
   return $html ;
}

sub www_empty_database  () {
   my $html ;
   if ( defined $_[0] and $_[0] eq "DO" ) {
      $html .= "<p><b>Database cleared!</b></p>\n" ;
      &empty_database() ;
   }
   $html .= "Recommended procedure:\n" ;
   $html .= "<ul>\n" ;
   $html .= "<li>Stop logger.pl</li>\n" ;
   $html .= "<li><a href=?".&www_make_url("*=-","appl=empty_database_DO").">Click this link to clear all data in the database</a></li>\n" ;
   $html .= "<li>Start logger.pl</li>\n" ;
   $html .= "<li><a href=?".&www_make_url("*=-","appl=scan_for_modules").">Trigger a scan</a> </li>\n" ;
   $html .= "<li><a href=?".&www_make_url("*=-","appl=print_found_modules").">Get an update of all module</a></li>\n" ;
   $html .= "</ul>\n" ;
   return $html ;
}

sub www_update_module_status () {
   my $sock = &open_socket ;
   my $temp = &update_module_status($sock) ;
   return $temp ;
}

# Loop all modules and messages and sort the info per message
sub www_process_messages () { 
   my %data ;

   # Loop all broadcast messages
   foreach my $Message (sort (keys %{$global{Cons}{MessagesBroadCast}}) ) {
      my $Name = $global{Cons}{MessagesBroadCast}{$Message}{Name} ; # Easier var
      my $Info = $global{Cons}{MessagesBroadCast}{$Message}{Info} ; # Easier var
      my $Prio = $global{Cons}{MessagesBroadCast}{$Message}{Prio} ; # Easier var
      $data{BroadCast}{$Message}{Name} = $Name ;
      $data{BroadCast}{$Message}{Info} = $Info ;
      $data{BroadCast}{$Message}{Prio} = $Prio ;
   }

   # Loop all Modules and Message
   foreach my $ModuleType (sort {$a cmp $b} keys (%{$global{Cons}{ModuleTypes}})) {
      foreach my $Message ( sort {$a cmp $b} keys (%{$global{Cons}{ModuleTypes}{$ModuleType}{Messages}}) ) {
         foreach my $Name (split ";", $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Name}) {
            $data{Module}{$Message}{Name}{$Name} = "yes" ;
         }
         my $Info = $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Info} ; # Easier var
         my $Prio = $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Prio} ; # Easier var
         $data{Module}{$Message}{ModuleType}{$ModuleType} = "yes" ;
         $data{Module}{$Message}{Info}{$Info} = "yes";
         $data{Module}{$Message}{Prio}{$Prio} = "yes";
      }
   }

   # Loop the messages and try to find a type to sort the messages
   foreach my $Message (sort {$a cmp $b} keys %{$data{Module}}) {
      my $MessageType = "rest" ;
      my $Name = join ";", sort keys %{$data{Module}{$Message}{Name}} ;
      if ( $Name =~ /_STATUS/ ) {
         $MessageType = "Status" ;
      } elsif ( $Name =~ /_PROGRAM/ ) {
         $MessageType = "Program" ;
      } elsif ( $Name =~ /_MEMORY/ ) {
         $MessageType = "Memory" ;
      } elsif ( $Name =~ /_NAME_/ ) {
         $MessageType = "Name" ;
      } elsif ( $Name =~ /DIM/ ) {
         $MessageType = "Dimmer" ;
      } elsif ( $Name =~ /RELAY_/ ) {
         $MessageType = "Relay" ;
      } elsif ( $Name =~ /BLIND_/ ) {
         $MessageType = "Blind" ;
      }
      push @{$data{PerType}{$MessageType}}, $Message ;
   }

   return %data ;
}

sub link_ModuleType () {
   my $ModuleType = $_[0] ;
   if ( defined $ModuleType and defined $global{Cons}{ModuleTypes}{$ModuleType} ) {
      return "<a href=?".&www_make_url("appl=print_velbus_protocol","ModuleType=$ModuleType").">$global{Cons}{ModuleTypes}{$ModuleType}{Type} ($ModuleType)</a>: $global{Cons}{ModuleTypes}{$ModuleType}{Info}" ;
   }
}
return 1 ;
