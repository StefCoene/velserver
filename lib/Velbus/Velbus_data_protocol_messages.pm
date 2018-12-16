# This is a list of messages with extra options.
# The format is easy to understand
#
# Temperature Sensor Module : VMB1TS
# 00 = COMMAND_OUTPUT_STATUS
#   This is in 2 blocks in the protocol file, the second blocks starts with x but since the first block starts with 0, this has to be 1.
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'0'}{Name} = "Heater" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'0'}{Match}{'%0..1...1'}{Info} = "Heater activated" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'0'}{Match}{'%0.....1.'}{Info} = "Turbo heater/cooler activated" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'0'}{Match}{'%0....1..'}{Info} = "Comfort or day mode activated" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'0'}{Match}{'%0...1...'}{Info} = "Cooler activated" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'0'}{Match}{'%0.1.....'}{Info} = "Low temperature alarm activated" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'0'}{Match}{'%01......'}{Info} = "High temperature alarm activated" ;

$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'1'}{Match}{'%0..1...1'}{Info} = "Heater deactivated" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'1'}{Match}{'%0.....1.'}{Info} = "Turbo heater/cooler deactivated" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'1'}{Match}{'%0....1..'}{Info} = "Comfort or day mode deactivated" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'1'}{Match}{'%0...1...'}{Info} = "Cooler deactivated" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'1'}{Match}{'%0.0.....'}{Info} = "Low temperature alarm deactivated" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'1'}{Match}{'%00......'}{Info} = "High temperature alarm deactivated" ;

$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'0'}{Match}{'%1......1'}{Info} = "Heater push button pressed" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'0'}{Match}{'%1.....1.'}{Info} = "Turbo heater/cooler push button pressed" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'0'}{Match}{'%1....1..'}{Info} = "Day mode push button pressed" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'0'}{Match}{'%1...1...'}{Info} = "Cooler push button pressed" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'0'}{Match}{'%1..1....'}{Info} = "Mode & heater (pump) button pressed" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'0'}{Match}{'%1.1.....'}{Info} = "Mode & turbo (low alarm) button pressed" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'0'}{Match}{'%11......'}{Info} = "Mode & day (high alarm) button pressed" ;

$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'1'}{Match}{'%1......1'}{Info} = "Heater push button released" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'1'}{Match}{'%1.....1.'}{Info} = "Turbo heater/cooler push button released" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'1'}{Match}{'%1....1..'}{Info} = "Day mode push button released" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'1'}{Match}{'%1...1...'}{Info} = "Cooler push button released" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'1'}{Match}{'%1..1....'}{Info} = "Mode & heater (pump) button released" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'1'}{Match}{'%1.1.....'}{Info} = "Mode & turbo (low alarm) button released" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'1'}{Match}{'%11......'}{Info} = "Mode & day (high alarm) button released" ;

$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'2'}{Match}{'%1......1'}{Info} = "Heater push button long pressed" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'2'}{Match}{'%1.....1.'}{Info} = "Turbo heater/cooler push button long pressed" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'2'}{Match}{'%1....1..'}{Info} = "Day mode push button long pressed" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'2'}{Match}{'%1...1...'}{Info} = "Cooler push button long pressed" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'2'}{Match}{'%1..1....'}{Info} = "Mode & heater (pump) button long pressed" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'2'}{Match}{'%1.1.....'}{Info} = "Mode & turbo (low alarm) button long pressed" ;
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{Data}{PerByte}{'2'}{Match}{'%11......'}{Info} = "Mode & day (high alarm) button long pressed" ;

################### Relays: messages
# 1-channel relay module: VMB1RY
$global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000001'}{Channel} = "01" ;

   $global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Name} = "Relay status" ;
   $global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000000'}{Info} = "Relay channel off" ;
   $global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000000'}{openHAB} = "OFF:Relay" ;
   $global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000001'}{Info} = "Relay channel on" ;
   $global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000001'}{openHAB} = "ON:Relay" ;

# 4-channel relay module: VMB4RY
$global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000001'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000010'}{Channel} = "02" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000100'}{Channel} = "03" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00001000'}{Channel} = "04" ;

   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Name} = "Relay status" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000000'}{Info} = "Relay channel off" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000000'}{openHAB} = "OFF:Relay" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000001'}{Info} = "Relay channel on" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000001'}{openHAB} = "ON:Relay" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000010'}{Info} = "Relay channel on" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000010'}{openHAB} = "ON:Relay" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000100'}{Info} = "Relay channel on" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000100'}{openHAB} = "ON:Relay" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00001000'}{Info} = "Relay channel on" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00001000'}{openHAB} = "ON:Relay" ;

   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{General} = "Byte3LedStatus" ;

# 4 channel relay module with directload connections: VMB4RYLD
# FB = COMMAND_RELAY_STATUS
$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000001'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000010'}{Channel} = "02" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000100'}{Channel} = "03" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00001000'}{Channel} = "04" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00010000'}{Channel} = "05" ; # Virtual channel

   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{General} = "Byte1ChannelStatus" ;

   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Name} = "Relay status" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......00'}{Info} = "Relay channel off" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......00'}{openHAB} = "OFF:Relay" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......01'}{Info} = "Relay channel on" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......01'}{openHAB} = "ON:Relay" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......11'}{Info} = "Relay channel interval timer on" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......11'}{openHAB} = "ON:Relay" ;

   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{General} = "Byte3LedStatus" ;

# 4 channel relay module with normalopen contacts: VMB4RYNO
# FB = COMMAND_RELAY_STATUS
$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000001'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000010'}{Channel} = "02" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000100'}{Channel} = "03" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00001000'}{Channel} = "04" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00010000'}{Channel} = "05" ; # Virtual channel

   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{General} = "Byte1ChannelStatus" ;

   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Name} = "Relay status" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......00'}{Info} = "Relay channel off" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......00'}{openHAB} = "OFF:Relay" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......01'}{Info} = "Relay channel on" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......01'}{openHAB} = "ON:Relay" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......11'}{Info} = "Relay channel interval timer on" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......11'}{openHAB} = "ON:Relay" ;

   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{General} = "Byte3LedStatus" ;

# 4 channel relay module with normalopen contacts: VMB1RYNO
# FB = COMMAND_RELAY_STATUS
$global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000001'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000010'}{Channel} = "02" ; # Virtual channel
   $global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000100'}{Channel} = "03" ; # Virtual channel
   $global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00001000'}{Channel} = "04" ; # Virtual channel
   $global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00010000'}{Channel} = "05" ; # Virtual channel

   $global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{General} = "Byte1ChannelStatus" ;

   $global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Name} = "Relay status" ;
   $global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......00'}{Info} = "Relay channel off" ;
   $global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......00'}{openHAB} = "OFF:Relay" ;
   $global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......01'}{Info} = "Relay channel on" ;
   $global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......01'}{openHAB} = "ON:Relay" ;
   $global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......11'}{Info} = "Relay channel interval timer on" ;
   $global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......11'}{openHAB} = "ON:Relay" ;

   $global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{General} = "Byte3LedStatus" ;

