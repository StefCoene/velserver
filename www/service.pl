#!/usr/bin/perl

# 1. item is updated by clicking in openHAB interface
# 2. service.pl is called via the http binding
# 3. service.pl checks the current state and if it differs calls the appropriate function to post a message to the velbus
# 4. logger.pl picks up the response to this message and use the REST API of openHAB to inform openhab that something changed
# 4bis. logger.pl also updates the mysql database
# 5. item is updated in openHAB
# 6. service.pl is called via the http binding
# 7. service.pl checks the current state and if it differs calls the appropriate function to post a message to the velbus
#      !!!!! if logger.pl is too slow in updating the mysql, service.pl is unaware of this change and will repost the velbus message

use lib "/data/velserver/lib" ;

use strict;
use POSIX qw/strftime/;

our %global ; # Variable shared by all functions where we store all data
$global{Config}{BaseDir} = "/data/velserver" ;

use Velbus ;

my $sock = &open_socket ;

use Velbus ;
use Velbus::Velbus_www ;

use CGI ;
use CGI::Session ;

$global{cgi}{CGI} = new CGI ;
my $session  = CGI::Session->load() ;

use JSON ;

%{$global{cgi}{params}} = $global{cgi}{CGI}->Vars; # Get all supplied parameters in a hash
 
&init ;

my $address ;    # Address of the module
my $Moduletype ; # Type of the module, based on $address
my $channel ;    # Channel of the module
my $type ;       # What type of command
my $action ;     # What to do
my $value ;      # Extra info for the command

# Parse options
if ( defined $global{cgi}{params}{address} ) {
   $address = $global{cgi}{params}{address} ;
   if ( defined $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} and $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} ne '' ) {
      $Moduletype = $global{Vars}{Modules}{Address}{$address}{ModuleInfo}{type} ;
   }
}
if ( defined $global{cgi}{params}{channel} ) {
   $channel = $global{cgi}{params}{channel} ;
}
if ( defined $global{cgi}{params}{action} ) {
   $action = $global{cgi}{params}{action} ;
}
if ( defined $global{cgi}{params}{type} ) {
   $type = $global{cgi}{params}{type} ;
}
if ( defined $global{cgi}{params}{value} ) {
   $value = $global{cgi}{params}{value} ;
}

my $LOG ;
if ( $action eq "Get" ) {
} else {
   #$LOG = "1" ;
}
open LOG,">>/tmp/velbus.log" if defined $LOG ;
print LOG "address = $address\n" if defined $LOG ;
print LOG "channel = $channel\n" if defined $LOG ;
print LOG "action = $action\n"   if defined $LOG ;
print LOG "type = $type\n"       if defined $LOG ;
print LOG "value = $value\n"     if defined $LOG and defined $value ;

my $json ;

# Put the time on the bus
if ( defined $action and $action eq "TimeSync" ) {
   &broadcast_datetime($sock) ;
   $json = "" ;
}

if ( $type eq "Temperature" and $action eq "Get" ) {
   if ( defined $Moduletype and ( $Moduletype eq "20" or $Moduletype eq "28" ) ) {
      my %data = &fetch_data ($global{dbh},"select * from modules_info where `address`='$address'","data") ;
      $json->{Name}        = $data{TempSensor}{value}  if defined $data{TempSensor} ;
      $json->{Temperature} = $data{Temperature}{value} if defined $data{Temperature} ;

      #my %data = &fetch_data ($global{dbh},"select * from modules_channel_info where `address`='$address' and `channel`='00'","data") ;
      #if ( %data ) {
      #   $json->{Temperature} = $data{'Current temperature'}{value} ;
      #}
   }
}

