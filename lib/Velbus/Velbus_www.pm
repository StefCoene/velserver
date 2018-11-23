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
   $content .= "<a href=?".&www_make_url("*=-","appl=print_modules").">Modules on bus</a> || " ;
   $content .= "<a href=?".&www_make_url("*=-","appl=print_channeltags").">Channel tags</a> || " ;
   $content .= "<a href=?".&www_make_url("*=-","appl=print_velbus_protocol").">Velbus protocol</a> || " ;
   $content .= "<a href=?".&www_make_url("*=-","appl=print_velbus_messages").">Velbus messages</a> || " ;
   $content .= "<a href=?".&www_make_url("*=-","appl=print_velbus_actions").">Velbus actions</a> || " ;
   $content .= "<a href=?".&www_make_url("*=-","appl=openHAB").">openHAB config</a> || " ;
   $content .= "<a href=?".&www_make_url("*=-","appl=scan").">Scan the bus</a> || " ;
   $content .= "<a href=?".&www_make_url("*=-","appl=clear_database").">Clear the database</a> " ;
   $content .= "</p>\n" ;

   if ( $global{cgi}{params}{appl} eq "print_modules" ) {
      if ( defined $global{cgi}{params}{action} ) {
         if ( $global{cgi}{params}{action} eq "status" ) {
            $content .= &www_update_module_status ;
         }
      }
      $content .= &www_print_modules ;
   }
   if ( $global{cgi}{params}{appl} eq "print_channeltags" ) {
      $content .= &www_print_channeltags ;
   }
   if ( $global{cgi}{params}{appl} eq "print_velbus_protocol" ) {
      $content .= &www_print_velbus_protocol ;
   }
   if ( $global{cgi}{params}{appl} eq "print_velbus_messages" ) {
      $content .= &www_print_velbus_messages ;
   }
   if ( $global{cgi}{params}{appl} eq "print_velbus_actions" ) {
      $content .= &www_print_velbus_actions ;
   }
   if ( $global{cgi}{params}{appl} eq "openHAB" ) {
      $content .= &www_openHAB ;
   }
   if ( $global{cgi}{params}{appl} eq "scan" ) {
      $content .= &www_scan ;
   }
   if ( $global{cgi}{params}{appl} eq "clear_database" ) {
      $content .= &www_clear_database ;
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

   # Save the original request parameters
   foreach (keys %{$global{cgi}{params}}) {
      $json{"Req$_"} = $global{cgi}{params}{$_} ;
   }

   my $address ;
   my $ModuleType ; # Type of the module, based on $address
   # Parse options: find the moduletype based on the supplied address
   if ( defined $global{cgi}{params}{address} ) {
      $address = $global{cgi}{params}{address} ;
      if ( defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} and $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} ne '' ) {
         $ModuleType = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} ;
         $json{ModuleType} = $ModuleType ;
      }
   }

   my $action ;
   if ( defined $global{cgi}{params}{action} ) {
      $action = $global{cgi}{params}{action} ;
   }

   my $value ;
   if ( defined $global{cgi}{params}{value} ) {
      $value = $global{cgi}{params}{value} ;
   }

   # Put the time on the bus
   if ( defined $action and $action eq "TimeSync" ) {
      &broadcast_datetime($sock) ;

   # Set memo text: only for VMBGPOD
   } elsif ( defined $action and $action eq "Memo" ) {
      # We need an address
      if ( ! defined $address ) {
         $json{Error} = "NO_ADDRESS" ;

      } elsif ( defined $ModuleType and $ModuleType eq "28" ) {
         if ( defined $value ) {
            &send_memo ($sock, $address, $value) ;
            $json{Text} = $value ;
         } else {
            &send_memo ($sock, $address) ;
         }

      } elsif ( defined $ModuleType ) {
         $json{Error} = "WRONG_MODULETYPE" ;

      } else {
         $json{Error} = "NO_MODULETYPE" ;
      }

   # The rest is for getting and setting.
   } elsif ( defined $global{cgi}{params}{type} ) {
      my $ActionType = $global{cgi}{params}{type} ;

      # 1: if we have a type, it should be defined in $global{Cons}{ActionType}
      if ( ! defined $global{Cons}{ActionType}{$ActionType} ) {
         $json{Error} = "UNSUPPORTED_TYPE" ;

      # 2: we need an address
      } elsif ( ! defined $global{cgi}{params}{address} ) {
         $json{Error} = "NO_ADDRESS" ;

      # 3: we need a module type (based on parameter address)
      } elsif ( ! defined $ModuleType ) {
         $json{Error} = "NO_MODULETYPE" ;

      # 4: the module type should be supported for the type
      } elsif ( ! defined $global{Cons}{ActionType}{$ActionType}{Module}{$ModuleType} ) {
         $json{Error} = "MODULETYPE_NOT_SUPPORTED" ;

      # 5: we also need an action
      } elsif ( ! defined $action ) {
         $json{Error} = "NO_ACTION" ;

      # 6: If action = Set we need a value
      } elsif ( $action eq "Set" and ! defined $value ) {
         $json{Error} = "NO_VALUE_FOR_SET" ;

      } else {
         my $Setaction ;

         # For blinds, the value is used to set Setacion
         if ( $ActionType eq "Blind" and $action eq "Set" ) {
            if ( $value eq "UP" ) {
               $Setaction = "Up" ;
            } elsif ( $value eq "DOWN" ) {
               $Setaction = "Down" ;
            } elsif ( $value eq "STOP" ) {
               $Setaction = "Stop" ;
            } elsif ( $value =~ /(\d+)/ ) {
               $value = $1 ;
               if ( $value >= 0 and $value <= 100 ) {
                  $Setaction = "Position" ;
               } else {
                  undef $value ;
               }
            }
         }

         # 7: the action should be supported for the type
         if ( ! defined $global{Cons}{ActionType}{$ActionType}{Module}{$ModuleType}{Action}{$action} ) {
            $json{Error} = "ACTION_NOT_SUPPORTED:$ActionType:$action" ;

         # If there is a SetAction, it should be supported for the type
         } elsif ( defined $Setaction and ! $global{Cons}{ActionType}{$ActionType}{Module}{$ModuleType}{SetAction}{$SetAction} ) {
            $json{Error} = "SETACTION_NOT_SUPPORTED:$ActionType:$action:$SetAction" ;

         } else {
            # If we need something regarding the temperature, we set the channel ourself
            my $Channel ;
            if ( $ActionType eq "Temperature" or
                 $ActionType eq "TemperatureCoHeMode" or
                 $ActionType eq "TemperatureMode" or
                 $ActionType eq "TemperatureTarget" ) {
               $Channel = $global{Cons}{ModuleTypes}{$ModuleType}{TemperatureChannel} ;
            } elsif ( defined $global{cgi}{params}{channel} ) {
               $Channel = $global{cgi}{params}{channel} ;
            }

            if ( ! defined $Channel ) {
               $json{Error} = "NO_CHANNEL" ;

            } else {
               my %data = &fetch_data ($global{dbh},"select * from modules_channel_info where `address`=? and `channel`=?","data",$address,$Channel) ;
               $json{Name} = $data{Name}{value} if defined $data{Name} ;

               # We don't bother in setting the blind channels by some alghorithm, but just set them in the code
               # For the 2 other blind modules, the channel numbering is normal.
               if ( $ActionType eq "Blind" and $action eq "Set" ) {
                  if ( $ModuleType eq "03" ) {
                     $Channel = "0x03" ; # B‘00000011’
                  }
                  if ( $ModuleType eq "09" ) {
                     if ( $Channel eq "01" ) {
                        $Channel = "0x03" ; # B’00000011’
                     }
                     if ( $Channel eq "02" ) {
                        $Channel = "0x0C" ; # B’00001100’
                     }
                  }
               }

               # Parse the value
               if ( $action eq "Set" ) {
                  # Parse the value for the Dimmer type
                  if ( $ActionType eq "Dimmer" ) {
                     if ( $value eq "ON" ) {
                        $value = "100" ;
                     } elsif ( $value eq "OFF" ) {
                        $value = "0" ;
                     } elsif ( $value =~ /(\d+)/ ) {
                        $value = $1 ;
                        if ( $value >= 0 and $value <= 100 ) {
                        } else {
                           undef $value ;
                        }
                     } else {
                        undef $value ;
                     }
                  }

                  # Parse the value for the TemperatureCoHeMode type
                  if ( $ActionType eq "TemperatureCoHeMode" ) {
                     if ( $value eq "1" or $value eq "0" ) {
                     } else {
                        undef $value ;
                     }
                  }

                  # Parse the value for the TemperatureMode type
                  if ( $ActionType eq "TemperatureMode" ) {
                     if ( $value eq "1" or $value eq "2" or $value eq "3" or $value eq "4" ) {
                     } else {
                        undef $value ;
                     }
                  }

                  # Parse the value for the TemperatureTarget type
                  if ( $ActionType eq "TemperatureTarget" ) {
                     if ( $value =~ /(\d+\.\d+)/ or $value =~ /(\d+)/ ) {
                        $value = $1 ;
                     } else {
                        undef $value ;
                     }
                  }
               }

               ###################################################
               # Get/Set Blind positoin
               if ( $ActionType eq "Blind" ) {
                  if (      $Setaction eq "Up" ) {
                     &blind_up   ($sock, $address, $Channel) ;
                     $json{Status} = $Setaction ;
                  } elsif ( $Setaction eq "Down" ) {
                     &blind_down ($sock, $address, $Channel) ;
                     $json{Status} = $Setaction ;
                  } elsif ( $Setaction eq "Stop" ) {
                     &blind_stop ($sock, $address, $Channel) ;
                     $json{Status} = $Setaction ;
                  } elsif ( $Setaction eq "Position" and defined $value ) {
                     &blind_pos  ($sock, $address, $Channel, $value) ;
                     $json{Status} = $value ;
                  } elsif ( $action eq "Get" ) {
                     $json{Status} = $data{Position}{value} if defined $data{Position} ;
                  } else {
                     $json{Error} = "INCORRECT_VALUE" ;
                  }

               # Get Counter : only for VMB7IN
               } elsif ( $ActionType eq "Counter" ) {
                  if ( $action eq "Get" ) {
                     $json{Status} = $data{Counter}{value}        if defined $data{Counter} ;
                  } elsif ( $action eq "GetCurrent" ) {
                     $json{Status} = $data{CounterCurrent}{value} if defined $data{CounterCurrent} ;
                  } elsif ( $action eq "GetDivider" ) {
                     $json{Status} = $data{Divider}{value}        if defined $data{Divider} ;
                  } elsif ( $action eq "GetRaw" ) {
                     $json{Status} = $data{CounterRaw}{value}     if defined $data{CounterRaw} ;
                  }

               # Get/Set Dimmer level
               } elsif ( $ActionType eq "Dimmer" ) {
                  if ( $action eq "Set" and defined $value ) {
                     &dim_value ($sock, $address, $Channel, $value) ;
                     $json{Status} = $value ;
                  } elsif ( $action eq "Get" ) {
                     $json{Status} = $data{Dimmer}{value} if defined $data{Dimmer}{value} ;
                  } else {
                     $json{Error} = "INCORRECT_VALUE" ;
                  }

               # Get/Set Relay status
               } elsif ( $ActionType eq "Relay" ) {
                  if ( $action eq "Set" and defined $value ) {
                     if ( $value eq "ON" ) {
                        &relay_on ($sock, $address, $Channel) ;
                        $json{Status} = "ON" ;
                     } elsif ( $value eq "OFF" ) {
                        &relay_off ($sock, $address, $Channel) ;
                        $json{Status} = "OFF" ;
                     }
                  } elsif ( $action eq "Get" ) {
                     if ( defined $data{'Relay status'} ) {
                        if ( $data{'Relay status'}{value}      eq "Relay channel off" ) {
                           $json{Status} = "OFF" ;
                        } elsif ( $data{'Relay status'}{value} eq "Relay channel on" ) {
                           $json{Status} = "ON" ;
                        }
                     }
                  } else {
                     $json{Error} = "INCORRECT_VALUE" ;
                  }

               # Get SensorNumber: only for VMB4AN
               } elsif ( $ActionType eq "SensorNumber" ) {
                  $json{Status} = $data{SensorNumber}{value} if defined $data{SensorNumber} ;

               # Sensor
               } elsif ( $ActionType eq "Sensor" ) {
                  if ( $action eq "Get" ) {
                     $json{Status} = $data{Button}{value} if defined $data{Button} ;
                  } else {
                     $json{Error} = "INCORRECT_VALUE" ;
                  }

               # Get/Set button: touch, input, sensors, ...
               } elsif ( $ActionType eq "Button" ) {
                  if ( $action eq "Set" and defined $value and $value eq "ON" ) {
                     &button_pressed ($sock, $address, $Channel) ;
                     $json{Status} = $value ;
                  } elsif ( $action eq "Get" ) {
                     $json{Status} = $data{Button}{value} if defined $data{Button} ;
                  } else {
                     $json{Error} = "INCORRECT_VALUE" ;
                  }

               # Get the current temperature: touch panels & outdoor sensor
               } elsif ( $ActionType eq "Temperature" ) {
                  $json{Status} = $data{Temperature}{value} if defined $data{Temperature} ;

               # Get/Set heating or cooling: touch panels
               } elsif ( $ActionType eq "TemperatureCoHeMode" ) {
                  if ( $action eq "Set" and defined $value ) {
                     &set_temperature_cohe_mode ($sock, $address, $value) ;
                     $json{Status} = $value ;
                  } elsif ( $action eq "Get" ) {
                     if ( defined $data{'Temperature CoHe mode'} ) {
                        if ( $data{'Temperature CoHe mode'}{value} =~ /cooler/i ) {
                           $json{Status} = 1 ;
                        } elsif ( $data{'Temperature CoHe mode'}{value} =~ /heater/i ) {
                           $json{Status} = 0 ;
                        }
                     }
                  } else {
                     $json{Error} = "INCORRECT_VALUE" ;
                  }

               # Get/Set the Heater mode: touch panels
               } elsif ( $ActionType eq "TemperatureMode" ) {
                  if ( $action eq "Set" and defined $value ) {
                     &set_temperature_mode ($sock, $address, $value) ;
                     $json{Status} = $value ;
                  } elsif ( $action eq "Get" ) {
                     if ( defined $data{'Temperature mode'} ) {
                        if (      $data{'Temperature mode'}{value} =~ /comfort/i ) {
                           $json{Status} = 1 ;
                        } elsif ( $data{'Temperature mode'}{value} =~ /day/i ) {
                           $json{Status} = 2 ;
                        } elsif ( $data{'Temperature mode'}{value} =~ /night/i ) {
                           $json{Status} = 3 ;
                        } elsif ( $data{'Temperature mode'}{value} =~ /safe/i ) {
                           $json{Status} = 4 ;
                        }
                     }
                  } else {
                     $json{Error} = "INCORRECT_VALUE" ;
                  }

               # Get/Set the Cooler/Heater target temperature: touch panels
               } elsif ( $ActionType eq "TemperatureTarget" ) {
                  if ( $action eq "Set" and defined $value ) {
                     &set_temperature ($sock, $address, $value) ;
                     $json{Status} = $value ;
                  } elsif ( $action eq "Get" ) {
                     if ( defined $data{'Current temperature set'} ) {
                        $json{Status} = $data{'Current temperature set'}{value} ;
                     }
                  } else {
                     $json{Error} = "INCORRECT_VALUE" ;
                  }
               }

               $json{Error} = "NO_INFO" if ! defined $json{Status} ;
            }
         }
      }
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

sub www_print_modules () {
   my $html ;
   $html .= "<h1>All modules on bus (<a href=\"?".&www_make_url("action=status")."\">refresh status</a>)</h1>\n" ;

   my %data ;

   &process_modules ;

   foreach my $status (sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerStatus}})) {
      next if $status eq "Start scan" ;

      $html .= "<h2>Status: $status</h2>\n" ;

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
      $table .= "    <th>MemoryMap</th>\n" ;
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
      $mail_body .= "address;type;ModuleName;Build;MemoryKey;MemoryMap;\n" ;

      foreach my $address ( sort {$a cmp $b} keys (%{$global{Vars}{Modules}{PerStatus}{$status}{ModuleList}}) ) {
         my $ModuleType = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} ; # Handier var
         my $MemoryKey = &module_find_MemoryKey ($address, $ModuleType) ; # Handier var
         my $MemoryMap = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{MemoryMap} ;
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
         if ( defined $MemoryMap ) {
            if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Memory}{$MemoryMap}{ModuleName}) {
               $table .= "    <td>$MemoryMap</td>\n" ;
               $mail_body .= "$MemoryMap;" ;
            } else {
               $table .= "    <td>$MemoryMap: not found?</td>\n" ;
               $mail_body .= "$MemoryMap not found;" ;
            }
         } else {
            $table .= "    <td>No MemoryMap found!</td>\n" ;
            $mail_body .= ";" ;
         }
         $table .= "    <td>$global{Vars}{Modules}{Address}{$address}{ModuleInfo}{'date'}</td>\n" ;
         $table .= "    <td><a href=\"?".&www_make_url("action=status","address=$address")."\">refresh status</a></td>\n" ;
         $table .= "  </tr>\n" ;
         $mail_body .= "\n" ;
      }
      $table .= "</tbody>\n" ;
      $table .= "</table>\n" ;

      $mail_body =~ s/\n/%0D%0A/g ;
      if ( $status eq "Found" ) {
         $html .= "<p>Do you want to help? Send me <a href=\"mailto:velserver\@docum.org?subject=velserver detected modules&body=$mail_body\">an email</a> with the content of this table. Especially if there is an issue with the MemoryKey and MemoryMap column</p>\n" ;
      }
      $html .= $table ;
   }

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