# 1 channel relay module: VMB1RYNOS
$global{Cons}{ModuleTypes}{'29'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'29'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000001'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'29'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000010'}{Channel} = "02" ; # Virtual channel
   $global{Cons}{ModuleTypes}{'29'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000100'}{Channel} = "03" ; # Virtual channel
   $global{Cons}{ModuleTypes}{'29'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00001000'}{Channel} = "04" ; # Virtual channel
   $global{Cons}{ModuleTypes}{'29'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00010000'}{Channel} = "05" ; # Virtual channel

   $global{Cons}{ModuleTypes}{'29'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Name} = "Relay status" ;
   $global{Cons}{ModuleTypes}{'29'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000000'}{Info} = "Relay channel off" ;
   $global{Cons}{ModuleTypes}{'29'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000000'}{openHAB} = "OFF:Relay" ;
   $global{Cons}{ModuleTypes}{'29'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000001'}{Info} = "Relay channel on" ;
   $global{Cons}{ModuleTypes}{'29'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000001'}{openHAB} = "ON:Relay" ;


################### Dimmers: messages
# Dimmer module: VMB1DM
# 0F = COMMAND_SLIDER_STATUS
$global{Cons}{ModuleTypes}{'07'}{Messages}{'0F'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'0F'}{Data}{PerByte}{'0'}{Match}{'01'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'0F'}{Data}{PerByte}{'1'}{Name} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'0F'}{Data}{PerByte}{'1'}{Match}{'%.'}{Convert} = "Procent" ;

   # EE = COMMAND_DIMMER_STATUS
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Match}{'00000000'} = "Start/stop timer" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Match}{'00000010'} = "Staircase timer" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Match}{'00000100'} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Match}{'00001000'} = "Dimmer with memory" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Match}{'00010000'} = "Multi step dimmer" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Match}{'00100000'} = "Slow on dimmer" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Match}{'01000000'} = "Slow off dimmer" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Match}{'10000000'} = "Slow on/off dimmer" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'EE'}{Data}{PerByte}{'1'}{Name} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'EE'}{Data}{PerByte}{'1'}{Match}{'%.'}{openHAB} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'EE'}{Data}{PerByte}{'1'}{Match}{'%.'}{Convert} = "Procent" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'EE'}{General} = "Byte2LedStatus" ;

# PWM LED strip dimmer module: VMB1LED
# 0F = COMMAND_SLIDER_STATUS
$global{Cons}{ModuleTypes}{'0F'}{Messages}{'0F'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'0F'}{Data}{PerByte}{'0'}{Match}{'01'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'0F'}{Data}{PerByte}{'1'}{Name} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'0F'}{Data}{PerByte}{'1'}{Match}{'%.'}{Convert} = "Procent" ;

   # EE = COMMAND_DIMMER_STATUS
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Match}{'00000000'} = "Start/stop timer" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Match}{'00000010'} = "Staircase timer" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Match}{'00000100'} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Match}{'00001000'} = "Dimmer with memory" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Match}{'00010000'} = "Multi step dimmer" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Match}{'00100000'} = "Slow on dimmer" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Match}{'01000000'} = "Slow off dimmer" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Match}{'10000000'} = "Slow on/off dimmer" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'EE'}{Data}{PerByte}{'1'}{Name} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'EE'}{Data}{PerByte}{'1'}{Match}{'%.'}{openHAB} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'EE'}{Data}{PerByte}{'1'}{Match}{'%.'}{Convert} = "Procent" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'EE'}{General} = "Byte2LedStatus" ;

# 0/1 to 10V dimmer controller module: VMB4DC
# 07 = COMMAND_SET_DIMVALUE
$global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{PerByte}{'0'}{Match}{'01'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{PerByte}{'0'}{Match}{'02'}{Channel} = "02" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{PerByte}{'0'}{Match}{'04'}{Channel} = "03" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{PerByte}{'0'}{Match}{'08'}{Channel} = "04" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{PerByte}{'1'}{Name} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{PerByte}{'1'}{Match}{'%.'}{Convert} = "Procent" ;

   # B8 = COMMAND_DIMMERCONTROLLER_STATUS: answer to 07 = COMMAND_SET_DIMVALUE
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{PerByte}{'0'}{Match}{'00000001'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{PerByte}{'0'}{Match}{'00000010'}{Channel} = "02" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{PerByte}{'0'}{Match}{'00000100'}{Channel} = "03" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{PerByte}{'0'}{Match}{'00001000'}{Channel} = "04" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{General} = "Byte1ChannelStatus" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{PerByte}{'2'}{Name} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{PerByte}{'2'}{Match}{'%.'}{Convert} = "Procent" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{PerByte}{'2'}{Match}{'%.'}{openHAB} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{General} = "Byte3LedStatus" ;

# Dimmer module: VMBDME
# 0F = COMMAND_SLIDER_STATUS"
$global{Cons}{ModuleTypes}{'14'}{Messages}{'0F'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'14'}{Messages}{'0F'}{Data}{PerByte}{'0'}{Match}{'01'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'14'}{Messages}{'0F'}{Data}{PerByte}{'1'}{Name} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'14'}{Messages}{'0F'}{Data}{PerByte}{'1'}{Match}{'%.'}{openHAB} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'14'}{Messages}{'0F'}{Data}{PerByte}{'1'}{Match}{'%.'}{Convert} = "Procent" ;

# Velbus dimmer for resistive orinductive load:    VMBDMI
# 0F = COMMAND_SLIDER_STATUS"
$global{Cons}{ModuleTypes}{'15'}{Messages}{'0F'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'15'}{Messages}{'0F'}{Data}{PerByte}{'0'}{Match}{'01'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'15'}{Messages}{'0F'}{Data}{PerByte}{'1'}{Name} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'15'}{Messages}{'0F'}{Data}{PerByte}{'1'}{Match}{'%.'}{openHAB} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'15'}{Messages}{'0F'}{Data}{PerByte}{'1'}{Match}{'%.'}{Convert} = "Procent" ;

################### Blinds: messages
# Blind Control Module: VMB1BL
# EC = COMMAND_BLIND_STATUS
$global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{PerByte}{'0'}{Match}{'03'}{Channel} = "01" ;

   # Blind status
   $global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Name} = "Blind status" ;
   $global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00'}{Info} = "Off" ;
   $global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'01'}{Info} = "Up" ;
   $global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'02'}{Info} = "Down" ;

# 2-channel Blind Control Module: VMB2BL
# EC = COMMAND_BLIND_STATUS
$global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'0'}{Match}{'03'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'0'}{Match}{'0C'}{Channel} = "02" ;

   # Blind status
   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Name} = "Blind status" ;
   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00000000'}{Info} = "Blinds off" ;
   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00000001'}{Info} = "Blind 1 up" ;
   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00000010'}{Info} = "Blind 1 down" ;
   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00000100'}{Info} = "Blind 2 up" ;
   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00001000'}{Info} = "Blind 2 down" ;

   # LED status
   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{General} = "LedStatusBlind" ;

# Blind Control Module: VMB1BLS
# EC = COMMAND_BLIND_STATUS
$global{Cons}{ModuleTypes}{'2E'}{Messages}{'EC'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'2E'}{Messages}{'EC'}{Data}{PerByte}{'0'}{Match}{'01'}{Channel} = "01" ;

   # Blind status
   $global{Cons}{ModuleTypes}{'2E'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Name} = "Blind status" ;
   $global{Cons}{ModuleTypes}{'2E'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00'}{Info} = "Off" ;
   $global{Cons}{ModuleTypes}{'2E'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'01'}{Info} = "Up" ;
   $global{Cons}{ModuleTypes}{'2E'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'02'}{Info} = "Down" ;

# 2 channel blind module: VMB2BLE
# EC = COMMAND_BLIND_STATUS
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'0'}{Match}{'01'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'0'}{Match}{'02'}{Channel} = "02" ;

