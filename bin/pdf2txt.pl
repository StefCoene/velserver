#!/usr/bin/perl

# Protocol pdf format:
#   Every file has a footer with some extra information about the document.
#   The file start with a frontpage where the module type and module text can be found.
#   The next few page contains some sort of index that we don't need.
#   After the index comes a list of messages that we need. Every messages start with a line that begins with no space and contains some fixed text like "reveived", "Transmit", ...
#   After the list of messages comes the Memory Map. We don't need this information.

# file{PerFile}
# file{PerMessageAddressType}
#   {$MessageAddressType}{$file} .= $counter . " " ;
# file{PerMessageAddressTypeDebug}
# file{PerType}

# file{RemoteMessage}
#   {$CommandHex}{$CommandText}{$MessageType}
# file{BroadcastMessage}
#   {$CommandHex}{$CommandText}{$MessageType}
# file{LocalMessage}
#   {$CommandHex}{$CommandText}{$MessageType}

our %global ;

use Data::Dumper ;
$Data::Dumper::Sortkeys = 1 ; # Sort the keys in the output
$Data::Dumper::Deepcopy = 1 ; # Enable deep copies of structures
$Data::Dumper::Indent = 1 ;   # Output in a reasonable style (but no array indexes)

# Convert the pdf's to text
foreach my $pdf (sort `ls protocol*.pdf`) {
  chomp $pdf ;
  #print "Zet om naar text: $pdf\n" ;
  `pdftotext -layout $pdf` ;
}

my %file ; # Contains all raw info read from the files

# Loop all files and process the raw input.
foreach my $file (sort `ls protocol*.txt`) {
   chomp $file ;
   #print "File: $file\n" ;

   open (FILE,"<$file") ;
   my @file = <FILE> ;
   close FILE ;

   # First line of the file is the type of the module
   my $ModuleType = &clean (shift @file) ;
   if ( $ModuleType eq "VMBGP1" ) { # For VMBGP1, VMBGP2 and VMBGP4: the text is split on 3 lines
      $ModuleType = "VMBGPx" ;
      shift @file ; # VMBGP2
      shift @file ; # VMBGP4
   } elsif ( $ModuleType eq "VMBGP1-2" ) { # For VMBGPx-2: the text is split on 3 lines
      $ModuleType = "VMBGPx-2" ;
      shift @file ; # VMBGP2-2
      shift @file ; # VMBGP4-2
   } elsif ( $ModuleType eq "VMBGPO" ) { # For VMBGPO: the text is split on 3 lines
      shift @file ;
      shift @file ;
   } elsif ( $ModuleType eq "VMBEL1" ) { # For VMBEL1: the text is split on 3 lines
      shift @file ;
      shift @file ;
   }
   $file{PerFile}{$file}{Info}{ModuleType} = $ModuleType ;

   # Second last line can be used to filter out the edition of the file
   &clean (pop @file) ;
   $file{PerFile}{$file}{Info}{Edition} = &clean (pop @file) ;
   if ( $file{PerFile}{$file}{Info}{Edition} =~ /(edition \d+ _ rev\d+)/ ) {
      $file{PerFile}{$file}{Info}{Edition} = $1 ;
   } elsif ( $file{PerFile}{$file}{Info}{Edition} =~ /(edition \d+)/ ) {
      $file{PerFile}{$file}{Info}{Edition} = $1 ;
   } elsif ( $file{PerFile}{$file}{Info}{Edition} =~ /(version \d+)/ ) {
      $file{PerFile}{$file}{Info}{Edition} = $1 ;
   } else {
      $file{PerFile}{$file}{Info}{Edition} = "" ;
   }

   # Second and optional the third line contains information about the module
   $file{PerFile}{$file}{Info}{ModuleText}  = &clean (shift @file) . " " ;
   $file{PerFile}{$file}{Info}{ModuleText} .= &clean (shift @file) ;
   $file{PerFile}{$file}{Info}{ModuleText} =~ s/PROTOCOL//g ; # Clean op some of the text
   $file{PerFile}{$file}{Info}{ModuleText} =~ s/for ?VELBUS ?system//ig ; # Clean op some of the text
   $file{PerFile}{$file}{Info}{ModuleText} =~ s/for ?VELBUS//ig ; # Clean op some of the text
   $file{PerFile}{$file}{Info}{ModuleText} =~ s/ +$//g ; # Clean op some of the text

   my $counter = 0 ; #  Counter will be incremented per found message

   my $previousline ;

   foreach my $line (@file) {
      chomp $line ;
      next if $line eq "" ; # Skip empty lines

      $line =~ s///g ; # Removing new page marker

      $line =~ s/^\s+//g ; # Remove spaces at start of line
      $line =~ s/\s+$//g ; # Remove spaces at end of line
      $line =~ s/\s+=\s+/=/g ; # Remove spaces around =

      # The page footer contains the text 'PROTOCOL –'.
      # The page footer contains some information about the version of the document
      if ( $line =~ /PROTOCOL –/ ) {
         if ( !defined $file{PerFile}{$file}{Info}{Version} ) {
            $file{PerFile}{$file}{Info}{Version} = &clean ($line) ;
         }
         next ;
      }

      my @split = split "=", $line ;
      # Priority of the message
      if ( $split[0] eq "SID10-SID9" ) {
         if ( $split[1] =~ /\((.+ priority)\)/ ) {
            $counter ++ ; # Incrementing the message counter
            $file{PerFile}{$file}{Messages}{$counter}{Prio} = $1 ;
            # The previous line is the tekst that belongs to this message
            $file{PerFile}{$file}{Messages}{$counter}{Info} = &clean($previousline) ;

         } else {
            print "$file SID10-SID9 not correctly parsed: $line\n" ;
         }
      # Filtering out the address
      } elsif ( $split[0] eq "SID8...SID1" ) {
         $file{PerFile}{$file}{Messages}{$counter}{MessageAddress} .= $split[1] ;

      # Info about RTR in the message
      } elsif ( $split[0] eq "RTR" ) {
         $file{PerFile}{$file}{Messages}{$counter}{RTR} = $split[1] ;

      # Info about the databytes in the message
      } elsif ( $split[0] =~ /^DATABYTE/ ) {
         $file{PerFile}{$file}{Messages}{$counter}{DATABYTE} .= $line . "\n" ;

      } elsif ( $line =~ /Memory map:/i or
                $line =~ /Memory map build/i ) {
         last ;
      } else {
         $previousline = $line ;
      }
   }
}

