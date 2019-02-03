# Some Velbus related helper functions used by the other modules

# Process incoming message: convert from bin to dec and do some valid checking with the checksum
sub process_raw_message {
   my $message = $_[0] ;

   # convert string into array
   my @message_bin = split(//,$message) ;

   my @message_dec = &message_bin_to_dec (@message_bin) ; # Convert into something readable

   # This is tricky: when flooding the bus during a scan, some of the reads from the socket contains multiple messages.
   # So we split them up and parse them 1 by 1.
   my @message_hex = &message_dec_to_hex(@message_dec) ; # Convert to hex
   my $message  = join " ", @message_hex ;
   $message =~ s/ 04 0F FB / 04;0F FB /g  ; # Adding a ; between the messages: every messages ends with 04 and every message starts with 0F FB
   $message =~ s/ 04 0F F8 / 04;0F F8 /g  ; # Adding a ; between the messages: every messages ends with 04 and every message starts with 0F F8

   my @message_hex_split = split ";", $message ;
   foreach my $message_hex (@message_hex_split) { # Loop over the messages
      my @message_dec = &message_hex_to_dec(split " ", $message_hex) ; # We need the message in dec for checksum calculation
      my $check = &check_valid(@message_dec) ;

      if ( $check ) {
         @message_hex = split (" ", $message_hex) ;
         &process_message (@message_hex) ;
      } else {
         print "Packet checksum not valid: $message_hex\n" ;
      }
   }
}

# Incoming data on socket is in bin, so we convert it to dec for checksum calculation
sub message_bin_to_dec {
   my @data = @_ ;
   my @return ;
   # convert the array into a usefull format
   for (my $k=0; $k<@data; $k++){
      $return[$k] = ord($data[$k]) ;
   }
   return @return ;
}

sub message_dec_to_hex {
   my @data = @_ ;
   my @return ;
   for (my $k=0; $k<@data; $k++) {
      $return[$k] = sprintf ("%02X",$data[$k]) ;
   }
   return @return ;
}

sub message_hex_to_dec {
   my @data = @_ ;
   my @return ;
   for (my $k=0; $k<@data; $k++) {
      $return[$k] = &hex_to_dec ($data[$k]) ;
   }
   return @return ;
}

# Make a message so it can be transmitted to the bus
sub make_message {
   my @message = @_ ;
   my $message_length = @message ; # Length of @message

   # Loop over the message and convert hex numbers to decimal if required
   for ($index=0; $index<=$#message; $index++) {
      if ( $message[$index] =~ /0x/ ) {
         $message[$index] = &hex_to_dec ($message[$index]) ;
      }
   }

   # Build new message in @message_new
   my @message_new = () ;
   $message_new[0] = &hex_to_dec ("0x0F") ;
   $message_new[1] = $message[0] ;
   $message_new[2] = $message[1] ;
   $message_new[3] = ($message[2] & 240) | (($message_length-3) & 15) ;

   for (my $make_count = 0; $make_count <= ($message_length-3); $make_count++) {
      $message_new[$make_count+4] = $message[$make_count+3] ;
   }

   # Calculating checksum and finalizing new message
   my $checksum = &calc_checksum_send(@message_new) ;
   $message_new[$message_length+1] = $checksum ;
   $message_new[$message_length+2] = &hex_to_dec ("0x04") ;

   # Convert to character
   for ($index=0; $index<=$#message_new; $index++) {
      $message_new[$index] = chr ($message_new[$index]) ;
   }

   my $message_new = join('',@message_new) ;
   return $message_new ;
}

# Convert a given temperature to the hex values
# Used when transmitting a new desired temperature to a sensor
sub temperature_to_hex {
   my $temperature = $_[0] ;
   my $first = 0 ;
   if ( $temperature < 0 ) {
      $first = 1 ;
      $temperature = $temperature + 64 ;
   }
   $temperature = $temperature / 0.0625 ;
   $temperature = $temperature / 8 ;
   $temperature = sprintf ("%07b", $temperature) ;

   $temperature = $first . $temperature ;

   $temperature = sprintf("%02X", &bin_to_dec ($temperature) ) ;
   return $temperature ;
}

# Convert a binary numer (8 bits) to a number
# Used when reading temperature settings
# From the docs, but this is not correct. The possitive numbers are ok (except for 63.5) , but the negative numbers:
#    0 1111111  111 00000     63.5    = 1016 x 0.0625   1016 in bin = 01111111
#    0 0000001  000 xxxxx      0.5    =    8 x 0.0625
#    0 0000000  100 xxxxx      0.25   =    4 x 0.0625
#    0 0000000  010 xxxxx      0.125  =    2 x 0.0625
#    0 0000000  001 xxxxx      0.0625 =    1 x 0.0625
#    0 0000000  000 xxxxx      0
#    1 1111111  110 xxxxx     -0.0625 =   1 x 0.0625   1
#    1 1111111  100 xxxxx     -0.125  =   2 x 0.0625   2 + 1 = 3
#    1 1111111  010 xxxxx     -0.25   =   4 x 0.0625   4 + 0 + 1 = 5
#    1 1111110  000 xxxxx     -0.5    =   8 x 0.0625   8 + 4 + 2 + 1 = 15
#    1 0010010  000 xxxxx    -55      = 880 x 0.0625  512 + 256 + 0 + 64 + 32 + 0 + 8 + 4 + 2 + 1 = 879
sub hex_to_temperature {
   my @temperature = @_ ;

   # If no second byte is given, use 0x00
   if ( ! defined $temperature[1] ) {
      $temperature[1] = "0x00" ;
   }

   $temperature[0] = &hex_to_bin ($temperature[0]) ;
   $temperature[1] = &hex_to_bin ($temperature[1]) ;
   $temperature = $temperature[0] . $temperature[1] ;

   # Last 5 digits are not used if we get 2 bytes.
   if ( $temperature =~ s/(...........)...../$1/ ) {
   } else {
      $temperature = $temperature . "000" ;
   }

   my $negative ;
   # If first number is 1, this is a negative number
   # Strip the first 1 and swap 0 and 1
   if ( $temperature =~ s/^1//g ) {
      $negative = 1 ;
      $temperature =~ s/0/2/g ;
      $temperature =~ s/1/0/g ;
      $temperature =~ s/2/1/g ;
   }  
   $temperature = &bin_to_dec ($temperature) ;
   $temperature = $temperature * 0.0625 ;
   if ( $negative ) {
      $temperature = 0 - $temperature ;
   }  
   return $temperature ; 
}

# Calculate checksum from message and return the checksum
sub calc_checksum {
   my @check_array = @_ ;

   pop @check_array ; # Last 2 elements of message are not part of the checksum
   pop @check_array ; # Last 2 elements of message are not part of the checksum

   my $check_return = 0 ;
   foreach my $check_array (@check_array) {
      $check_return += $check_array ;
   }
   $check_return *= -1 ;
   $check_return = $check_return & 255 ;
   return $check_return ;
}

# Calculate checksum from message and return the checksum
sub calc_checksum_send {
   my @check_array = @_ ;

   my $check_return = 0 ;
   foreach my $check_array (@check_array) {
      $check_return += $check_array ;
   }
   $check_return *= -1 ;
   $check_return = $check_return & 255 ;
   return $check_return ;
}

# Check to see if the checksum of a message is OK
sub check_valid {
   my @check_array = @_ ;
   my $check_return = 0 ;
   my $check_size = @check_array ;

   if (($check_array[0] eq 15) && ($check_array[$check_size-1] eq 4)) {
      if (&calc_checksum(@check_array) eq $check_array[$check_size-2]) {
         $check_return = 1 ;
      }
   }
   return $check_return ;
}

# open a socket to a Velbus server
# Param 1: server (default = localhost)
# Param 2: port (default = 3788)
# Return: socket
sub open_socket () {
   my $sock = new IO::Socket::INET(
         PeerAddr => $global{Config}{velbus}{HOST},
         PeerPort => $global{Config}{velbus}{PORT},
         Proto    => 'tcp'
      );

   if ( $sock ) {
      $sock->autoflush(1);
   } else {
      # Do not print an error, but trap an error in the calling function
      #print "No connection to $global{Config}{velbus}{HOST} port $global{Config}{velbus}{PORT}: $!\n" ;
   }
   return $sock ;
}

# Print something to the socket.
sub print_sock {
   my $sock = shift (@_) ;
   my @message = @_ ;
   #usleep (20000) ;
   print $sock &make_message(@message);
}

# Read a config file
sub read_config {
   my $config = $_[0] ;
   my $file = "$global{BaseDir}/etc/".$config.".cfg" ;

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

sub dec_to_hex {
   my $dec = $_[0] ;
   return sprintf ("%02X",$dec) ;
}

sub dec_to_4hex {
   my $dec = $_[0] ;
   return sprintf ("%04X",$dec) ;
}

sub hex_to_bin {
   my $hex = $_[0] ;
   return sprintf ("%08b",hex $hex) ;
}

sub hex_to_dec {
   my $hex = $_[0] ;
   return sprintf ("%02d", hex $hex) ;
}

sub bin_to_hex {
   my $hex = $_[0] ;
   &dec_to_hex(&bin_to_dec($hex)) ;
}

sub bin_to_dec {
   return unpack("N", pack("B32", substr("0" x 32 . shift, -32)));
}

# Convert a channel index to a hex number. Channel 4 -> 1000 -> 0x08
sub channel_to_hex {
   my $channel = $_[0] ;
   $channel -- ;
   $chennel = "1" . "0" x $channel ;
   $channel = &bin_to_hex ($chennel) ;
   return $channel ;
}

# Push a change of an item to openHAB
sub openHAB_update_state {
   my $name = $_[0] ;
   my $data = $_[1] ;

   &log("openHAB","$name: $data") ;

   my $URL = "$global{Config}{openHAB}{REST_URL}/$name/state" ;

   # Create the browser that will post the information.
   my $Browser = new LWP::UserAgent;

   my $Page = $Browser->request(PUT $URL,
      Content_Type => 'text/plain',
      Content => "$data"
   ) ;

   my $content = $Page->content ;
}

# Get a pretty printed timestamp, used for logging
sub timestamp {
   my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time) ;
   $mon += 1 ;
   $year += 1900 ;
   if ( $hour < "10" ) { $hour = "0$hour" }
   if ( $min  < "10" ) { $min  = "0$min"  }
   if ( $sec  < "10" ) { $sec  = "0$sec"  }
   if ( $mon  < "10" ) { $mon  = "0$mon"  }
   if ( $mday < "10" ) { $mday = "0$mday" }
   my $timestamp = $year."-".$mon."-".$mday."_".$hour."-".$min."-".$sec ;
   return $timestamp ;
}

# Calculate the Channel based on te address and sub address
# Never used
sub SubAddr_Channel {
   my $address = shift ;
   my $SubAddr = shift ;
   my $Channel = shift ;
   if ( defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{SubAddr1} and
      $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{SubAddr1} eq "$SubAddr" ) {
      $Channel = &hex_to_dec($Channel) + 8 ;
   }
   if ( defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{SubAddr2} and
      $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{SubAddr2} eq "$SubAddr" ) {
      $Channel = &hex_to_dec($Channel) + 16 ;
   }
   if ( defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{SubAddr3} and
      $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{SubAddr3} eq "$SubAddr" ) {
      $Channel = &hex_to_dec($Channel) + 24 ;
   }
   $Channel = &dec_to_hex($Channel) ;
   return $Channel ;
}

# Parse and rewrite the memory addresses for ModuleName and SensorName so we nnow for each possible memory address what it contains.
sub find_memory_addresses {
   foreach my $Type (sort keys %{$global{Cons}{ModuleTypes}}) {
      if ( defined $global{Cons}{ModuleTypes}{$Type}{Memory} ) {
         foreach my $MemoryKey (sort keys %{$global{Cons}{ModuleTypes}{$Type}{Memory}}) {
            if ( defined $global{Cons}{ModuleTypes}{$Type}{Memory}{$MemoryKey}{ModuleName} ) {
               my $counter = 0 ; # Number of address
               my $AddressHex ; # The address in hex

               my @ModuleNameAddress ; # To store all addresses
               foreach my $loop (split ";", $global{Cons}{ModuleTypes}{$Type}{Memory}{$MemoryKey}{ModuleName}) {
                  my ($start,$end) = split "-", $loop ;
                  $start = &hex_to_dec ($start) ;
                  $end   = &hex_to_dec ($end) ;
                  for ($i="$start"; $i <= "$end"; $i++) {
                     $AddressHex = &dec_to_4hex($i) ;
                     push @ModuleNameAddress, $AddressHex ;
                     if ( $counter eq "0" ) {
                        # First address
                        $global{Cons}{ModuleTypes}{$Type}{Memory}{$MemoryKey}{Address}{"$AddressHex"}{ModuleName} = "$counter:Start" ;
                     } else {
                        $global{Cons}{ModuleTypes}{$Type}{Memory}{$MemoryKey}{Address}{"$AddressHex"}{ModuleName} = "$counter" ;
                     }
                     $counter ++ ;
                  }
               }

               # Save all addresses for the get_status procedure
               $global{Cons}{ModuleTypes}{$Type}{Memory}{$MemoryKey}{ModuleNameAddress} = join ";", @ModuleNameAddress ;

               # Remember last adress
               $global{Cons}{ModuleTypes}{$Type}{Memory}{$MemoryKey}{Address}{"$AddressHex"}{ModuleName} = "$counter:Save" ;
            }

            if ( defined $global{Cons}{ModuleTypes}{$Type}{Memory}{$MemoryKey}{SensorName} ) {
               foreach my $Channel (sort keys %{$global{Cons}{ModuleTypes}{$Type}{Memory}{$MemoryKey}{SensorName}}) {
                  my $counter = 0 ; # Number of address
                  my $AddressHex ; # The address in hex

                  my @SensorNameAddress ; # To store all addresses
                  foreach my $loop (split ";", $global{Cons}{ModuleTypes}{$Type}{Memory}{$MemoryKey}{SensorName}{$Channel}) {
                     #print "loop $loop\n" ;
                     my ($start,$end) = split "-", $loop ;
                     $start = &hex_to_dec ($start) ;
                     $end   = &hex_to_dec ($end) ;
                     for ($i="$start"; $i <= "$end"; $i++) {
                        $AddressHex = &dec_to_4hex($i) ;
                        push @SensorNameAddress, $AddressHex ;
                        if ( $counter eq "0" ) {
                           # First address
                           $global{Cons}{ModuleTypes}{$Type}{Memory}{$MemoryKey}{Address}{"$AddressHex"}{SensorName} = "$Channel:$counter:Start" ;
                        } else {
                           $global{Cons}{ModuleTypes}{$Type}{Memory}{$MemoryKey}{Address}{"$AddressHex"}{SensorName} = "$Channel:$counter" ;
                        }
                        $counter ++ ;
                     }
                  }

                  # Save all addresses for the get_status procedure
                  $global{Cons}{ModuleTypes}{$Type}{Memory}{$MemoryKey}{SensorNameAddress} = join ";", @SensorNameAddress ;

                  # Remember last adress
                  $global{Cons}{ModuleTypes}{$Type}{Memory}{$MemoryKey}{Address}{"$AddressHex"}{SensorName} = "$Channel:$counter:Save" ;
               }
            }
         }
      }
   }
}

# This is a bit tricky. Find the MemoryKey based on the Buld and the module type.
# MemoryKey is used to specify the memory address that has to be used. These addresses can differ between Build versions.
sub module_find_MemoryKey () {
   my $address = $_[0] ;
   my $type    = $_[1] ;

   my $Build = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{BuildYear} . $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{BuildWeek} ;

   my $MemoryKey = 0 ;
   if ( defined $global{Cons}{ModuleTypes}{$type} and
        defined $global{Cons}{ModuleTypes}{$type}{MemoryMatch} ) {
      foreach my $key (sort {$a <=> $b} (keys %{$global{Cons}{ModuleTypes}{$type}{MemoryMatch}} ) ) {
         if ( defined $global{Cons}{ModuleTypes}{$type}{MemoryMatch}{$key}{Build} ) {
            my $code = "if ( $Build $global{Cons}{ModuleTypes}{$type}{MemoryMatch}{$key}{Build} ) {
               \$MemoryKey = '$global{Cons}{ModuleTypes}{$type}{MemoryMatch}{$key}{Version}' ;
            } ; " ;
            eval $code ;
            return $MemoryKey if defined $MemoryKey ;;
         }
      }
   }
   return $MemoryKey ;
}

return 1