# Blind status
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Name} = "Blind status" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00'}{Info} = "Off" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'01'}{Info} = "Up" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'02'}{Info} = "Down" ;

# LED status
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{General} = "LedStatusBlind" ;

# blind position (0% = up...100%=down)
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'4'}{Name} = "Position" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'4'}{Match}{'%.'}{openHAB} = "Blind" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'4'}{Match}{'%.'}{Convert} = "Procent" ;

# Channel status
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'5'}{Name} = "Channel status" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'5'}{Match}{'00'}{Info} = "Channel normal" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'5'}{Match}{'01'}{Info} = "Channel inhibted" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'5'}{Match}{'02'}{Info} = "Channel inhibted preset down" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'5'}{Match}{'03'}{Info} = "Channel inhibted preset up" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'5'}{Match}{'04'}{Info} = "Channel forced down" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'5'}{Match}{'05'}{Info} = "Channel forced up" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'5'}{Match}{'06'}{Info} = "Channel locked" ;

# Channel options
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'8'}{Name} = "Options" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'8'}{Match}{'%......00'}{Info} = "Auto mode disabled" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'8'}{Match}{'%......01'}{Info} = "Auto mode 1" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'8'}{Match}{'%......10'}{Info} = "Auto mode 2" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'8'}{Match}{'%......11'}{Info} = "Auto mode 3" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'8'}{Match}{'%.....0..'}{Info} = "Alarm 1 off" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'8'}{Match}{'%.....1..'}{Info} = "Alarm 1 on" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'8'}{Match}{'%....0...'}{Info} = "Local alarm 1" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'8'}{Match}{'%....1...'}{Info} = "Global alarm 1" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'8'}{Match}{'%...0....'}{Info} = "Alarm 2 off" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'8'}{Match}{'%...1....'}{Info} = "Alarm 2 on" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'8'}{Match}{'%..0.....'}{Info} = "Local alarm 2" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'8'}{Match}{'%..1.....'}{Info} = "Global alarm 2" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'8'}{Match}{'%.0......'}{Info} = "Sunrise disabled" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'8'}{Match}{'%.1......'}{Info} = "Sunrise enabled" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'8'}{Match}{'%0.......'}{Info} = "Sunset disabled" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'8'}{Match}{'%1.......'}{Info} = "Sunset enabled" ;

