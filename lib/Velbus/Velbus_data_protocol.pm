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
$global{Cons}{ModuleTypes}{'10'}{Channels}{"0x01"}{Name} = "Relay 1" ;
$global{Cons}{ModuleTypes}{'10'}{Channels}{"0x02"}{Name} = "Relay 2" ;
$global{Cons}{ModuleTypes}{'10'}{Channels}{"0x04"}{Name} = "Relay 3" ;
$global{Cons}{ModuleTypes}{'10'}{Channels}{"0x08"}{Name} = "Relay 4" ;
$global{Cons}{ModuleTypes}{'10'}{Channels}{"0x10"}{Name} = "Virtual Relay" ;

# 4-channel relay module
$global{Cons}{ModuleTypes}{'11'}{Channels}{"0x01"}{Name} = "Relay 1" ;
$global{Cons}{ModuleTypes}{'11'}{Channels}{"0x02"}{Name} = "Relay 2" ;
$global{Cons}{ModuleTypes}{'11'}{Channels}{"0x04"}{Name} = "Relay 3" ;
$global{Cons}{ModuleTypes}{'11'}{Channels}{"0x08"}{Name} = "Relay 4" ;
$global{Cons}{ModuleTypes}{'11'}{Channels}{"0x10"}{Name} = "Virtual Relay" ;

# 1-channel 0(1)-10V control: VMB1DM
$global{Cons}{ModuleTypes}{'07'}{Channels}{"0x01"}{Name} = "Dimmer 1" ;
# 1-channel LED: VMB1LED
$global{Cons}{ModuleTypes}{'0F'}{Channels}{"0x01"}{Name} = "Dimmer 1" ;
# 4-channel 0(1)-10V control
$global{Cons}{ModuleTypes}{'12'}{Channels}{"0x01"}{Name} = "Dimmer 1" ;
$global{Cons}{ModuleTypes}{'12'}{Channels}{"0x02"}{Name} = "Dimmer 2" ;
$global{Cons}{ModuleTypes}{'12'}{Channels}{"0x04"}{Name} = "Dimmer 3" ;
$global{Cons}{ModuleTypes}{'12'}{Channels}{"0x08"}{Name} = "Dimmer 4" ;
# 1-channel Dimmer: VMBDME
$global{Cons}{ModuleTypes}{'14'}{Channels}{"0x01"}{Name} = "Dimmer 1" ;
# 1-channel Dimmer: VMBDMI
$global{Cons}{ModuleTypes}{'15'}{Channels}{"0x01"}{Name} = "Dimmer 1" ;

# 1-channel blind control module: VMB1BL
$global{Cons}{ModuleTypes}{'03'}{Channels}{"0x01"}{Name} = "Blind 1" ;
# 2-channel blind control module: VMB2BL
$global{Cons}{ModuleTypes}{'09'}{Channels}{"0x01"}{Name} = "Blind 1" ;
$global{Cons}{ModuleTypes}{'09'}{Channels}{"0x01"}{Name} = "Blind 2" ;
# 2-channel blind control module: VMB2BLE
$global{Cons}{ModuleTypes}{'1D'}{Channels}{"0x01"}{Name} = "Blind 1" ;
$global{Cons}{ModuleTypes}{'1D'}{Channels}{"0x02"}{Name} = "Blind 2" ;

# Extra command info
# FB = COMMAND_RELAY_STATUS
$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'0'}{Name} = "Channel" ;
$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'0'}{Match}{'00000001'}{Channel} = "01" ;
$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'0'}{Match}{'00000010'}{Channel} = "02" ;
$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'0'}{Match}{'00000100'}{Channel} = "04" ;
$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'0'}{Match}{'00001000'}{Channel} = "08" ;
$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'0'}{Match}{'00010000'}{Channel} = "10" ;