my %data ; # Contains al parsed data
#print Dumper {%file} ;

# Loop all the data we found in the files
foreach my $file (sort keys(%{$file{PerFile}})) {
   my $ModuleType = $file{PerFile}{$file}{Info}{ModuleType} ; # Handier var

   # Make sure we see each Module type only once
   if ( defined $file{PerType}{$ModuleType} ) {
      print "Error: file $file: We already had type $ModuleType in file $file{PerType}{$ModuleType}{'$ModuleTypeHex'}{File}\n" ;
      next ;
   } else {
      $file{PerType}{$ModuleType}{'$ModuleTypeHex'}{File} = $file ; # Remember that we have seen the module
   }

   # Loop all the messages
   foreach my $counter (sort keys (%{$file{PerFile}{$file}{Messages}}) ) {
      # We need at least an address and text for each message
      if ( defined $file{PerFile}{$file}{Messages}{$counter}{MessageAddress} and
           defined $file{PerFile}{$file}{Messages}{$counter}{Info} ) {

         my $MessageAddress = $file{PerFile}{$file}{Messages}{$counter}{MessageAddress} ; # Handier var
         my $Info    = $file{PerFile}{$file}{Messages}{$counter}{Info} ;    # Handier var

         # Parse the info in $MessageAddress to find the type of address: broadcast, local or remote
         my $MessageAddressType ;
         if ( $MessageAddress eq 'H’00’' ) {
            $MessageAddressType = "broadcast" ;
         } elsif ( $MessageAddress =~ /^Address of the module/i or
                   $MessageAddress =~ /^Address set by hex switches/i or
                   $MessageAddress =~ /^Module Address/i or
                   $MessageAddress =~ /^Current module Address/i or
                   $MessageAddress =~ /^Program location Address/i or
                   $MessageAddress =~ /^Channel button address/i or
                   $MessageAddress =~ /Subaddress/i ) {
            $MessageAddressType = "local" ;
         } else {
            $MessageAddressType = "remote" ;
         }
         $file{PerFile}{$file}{Messages}{$counter}{MessageAddressType} = $MessageAddressType ; # Remember MessageAddressType

         # Remember the messages per MessageAddressType (broadcast, local of remote)
         # Can be used to check if the MessageAddressType is correct detected
         $file{PerMessageAddressTypeDebug}{$MessageAddressType}{$MessageAddress}{$file} .= $counter . " " ;

         $file{PerFile}{$file}{Messages}{$counter}{Info} =~ s/ \(Build.+ or higher\)//g ; # Filter out some unwanted text

         # Parse the Info to determine if the message is a message or a command and is it receive or transmit
         # "... command received:" The blind module can receive the following commands
         $file{PerFile}{$file}{Messages}{$counter}{Info} =~ s/://g ;
         #if (  $file{PerFile}{$file}{Messages}{$counter}{Info} =~ s/(.+) command received/$1/g ) {
         #   $MessageType = "ReceiveCommand" ;
         ## "... received:" The blind module can transmit the following messages
         #} elsif (  $file{PerFile}{$file}{Messages}{$counter}{Info} =~ s/(.+) received/$1/g ) {
         #   $MessageType = "ReceiveMessage" ;
         ## "Transmit: ... :" The blind module can transmit the following commands
         #} elsif (  $file{PerFile}{$file}{Messages}{$counter}{Info} =~ s/Transmit (.+)/$1/g )  {
         #   $MessageType = "TransmitCommand" ;
         ## "Transmits ... :" The blind module can transmit the following messages
         #} elsif (  $file{PerFile}{$file}{Messages}{$counter}{Info} =~ s/(Transmits .+)/$1/g )  {
         #   $MessageType = "TransmitMessage" ;
         #} else {
         #   print "REST $file{PerFile}{$file}{Messages}{$counter}{Info}\n" ;
         #}
         #$file{PerFile}{$file}{Messages}{$counter}{MessageType} = $MessageType if defined $MessageType ; # Remember MessageType

         # Priority....
         if ( $file{PerFile}{$file}{Messages}{$counter}{Prio} =~ /high/i ) {
            $file{PerFile}{$file}{Messages}{$counter}{Prio} = "High"
         } else {
            $file{PerFile}{$file}{Messages}{$counter}{Prio} = "Low"
         }

         # Parse the DATABYTE information
         foreach my $line (split "\n", $file{PerFile}{$file}{Messages}{$counter}{DATABYTE} ) {
            # First databyte contains the type of message
            if ( $line =~ /DATABYTE1/ ) {
               if ( $line =~ /DATABYTE1=(.+) \(H’(..)’\)/ or
                    $line =~ /DATABYTE1=(.+) \(0x(.+)\)/ ) {
                  my $CommandText = $1 ;
                  my $CommandHex  = $2 ;
                  # Some text corrections so we have the same text for the different modules
                  $CommandText = "COMMAND_BUS_ERROR_COUNTER_STATUS_REQUEST" if $CommandText eq "COMMAND_BUS_ERROR_CONTER_STATUS_REQUEST" ;
                  $CommandText = "COMMAND_PUSH_BUTTON_STATUS"               if $CommandText eq "COMMAND_PUSHBUTTON_STATUS" ;
                  $CommandText = "COMMAND_MODULETYPE"                       if $CommandText eq "COMMAND_MODULE_TYPE" ;
                  $CommandText = "COMMAND_REALTIME_CLOCK_STATUS"            if $CommandText eq "COMMAND_SET_REALTIME_CLOCK" ;

                  $file{PerFile}{$file}{Messages}{$counter}{CommandText} = $CommandText ;
                  $file{PerFile}{$file}{Messages}{$counter}{CommandHex}  = $CommandHex ;

                  #$file{PerMessageHex}{$CommandHex}{$file} .= $counter . " " ;
                  $file{PerMessageAddressType}{$MessageAddressType}{$file} .= $counter . " " ; # Remember the messags per AdressType
                  $file{PerCommandHex}{$file}{$CommandHex} .= $counter . " " ; # Remeber per file the $CommandHex. We use this to quickly find message 'FF'

               } elsif ( $line =~ /SOF-SID10/ ) {
                  # Ignore
                  #  DATABYTE1: <SOF-SID10...SID0-RTR-IDE-r0-DLC3...0-DATABYTE1...DATABYTEn-CRC14...CRC1-CRCDEL-ACK-ACKDEL-
               } else {
                  print "$file Error DATABYTE1 format: $line\n" ;
               }
            } else {
               if ( $line =~ /DATABYTE(\d)=(.+)/ ) {
                  my $DATABYTE = $1 ;
                  $file{PerFile}{$file}{Messages}{$counter}{byte}{$DATABYTE}{text} = $2 ;
                  if ( $line =~ /100%/ ) {
                     $file{PerFile}{$file}{Messages}{$counter}{byte}{$DATABYTE}{type} = "%" ;
                  }
               }
            }
         }
      } else {
         # Some error messages
         if ( ! defined $file{PerFile}{$file}{Messages}{$counter}{MessageAddress} ) {
            print "Error: file $file, MessageAddress missing for $counter\n" ;
         }
         if ( ! defined $file{PerFile}{$file}{Messages}{$counter}{Info} ) {
            print "Error: file $file, Info missing for $counter\n" ;
         }
         print Dumper \%{$file{PerFile}{$file}{Messages}{$counter}}
      }
   }
}

