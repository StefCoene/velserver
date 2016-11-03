# This is a big list of all Velbus module related info.
# Most of the info comes from the protocol pdf files you can download.
# Script pdf2txt.pl is used to extract the message information.

# list of possible messages
#   $global{Cons}{MessageTypes}{'FF'}{Name} = "Module type" ;
#   $global{Cons}{MessageTypes}{'B0'}{Name} = "Module subtype" ;
#   $global{Cons}{MessageTypes}{'FA'}{Name} = "Status request" ;
#   $global{Cons}{MessageTypes}{'D8'}{Name} = "Realtime clock status" ;

# Channels of specific modules
# 4-channel voltage-out relay module
   $global{Cons}{ModuleTypes}{'10'}{Channels}{"0x01"} = "Relay 1" ;
   $global{Cons}{ModuleTypes}{'10'}{Channels}{"0x02"} = "Relay 2" ;
   $global{Cons}{ModuleTypes}{'10'}{Channels}{"0x04"} = "Relay 3" ;
   $global{Cons}{ModuleTypes}{'10'}{Channels}{"0x08"} = "Relay 4" ;
   $global{Cons}{ModuleTypes}{'10'}{Channels}{"0x10"} = "Virtual Relay" ;
# 4-channel relay module
   $global{Cons}{ModuleTypes}{'11'}{Channels}{"0x01"} = "Relay 1" ;
   $global{Cons}{ModuleTypes}{'11'}{Channels}{"0x02"} = "Relay 2" ;
   $global{Cons}{ModuleTypes}{'11'}{Channels}{"0x04"} = "Relay 3" ;
   $global{Cons}{ModuleTypes}{'11'}{Channels}{"0x08"} = "Relay 4" ;
   $global{Cons}{ModuleTypes}{'11'}{Channels}{"0x10"} = "Virtual Relay" ;
# 4-channel 0(1)-10V control
   $global{Cons}{ModuleTypes}{'12'}{Channels}{"0x01"} = "Dimmer 1" ;
   $global{Cons}{ModuleTypes}{'12'}{Channels}{"0x02"} = "Dimmer 2" ;
   $global{Cons}{ModuleTypes}{'12'}{Channels}{"0x04"} = "Dimmer 3" ;
   $global{Cons}{ModuleTypes}{'12'}{Channels}{"0x08"} = "Dimmer 4" ;
# 2-channel blind control module
   $global{Cons}{ModuleTypes}{'1D'}{Channels}{"0x01"} = "Blind 1" ;
   $global{Cons}{ModuleTypes}{'1D'}{Channels}{"0x02"} = "Blind 2" ;

# Extra command info
# FB = COMMAND_RELAY_STATUS
   #$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'2'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'2'}{Match}{'00000001'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'2'}{Match}{'00000010'}{Channel} = "02" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'2'}{Match}{'00000100'}{Channel} = "04" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'2'}{Match}{'00001000'}{Channel} = "08" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'2'}{Match}{'00010000'}{Channel} = "10" ;

   #$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'3'}{Name} = "Channel status" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'3'}{Match}{'%......00'}{Info} = "Channel normal" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'3'}{Match}{'%......01'}{Info} = "Channel inhibted" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'3'}{Match}{'%......10'}{Info} = "Channel forced on" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'3'}{Match}{'%......11'}{Info} = "Channel disabled" ;
   #$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'4'}{Name} = "Relay status" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'4'}{Match}{'%......00'}{Info} = "Relay channel off" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'4'}{Match}{'%......01'}{Info} = "Relay channel on" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'4'}{Match}{'%......11'}{Info} = "Relay channel interval timer on" ;
   #$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'5'}{Name} = "LED status" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'5'}{Match}{'00000000'}{Info} = "LED off" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'5'}{Match}{'10000000'}{Info} = "LED on" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'5'}{Match}{'01000000'}{Info} = "LED slow blinking" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'5'}{Match}{'00100000'}{Info} = "LED fast blinking" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'5'}{Match}{'00010000'}{Info} = "LED very fast blinking" ;
   # 5 + 6 + 7 -> 24 bit time in seconds for current delay time (TODO)

# 07 = COMMAND_SET_DIMVALUE
   #$global{Cons}{ModuleTypes}{'10'}{Messages}{'07'}{Data}{'2'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{'2'}{Match}{'01'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{'2'}{Match}{'02'}{Channel} = "02" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{'2'}{Match}{'04'}{Channel} = "04" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{'2'}{Match}{'08'}{Channel} = "08" ;
   #$global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{'3'}{Match}{Value} = "yes" ;
# 0F = COMMAND_SLIDER_STATUS"
   #$global{Cons}{ModuleTypes}{'10'}{Messages}{'0F'}{Data}{'2'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'0F'}{Data}{'2'}{Match}{'01'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'0F'}{Data}{'2'}{Match}{'02'}{Channel} = "02" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'0F'}{Data}{'2'}{Match}{'04'}{Channel} = "04" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'0F'}{Data}{'2'}{Match}{'08'}{Channel} = "08" ;
   #$global{Cons}{ModuleTypes}{'12'}{Messages}{'0F'}{Data}{'4'}{Name} = "Dimmer" ;