$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'1'}{Name} = "Channel status" ;
$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'1'}{Match}{'%......00'}{Info} = "Channel normal" ;
$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'1'}{Match}{'%......01'}{Info} = "Channel inhibted" ;
$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'1'}{Match}{'%......10'}{Info} = "Channel forced on" ;
$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'1'}{Match}{'%......11'}{Info} = "Channel disabled" ;
$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'2'}{Name} = "Relay status" ;
$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'2'}{Match}{'%......00'}{Info} = "Relay channel off" ;
$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'2'}{Match}{'%......01'}{Info} = "Relay channel on" ;
$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'2'}{Match}{'%......11'}{Info} = "Relay channel interval timer on" ;
$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'3'}{Name} = "LED status" ;
$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'3'}{Match}{'00000000'}{Info} = "LED off" ;
$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'3'}{Match}{'10000000'}{Info} = "LED on" ;
$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'3'}{Match}{'01000000'}{Info} = "LED slow blinking" ;
$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'3'}{Match}{'00100000'}{Info} = "LED fast blinking" ;
$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'3'}{Match}{'00010000'}{Info} = "LED very fast blinking" ;
# 5 + 6 + 7 -> 24 bit time in seconds for current delay time (TODO)

$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'0'}{Name} = "Channel" ;
$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'0'}{Match}{'00000001'}{Channel} = "01" ;
$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'0'}{Match}{'00000010'}{Channel} = "02" ;
$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'0'}{Match}{'00000100'}{Channel} = "04" ;
$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'0'}{Match}{'00001000'}{Channel} = "08" ;
$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'0'}{Match}{'00010000'}{Channel} = "10" ;

$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'1'}{Name} = "Channel status" ;
$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'1'}{Match}{'%......00'}{Info} = "Channel normal" ;
$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'1'}{Match}{'%......01'}{Info} = "Channel inhibted" ;
$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'1'}{Match}{'%......10'}{Info} = "Channel forced on" ;
$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'1'}{Match}{'%......11'}{Info} = "Channel disabled" ;
$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'2'}{Name} = "Relay status" ;
$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'2'}{Match}{'%......00'}{Info} = "Relay channel off" ;
$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'2'}{Match}{'%......01'}{Info} = "Relay channel on" ;
$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'2'}{Match}{'%......11'}{Info} = "Relay channel interval timer on" ;
$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'3'}{Name} = "LED status" ;
$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'3'}{Match}{'00000000'}{Info} = "LED off" ;
$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'3'}{Match}{'10000000'}{Info} = "LED on" ;
$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'3'}{Match}{'01000000'}{Info} = "LED slow blinking" ;
$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'3'}{Match}{'00100000'}{Info} = "LED fast blinking" ;
$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'3'}{Match}{'00010000'}{Info} = "LED very fast blinking" ;
# 5 + 6 + 7 -> 24 bit time in seconds for current delay time (TODO)

# 0F = COMMAND_SLIDER_STATUS"
$global{Cons}{ModuleTypes}{'07'}{Messages}{'0F'}{Data}{'0'}{Name} = "Channel" ;
$global{Cons}{ModuleTypes}{'07'}{Messages}{'0F'}{Data}{'0'}{Match}{'01'}{Channel} = "01" ;
$global{Cons}{ModuleTypes}{'07'}{Messages}{'0F'}{Data}{'1'}{Name} = "Dimmer" ;
$global{Cons}{ModuleTypes}{'07'}{Messages}{'0F'}{Data}{'1'}{Match}{Procent} = "yes" ;

# 0F = COMMAND_SLIDER_STATUS"
$global{Cons}{ModuleTypes}{'0F'}{Messages}{'0F'}{Data}{'0'}{Name} = "Channel" ;
$global{Cons}{ModuleTypes}{'0F'}{Messages}{'0F'}{Data}{'0'}{Match}{'01'}{Channel} = "01" ;
$global{Cons}{ModuleTypes}{'0F'}{Messages}{'0F'}{Data}{'1'}{Name} = "Dimmer" ;
$global{Cons}{ModuleTypes}{'0F'}{Messages}{'0F'}{Data}{'1'}{Match}{Procent} = "yes" ;