# Loop all the data we found in the files a second time.
# We search for MessageHex FF to find out the ModuleTypeHex.
# This time we will sort the data per CommandHex. We do this to filter out the broadcast messages.
open (OUTPUT,">Velbus_data_protocol_auto.pm") ;
print OUTPUT "# This is a big list of all Velbus module related info.\n" ;
print OUTPUT "# Most of the info comes from the protocol pdf files you can download.\n" ;
print OUTPUT "# Script pdf2txt.pl is used to extract the message information.\n" ;
print OUTPUT "\n" ;

foreach my $file (sort keys(%{$file{PerFile}})) {
   my $ModuleType    = $file{PerFile}{$file}{Info}{ModuleType} ; # Handier var
   my $ModuleTypeHex ;

   # Parse CommandHex FF
   if ( defined $file{PerCommandHex}{$file}{'FF'} ) {
      foreach my $counter (split " ", $file{PerCommandHex}{$file}{'FF'}) {
         if ( defined $file{PerFile}{$file}{Messages}{$counter} ) {
            if ( $file{PerFile}{$file}{Messages}{$counter}{byte}{'2'}{text} =~ /.+_TYPE.+\(H’(..)’\)/i or
                 $file{PerFile}{$file}{Messages}{$counter}{byte}{'2'}{text} =~ /.+ TYPE.+\(H’(..)’\)/i or
                 $file{PerFile}{$file}{Messages}{$counter}{byte}{'2'}{text} =~ /.+.+\(H’(..)’\)/i or
                 $file{PerFile}{$file}{Messages}{$counter}{byte}{'2'}{text} =~ /.+ type \(0x(..)\)/i or
                 $file{PerFile}{$file}{Messages}{$counter}{byte}{'2'}{text} =~ /type \(0x(..)/i ) {
               $ModuleTypeHex = $1 ;
               #if ( $ModuleType eq "VMBGPOD" ) { # In the pdf this is type 21, but this is wrong and should be type 28. I think...
               #   $ModuleTypeHex = "28" ;
               #}
               $file{PerHexType}{$ModuleTypeHex} = $file ; # Remember all the Hex Module Types
               $file{PerFile}{$file}{Info}{ModuleTypeHex} = $ModuleTypeHex ; # Remember the Hex value per ModuleType

               if ( defined $file{PerFile}{$file}{Messages}{$counter}{byte} ) {
                  if ( $ModuleTypeHex eq "0C" ) {
                     $file{ModuleType}{$ModuleTypeHex}{SerialHigh} = "4" ;
                     $file{ModuleType}{$ModuleTypeHex}{SerialLow}  = "5" ;
                     $file{ModuleType}{$ModuleTypeHex}{MemoryMap}  = "6" ;
                     $file{ModuleType}{$ModuleTypeHex}{Buildyear}  = "7" ;
                     $file{ModuleType}{$ModuleTypeHex}{BuildWeek}  = "8" ;

                  } else {
                     foreach my $DATABYTE (sort keys %{$file{PerFile}{$file}{Messages}{$counter}{byte}}) {
                        next if $DATABYTE eq "2" ;
                        if ( $file{PerFile}{$file}{Messages}{$counter}{byte}{$DATABYTE}{text} =~ /Memorymap version/ or
                             $file{PerFile}{$file}{Messages}{$counter}{byte}{$DATABYTE}{text} =~ /Memory map version/ ) {
                           $file{ModuleType}{$ModuleTypeHex}{MemoryMap} = $DATABYTE ;
                        } elsif ( $file{PerFile}{$file}{Messages}{$counter}{byte}{$DATABYTE}{text} =~ /High byte of serial number/ or
                                  $file{PerFile}{$file}{Messages}{$counter}{byte}{$DATABYTE}{text} =~ /Serial number high/ ) {
                           $file{ModuleType}{$ModuleTypeHex}{SerialHigh} = $DATABYTE ;
                        } elsif ( $file{PerFile}{$file}{Messages}{$counter}{byte}{$DATABYTE}{text} =~ /Low byte of serial number/ or
                                  $file{PerFile}{$file}{Messages}{$counter}{byte}{$DATABYTE}{text} =~ /Serial number low/ ) {
                           $file{ModuleType}{$ModuleTypeHex}{SerialLow} = $DATABYTE ;
                        } elsif ( $file{PerFile}{$file}{Messages}{$counter}{byte}{$DATABYTE}{text} =~ /Build year/i ) {
                           $file{ModuleType}{$ModuleTypeHex}{Buildyear} = $DATABYTE ;
                        } elsif ( $file{PerFile}{$file}{Messages}{$counter}{byte}{$DATABYTE}{text} =~ /Build week/i ) {
                           $file{ModuleType}{$ModuleTypeHex}{BuildWeek} = $DATABYTE ;
                        } elsif ( $file{PerFile}{$file}{Messages}{$counter}{byte}{$DATABYTE}{text} =~ /don’t care/i ) {
                        } else {
                           #print "Warning: DATABYTE=$DATABYTE = \"$file{PerFile}{$file}{Messages}{$counter}{byte}{$DATABYTE}{text}\" in $file\n" ;
                        }
                     }
                  }
               }
               # VMBGP1 = 1E: from pdf file
               # VMBGP2 = 1F: ??
               # VMBGP4 = 20: from my bus
               if ( $ModuleTypeHex eq "1E" ) {
                  %{$file{ModuleType}{'1F'}} = %{$file{ModuleType}{'1E'}} ;
                  %{$file{ModuleType}{'20'}} = %{$file{ModuleType}{'1E'}} ;

                  print OUTPUT "\$global{Cons}{ModuleTypes}{'1E'}{File} = \"$file\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'1E'}{Type} = \"VMBGP1\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'1E'}{Info} = \"$file{PerFile}{$file}{Info}{ModuleText}\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'1E'}{Version} = \"$file{PerFile}{$file}{Info}{Edition}\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'1F'}{File} = \"$file\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'1F'}{Type} = \"VMBGP2\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'1F'}{Info} = \"$file{PerFile}{$file}{Info}{ModuleText}\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'1F'}{Version} = \"$file{PerFile}{$file}{Info}{Edition}\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'20'}{File} = \"$file\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'20'}{Type} = \"VMBGP4\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'20'}{Info} = \"$file{PerFile}{$file}{Info}{ModuleText}\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'20'}{Version} = \"$file{PerFile}{$file}{Info}{Edition}\" ;\n" ;
               # VMBEL1 = 34
               # VMBEL2 = 35
               # VMBEL4 = 36
               } elsif ( $ModuleTypeHex eq "34" ) {
                  %{$file{ModuleType}{'35'}} = %{$file{ModuleType}{'34'}} ;
                  %{$file{ModuleType}{'36'}} = %{$file{ModuleType}{'34'}} ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'34'}{File} = \"$file\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'34'}{Type} = \"VMBEL1\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'34'}{Info} = \"$file{PerFile}{$file}{Info}{ModuleText}\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'34'}{Version} = \"$file{PerFile}{$file}{Info}{Edition}\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'35'}{File} = \"$file\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'35'}{Type} = \"VMBEL2\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'35'}{Info} = \"$file{PerFile}{$file}{Info}{ModuleText}\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'35'}{Version} = \"$file{PerFile}{$file}{Info}{Edition}\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'36'}{File} = \"$file\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'36'}{Type} = \"VMBEL4\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'36'}{Info} = \"$file{PerFile}{$file}{Info}{ModuleText}\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'36'}{Version} = \"$file{PerFile}{$file}{Info}{Edition}\" ;\n" ;
               # VMBGP1-2 = 3A
               # VMBGP2-2 = 3B
               # VMBGP4-2 = 3C
               } elsif ( $ModuleTypeHex eq "3C" ) {
                  %{$file{ModuleType}{'3A'}} = %{$file{ModuleType}{'3C'}} ;
                  %{$file{ModuleType}{'3B'}} = %{$file{ModuleType}{'3C'}} ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'3A'}{File} = \"$file\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'3A'}{Type} = \"VMBGP1-2\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'3A'}{Info} = \"$file{PerFile}{$file}{Info}{ModuleText}\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'3A'}{Version} = \"$file{PerFile}{$file}{Info}{Edition}\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'3B'}{File} = \"$file\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'3B'}{Type} = \"VMBGP2-2\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'3B'}{Info} = \"$file{PerFile}{$file}{Info}{ModuleText}\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'3B'}{Version} = \"$file{PerFile}{$file}{Info}{Edition}\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'3C'}{File} = \"$file\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'3C'}{Type} = \"VMBGP4-2\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'3C'}{Info} = \"$file{PerFile}{$file}{Info}{ModuleText}\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'3C'}{Version} = \"$file{PerFile}{$file}{Info}{Edition}\" ;\n" ;
               } else {
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'$ModuleTypeHex'}{File} = \"$file\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'$ModuleTypeHex'}{Type} = \"$ModuleType\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'$ModuleTypeHex'}{Info} = \"$file{PerFile}{$file}{Info}{ModuleText}\" ;\n" ;
                  print OUTPUT "\$global{Cons}{ModuleTypes}{'$ModuleTypeHex'}{Version} = \"$file{PerFile}{$file}{Info}{Edition}\" ;\n" ;
               }

            } else {
               print "Error $ModuleType: no matching FF command: $file{PerFile}{$file}{Messages}{$counter}{byte}{'2'}{text}\n" ;
            }
         } else {
            print "Error no DATABYTE2 found in $file for message counter $counter\n" ;
         }
      }
   } else {
      print "Error: no message FF in $file found!\n" ;
   }

   # Loop all the messages
   foreach my $counter (sort keys (%{$file{PerFile}{$file}{Messages}}) ) {
      # When RTR is 1, we receive an empty request 'Module type request'
      # We ignore this message since this contains no extra HEX code for the command. The answer however, is type FF
      if (  $file{PerFile}{$file}{Messages}{$counter}{RTR} eq "1" ) {
      } else {
         my $MessageAddressType  = $file{PerFile}{$file}{Messages}{$counter}{MessageAddressType} ; # Handier var
         my $CommandHex          = $file{PerFile}{$file}{Messages}{$counter}{CommandHex} ;         # Handier var
         my $CommandText         = $file{PerFile}{$file}{Messages}{$counter}{CommandText} ;        # Handier var
         my $Info                = $file{PerFile}{$file}{Messages}{$counter}{Info} ;               # Handier var
         my $Prio                = $file{PerFile}{$file}{Messages}{$counter}{Prio} ;               # Handier var

         # Broadcast messages are stored and processed later
         # We keep all possible options by using them als keys for a hash
         if ( $MessageAddressType eq "broadcast" ) {
            $file{PerCommandHexBroadcast}{$CommandHex}{CommandText}{$CommandText} .= "" ; # $file . ":" . $counter  . " " ;
            $file{PerCommandHexBroadcast}{$CommandHex}{Info}{$Info} .= "" ; # . $file . ":" . $counter  . " " ;
            $file{PerCommandHexBroadcast}{$CommandHex}{Prio}{$Prio} .= "" ; # . $file . ":" . $counter  . " " ;
         } elsif ( $MessageAddressType eq "remote" ) {
            $file{PerCommandHexRemote}{$ModuleTypeHex}{$CommandHex}{CommandText}{$CommandText} .= "" ; # . $file . ":" . $counter  . " " ;
            $file{PerCommandHexRemote}{$ModuleTypeHex}{$CommandHex}{Info}{$Info} .= "" ; # . $file . ":" . $counter  . " " ;
            $file{PerCommandHexRemote}{$ModuleTypeHex}{$CommandHex}{Prio}{$Prio} .= "" ; # . $file . ":" . $counter  . " " ;
         } elsif ( $MessageAddressType eq "local" ) {
            $file{PerCommandHexLocal}{$ModuleTypeHex}{$CommandHex}{CommandText}{$CommandText} .= "" ; # . $file . ":" . $counter  . " " ;
            $file{PerCommandHexLocal}{$ModuleTypeHex}{$CommandHex}{Info}{$Info} .= "" ; # . $file . ":" . $counter  . " " ;
            $file{PerCommandHexLocal}{$ModuleTypeHex}{$CommandHex}{Prio}{$Prio} .= "" ; # . $file . ":" . $counter  . " " ;
         }
      }
   }
}