if ( $type eq "HeaterTemperature" and ( $action eq "Get" or $action eq "Set" ) ) {
   if ( defined $Moduletype and ( $Moduletype eq "20" or $Moduletype eq "28" ) ) {
      my %data = &fetch_data ($global{dbh},"select * from modules_info where `address`='$address'","data") ;
      $json->{Name}        = $data{TempSensor}{value}  if defined $data{TempSensor} ;

      my %data = &fetch_data ($global{dbh},"select * from modules_channel_info where `address`='$address' and `channel`='00'","data") ;
      if ( defined $data{'Current temperature set'} ) {
         $json->{Temperature} = $data{'Current temperature set'}{value} ;
         if ( $action eq "Set" and defined $value and $value ne $data{'Current temperature set'}{value} ) {
            &set_temperature ($sock, $address, $value) ;
            $json->{Action} = "$value"  ;
         }
      }
   }
}

if ( $type eq "HeaterMode" and ( $action eq "Get" or $action eq "Set" ) ) {
   if ( defined $Moduletype and ( $Moduletype eq "20" or $Moduletype eq "28" ) ) {
      my %data ;
      if ( $Moduletype eq "28" ) {
         %data = &fetch_data ($global{dbh},"select * from modules_channel_info where `address`='$address' and `channel`='21'","data") ;
      }
      if ( $Moduletype eq "20" ) {
         %data = &fetch_data ($global{dbh},"select * from modules_channel_info where `address`='$address' and `channel`='09'","data") ;
      }
      $json->{Name} = $data{name}{value} if defined $data{name} ;

      %data = &fetch_data ($global{dbh},"select * from modules_channel_info where `address`='$address' and `channel`='00'","data") ;
      if ( defined $data{'Temperature mode'} ) {
         if ( $data{'Temperature mode'}{value} =~ /comfort/i ) {
            $json->{Status} = 1 ;
            if ( $action eq "Set" and defined $value and $value ne "1" ) {
               &set_temperature_mode ($sock, $address, $value) ;
               $json->{Action} = "1" ;
            }
         } elsif ( $data{'Temperature mode'}{value} =~ /day/i ) {
            $json->{Status} = 2 ;
            if ( $action eq "Set" and defined $value and $value ne "2" ) {
               &set_temperature_mode ($sock, $address, $value) ;
               $json->{Action} = "2" ;
            }
         } elsif ( $data{'Temperature mode'}{value} =~ /night/i ) {
            $json->{Status} = 3 ;
            if ( $action eq "Set" and defined $value and $value ne "3" ) {
               &set_temperature_mode ($sock, $address, $value) ;
               $json->{Action} = "3" ;
            }
         } elsif ( $data{'Temperature mode'}{value} =~ /safe/i ) {
            $json->{Status} = 4 ;
            if ( $action eq "Set" and defined $value and $value ne "4" ) {
               &set_temperature_mode ($sock, $address, $value) ;
               $json->{Action} = "4" ;
            }
         } else {
            $json->{Status} = 0 ;
            $json->{Action} = "NONE" ;
         }
      } else {
         $json->{Error} = "NO_INFO" ;
         if ( $action eq "Set" and defined $value and $value ne "1" ) {
            &set_temperature_mode ($sock, $address, $value) ;
            $json->{Action} = "1" ;
         }
         if ( $action eq "Set" and defined $value and $value ne "2" ) {
            &set_temperature_mode ($sock, $address, $value) ;
            $json->{Action} = "2" ;
         }
         if ( $action eq "Set" and defined $value and $value ne "3" ) {
            &set_temperature_mode ($sock, $address, $value) ;
            $json->{Action} = "3" ;
         }
         if ( $action eq "Set" and defined $value and $value ne "4" ) {
            &set_temperature_mode ($sock, $address, $value) ;
            $json->{Action} = "4" ;
         }
      }
   }
}