# B8 = COMMAND_DIMMERCONTROLLER_STATUS
   #$global{Cons}{ModuleTypes}{'10'}{Messages}{'B8'}{Data}{'2'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'2'}{Match}{'00000001'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'2'}{Match}{'00000010'}{Channel} = "02" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'2'}{Match}{'00000100'}{Channel} = "04" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'2'}{Match}{'00001000'}{Channel} = "08" ;
   #$global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'3'}{Name} = "Channel status" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'3'}{Match}{'%......00'}{Info} = "Channel normal" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'3'}{Match}{'%......01'}{Info} = "Channel inhibted" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'3'}{Match}{'%......10'}{Info} = "Channel forced on" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'3'}{Match}{'%......11'}{Info} = "Channel disabled" ;
   #$global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'4'}{Name} = "Dimmer" ;
   #$global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'4'}{Match}{Value} = "yes" ;
   #$global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'5'}{Name} = "LED status" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'5'}{Match}{'00000000'}{Info} = "LED off" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'5'}{Match}{'10000000'}{Info} = "LED on" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'5'}{Match}{'01000000'}{Info} = "LED slow blinking" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'5'}{Match}{'00100000'}{Info} = "LED fast blinking" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'5'}{Match}{'00010000'}{Info} = "LED very fast blinking" ;
   # 5 + 6 + 7 -> 24 bit time in seconds for current delay time (TODO)

# EC = COMMAND_BLIND_STATUS
   #$global{Cons}{ModuleTypes}{'10'}{Messages}{'EC'}{Data}{'2'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'2'}{Match}{'01'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'2'}{Match}{'02'}{Channel} = "02" ;
   #$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'4'}{Name} = "Blind status" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'4'}{Match}{'00'}{Info} = "Off" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'4'}{Match}{'01'}{Info} = "Up" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'4'}{Match}{'02'}{Info} = "Down" ;

   # LED status
   #$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'5'}{Name} = "Led status" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'5'}{Match}{'00'}{Info} = "Leds off" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'5'}{Match}{'18'}{Info} = "Down LED on" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'5'}{Match}{'14'}{Info} = "Down LED slow blinking" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'5'}{Match}{'12'}{Info} = "Down LED fast blinking" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'5'}{Match}{'10'}{Info} = "Down LED very fast blinking" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'5'}{Match}{'08'}{Info} = "Up LED on" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'5'}{Match}{'04'}{Info} = "Up LED slow blinking" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'5'}{Match}{'02'}{Info} = "Up LED fast blinking" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'5'}{Match}{'01'}{Info} = "Up LED very fast blinking" ;
   # 4: blind position (0% = up...100%=down)
   #$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'6'}{Name} = "Position" ;
   #$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'6'}{Match}{Value} = "yes" ;

   #$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'7'}{Name} = "Channel status" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'7'}{Match}{'00'}{Info} = "Channel normal" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'7'}{Match}{'01'}{Info} = "Channel inhibted" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'7'}{Match}{'02'}{Info} = "Channel inhibted preset down" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'7'}{Match}{'03'}{Info} = "Channel inhibted preset up" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'7'}{Match}{'04'}{Info} = "Channel forced down" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'7'}{Match}{'05'}{Info} = "Channel forced up" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'7'}{Match}{'06'}{Info} = "Channel locked" ;

   
   #$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'10'}{Name} = "Options" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'10'}{Match}{'%......00'}{Info} = "Auto mode disabled" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'10'}{Match}{'%......01'}{Info} = "Auto mode 1" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'10'}{Match}{'%......10'}{Info} = "Auto mode 2" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'10'}{Match}{'%......11'}{Info} = "Auto mode 3" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'10'}{Match}{'%.....0..'}{Info} = "Alarm 1 off" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'10'}{Match}{'%.....1..'}{Info} = "Alarm 1 on" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'10'}{Match}{'%....0...'}{Info} = "Local alarm 1" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'10'}{Match}{'%....1...'}{Info} = "Global alarm 1" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'10'}{Match}{'%...0....'}{Info} = "Alarm 2 off" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'10'}{Match}{'%...1....'}{Info} = "Alarm 2 on" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'10'}{Match}{'%..0.....'}{Info} = "Local alarm 2" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'10'}{Match}{'%..1.....'}{Info} = "Global alarm 2" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'10'}{Match}{'%.0......'}{Info} = "Sunrise disabled" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'10'}{Match}{'%.1......'}{Info} = "Sunrise enabled" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'10'}{Match}{'%0.......'}{Info} = "Sunset disabled" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'10'}{Match}{'%1.......'}{Info} = "Sunset enabled" ;

return 1 ;