#print Dumper %{$file{PerCommandHexLocal}} ;

foreach my $ModuleTypeHex (sort keys %{$file{PerCommandHexLocal}}) {
   foreach my $CommandHex (sort keys %{$file{PerCommandHexLocal}{$ModuleTypeHex}}) {
      if ( defined $file{PerCommandHexBroadcast}{$CommandHex} ) {
      } else {
         my @Name = sort keys %{$file{PerCommandHexLocal}{$ModuleTypeHex}{$CommandHex}{CommandText}} ;
         my @Info = sort keys %{$file{PerCommandHexLocal}{$ModuleTypeHex}{$CommandHex}{Info}} ;
         my @Prio = sort keys %{$file{PerCommandHexLocal}{$ModuleTypeHex}{$CommandHex}{Prio}} ;

         my $Name = join ";", @Name ;
         my $Info = join ";", @Info ;
         my $Prio = join ";", @Prio    ;

         print OUTPUT "\$global{Cons}{ModuleTypes}{'$ModuleTypeHex'}{Messages}{'$CommandHex'}{Name} = \"$Name\" ;\n" ;
         print OUTPUT "\$global{Cons}{ModuleTypes}{'$ModuleTypeHex'}{Messages}{'$CommandHex'}{Info} = \"$Info\" ;\n" ;
         print OUTPUT "\$global{Cons}{ModuleTypes}{'$ModuleTypeHex'}{Messages}{'$CommandHex'}{Prio} = \"$Prio\" ;\n" ;

         # VMBGP2 = 1E: from pdf
         # VMBGP2 = 1F: I think
         # VMBGP4 = 20: from my bus
         if ( $ModuleTypeHex eq "1E" ) {
            print OUTPUT "\$global{Cons}{ModuleTypes}{'1F'}{Messages}{'$CommandHex'}{Name} = \"$Name\" ;\n" ;
            print OUTPUT "\$global{Cons}{ModuleTypes}{'1F'}{Messages}{'$CommandHex'}{Info} = \"$Info\" ;\n" ;
            print OUTPUT "\$global{Cons}{ModuleTypes}{'1F'}{Messages}{'$CommandHex'}{Prio} = \"$Prio\" ;\n" ;
            print OUTPUT "\$global{Cons}{ModuleTypes}{'20'}{Messages}{'$CommandHex'}{Name} = \"$Name\" ;\n" ;
            print OUTPUT "\$global{Cons}{ModuleTypes}{'20'}{Messages}{'$CommandHex'}{Info} = \"$Info\" ;\n" ;
            print OUTPUT "\$global{Cons}{ModuleTypes}{'20'}{Messages}{'$CommandHex'}{Prio} = \"$Prio\" ;\n" ;
         }
         if ( $ModuleTypeHex eq "34" ) {
            print OUTPUT "\$global{Cons}{ModuleTypes}{'35'}{Messages}{'$CommandHex'}{Name} = \"$Name\" ;\n" ;
            print OUTPUT "\$global{Cons}{ModuleTypes}{'35'}{Messages}{'$CommandHex'}{Info} = \"$Info\" ;\n" ;
            print OUTPUT "\$global{Cons}{ModuleTypes}{'35'}{Messages}{'$CommandHex'}{Prio} = \"$Prio\" ;\n" ;
            print OUTPUT "\$global{Cons}{ModuleTypes}{'36'}{Messages}{'$CommandHex'}{Name} = \"$Name\" ;\n" ;
            print OUTPUT "\$global{Cons}{ModuleTypes}{'36'}{Messages}{'$CommandHex'}{Info} = \"$Info\" ;\n" ;
            print OUTPUT "\$global{Cons}{ModuleTypes}{'36'}{Messages}{'$CommandHex'}{Prio} = \"$Prio\" ;\n" ;
         }
         if ( $ModuleTypeHex eq "3C" ) {
            print OUTPUT "\$global{Cons}{ModuleTypes}{'3A'}{Messages}{'$CommandHex'}{Name} = \"$Name\" ;\n" ;
            print OUTPUT "\$global{Cons}{ModuleTypes}{'3A'}{Messages}{'$CommandHex'}{Info} = \"$Info\" ;\n" ;
            print OUTPUT "\$global{Cons}{ModuleTypes}{'3A'}{Messages}{'$CommandHex'}{Prio} = \"$Prio\" ;\n" ;
            print OUTPUT "\$global{Cons}{ModuleTypes}{'3B'}{Messages}{'$CommandHex'}{Name} = \"$Name\" ;\n" ;
            print OUTPUT "\$global{Cons}{ModuleTypes}{'3B'}{Messages}{'$CommandHex'}{Info} = \"$Info\" ;\n" ;
            print OUTPUT "\$global{Cons}{ModuleTypes}{'3B'}{Messages}{'$CommandHex'}{Prio} = \"$Prio\" ;\n" ;
         }
      }
   }
}