################### Touch panels: messages
# One, two or four touch buttonsmodule: VMBGP1
$global{Cons}{ModuleTypes}{'1E'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "09" ; # Temperature sensor is CH9
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{General} = "TouchTempStatus" ;
   # Not needed, info is also transmitted in message EA
   #$global{Cons}{ModuleTypes}{'1E'}{Messages}{'DF'}{General} = "TouchCoolerMode" ;
   #$global{Cons}{ModuleTypes}{'1E'}{Messages}{'E0'}{General} = "TouchHeaterMode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'E6'}{Data}{PerByte}{'0'}{Name} = "Dummy" ; # Just to indicate that this module has a temperature sensor
$global{Cons}{ModuleTypes}{'1Et'}{Messages}{'00'}{General} = "Touch124Temperature" ;

# One, two or four touch buttonsmodule: VMBGP2
$global{Cons}{ModuleTypes}{'1F'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "09" ; # Temperature sensor is CH9
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{General} = "TouchTempStatus" ;
   # Not needed, info is also transmitted in message EA
   #$global{Cons}{ModuleTypes}{'1F'}{Messages}{'DF'}{General} = "TouchCoolerMode" ;
   #$global{Cons}{ModuleTypes}{'1F'}{Messages}{'E0'}{General} = "TouchHeaterMode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'E6'}{Data}{PerByte}{'0'}{Name} = "Dummy" ; # Just to indicate that this module has a temperature sensor
$global{Cons}{ModuleTypes}{'1Ft'}{Messages}{'00'}{General} = "Touch124Temperature" ;

# One, two or four touch buttonsmodule: VMBGP4
$global{Cons}{ModuleTypes}{'20'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "09" ; # Temperature sensor is CH9
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{General} = "TouchTempStatus" ;
   # Not needed, info is also transmitted in message EA
   #$global{Cons}{ModuleTypes}{'20'}{Messages}{'DF'}{General} = "TouchCoolerMode" ;
   #$global{Cons}{ModuleTypes}{'20'}{Messages}{'E0'}{General} = "TouchHeaterMode" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'E6'}{Data}{PerByte}{'0'}{Name} = "Dummy" ; # Just to indicate that this module has a temperature sensor
$global{Cons}{ModuleTypes}{'20t'}{Messages}{'00'}{General} = "Touch124Temperature" ;

# VMBGPO (21): Touch panel with Oled display
$global{Cons}{ModuleTypes}{'21'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'21'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "33" ; # Temperature sensor is CH9
   $global{Cons}{ModuleTypes}{'21'}{Messages}{'EA'}{General} = "TouchTempStatus" ;
   # Not needed, info is also transmitted in message EA
   #$global{Cons}{ModuleTypes}{'21'}{Messages}{'DF'}{General} = "TouchCoolerMode" ;
   #$global{Cons}{ModuleTypes}{'21'}{Messages}{'E0'}{General} = "TouchHeaterMode" ;
   $global{Cons}{ModuleTypes}{'21'}{Messages}{'E6'}{Data}{PerByte}{'0'}{Name} = "Dummy" ; # Just to indicate that this module has a temperature sensor
$global{Cons}{ModuleTypes}{'21t'}{Messages}{'00'}{General} = "TouchOTemperature" ;

# Four touch buttons with PIR detectormodule: VMBGP4PIR
$global{Cons}{ModuleTypes}{'2D'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "09" ; # Temperature sensor is CH9
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{General} = "TouchTempStatus" ;
   # Not needed, info is also transmitted in message EA
   #$global{Cons}{ModuleTypes}{'2D'}{Messages}{'DF'}{General} = "TouchCoolerMode" ;
   #$global{Cons}{ModuleTypes}{'2D'}{Messages}{'E0'}{General} = "TouchHeaterMode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'E6'}{Data}{PerByte}{'0'}{Name} = "Dummy" ; # Just to indicate that this module has a temperature sensor
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'ED'}{General} = "LightSensor" ;
$global{Cons}{ModuleTypes}{'2Dt'}{Messages}{'00'}{General} = "Touch124Temperature" ;

# Touch panel with Oled display: VMBGPOD
$global{Cons}{ModuleTypes}{'28'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "33" ; # Temperature sensor is CH33
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{General} = "TouchTempStatus" ;
   # Not needed, info is also transmitted in message EA
   #$global{Cons}{ModuleTypes}{'28'}{Messages}{'DF'}{General} = "TouchCoolerMode" ;
   #$global{Cons}{ModuleTypes}{'28'}{Messages}{'E0'}{General} = "TouchHeaterMode" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'E6'}{Data}{PerByte}{'0'}{Name} = "Dummy" ; # Just to indicate that this module has a temperature sensor
$global{Cons}{ModuleTypes}{'28'}{Messages}{'AC'}{Data}{PerMessage}{Convert} = "MemoText" ;
$global{Cons}{ModuleTypes}{'28t'}{Messages}{'00'}{General} = "TouchOTemperature" ;

# VMBEL1 (34): Edge-lit one, two or four touch buttons module
$global{Cons}{ModuleTypes}{'34'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'34'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "09" ; # Temperature sensor is CH9
   $global{Cons}{ModuleTypes}{'34'}{Messages}{'EA'}{General} = "TouchTempStatus" ;
   # Not needed, info is also transmitted in message EA
   #$global{Cons}{ModuleTypes}{'34'}{Messages}{'DF'}{General} = "TouchCoolerMode" ;
   #$global{Cons}{ModuleTypes}{'34'}{Messages}{'E0'}{General} = "TouchHeaterMode" ;
   $global{Cons}{ModuleTypes}{'34'}{Messages}{'E6'}{Data}{PerByte}{'0'}{Name} = "Dummy" ; # Just to indicate that this module has a temperature sensor
$global{Cons}{ModuleTypes}{'34t'}{Messages}{'00'}{General} = "Touch124Temperature" ;

# VMBEL2 (35): Edge-lit one, two or four touch buttons module
$global{Cons}{ModuleTypes}{'35'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'35'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "09" ; # Temperature sensor is CH9
   $global{Cons}{ModuleTypes}{'35'}{Messages}{'EA'}{General} = "TouchTempStatus" ;
   # Not needed, info is also transmitted in message EA
   #$global{Cons}{ModuleTypes}{'35'}{Messages}{'DF'}{General} = "TouchCoolerMode" ;
   #$global{Cons}{ModuleTypes}{'35'}{Messages}{'E0'}{General} = "TouchHeaterMode" ;
   $global{Cons}{ModuleTypes}{'35'}{Messages}{'E6'}{Data}{PerByte}{'0'}{Name} = "Dummy" ; # Just to indicate that this module has a temperature sensor
$global{Cons}{ModuleTypes}{'35t'}{Messages}{'00'}{General} = "Touch124Temperature" ;

# VMBEL4 (36): Edge-lit one, two or four touch buttons module
$global{Cons}{ModuleTypes}{'36'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'36'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "09" ; # Temperature sensor is CH9
   $global{Cons}{ModuleTypes}{'36'}{Messages}{'EA'}{General} = "TouchTempStatus" ;
   # Not needed, info is also transmitted in message EA
   #$global{Cons}{ModuleTypes}{'36'}{Messages}{'DF'}{General} = "TouchCoolerMode" ;
   #$global{Cons}{ModuleTypes}{'36'}{Messages}{'E0'}{General} = "TouchHeaterMode" ;
   $global{Cons}{ModuleTypes}{'36'}{Messages}{'E6'}{Data}{PerByte}{'0'}{Name} = "Dummy" ; # Just to indicate that this module has a temperature sensor
$global{Cons}{ModuleTypes}{'36t'}{Messages}{'00'}{General} = "Touch124Temperature" ;

# VMBELO (37): Edge-lit touch panel with Oled display
$global{Cons}{ModuleTypes}{'37'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'37'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "33" ; # Temperature sensor is CH9
   $global{Cons}{ModuleTypes}{'37'}{Messages}{'EA'}{General} = "TouchTempStatus" ;
   # Not needed, info is also transmitted in message EA
   #$global{Cons}{ModuleTypes}{'37'}{Messages}{'DF'}{General} = "TouchCoolerMode" ;
   #$global{Cons}{ModuleTypes}{'37'}{Messages}{'E0'}{General} = "TouchHeaterMode" ;
   $global{Cons}{ModuleTypes}{'37'}{Messages}{'E6'}{Data}{PerByte}{'0'}{Name} = "Dummy" ; # Just to indicate that this module has a temperature sensor
$global{Cons}{ModuleTypes}{'37t'}{Messages}{'00'}{General} = "Touch124Temperature" ;

# VMBGP1-2 (3A): One, two or four touch buttons module (ed2)e
$global{Cons}{ModuleTypes}{'3A'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'3A'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "09" ; # Temperature sensor is CH9
   $global{Cons}{ModuleTypes}{'3A'}{Messages}{'EA'}{General} = "TouchTempStatus" ;
   # Not needed, info is also transmitted in message EA
   #$global{Cons}{ModuleTypes}{'3A'}{Messages}{'DF'}{General} = "TouchCoolerMode" ;
   #$global{Cons}{ModuleTypes}{'3A'}{Messages}{'E0'}{General} = "TouchHeaterMode" ;
   $global{Cons}{ModuleTypes}{'3A'}{Messages}{'E6'}{Data}{PerByte}{'0'}{Name} = "Dummy" ; # Just to indicate that this module has a temperature sensor
$global{Cons}{ModuleTypes}{'3At'}{Messages}{'00'}{General} = "Touch124Temperature" ;

# VMBGP2-2 (3B): One, two or four touch buttons module (ed2)e
$global{Cons}{ModuleTypes}{'3B'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'3B'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "09" ; # Temperature sensor is CH9
   $global{Cons}{ModuleTypes}{'3B'}{Messages}{'EA'}{General} = "TouchTempStatus" ;
   # Not needed, info is also transmitted in message EA
   #$global{Cons}{ModuleTypes}{'3B'}{Messages}{'DF'}{General} = "TouchCoolerMode" ;
   #$global{Cons}{ModuleTypes}{'3B'}{Messages}{'E0'}{General} = "TouchHeaterMode" ;
   $global{Cons}{ModuleTypes}{'3B'}{Messages}{'E6'}{Data}{PerByte}{'0'}{Name} = "Dummy" ; # Just to indicate that this module has a temperature sensor
$global{Cons}{ModuleTypes}{'3Bt'}{Messages}{'00'}{General} = "Touch124Temperature" ;

# VMBGP4-2 (3C): One, two or four touch buttons module (ed2)e
$global{Cons}{ModuleTypes}{'3C'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'3C'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "09" ; # Temperature sensor is CH9
   $global{Cons}{ModuleTypes}{'3C'}{Messages}{'EA'}{General} = "TouchTempStatus" ;
   # Not needed, info is also transmitted in message EA
   #$global{Cons}{ModuleTypes}{'3C'}{Messages}{'DF'}{General} = "TouchCoolerMode" ;
   #$global{Cons}{ModuleTypes}{'3C'}{Messages}{'E0'}{General} = "TouchHeaterMode" ;
   $global{Cons}{ModuleTypes}{'3C'}{Messages}{'E6'}{Data}{PerByte}{'0'}{Name} = "Dummy" ; # Just to indicate that this module has a temperature sensor
$global{Cons}{ModuleTypes}{'3Ct'}{Messages}{'00'}{General} = "Touch124Temperature" ;

# VMBGPOD-2 (3D): Touch panel with Oled display (ed2)
$global{Cons}{ModuleTypes}{'3D'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'3D'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "33" ; # Temperature sensor is CH9
   $global{Cons}{ModuleTypes}{'3D'}{Messages}{'EA'}{General} = "TouchTempStatus" ;
   # Not needed, info is also transmitted in message EA
   #$global{Cons}{ModuleTypes}{'3D'}{Messages}{'DF'}{General} = "TouchCoolerMode" ;
   #$global{Cons}{ModuleTypes}{'3D'}{Messages}{'E0'}{General} = "TouchHeaterMode" ;
   $global{Cons}{ModuleTypes}{'3D'}{Messages}{'E6'}{Data}{PerByte}{'0'}{Name} = "Dummy" ; # Just to indicate that this module has a temperature sensor
$global{Cons}{ModuleTypes}{'3Dt'}{Messages}{'00'}{General} = "Touch124Temperature" ;

# VMBGP4PIR-2 (3E): Four touch buttons with PIR detector module (ed2)
$global{Cons}{ModuleTypes}{'3E'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'3E'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "33" ; # Temperature sensor is CH9
   $global{Cons}{ModuleTypes}{'3E'}{Messages}{'EA'}{General} = "TouchTempStatus" ;
   # Not needed, info is also transmitted in message EA
   #$global{Cons}{ModuleTypes}{'3E'}{Messages}{'DF'}{General} = "TouchCoolerMode" ;
   #$global{Cons}{ModuleTypes}{'3E'}{Messages}{'E0'}{General} = "TouchHeaterMode" ;
   $global{Cons}{ModuleTypes}{'3E'}{Messages}{'E6'}{Data}{PerByte}{'0'}{Name} = "Dummy" ; # Just to indicate that this module has a temperature sensor
   $global{Cons}{ModuleTypes}{'3E'}{Messages}{'ED'}{General} = "LightSensor" ;
$global{Cons}{ModuleTypes}{'3Et'}{Messages}{'00'}{General} = "Touch124Temperature" ;

################### Input: messages
# 8-channel Push button interface module: VMB8PB
$global{Cons}{ModuleTypes}{'01'}{Messages}{'00'}{General} = "ButtonPress" ;

# 6-Channel Input Module :VMB6IN
$global{Cons}{ModuleTypes}{'05'}{Messages}{'00'}{General} = "ButtonPress" ;

# 8-channel Push button interface module: VMB8PBU
$global{Cons}{ModuleTypes}{'16'}{Messages}{'00'}{General} = "ButtonPress" ;

# 7 channel input module: VMB7IN
$global{Cons}{ModuleTypes}{'22'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'BE'}{Data}{PerByte}{'0'}{Match}{'%........'}{Convert} = "Divider" ;
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'BE'}{Data}{PerByte}{'1'}{Match}{'%.'}{Convert} = "Counter" ;
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'BE'}{Data}{PerByte}{'2'}{Match}{'%.'}{Convert} = "Counter" ;
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'BE'}{Data}{PerByte}{'3'}{Match}{'%.'}{Convert} = "Counter" ;
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'BE'}{Data}{PerByte}{'4'}{Match}{'%.'}{Convert} = "Counter" ;

# Push button and timer panel: VMB4PD
$global{Cons}{ModuleTypes}{'0B'}{Messages}{'00'}{General} = "ButtonPress" ;

# Push button module for 1 or 2 NIKO push buttons : VMB2PBN
$global{Cons}{ModuleTypes}{'18'}{Messages}{'00'}{General} = "ButtonPress" ;

# Push button interface module for 4 or 6 NIKO push buttons : VMB6PBN
$global{Cons}{ModuleTypes}{'17'}{Messages}{'00'}{General} = "ButtonPress" ;

################### PIR Sensors: Messages
# Mini PIR detector module: VMBPIRM
$global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{General} = "PirOutput PirOutputIn" ;
$global{Cons}{ModuleTypes}{'2A'}{Messages}{'ED'}{General} = "LightSensor" ;

# VMBPIRC (2B): Ceiling PIR detector module
$global{Cons}{ModuleTypes}{'2B'}{Messages}{'00'}{General} = "PirOutput PirOutputIn" ;
$global{Cons}{ModuleTypes}{'2B'}{Messages}{'ED'}{General} = "LightSensor" ;

# Outdour PIR sensor: VMBPIRO
$global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{General} = "PirOutput PirOutputOut" ;
$global{Cons}{ModuleTypes}{'2C'}{Messages}{'ED'}{General} = "LightSensor" ;

################### Other
# VMBMETEO (31): Meteo station
$global{Cons}{ModuleTypes}{'31'}{Messages}{'E6'}{Data}{PerByte}{'0'}{Name} = "Dummy" ; # Just to indicate that this module has a temperature sensor
$global{Cons}{ModuleTypes}{'31'}{Messages}{'AC'}{Data}{PerMessage}{Convert} = "SensorNumber" ;

# VMB4AN (32): Analog I/O module
$global{Cons}{ModuleTypes}{'32'}{Messages}{'AC'}{Data}{PerMessage}{Convert} = "SensorNumber" ;

# VMBVP1 (33): Doorbird interface module
$global{Cons}{ModuleTypes}{'33'}{Messages}{'00'}{General} = "ButtonPress" ;

################### General messages that can be used in different modules
$global{Cons}{ModuleGeneral}{Messages}{ButtonPress}{Data}{PerByte}{'0'}{Name} = "Channel pressed" ;
   $global{Cons}{ModuleGeneral}{Messages}{ButtonPress}{Data}{PerByte}{'0'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleGeneral}{Messages}{ButtonPress}{Data}{PerByte}{'0'}{Match}{'%.'}{Info} = "pressed" ;
   $global{Cons}{ModuleGeneral}{Messages}{ButtonPress}{Data}{PerByte}{'0'}{Match}{'%.'}{openHAB} = "PRESSED:Button" ;

   $global{Cons}{ModuleGeneral}{Messages}{ButtonPress}{Data}{PerByte}{'1'}{Name} = "Channel released" ;
   $global{Cons}{ModuleGeneral}{Messages}{ButtonPress}{Data}{PerByte}{'1'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleGeneral}{Messages}{ButtonPress}{Data}{PerByte}{'1'}{Match}{'%.'}{Info} = "released" ;
   $global{Cons}{ModuleGeneral}{Messages}{ButtonPress}{Data}{PerByte}{'1'}{Match}{'%.'}{openHAB} = "RELEASED:Button" ;

   $global{Cons}{ModuleGeneral}{Messages}{ButtonPress}{Data}{PerByte}{'2'}{Name} = "Channel long pressed" ;
   $global{Cons}{ModuleGeneral}{Messages}{ButtonPress}{Data}{PerByte}{'2'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleGeneral}{Messages}{ButtonPress}{Data}{PerByte}{'2'}{Match}{'%.'}{Info} = "longpressed" ;
   $global{Cons}{ModuleGeneral}{Messages}{ButtonPress}{Data}{PerByte}{'2'}{Match}{'%.'}{openHAB} = "LONGPRESSED:Button" ;

$global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Name} = "Operating mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%.......1'}{Info} = "Mode push button locked" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%.......0'}{Info} = "Mode push button unlocked" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%.....11.'}{Info} = "Disable mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%.....01.'}{Info} = "Manual mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%.....10.'}{Info} = "Sleep timer mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%.....00.'}{Info} = "Run mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%....1...'}{Info} = "Auto send sensor temperature enabled" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%....0...'}{Info} = "Auto send sensor temperature disabled" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%.100....'}{Name} = "Temperature mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%.100....'}{Info} = "Comfort mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%.100....'}{openHAB} = "1:TemperatureMode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%.010....'}{Name} = "Temperature mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%.010....'}{Info} = "Day mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%.010....'}{openHAB} = "2:TemperatureMode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%.001....'}{Name} = "Temperature mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%.001....'}{Info} = "Night mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%.001....'}{openHAB} = "3:TemperatureMode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%.000....'}{Name} = "Temperature mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%.000....'}{Info} = "Safe temp mode (anti frost)" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%.000....'}{openHAB} = "4:TemperatureMode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%1.......'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%1.......'}{Info} = "Cooler mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%1.......'}{openHAB} = "1:TemperatureCoHeMode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%0.......'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%0.......'}{Info} = "Heater mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'0'}{Match}{'%0.......'}{openHAB} = "0:TemperatureCoHeMode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'1'}{Name} = "Program step mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'1'}{Match}{'%.....0..'}{Info} = "No sensor program group 1" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'1'}{Match}{'%.....1..'}{Info} = "Sensor program group 1 available" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'1'}{Match}{'%....0...'}{Info} = "No sensor program group 2" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'1'}{Match}{'%....1...'}{Info} = "Sensor program group 2 available" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'1'}{Match}{'%0.......'}{Info} = "No sensor program group 3" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'1'}{Match}{'%1.......'}{Info} = "Sensor program group 3 available" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'1'}{Match}{'%.100....'}{Info} = "Comfort program step received" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'1'}{Match}{'%.010....'}{Info} = "Day program step received" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'1'}{Match}{'%.001....'}{Info} = "Night program step received" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'1'}{Match}{'%.000....'}{Info} = "Safe temperature program step received" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'1'}{Match}{'%......1.'}{Info} = "Enable unjamming heater valve" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'1'}{Match}{'%......0.'}{Info} = "Disable unjamming heater valve" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'1'}{Match}{'%.......1'}{Info} = "Enable unjamming pump" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'1'}{Match}{'%.......0'}{Info} = "Disable unjamming pump" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'2'}{Name} = "Output status" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'2'}{Match}{'%.......0'}{Info} = "Heater off" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'2'}{Match}{'%.......1'}{Info} = "Heater on" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'2'}{Match}{'%......0.'}{Info} = "Boost heater/cooler off" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'2'}{Match}{'%......1.'}{Info} = "Boost heater/cooler on" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'2'}{Match}{'%.....0..'}{Info} = "Pump off" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'2'}{Match}{'%.....1..'}{Info} = "Pump on" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'2'}{Match}{'%....0...'}{Info} = "Cooler off" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'2'}{Match}{'%....1...'}{Info} = "Cooler on" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'2'}{Match}{'%...0....'}{Info} = "Temperature alarm 1 off" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'2'}{Match}{'%...1....'}{Info} = "Temperature alarm 1 on" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'2'}{Match}{'%..0.....'}{Info} = "Temperature alarm 2 off" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'2'}{Match}{'%..1.....'}{Info} = "Temperature alarm 2 on" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'2'}{Match}{'%.0......'}{Info} = "Temperature alarm 3 off" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'2'}{Match}{'%.1......'}{Info} = "Temperature alarm 3 on" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'2'}{Match}{'%0.......'}{Info} = "Temperature alarm 4 off" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'2'}{Match}{'%1.......'}{Info} = "Temperature alarm 4 on" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'3'}{Name} = "Current temperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'3'}{Match}{'%.'}{Convert} = "Temperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'4'}{Name} = "Current temperature set" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'4'}{Match}{'%.'}{Convert} = "Temperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchTempStatus}{Data}{PerByte}{'4'}{Match}{'%.'}{openHAB} = "TemperatureTarget" ;