# 07 = COMMAND_SET_DIMVALUE
$global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{'0'}{Name} = "Channel" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{'0'}{Match}{'01'}{Channel} = "01" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{'0'}{Match}{'02'}{Channel} = "02" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{'0'}{Match}{'04'}{Channel} = "04" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{'0'}{Match}{'08'}{Channel} = "08" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{'1'}{Name} = "Dimmer" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{'1'}{Match}{Procent} = "yes" ;
# 0F = COMMAND_SLIDER_STATUS
$global{Cons}{ModuleTypes}{'12'}{Messages}{'0F'}{Data}{'0'}{Name} = "Channel" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'0F'}{Data}{'0'}{Match}{'01'}{Channel} = "01" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'0F'}{Data}{'0'}{Match}{'02'}{Channel} = "02" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'0F'}{Data}{'0'}{Match}{'04'}{Channel} = "04" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'0F'}{Data}{'0'}{Match}{'08'}{Channel} = "08" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'0F'}{Data}{'1'}{Name} = "Dimmer" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'0F'}{Data}{'1'}{Match}{Procent} = "yes" ;

# B8 = COMMAND_DIMMERCONTROLLER_STATUS
$global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'0'}{Name} = "Channel" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'0'}{Match}{'00000001'}{Channel} = "01" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'0'}{Match}{'00000010'}{Channel} = "02" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'0'}{Match}{'00000100'}{Channel} = "04" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'0'}{Match}{'00001000'}{Channel} = "08" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'1'}{Name} = "Channel status" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'1'}{Match}{'%......00'}{Info} = "Channel normal" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'1'}{Match}{'%......01'}{Info} = "Channel inhibted" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'1'}{Match}{'%......10'}{Info} = "Channel forced on" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'1'}{Match}{'%......11'}{Info} = "Channel disabled" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'2'}{Name} = "Dimmer" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'2'}{Match}{Procent} = "yes" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'3'}{Name} = "LED status" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'3'}{Match}{'00000000'}{Info} = "LED off" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'3'}{Match}{'10000000'}{Info} = "LED on" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'3'}{Match}{'01000000'}{Info} = "LED slow blinking" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'3'}{Match}{'00100000'}{Info} = "LED fast blinking" ;
$global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'3'}{Match}{'00010000'}{Info} = "LED very fast blinking" ;
# 5 + 6 + 7 -> 24 bit time in seconds for current delay time (TODO)

# 0F = COMMAND_SLIDER_STATUS"
$global{Cons}{ModuleTypes}{'14'}{Messages}{'0F'}{Data}{'0'}{Name} = "Channel" ;
$global{Cons}{ModuleTypes}{'14'}{Messages}{'0F'}{Data}{'0'}{Match}{'01'}{Channel} = "01" ;
$global{Cons}{ModuleTypes}{'14'}{Messages}{'0F'}{Data}{'1'}{Name} = "Dimmer" ;
$global{Cons}{ModuleTypes}{'14'}{Messages}{'0F'}{Data}{'1'}{Match}{Procent} = "yes" ;

# 0F = COMMAND_SLIDER_STATUS"
$global{Cons}{ModuleTypes}{'15'}{Messages}{'0F'}{Data}{'0'}{Name} = "Channel" ;
$global{Cons}{ModuleTypes}{'15'}{Messages}{'0F'}{Data}{'0'}{Match}{'01'}{Channel} = "01" ;
$global{Cons}{ModuleTypes}{'15'}{Messages}{'0F'}{Data}{'1'}{Name} = "Dimmer" ;
$global{Cons}{ModuleTypes}{'15'}{Messages}{'0F'}{Data}{'1'}{Match}{Procent} = "yes" ;