#print Dumper \%{$file{PerCommandHexBroadcast}} ;
print OUTPUT "\n" ;

foreach my $CommandHex (sort keys %{$file{PerCommandHexBroadcast}}) {
   my @Name = sort keys %{$file{PerCommandHexBroadcast}{$CommandHex}{CommandText}} ;
   my @Info = sort keys %{$file{PerCommandHexBroadcast}{$CommandHex}{Info}} ;
   my @Prio = sort keys %{$file{PerCommandHexBroadcast}{$CommandHex}{Prio}} ;

   my $Name = join ";", @Name ;
   my $Info = join ";", @Info ;
   my $Prio = join ";", @Prio    ;

   print OUTPUT "\$global{Cons}{MessagesBroadCast}{'$CommandHex'}{Name} = \"$Name\" ;\n" ;
   print OUTPUT "\$global{Cons}{MessagesBroadCast}{'$CommandHex'}{Info} = \"$Info\" ;\n" ;
   print OUTPUT "\$global{Cons}{MessagesBroadCast}{'$CommandHex'}{Prio} = \"$Prio\" ;\n" ;
}

print OUTPUT "\n" ;

foreach my $ModuleTypeHex (sort keys %{$file{ModuleType}}) {
   foreach my $info (sort keys %{$file{ModuleType}{$ModuleTypeHex}}) {
      print OUTPUT "\$file{Cons}{ModuleType}{'$ModuleTypeHex'}{$info} = $file{ModuleType}{$ModuleTypeHex}{$info} ;\n" ;
      if ( $ModuleTypeHex eq "1E" ) {
         print OUTPUT "\$file{Cons}{ModuleType}{'1F'}{$info} = $file{ModuleType}{$ModuleTypeHex}{$info} ;\n" ;
         print OUTPUT "\$file{Cons}{ModuleType}{'20'}{$info} = $file{ModuleType}{$ModuleTypeHex}{$info} ;\n" ;
      }
      if ( $ModuleTypeHex eq "34" ) {
         print OUTPUT "\$file{Cons}{ModuleType}{'34'}{$info} = $file{ModuleType}{$ModuleTypeHex}{$info} ;\n" ;
         print OUTPUT "\$file{Cons}{ModuleType}{'35'}{$info} = $file{ModuleType}{$ModuleTypeHex}{$info} ;\n" ;
      }
      if ( $ModuleTypeHex eq "3C" ) {
         print OUTPUT "\$file{Cons}{ModuleType}{'3A'}{$info} = $file{ModuleType}{$ModuleTypeHex}{$info} ;\n" ;
         print OUTPUT "\$file{Cons}{ModuleType}{'3B'}{$info} = $file{ModuleType}{$ModuleTypeHex}{$info} ;\n" ;
      }
   }
}

close OUTPUT ;

sub clean () {
   my $text = $_[0] ;
   chomp $text ;
   $text =~ s/^ +//g ;
   $text =~ s/ +$//g ;
   $text =~ s/‘//g ;
   $text =~ s/’//g ;
   return $text ;
}