sub www_print_channeltags () {
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

sub www_print_velbus_actions () {
   $html .= "<h1>Velbus actions</h1>\n" ;

   foreach my $ActionType (sort keys %{$global{Cons}{ActionType}} ) {
      $html .= "<h2>Action: $ActionType</h2>\n" ;
      if ( defined $global{Cons}{ActionType}{$ActionType}{Info} ) {
         $html .= $global{Cons}{ActionType}{$ActionType}{Info} ;
      }
      $html .= "<table border=\"1\">\n" ;
      $html .= "<thead>\n" ;
      $html .= "<tr>\n" ;
      $html .= "<th>Module</th>\n" ;
      $html .= "<th>Info</th>\n" ;
      $html .= "<th>Action</th>\n" ;
      $html .= "<th>SetAction</th>\n" ;
      $html .= "</tr>\n" ;
      $html .= "</thead>\n" ;
      $html .= "<tbody>\n" ;
      foreach my $ModuleType (sort keys %{$global{Cons}{ActionType}{$ActionType}{Module}} ) {
         $html .= "<tr>\n" ;
         $html .= "<th><a href=?".&www_make_url("appl=print_velbus_protocol","ModuleType=$ModuleType").">$global{Cons}{ModuleTypes}{$ModuleType}{Type} ($ModuleType)</a></th>" ;
         $html .= "<td>$global{Cons}{ModuleTypes}{$ModuleType}{Info}</td>\n" ;
         $html .= "<td>\n" ;

         foreach my $Action (sort keys %{$global{Cons}{ActionType}{$ActionType}{Module}{$ModuleType}{Action}} ) {
            $html .= "$Action" ;
            my $MessageTxt ;
            foreach my $Message (sort split " ", $global{Cons}{ActionType}{$ActionType}{Module}{$ModuleType}{Action}{$Action}) {
              $MessageTxt .= "<a href=?".&www_make_url("appl=print_velbus_messages", "Message=$Message").">$Message</a>" ;
            }
            if ( defined $MessageTxt ) {
               $html .= " ($MessageTxt)" ;
            }
            $html .= "<br />" ;
         }
         $html .= "</td>\n" ;
         $html .= "<td>\n" ;
         if ( defined $global{Cons}{ActionType}{$ActionType}{Module}{$ModuleType}{SetAction} ) {
            foreach my $SetAction (sort keys %{$global{Cons}{ActionType}{$ActionType}{Module}{$ModuleType}{SetAction}} ) {
               $html .= "$SetAction (" ;
               foreach my $Message (sort split " ", $global{Cons}{ActionType}{$ActionType}{Module}{$ModuleType}{SetAction}{$SetAction}) {
                  $html .= "<a href=?".&www_make_url("appl=print_velbus_messages", "Message=$Message").">$Message</a>" ;
               }
               $html .= ")<br />" ;
            }
         }
         $html .= "</td>\n" ;
         $html .= "</tr>\n" ;
      }
      $html .= "</tbody>\n" ;
      $html .= "</table>\n" ;
      #$html .= "<pre>\n" ;
      #$html .= Dumper \%{$global{Cons}{ActionType}{$ActionType}} ;
      #$html .= "</pre>\n" ;
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
         $html .= "<a href=?".&www_make_url("appl=print_velbus_protocol","ModuleType=$ModuleType").">$global{Cons}{ModuleTypes}{$ModuleType}{Type} ($ModuleType)</a>: $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Type}<br />" ;
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
            $html .= "<h3><a href=?".&www_make_url("appl=print_velbus_protocol","ModuleType=$ModuleType").">$global{Cons}{ModuleTypes}{$ModuleType}{Type} ($ModuleType) = $global{Cons}{ModuleTypes}{$ModuleType}{Info}</a></h3>\n" ;
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
            $html .= "<h3><a href=?".&www_make_url("appl=print_velbus_protocol","ModuleType=$ModuleType").">$global{Cons}{ModuleTypes}{$ModuleType}{Type} ($ModuleType) = $global{Cons}{ModuleTypes}{$ModuleType}{Info}</a>: not supported</h3>\n" ;
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
      my $Name = $data{BroadCast}{$Message}{Name} ; # Handier var
      my $Info = $data{BroadCast}{$Message}{Info} ; # Handier var
      my $Prio = $data{BroadCast}{$Message}{Prio} ; # Handier var
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
            $html .= "<a href=?".&www_make_url("appl=print_velbus_protocol","ModuleType=$ModuleType").">$global{Cons}{ModuleTypes}{$ModuleType}{Type} ($ModuleType)</a><br />" ;
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
   $html .= "<p>This is a list of all modules based on the published protocol files. For each module, the protocol pdf file is converted to txt and parsed. The script can found in bin/pdf2txt.pl and the result is lib/Velbus/Velbus_data_protocol_auto.pm.<br />.</p>\n" ;
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
                  $html2 .= "$Parser: $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Data}{$DataByte}{Match}{$Parser}{Info}<br />\n" ;
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
   }
   return $html ;
}

sub www_print_velbus_protocol_print_modules () {
   my $html ;
   $html .= "<table border=1 data-paging=false class=\"datatable\">\n" ;
   $html .= "<thead>\n" ;
   $html .= "  <tr>\n" ;
   $html .= "    <th>Module</th>\n" ;
   $html .= "    <th>Type</th>\n" ;
   $html .= "    <th>Info</th>\n" ;
   $html .= "    <th>Version</th>\n" ;
   $html .= "    <th>Memory</th>\n" ;
   $html .= "    <th>Module name</th>\n" ;
   $html .= "    <th>Channels</th>\n" ;
   $html .= "  </tr>\n" ;
   $html .= "</thead>\n" ;

   foreach my $ModuleType (sort {$a cmp $b} keys (%{$global{Cons}{ModuleTypes}})) {
      $html .= "  <tr>\n" ;
      $html .= "    <th>$ModuleType</th>\n" ;
      $html .= "    <td><a href=?".&www_make_url("ModuleType=$ModuleType").">$global{Cons}{ModuleTypes}{$ModuleType}{Type}</a></td>\n" ;
      $html .= "    <td>$global{Cons}{ModuleTypes}{$ModuleType}{Info}</td>\n" ;
      $html .= "    <td>$global{Cons}{ModuleTypes}{$ModuleType}{Version}</td>\n" ;
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

sub www_openHAB () {
   &openHAB_parse_config () ;
   my $openHAB = &openHAB_config () ;
   $openHAB =~ s/</&lt;/g ;    # Prepare for html output
   $openHAB =~ s/>/&gt;/g ;    # Prepare for html output
   $openHAB =~ s/\n/<br>\n/g ; # Prepare for html output
   return "$openHAB\n" ;
}

sub www_scan () {
   my $sock = &open_socket ;
   &scan($sock) ;
}

sub www_clear_database  () {
   my $html ;
   $html .= "Recommended procedure:\n" ;
   $html .= "<ul>\n" ;
   $html .= "<li>Stop logger.pl</li>\n" ;
   $html .= "<li>Visit this page</li>\n" ;
   $html .= "<li>Start logger.pl</li>\n" ;
   $html .= "<li>Trigger a scan</li>\n" ;
   $html .= "<li>Get an update of all module</li>\n" ;
   $html .= "</ul>\n" ;
   &clear_database() ;
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
      my $Name = $global{Cons}{MessagesBroadCast}{$Message}{Name} ; # Handier var
      my $Info = $global{Cons}{MessagesBroadCast}{$Message}{Info} ; # Handier var
      my $Prio = $global{Cons}{MessagesBroadCast}{$Message}{Prio} ; # Handier var
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
         my $Info = $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Info} ; # Handier var
         my $Prio = $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$Message}{Prio} ; # Handier var
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

return 1 ;