# EC = COMMAND_BLIND_STATUS
$global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{'0'}{Name} = "Channel" ;
$global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{'0'}{Match}{'01'}{Channel} = "01" ;
# Blind status
$global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{'2'}{Name} = "Blind status" ;
$global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{'2'}{Match}{'00'}{Info} = "Off" ;
$global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{'2'}{Match}{'01'}{Info} = "Up" ;
$global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{'2'}{Match}{'02'}{Info} = "Down" ;
# LED status
$global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{'3'}{Name} = "Led status" ;
$global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{'3'}{Match}{'00'}{Info} = "Leds off" ;
$global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{'3'}{Match}{'18'}{Info} = "Down LED on" ;
$global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{'3'}{Match}{'14'}{Info} = "Down LED slow blinking" ;
$global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{'3'}{Match}{'12'}{Info} = "Down LED fast blinking" ;
$global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{'3'}{Match}{'10'}{Info} = "Down LED very fast blinking" ;
$global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{'3'}{Match}{'08'}{Info} = "Up LED on" ;
$global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{'3'}{Match}{'04'}{Info} = "Up LED slow blinking" ;
$global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{'3'}{Match}{'02'}{Info} = "Up LED fast blinking" ;
$global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{'3'}{Match}{'01'}{Info} = "Up LED very fast blinking" ;

# EC = COMMAND_BLIND_STATUS
$global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{'0'}{Name} = "Channel" ;
$global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{'0'}{Match}{'01'}{Channel} = "01" ;
$global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{'0'}{Match}{'02'}{Channel} = "02" ;
# Blind status
$global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{'2'}{Name} = "Blind status" ;
$global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{'2'}{Match}{'00000000'}{Info} = "Blinds off" ;
$global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{'2'}{Match}{'00000001'}{Info} = "Blind 1 up" ;
$global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{'2'}{Match}{'00000010'}{Info} = "Blind 1 down" ;
$global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{'2'}{Match}{'00000100'}{Info} = "Blind 2 up" ;
$global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{'2'}{Match}{'00001000'}{Info} = "Blind 2 down" ;
# LED status
$global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{'3'}{Name} = "Led status" ;
$global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{'3'}{Match}{'00'}{Info} = "Leds off" ;
$global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{'3'}{Match}{'18'}{Info} = "Down LED on" ;
$global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{'3'}{Match}{'14'}{Info} = "Down LED slow blinking" ;
$global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{'3'}{Match}{'12'}{Info} = "Down LED fast blinking" ;
$global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{'3'}{Match}{'10'}{Info} = "Down LED very fast blinking" ;
$global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{'3'}{Match}{'08'}{Info} = "Up LED on" ;
$global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{'3'}{Match}{'04'}{Info} = "Up LED slow blinking" ;
$global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{'3'}{Match}{'02'}{Info} = "Up LED fast blinking" ;
$global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{'3'}{Match}{'01'}{Info} = "Up LED very fast blinking" ;