if ( $type eq "Dimmer" and ( $action eq "Get" or $action eq "Set" ) ) {
   if ( defined $Moduletype and ( $Moduletype eq "07" or $Moduletype eq "0F" or $Moduletype eq "12" or $Moduletype eq "14" or $Moduletype eq "15" ) ) {
      if ( $action eq "Set" ) {
         if ( defined $value ) {
            &set_dim_value ($sock, $address, $channel, $value) ;
         }
      }
      my %data = &fetch_data ($global{dbh},"select * from modules_channel_info where `address`='$address' and `channel`='$channel'","data") ;
      if ( %data ) {
         $json->{Name}   = $data{name}{value} ;
         $json->{Status} = $data{Dimmer}{value} ;
      }
   }
}

if ( $type eq "Blind" and ( $action eq "Get" or $action eq "Set" ) ) {
   if ( defined $Moduletype and ( $Moduletype eq "03" or $Moduletype eq "09" or $Moduletype eq "1D" ) ) {
      if ( $value eq "UP" ) {
         &blind_up ($sock, $address, $channel) ;
      }
      if ( $value eq "DOWN" ) {
         &blind_down ($sock, $address, $channel) ;
      }
      if ( $value eq "STOP" ) {
         &blind_stop ($sock, $address, $channel) ;
      }
      my %data = &fetch_data ($global{dbh},"select * from modules_channel_info where `address`='$address' and `channel`='$channel'","data") ;
      if ( %data ) {
         $json->{Name}   = $data{name}{value} ;
         $json->{Status} = $data{Position}{value} ;
      }
   }
}

if ( $type eq "Relay" and ( $action eq "Get" or $action eq "On" or $action eq "Off" ) ) {
   if ( defined $Moduletype and ( $Moduletype eq "02" or $Moduletype eq "08" or $Moduletype eq "10" or $Moduletype eq "11" ) ) {
      my %data = &fetch_data ($global{dbh},"select * from modules_channel_info where `address`='$address' and `channel`='$channel'","data") ;

      $json->{Name} = $data{name}{value} if defined $data{name} ;

      if ( defined $data{'Relay status'} ) {
         if ( $data{'Relay status'}{value} eq "Relay channel off" ) {
            $json->{Status} = "OFF" ;
            if ( $action eq "On" ) {
               &relay_on ($sock, $address, $channel) ;
               $json->{Action} = "On" ;
            }

         } elsif ( $data{'Relay status'}{value} eq "Relay channel on" ) {
            $json->{Status} = "ON" ;
            if ( $action eq "Off" ) {
               &relay_off ($sock, $address, $channel) ;
               $json->{Action} = "Off" ;
            }
         }

      } else {
         $json->{Error} = "NO_INFO" ;
         if ( $action eq "On" ) {
            &relay_on ($sock, $address, $channel) ;
            $json->{Action} = "On" ;
         }
         if ( $action eq "Off" ) {
            &relay_off ($sock, $address, $channel) ;
            $json->{Action} = "Off" ;
         }
      }
   }
}

if ( $type eq "Counter" and ( $action eq "GetCounter" or $action eq "GetDivider" ) ) {
   if ( defined $Moduletype and $Moduletype eq "22" ) {
      my %data = &fetch_data ($global{dbh},"select * from modules_channel_info where `address`='$address' and `channel`='$channel'","data") ;

      if ( $action eq "GetCounter" ) {
         $json->{Status} = $data{Counter}{value} if defined $data{Counter} ;
      } else {
         $json->{Status} = $data{Divider}{value} if defined $data{Divider} ;
      }
   }
}

if ( defined $json ) {
   print $session->header(-type=>'application/json') ;
   print encode_json($json);
   print LOG encode_json($json)if defined $LOG ;
} else {
   # Starting debug: dumping internal hash
   print $session->header() ;
   print $global{cgi}{CGI}->start_html (
      -title=>"Velbus info",
   ) ;
   #print "<pre>\n" ;
   #print Dumper {%global} ;
   print $global{cgi}{CGI}->end_html() ;
}
print LOG "\n" if defined $LOG ;
print LOG "\n" if defined $LOG ;
close LOG if defined $LOG ;
