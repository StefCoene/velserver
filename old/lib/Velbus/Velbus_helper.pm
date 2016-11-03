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
      $return[$k] = hex ($data[$k]) ;
   }
   return @return ;
}

sub hex_to_binary {
   my $hex = $_[0] ;
   return sprintf ("%08b",hex $hex) ;
}

# Make a message so it can be transmitted to the bus
sub make_message {
   my @message = @_ ;
   my $message_length = @message ; # Length of @message

   # Loop over the message and convert hex numbers to decimal if required
   for ($index=0; $index<=$#message; $index++) {
      if ( $message[$index] =~ /0x/ ) {
         $message[$index] = hex $message[$index] ;
      }
   }

   # Build new message in @message_new
   my @message_new = () ;
   $message_new[0] = hex "0x0F" ;
   $message_new[1] = $message[0] ;
   $message_new[2] = $message[1] ;
   $message_new[3] = ($message[2] & 240) | (($message_length-3) & 15) ;
   
   for (my $make_count = 0; $make_count <= ($message_length-3); $make_count++) {
      $message_new[$make_count+4] = $message[$make_count+3] ;
   }
   
   # Calculating checksum and finalizing new message
   my $checksum = &calc_checksum_send(@message_new) ;
   $message_new[$message_length+1] = $checksum ;
   $message_new[$message_length+2] = hex "0x04" ;

   # Convert to character
   for ($index=0; $index<=$#message_new; $index++) {
      $message_new[$index] = chr ($message_new[$index]) ;
   }

   my $message_new = join('',@message_new) ;
   return $message_new ;
}

# Calculate temperature
sub temperature {
   my @data = @_ ;

   @data = &message_hex_to_dec (@data) ;

   my $temperature = $data[0] << 8 ;
   $temperature |= $data[1] ;
   $temperature /= 32 ;
   $temperature *= 0.0625 ;
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
   $global{Config}{velbus}{host} = "localhost"    if ! defined $global{Config}{velbus}{host} ;
   $global{Config}{velbus}{port} = "3788"         if ! defined $global{Config}{velbus}{port} ;

   my $sock = new IO::Socket::INET(
                   PeerAddr => $global{Config}{velbus}{host},
                   PeerPort => $global{Config}{velbus}{port},
                   Proto    => 'tcp');
   $sock or die "no socket :$!";

   $sock->autoflush(1);

   return $sock ;
}

return 1