# EC = COMMAND_BLIND_STATUS
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'0'}{Name} = "Channel" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'0'}{Match}{'01'}{Channel} = "01" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'0'}{Match}{'02'}{Channel} = "02" ;
# Blind status
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'2'}{Name} = "Blind status" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'2'}{Match}{'00'}{Info} = "Off" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'2'}{Match}{'01'}{Info} = "Up" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'2'}{Match}{'02'}{Info} = "Down" ;
# LED status
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'3'}{Name} = "Led status" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'3'}{Match}{'00'}{Info} = "Leds off" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'3'}{Match}{'18'}{Info} = "Down LED on" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'3'}{Match}{'14'}{Info} = "Down LED slow blinking" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'3'}{Match}{'12'}{Info} = "Down LED fast blinking" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'3'}{Match}{'10'}{Info} = "Down LED very fast blinking" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'3'}{Match}{'08'}{Info} = "Up LED on" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'3'}{Match}{'04'}{Info} = "Up LED slow blinking" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'3'}{Match}{'02'}{Info} = "Up LED fast blinking" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'3'}{Match}{'01'}{Info} = "Up LED very fast blinking" ;
# blind position (0% = up...100%=down)
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'4'}{Name} = "Position" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'4'}{Match}{Procent} = "yes" ;
# Channel status
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'5'}{Name} = "Channel status" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'5'}{Match}{'00'}{Info} = "Channel normal" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'5'}{Match}{'01'}{Info} = "Channel inhibted" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'5'}{Match}{'02'}{Info} = "Channel inhibted preset down" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'5'}{Match}{'03'}{Info} = "Channel inhibted preset up" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'5'}{Match}{'04'}{Info} = "Channel forced down" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'5'}{Match}{'05'}{Info} = "Channel forced up" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'5'}{Match}{'06'}{Info} = "Channel locked" ;
# Channel options
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'8'}{Name} = "Options" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'8'}{Match}{'%......00'}{Info} = "Auto mode disabled" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'8'}{Match}{'%......01'}{Info} = "Auto mode 1" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'8'}{Match}{'%......10'}{Info} = "Auto mode 2" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'8'}{Match}{'%......11'}{Info} = "Auto mode 3" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'8'}{Match}{'%.....0..'}{Info} = "Alarm 1 off" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'8'}{Match}{'%.....1..'}{Info} = "Alarm 1 on" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'8'}{Match}{'%....0...'}{Info} = "Local alarm 1" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'8'}{Match}{'%....1...'}{Info} = "Global alarm 1" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'8'}{Match}{'%...0....'}{Info} = "Alarm 2 off" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'8'}{Match}{'%...1....'}{Info} = "Alarm 2 on" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'8'}{Match}{'%..0.....'}{Info} = "Local alarm 2" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'8'}{Match}{'%..1.....'}{Info} = "Global alarm 2" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'8'}{Match}{'%.0......'}{Info} = "Sunrise disabled" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'8'}{Match}{'%.1......'}{Info} = "Sunrise enabled" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'8'}{Match}{'%0.......'}{Info} = "Sunset disabled" ;
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'8'}{Match}{'%1.......'}{Info} = "Sunset enabled" ;

$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Name} = "Operating mode" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.......1'}{Info} = "Mode push button locked" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.......0'}{Info} = "Mode push button unlocked" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%X....11.'}{Info} = "Disable mode" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.....01.'}{Info} = "Manual mode" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.....10.'}{Info} = "Sleep timer mode" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.....00.'}{Info} = "Run mode" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%....1...'}{Info} = "Auto send sensor temperature enabled" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%....0...'}{Info} = "Auto send sensor temperature disabled" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.100....'}{Name} = "Temperature mode" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.100....'}{Info} = "Comfort mode" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.010....'}{Name} = "Temperature mode" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.010....'}{Info} = "Day mode" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.001....'}{Name} = "Temperature mode" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.001....'}{Info} = "Night mode" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.000....'}{Name} = "Temperature mode" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.000....'}{Info} = "Safe temp mode (anti frost)" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%1.......'}{Info} = "Cooler mode" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%0.......'}{Info} = "Heater mode" ;

$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'1'}{Name} = "Program step mode" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.....0..'}{Info} = "No sensor program group 1" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.....1..'}{Info} = "Sensor program group 1 available" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'1'}{Match}{'%....0...'}{Info} = "No sensor program group 2" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'1'}{Match}{'%....1...'}{Info} = "Sensor program group 2 available" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'1'}{Match}{'%0.......'}{Info} = "No sensor program group 3" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'1'}{Match}{'%1.......'}{Info} = "Sensor program group 3 available" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.100....'}{Info} = "Comfort program step received" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.010....'}{Info} = "Day program step received" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.001....'}{Info} = "Night program step received" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'1'}{Match}{'%X000....'}{Info} = "Safe temperature program step received" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'1'}{Match}{'%......1.'}{Info} = "Enable unjamming heater valve" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'1'}{Match}{'%......0.'}{Info} = "Disable unjamming heater valve" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.......1'}{Info} = "Enable unjamming pump" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.......0'}{Info} = "Disable unjamming pump" ;