$global{Cons}{ModuleGeneral}{Messages}{TouchCoolerMode}{Data}{PerByte}{'0'}{Match}{'%........'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchCoolerMode}{Data}{PerByte}{'0'}{Match}{'%........'}{Info} = "Cooler mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchCoolerMode}{Data}{PerByte}{'0'}{Match}{'%........'}{openHAB} = "1:TemperatureCoHeMode" ;
$global{Cons}{ModuleGeneral}{Messages}{TouchHeaterMode}{Data}{PerByte}{'0'}{Match}{'%........'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchHeaterMode}{Data}{PerByte}{'0'}{Match}{'%........'}{Info} = "Heater mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchHeaterMode}{Data}{PerByte}{'0'}{Match}{'%........'}{openHAB} = "0:TemperatureCoHeMode" ;

$global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Name} = "COMMAND_OUTPUT_STATUS_TEMPERATURE" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Name} = "Output channel activated" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%.......1'}{Info} = "Heater activated" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%.......1'}{openHAB} = "ON:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%.......1'}{Channel} = "11" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%......1.'}{Info} = "Boost heater/cooler activated" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%......1.'}{openHAB} = "ON:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%......1.'}{Channel} = "12" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%.....1..'}{Info} = "Pump activated" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%.....1..'}{openHAB} = "ON:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%.....1..'}{Channel} = "13" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%....1...'}{Info} = "Cooler activated" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%....1...'}{openHAB} = "ON:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%....1...'}{Channel} = "14" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%...1....'}{Info} = "Temperature alarm 1 activated" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%...1....'}{openHAB} = "ON:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%...1....'}{Channel} = "15" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%..1.....'}{Info} = "Temperature alarm 2 activated" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%..1.....'}{openHAB} = "ON:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%..1.....'}{Channel} = "16" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%.1......'}{Info} = "Temperature alarm 3 activated" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%.1......'}{openHAB} = "ON:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%.1......'}{Channel} = "17" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%1.......'}{Info} = "Temperature alarm 4 activated" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%1.......'}{openHAB} = "ON:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'0'}{Match}{'%1.......'}{Channel} = "18" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Name} = "Output channel deactivated" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%.......1'}{Info} = "Heater deactivated" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%.......1'}{openHAB} = "OFF:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%.......1'}{Channel} = "11" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%......1.'}{Info} = "Boost heater/cooler deactivated" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%......1.'}{openHAB} = "OFF:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%......1.'}{Channel} = "12" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%.....1..'}{Info} = "Pump deactivated" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%.....1..'}{openHAB} = "OFF:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%.....1..'}{Channel} = "13" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%....1...'}{Info} = "Cooler deactivated" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%....1...'}{openHAB} = "OFF:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%....1...'}{Channel} = "14" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%...1....'}{Info} = "Temperature alarm 1 deactivated" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%...1....'}{openHAB} = "OFF:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%...1....'}{Channel} = "15" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%..1.....'}{Info} = "Temperature alarm 2 deactivated" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%..1.....'}{openHAB} = "OFF:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%..1.....'}{Channel} = "16" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%.1......'}{Info} = "Temperature alarm 3 deactivated" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%.1......'}{openHAB} = "OFF:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%.1......'}{Channel} = "17" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%1.......'}{Info} = "Temperature alarm 4 deactivated" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%1.......'}{openHAB} = "OFF:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{Touch124Temperature}{Data}{PerByte}{'1'}{Match}{'%1.......'}{Channel} = "18" ;
$global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Name} = "COMMAND_OUTPUT_STATUS_TEMPERATURE" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Name} = "Output channel activated" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%.......1'}{Info} = "Heater activated" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%.......1'}{openHAB} = "ON:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%.......1'}{Channel} = "35" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%......1.'}{Info} = "Boost heater/cooler activated" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%.......1'}{openHAB} = "ON:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%.......1'}{Channel} = "36" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%.....1..'}{Info} = "Pump activated" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%.......1'}{openHAB} = "ON:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%.......1'}{Channel} = "37" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%....1...'}{Info} = "Cooler activated" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%.......1'}{openHAB} = "ON:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%.......1'}{Channel} = "38" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%...1....'}{Info} = "Temperature alarm 1 activated" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%.......1'}{openHAB} = "ON:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%.......1'}{Channel} = "39" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%..1.....'}{Info} = "Temperature alarm 2 activated" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%.......1'}{openHAB} = "ON:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%.......1'}{Channel} = "40" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%.1......'}{Info} = "Temperature alarm 3 activated" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%.......1'}{openHAB} = "ON:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%.......1'}{Channel} = "41" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%1.......'}{Info} = "Temperature alarm 4 activated" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%.......1'}{openHAB} = "ON:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'0'}{Match}{'%.......1'}{Channel} = "42" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Name} = "Output channel deactivated" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%.......1'}{Info} = "Heater deactivated" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%.......1'}{openHAB} = "OFF:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%.......1'}{Channel} = "35" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%......1.'}{Info} = "Boost heater/cooler deactivated" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%.......1'}{openHAB} = "OFF:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%.......1'}{Channel} = "36" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%.....1..'}{Info} = "Pump deactivated" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%.......1'}{openHAB} = "OFF:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%.......1'}{Channel} = "37" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%....1...'}{Info} = "Cooler deactivated" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%.......1'}{openHAB} = "OFF:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%.......1'}{Channel} = "38" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%...1....'}{Info} = "Temperature alarm 1 deactivated" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%.......1'}{openHAB} = "OFF:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%.......1'}{Channel} = "39" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%..1.....'}{Info} = "Temperature alarm 2 deactivated" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%.......1'}{openHAB} = "OFF:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%.......1'}{Channel} = "40" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%.1......'}{Info} = "Temperature alarm 3 deactivated" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%.......1'}{openHAB} = "OFF:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%.......1'}{Channel} = "41" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%1.......'}{Info} = "Temperature alarm 4 deactivated" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%.......1'}{openHAB} = "OFF:ChannelTemperature" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchOTemperature}{Data}{PerByte}{'1'}{Match}{'%.......1'}{Channel} = "42" ;

