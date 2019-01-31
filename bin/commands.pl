#!/usr/bin/perl 

use lib "/home/velbus/velserver/lib" ;
our %global ;
$global{BaseDir} = "/home/velbus/velserver" ;

use Getopt::Long ;
&GetOptions ('option=s' => \$global{opts}{option} ,
             'address=s' => \$global{opts}{address} ,
             'text=s' => \$global{opts}{text} ,
             'help' => \$global{opts}{help} ) or &print_help ;

# Print help en exit dan
sub print_help {
   print "Possible options:

   -o = 
      scan = scan all modules on the bus
      status = get status off all modules
      date = broadcast date and time
      memo = show memo text on OLED
         optional parameter address for the address and text for the text
      tempinterval = force interval updates for temperaure to 60 seconds
      openHAB_push_status = push state of items to openHAB
      openHAB = create the openHAB items file
         it also prints the file
   
" ;
   exit ;
}  

if ( defined $global{opts}{help} ) {
   &print_help ;
}  

use strict;

use Velbus ;
&init () ;

my $sock = &open_socket ;
if ( ! defined $sock ) {
   print "No connection to $global{Config}{velbus}{HOST} port $global{Config}{velbus}{PORT}\n" ;
} else {
   if ( $global{opts}{option} eq "scan" ) {
      &scan($sock) ;
   } elsif ( $global{opts}{option} eq "status" ) {
      &update_module_status($sock) ;
   } elsif ( $global{opts}{option} =~ /test(..)(..)(..)/ ) {
      my $red   = $1 ; # 0 - 255
      my $green = $2 ; # 0 - 255
      my $blue  = $3 ; # 0 - 255

      my $sat = "10" ;

      my $address = "14" ;

      my $max = bin_to_dec ("1111111") ;
      #print "$max\n" ;
      #print "$sat\n" ;
      $sat = $sat * $max / 100  ;
      #print "$sat\n" ;
      $sat = hex_to_bin(dec_to_hex ($sat)) ;
      #print "$sat\n" ;
      $sat =~ s/^.//g ;
      #print "$sat\n" ;
      $sat = "0" . $sat ;  # RGB, 1 = white
      #print "$sat\n" ;
      my $sat = &bin_to_hex ($sat) ;
      #print "$sat\n" ;
      my $pal = "30" ;
      $pal = &dec_to_hex ($pal) ;
      &send_message ($sock, $address, "D4", $pal, $sat, $red, $green, $blue) ;
      $pal = hex_to_dec($pal) ;
      $sat = hex_to_bin($sat) ;
      $red = hex_to_dec($red) ;
      $green = hex_to_dec($green) ;
      $blue = hex_to_dec($blue) ;
      print "$pal, $sat, $red, $green, $blue\n" ;

      my $hex2 = &bin_to_hex ("01111111") ; # default + apply to all
      my $hex2 = &bin_to_hex ("11111111") ; # custom + apply to all

      my $hex3 = &bin_to_hex ("11111111") ; # everywhere  BRTL

      $pal = hex_to_bin(dec_to_hex ($pal)) ;
      $pal =~ s/^...//g ;
      my $hex4 = &bin_to_hex ("011$pal") ; #
      &send_message ($sock, $address, "D4", $hex2, $hex3, $hex4) ;

   } elsif ( $global{opts}{option} eq "tempinterval" ) {
      &set_temperature_interval_all($sock,"60") ;
   } elsif ( $global{opts}{option} eq "date" ) {
      &broadcast_datetime($sock) ;
   } elsif ( $global{opts}{option} eq "memo" ) {
      if ( defined $global{opts}{address} ) {
         &send_memo ($sock,$global{opts}{address},$global{opts}{text}) ;
      }

   } elsif ( $global{opts}{option} eq "openHAB" ) {
      &openHAB_parse_config () ;
      my $openHAB = &openHAB_config () ;
      print $openHAB ;
   } elsif ( $global{opts}{option} eq "openHAB_push_status" ) {
      use Velbus::Velbus_www ;
      &openHAB_status ;
   } else {
      &print_help ;
   }
}