$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'2'}{Name} = "Output status" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.......0'}{Info} = "Heater off" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.......1'}{Info} = "Heater on" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'2'}{Match}{'%......0.'}{Info} = "Boost heater/cooler off" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'2'}{Match}{'%......1.'}{Info} = "Boost heater/cooler on" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.....0..'}{Info} = "Pump off" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.....1..'}{Info} = "Pump on" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'2'}{Match}{'%....0...'}{Info} = "Cooler off" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'2'}{Match}{'%....1...'}{Info} = "Cooler on" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'2'}{Match}{'%...0....'}{Info} = "Temperature alarm 1 off" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'2'}{Match}{'%...1....'}{Info} = "Temperature alarm 1 on" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'2'}{Match}{'%..0.....'}{Info} = "Temperature alarm 2 off" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'2'}{Match}{'%..1.....'}{Info} = "Temperature alarm 2 on" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.0......'}{Info} = "Temperature alarm 3 off" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.1......'}{Info} = "Temperature alarm 3 on" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'2'}{Match}{'%0.......'}{Info} = "Temperature alarm 4 off" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'2'}{Match}{'%1.......'}{Info} = "Temperature alarm 4 on" ;

$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'3'}{Name} = "Current temperature" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'3'}{Match}{Temperature} = "yes" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'4'}{Name} = "Current temperature set" ;
$global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'4'}{Match}{Temperature} = "yes" ;

$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Name} = "Operating mode" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.......1'}{Info} = "Mode push button locked" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.......0'}{Info} = "Mode push button unlocked" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%X....11.'}{Info} = "Disable mode" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.....01.'}{Info} = "Manual mode" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.....10.'}{Info} = "Sleep timer mode" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.....00.'}{Info} = "Run mode" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%....1...'}{Info} = "Auto send sensor temperature enabled" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%....0...'}{Info} = "Auto send sensor temperature disabled" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.100....'}{Name} = "Temperature mode" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.100....'}{Info} = "Comfort mode" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.010....'}{Name} = "Temperature mode" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.010....'}{Info} = "Day mode" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.001....'}{Name} = "Temperature mode" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.001....'}{Info} = "Night mode" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.000....'}{Name} = "Temperature mode" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.000....'}{Info} = "Safe temp mode (anti frost)" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%1.......'}{Info} = "Cooler mode" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%0.......'}{Info} = "Heater mode" ;

$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'1'}{Name} = "Program step mode" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.....0..'}{Info} = "No sensor program group 1" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.....1..'}{Info} = "Sensor program group 1 available" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'1'}{Match}{'%....0...'}{Info} = "No sensor program group 2" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'1'}{Match}{'%....1...'}{Info} = "Sensor program group 2 available" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'1'}{Match}{'%0.......'}{Info} = "No sensor program group 3" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'1'}{Match}{'%1.......'}{Info} = "Sensor program group 3 available" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.100....'}{Info} = "Comfort program step received" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.010....'}{Info} = "Day program step received" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.001....'}{Info} = "Night program step received" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'1'}{Match}{'%X000....'}{Info} = "Safe temperature program step received" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'1'}{Match}{'%......1.'}{Info} = "Enable unjamming heater valve" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'1'}{Match}{'%......0.'}{Info} = "Disable unjamming heater valve" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.......1'}{Info} = "Enable unjamming pump" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.......0'}{Info} = "Disable unjamming pump" ;

