#!/usr/bin/perl

use lib "/data/Velbus/perl/lib" ;

use strict;
use POSIX qw/strftime/;

use Velbus ;

my $sock = &open_socket ;

our %global ; # Variable shared by all functions where we store all data

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

my $json ;

# Put the time on the bus
if ( defined $action and $action eq "TimeSync" ) {
   &broadcast_datetime($sock) ;
   $json = "" ;
}

if ( $type eq "Temperature" and $action eq "Get" ) {
   if ( defined $Moduletype and ( $Moduletype eq "20" or $Moduletype eq "28" ) ) {
      my %data = &fetch_data ($global{dbh},"select * from modules_info where `address`='$address'","data") ;
      if ( %data ) {
         $json->{Name}        = $data{TempSensor}{value} ;
         $json->{Temperature} = $data{Temperature}{value} ;
      }
      #my %data = &fetch_data ($global{dbh},"select * from modules_channel_info where `address`='$address' and `channel`='00'","data") ;
      #if ( %data ) {
      #   $json->{Temperature} = $data{'Current temperature'}{value} ;
      #}
   }
}

if ( $type eq "HeaterTemperature" and ( $action eq "Get" or $action eq "Set" ) ) {
   if ( defined $Moduletype and ( $Moduletype eq "20" or $Moduletype eq "28" ) ) {
      if ( $action eq "Set" ) {
         if ( defined $value ) {
            &set_temperature ($sock, $address, $value) ;
         }
      }
      my %data = &fetch_data ($global{dbh},"select * from modules_info where `address`='$address'","data") ;
      if ( %data ) {
         $json->{Name}        = $data{TempSensor}{value} ;
         $json->{Temperature} = $data{Temperature}{value} ;
      }
      my %data = &fetch_data ($global{dbh},"select * from modules_channel_info where `address`='$address' and `channel`='00'","data") ;
      if ( %data ) {
         $json->{Temperature} = $data{'Current temperature set'}{value} ;
      }
   }
}

if ( $type eq "HeaterMode" and ( $action eq "Get" or $action eq "Set" ) ) {
   if ( defined $Moduletype and ( $Moduletype eq "20" or $Moduletype eq "28" ) ) {
      if ( $action eq "Set" ) {
         if ( defined $value ) {
            &set_temperature_mode ($sock, $address, $value) ;
         }
      }
      my %data = &fetch_data ($global{dbh},"select * from modules_channel_info where `address`='$address' and `channel`='00'","data") ;
      if ( %data ) {
         $json->{Name}   = $data{name}{value} ;
         if ( $data{'Temperature mode'}{value} =~ /comfort/i ) {
            $json->{Status} = 1 ;
         } elsif ( $data{'Temperature mode'}{value} =~ /day/i ) {
            $json->{Status} = 2 ;
         } elsif ( $data{'Temperature mode'}{value} =~ /night/i ) {
            $json->{Status} = 3 ;
         } elsif ( $data{'Temperature mode'}{value} =~ /safe/i ) {
            $json->{Status} = 4 ;
         } else {
            $json->{Status} = 0 ;
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
      if ( $action eq "On" ) {
         &relay_on ($sock, $address, $channel) ;
      }
      if ( $action eq "Off" ) {
         &relay_off ($sock, $address, $channel) ;
      }
      my %data = &fetch_data ($global{dbh},"select * from modules_channel_info where `address`='$address' and `channel`='$channel'","data") ;
      if ( %data ) {
         $json->{Name}   = $data{name}{value} ;
         if ( $data{'Relay status'}{value} eq "Relay channel off" ) {
            $json->{Status} = "OFF" ;
         } else {
            $json->{Status} = "ON" ;
         }
      }
   }
}

if ( defined $json ) {
   print $session->header(-type=>'application/json') ;
   print encode_json($json);
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