$global{Cons}{ModuleGeneral}{Messages}{Byte2LedStatus}{Data}{PerByte}{'2'}{Name} = "LED status" ;
   $global{Cons}{ModuleGeneral}{Messages}{Byte2LedStatus}{Data}{PerByte}{'2'}{Match}{'00000000'}{Info} = "LED off" ;
   $global{Cons}{ModuleGeneral}{Messages}{Byte2LedStatus}{Data}{PerByte}{'2'}{Match}{'10000000'}{Info} = "LED on" ;
   $global{Cons}{ModuleGeneral}{Messages}{Byte2LedStatus}{Data}{PerByte}{'2'}{Match}{'01000000'}{Info} = "LED slow blinking" ;
   $global{Cons}{ModuleGeneral}{Messages}{Byte2LedStatus}{Data}{PerByte}{'2'}{Match}{'00100000'}{Info} = "LED fast blinking" ;
   $global{Cons}{ModuleGeneral}{Messages}{Byte2LedStatus}{Data}{PerByte}{'2'}{Match}{'00010000'}{Info} = "LED very fast blinking" ;

$global{Cons}{ModuleGeneral}{Messages}{Byte3LedStatus}{Data}{PerByte}{'3'}{Name} = "LED status" ;
   $global{Cons}{ModuleGeneral}{Messages}{Byte3LedStatus}{Data}{PerByte}{'3'}{Match}{'00000000'}{Info} = "LED off" ;
   $global{Cons}{ModuleGeneral}{Messages}{Byte3LedStatus}{Data}{PerByte}{'3'}{Match}{'10000000'}{Info} = "LED on" ;
   $global{Cons}{ModuleGeneral}{Messages}{Byte3LedStatus}{Data}{PerByte}{'3'}{Match}{'01000000'}{Info} = "LED slow blinking" ;
   $global{Cons}{ModuleGeneral}{Messages}{Byte3LedStatus}{Data}{PerByte}{'3'}{Match}{'00100000'}{Info} = "LED fast blinking" ;
   $global{Cons}{ModuleGeneral}{Messages}{Byte3LedStatus}{Data}{PerByte}{'3'}{Match}{'00010000'}{Info} = "LED very fast blinking" ;