$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'2'}{Name} = "Output status" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.......0'}{Info} = "Heater off" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.......1'}{Info} = "Heater on" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'2'}{Match}{'%......0.'}{Info} = "Boost heater/cooler off" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'2'}{Match}{'%......1.'}{Info} = "Boost heater/cooler on" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.....0..'}{Info} = "Pump off" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.....1..'}{Info} = "Pump on" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'2'}{Match}{'%....0...'}{Info} = "Cooler off" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'2'}{Match}{'%....1...'}{Info} = "Cooler on" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'2'}{Match}{'%...0....'}{Info} = "Temperature alarm 1 off" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'2'}{Match}{'%...1....'}{Info} = "Temperature alarm 1 on" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'2'}{Match}{'%..0.....'}{Info} = "Temperature alarm 2 off" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'2'}{Match}{'%..1.....'}{Info} = "Temperature alarm 2 on" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.0......'}{Info} = "Temperature alarm 3 off" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.1......'}{Info} = "Temperature alarm 3 on" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'2'}{Match}{'%0.......'}{Info} = "Temperature alarm 4 off" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'2'}{Match}{'%1.......'}{Info} = "Temperature alarm 4 on" ;

$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'3'}{Name} = "Current temperature" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'3'}{Match}{Temperature} = "yes" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'4'}{Name} = "Current temperature set" ;
$global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'4'}{Match}{Temperature} = "yes" ;

# Don't think this is usefull
#$global{Cons}{ModuleTypes}{'28'}{Messages}{'ED'}{Data}{'5'}{Name} = "alarm and program selection" ;
#$global{Cons}{ModuleTypes}{'28'}{Messages}{'ED'}{Data}{'5'}{Match}{'%......00'}{Info} = "None" ;
#$global{Cons}{ModuleTypes}{'28'}{Messages}{'ED'}{Data}{'5'}{Match}{'%......01'}{Info} = "Summer" ;
#$global{Cons}{ModuleTypes}{'28'}{Messages}{'ED'}{Data}{'5'}{Match}{'%......10'}{Info} = "Winter" ;
#$global{Cons}{ModuleTypes}{'28'}{Messages}{'ED'}{Data}{'5'}{Match}{'%......11'}{Info} = "Holiday" ;
#$global{Cons}{ModuleTypes}{'28'}{Messages}{'ED'}{Data}{'5'}{Match}{'%.....0..'}{Info} = "Alarm 1 off" ;
#$global{Cons}{ModuleTypes}{'28'}{Messages}{'ED'}{Data}{'5'}{Match}{'%.....1..'}{Info} = "Alarm 1 on" ;
#$global{Cons}{ModuleTypes}{'28'}{Messages}{'ED'}{Data}{'5'}{Match}{'%....0...'}{Info} = "Local alarm 1" ;
#$global{Cons}{ModuleTypes}{'28'}{Messages}{'ED'}{Data}{'5'}{Match}{'%....1...'}{Info} = "Global alarm 1" ;
#$global{Cons}{ModuleTypes}{'28'}{Messages}{'ED'}{Data}{'5'}{Match}{'%...0....'}{Info} = "Alarm 2 off" ;
#$global{Cons}{ModuleTypes}{'28'}{Messages}{'ED'}{Data}{'5'}{Match}{'%...1....'}{Info} = "Alarm 2 on" ;
#$global{Cons}{ModuleTypes}{'28'}{Messages}{'ED'}{Data}{'5'}{Match}{'%..0.....'}{Info} = "Local alarm 2" ;
#$global{Cons}{ModuleTypes}{'28'}{Messages}{'ED'}{Data}{'5'}{Match}{'%..1.....'}{Info} = "Global alarm 2" ;
#$global{Cons}{ModuleTypes}{'28'}{Messages}{'ED'}{Data}{'5'}{Match}{'%.0......'}{Info} = "Sunrise disabled" ;
#$global{Cons}{ModuleTypes}{'28'}{Messages}{'ED'}{Data}{'5'}{Match}{'%.1......'}{Info} = "Sunrise enabled" ;
#$global{Cons}{ModuleTypes}{'28'}{Messages}{'ED'}{Data}{'5'}{Match}{'%0.......'}{Info} = "Sunset disabled" ;
#$global{Cons}{ModuleTypes}{'28'}{Messages}{'ED'}{Data}{'5'}{Match}{'%1.......'}{Info} = "Sunset enabled" ;


return 1 ;