$global{Cons}{ModuleGeneral}{Messages}{Byte1ChannelStatus}{Data}{PerByte}{'1'}{Name} = "Channel status" ;
   $global{Cons}{ModuleGeneral}{Messages}{Byte1ChannelStatus}{Data}{PerByte}{'1'}{Match}{'%......00'}{Info} = "Channel normal" ;
   $global{Cons}{ModuleGeneral}{Messages}{Byte1ChannelStatus}{Data}{PerByte}{'1'}{Match}{'%......01'}{Info} = "Channel inhibted" ;
   $global{Cons}{ModuleGeneral}{Messages}{Byte1ChannelStatus}{Data}{PerByte}{'1'}{Match}{'%......10'}{Info} = "Channel forced on" ;
   $global{Cons}{ModuleGeneral}{Messages}{Byte1ChannelStatus}{Data}{PerByte}{'1'}{Match}{'%......11'}{Info} = "Channel disabled" ;

$global{Cons}{ModuleGeneral}{Messages}{LedStatusBlind}{Data}{PerByte}{'3'}{Name} = "Led status" ;
   $global{Cons}{ModuleGeneral}{Messages}{LedStatusBlind}{Data}{PerByte}{'3'}{Match}{'00'}{Info} = "Leds off" ;
   $global{Cons}{ModuleGeneral}{Messages}{LedStatusBlind}{Data}{PerByte}{'3'}{Match}{'18'}{Info} = "Down LED on" ;
   $global{Cons}{ModuleGeneral}{Messages}{LedStatusBlind}{Data}{PerByte}{'3'}{Match}{'14'}{Info} = "Down LED slow blinking" ;
   $global{Cons}{ModuleGeneral}{Messages}{LedStatusBlind}{Data}{PerByte}{'3'}{Match}{'12'}{Info} = "Down LED fast blinking" ;
   $global{Cons}{ModuleGeneral}{Messages}{LedStatusBlind}{Data}{PerByte}{'3'}{Match}{'10'}{Info} = "Down LED very fast blinking" ;
   $global{Cons}{ModuleGeneral}{Messages}{LedStatusBlind}{Data}{PerByte}{'3'}{Match}{'08'}{Info} = "Up LED on" ;
   $global{Cons}{ModuleGeneral}{Messages}{LedStatusBlind}{Data}{PerByte}{'3'}{Match}{'04'}{Info} = "Up LED slow blinking" ;
   $global{Cons}{ModuleGeneral}{Messages}{LedStatusBlind}{Data}{PerByte}{'3'}{Match}{'02'}{Info} = "Up LED fast blinking" ;
   $global{Cons}{ModuleGeneral}{Messages}{LedStatusBlind}{Data}{PerByte}{'3'}{Match}{'01'}{Info} = "Up LED very fast blinking" ;

$global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'0'}{Name} = "Channel pressed" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'0'}{Match}{'%.......1'}{Info} = "Dark output" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'0'}{Match}{'%.......1'}{Channel} = "01" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'0'}{Match}{'%.......1'}{openHAB} = "PRESSED:Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'0'}{Match}{'%......1.'}{Info} = "Light output" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'0'}{Match}{'%......1.'}{Channel} = "02" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'0'}{Match}{'%......1.'}{openHAB} = "PRESSED:Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'0'}{Match}{'%.....1..'}{Info} = "Motion 1 output" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'0'}{Match}{'%.....1..'}{Channel} = "03" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'0'}{Match}{'%.....1..'}{openHAB} = "PRESSED:Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'0'}{Match}{'%....1...'}{Info} = "Light depending motion 1 output" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'0'}{Match}{'%....1...'}{Channel} = "04" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'0'}{Match}{'%....1...'}{openHAB} = "PRESSED:Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'0'}{Match}{'%...1....'}{Info} = "Motion 2 output" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'0'}{Match}{'%...1....'}{Channel} = "05" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'0'}{Match}{'%...1....'}{openHAB} = "PRESSED:Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'0'}{Match}{'%..1.....'}{Info} = "Light depending motion 2 output" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'0'}{Match}{'%..1.....'}{Channel} = "06" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'0'}{Match}{'%..1.....'}{openHAB} = "PRESSED:Button" ;

   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'1'}{Name} = "Channel released" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'1'}{Match}{'%.......1'}{Info} = "Dark output" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'1'}{Match}{'%.......1'}{Channel} = "01" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'1'}{Match}{'%.......1'}{openHAB} = "RELEASED:Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'1'}{Match}{'%......1.'}{Info} = "Light output" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'1'}{Match}{'%......1.'}{Channel} = "02" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'1'}{Match}{'%......1.'}{openHAB} = "RELEASED:Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'1'}{Match}{'%.....1..'}{Info} = "Motion 1 output" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'1'}{Match}{'%.....1..'}{Channel} = "03" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'1'}{Match}{'%.....1..'}{openHAB} = "RELEASED:Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'1'}{Match}{'%....1...'}{Info} = "Light depending motion 1 output" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'1'}{Match}{'%....1...'}{Channel} = "04" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'1'}{Match}{'%....1...'}{openHAB} = "RELEASED:Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'1'}{Match}{'%...1....'}{Info} = "Motion 2 output" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'1'}{Match}{'%...1....'}{Channel} = "05" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'1'}{Match}{'%...1....'}{openHAB} = "RELEASED:Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'1'}{Match}{'%..1.....'}{Info} = "Light depending motion 2 output" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'1'}{Match}{'%..1.....'}{Channel} = "06" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'1'}{Match}{'%..1.....'}{openHAB} = "RELEASED:Button" ;

   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'2'}{Name} = "Channel long pressed" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'2'}{Match}{'%.......1'}{Info} = "Dark output" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'2'}{Match}{'%.......1'}{Channel} = "01" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'2'}{Match}{'%.......1'}{openHAB} = "LONGPRESSED:Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'2'}{Match}{'%......1.'}{Info} = "Light output" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'2'}{Match}{'%......1.'}{Channel} = "02" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'2'}{Match}{'%......1.'}{openHAB} = "LONGPRESSED:Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'2'}{Match}{'%.....1..'}{Info} = "Motion 1 output" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'2'}{Match}{'%.....1..'}{Channel} = "03" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'2'}{Match}{'%.....1..'}{openHAB} = "LONGPRESSED:Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'2'}{Match}{'%....1...'}{Info} = "Light depending motion 1 output" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'2'}{Match}{'%....1...'}{Channel} = "04" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'2'}{Match}{'%....1...'}{openHAB} = "LONGPRESSED:Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'2'}{Match}{'%...1....'}{Info} = "Motion 2 output" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'2'}{Match}{'%...1....'}{Channel} = "05" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'2'}{Match}{'%...1....'}{openHAB} = "LONGPRESSED:Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'2'}{Match}{'%..1.....'}{Info} = "Light depending motion 2 output" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'2'}{Match}{'%..1.....'}{Channel} = "06" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'2'}{Match}{'%..1.....'}{openHAB} = "LONGPRESSED:Button" ;

# For sensors used in house
$global{Cons}{ModuleGeneral}{Messages}{PirOutputIn}{Data}{PerByte}{'0'}{Match}{'%.1......'}{Info} = "Absence output" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputIn}{Data}{PerByte}{'0'}{Match}{'%.1......'}{Channel} = "07" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputIn}{Data}{PerByte}{'0'}{Match}{'%.1......'}{openHAB} = "PRESSED:Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputIn}{Data}{PerByte}{'1'}{Match}{'%.1......'}{Info} = "Absence output" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputIn}{Data}{PerByte}{'1'}{Match}{'%.1......'}{Channel} = "07" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputIn}{Data}{PerByte}{'1'}{Match}{'%.1......'}{openHAB} = "RELEASED:Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputIn}{Data}{PerByte}{'2'}{Match}{'%.1......'}{Info} = "Absence output" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputIn}{Data}{PerByte}{'2'}{Match}{'%.1......'}{Channel} = "07" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputIn}{Data}{PerByte}{'2'}{Match}{'%.1......'}{openHAB} = "LONGPRESSED:Button" ;

# For sensors used outside
$global{Cons}{ModuleGeneral}{Messages}{PirOutputOut}{Data}{PerByte}{'0'}{Match}{'%.1......'}{Info} = "Low temperature alarm" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputOut}{Data}{PerByte}{'0'}{Match}{'%.1......'}{Channel} = "07" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputOut}{Data}{PerByte}{'0'}{Match}{'%.1......'}{openHAB} = "PRESSED:Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputOut}{Data}{PerByte}{'1'}{Match}{'%.1......'}{Info} = "Low temperature alarm" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputOut}{Data}{PerByte}{'1'}{Match}{'%.1......'}{Channel} = "07" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputOut}{Data}{PerByte}{'1'}{Match}{'%.1......'}{openHAB} = "RELEASED:Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputOut}{Data}{PerByte}{'2'}{Match}{'%.1......'}{Info} = "Low temperature alarm" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputOut}{Data}{PerByte}{'2'}{Match}{'%.1......'}{Channel} = "07" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputOut}{Data}{PerByte}{'2'}{Match}{'%.1......'}{openHAB} = "LONGPRESSED:Button" ;

   $global{Cons}{ModuleGeneral}{Messages}{PirOutputOut}{Data}{PerByte}{'0'}{Match}{'%1.......'}{Info} = "High temperature alarm" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputOut}{Data}{PerByte}{'0'}{Match}{'%1.......'}{Channel} = "08" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputOut}{Data}{PerByte}{'0'}{Match}{'%1.......'}{openHAB} = "PRESSED:Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputOut}{Data}{PerByte}{'1'}{Match}{'%1.......'}{Info} = "High temperature alarm" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputOut}{Data}{PerByte}{'1'}{Match}{'%1.......'}{Channel} = "08" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputOut}{Data}{PerByte}{'1'}{Match}{'%1.......'}{openHAB} = "RELEASED:Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputOut}{Data}{PerByte}{'2'}{Match}{'%1.......'}{Info} = "High temperature alarm" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputOut}{Data}{PerByte}{'2'}{Match}{'%1.......'}{Channel} = "08" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutputOut}{Data}{PerByte}{'2'}{Match}{'%1.......'}{openHAB} = "LONGPRESSED:Button" ;

$global{Cons}{ModuleGeneral}{Messages}{LightSensor}{Data}{PerMessage}{Convert} = "LightSensor" ;

# Merge the {General} information
foreach my $ModuleType (sort keys %{$global{Cons}{ModuleTypes}}) {
   foreach my $MessageType (sort keys %{$global{Cons}{ModuleTypes}{$ModuleType}{Messages}}) {
      if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$MessageType}{General} ) {
         foreach my $GeneralType (split " ", $global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$MessageType}{General} ) {
            if ( defined $global{Cons}{ModuleGeneral}{Messages}{$GeneralType} ) {
               %{$global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$MessageType}} = %{ merge( \%{$global{Cons}{ModuleTypes}{$ModuleType}{Messages}{$MessageType}}, \%{$global{Cons}{ModuleGeneral}{Messages}{$GeneralType}} ) };
            }
         }
      }
   }
}

return 1 ;
