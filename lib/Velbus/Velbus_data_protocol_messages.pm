# This is a list of messages with extra options.
# The format is easy to understand

################### Relays: messages
# 1-channel relay module: VMB1RY
$global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{'0'}{Match}{'00000001'}{Channel} = "01" ;

   $global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{'2'}{Name} = "Relay status" ;
   $global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{'2'}{Match}{'00000000'}{Info} = "Relay channel off" ;
   $global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{'2'}{Match}{'00000000'}{openHAB} = "OFF:Relay" ;
   $global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{'2'}{Match}{'00000001'}{Info} = "Relay channel on" ;
   $global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{'2'}{Match}{'00000001'}{openHAB} = "ON:Relay" ;

   $global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{'3'}{Name} = "LED status" ;
   $global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{'3'}{Match}{'00000000'}{Info} = "LED off" ;
   $global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{'3'}{Match}{'10000000'}{Info} = "LED on" ;
   $global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{'3'}{Match}{'01000000'}{Info} = "LED slow blinking" ;
   $global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{'3'}{Match}{'00100000'}{Info} = "LED fast blinking" ;
   $global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{'3'}{Match}{'00010000'}{Info} = "LED very fast blinking" ;

# 4-channel relay module: VMB4RY
$global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{'0'}{Match}{'00000001'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{'0'}{Match}{'00000010'}{Channel} = "02" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{'0'}{Match}{'00000100'}{Channel} = "03" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{'0'}{Match}{'00001000'}{Channel} = "04" ;

   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{'2'}{Name} = "Relay status" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{'2'}{Match}{'00000000'}{Info} = "Relay channel off" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{'2'}{Match}{'00000000'}{openHAB} = "OFF:Relay" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{'2'}{Match}{'00000001'}{Info} = "Relay channel on" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{'2'}{Match}{'00000001'}{openHAB} = "ON:Relay" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{'2'}{Match}{'00000010'}{Info} = "Relay channel on" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{'2'}{Match}{'00000010'}{openHAB} = "ON:Relay" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{'2'}{Match}{'00000100'}{Info} = "Relay channel on" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{'2'}{Match}{'00000100'}{openHAB} = "ON:Relay" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{'2'}{Match}{'00001000'}{Info} = "Relay channel on" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{'2'}{Match}{'00001000'}{openHAB} = "ON:Relay" ;

   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{'3'}{Name} = "LED status" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{'3'}{Match}{'00000000'}{Info} = "LED off" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{'3'}{Match}{'10000000'}{Info} = "LED on" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{'3'}{Match}{'01000000'}{Info} = "LED slow blinking" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{'3'}{Match}{'00100000'}{Info} = "LED fast blinking" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{'3'}{Match}{'00010000'}{Info} = "LED very fast blinking" ;

# 4 channel relay module with directload connections: VMB4RYLD
# FB = COMMAND_RELAY_STATUS
$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'0'}{Match}{'00000001'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'0'}{Match}{'00000010'}{Channel} = "02" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'0'}{Match}{'00000100'}{Channel} = "03" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'0'}{Match}{'00001000'}{Channel} = "04" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'0'}{Match}{'00010000'}{Channel} = "05" ;

   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'1'}{Name} = "Channel status" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'1'}{Match}{'%......00'}{Info} = "Channel normal" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'1'}{Match}{'%......01'}{Info} = "Channel inhibted" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'1'}{Match}{'%......10'}{Info} = "Channel forced on" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'1'}{Match}{'%......11'}{Info} = "Channel disabled" ;

   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'2'}{Name} = "Relay status" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'2'}{Match}{'%......00'}{Info} = "Relay channel off" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'2'}{Match}{'%......00'}{openHAB} = "OFF:Relay" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'2'}{Match}{'%......01'}{Info} = "Relay channel on" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'2'}{Match}{'%......01'}{openHAB} = "ON:Relay" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'2'}{Match}{'%......11'}{Info} = "Relay channel interval timer on" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'2'}{Match}{'%......11'}{openHAB} = "ON:Relay" ;

   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'3'}{Name} = "LED status" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'3'}{Match}{'00000000'}{Info} = "LED off" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'3'}{Match}{'10000000'}{Info} = "LED on" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'3'}{Match}{'01000000'}{Info} = "LED slow blinking" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'3'}{Match}{'00100000'}{Info} = "LED fast blinking" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{'3'}{Match}{'00010000'}{Info} = "LED very fast blinking" ;

# 4 channel relay module with normalopen contacts: VMB4RYNO
# FB = COMMAND_RELAY_STATUS
$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'0'}{Match}{'00000001'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'0'}{Match}{'00000010'}{Channel} = "02" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'0'}{Match}{'00000100'}{Channel} = "03" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'0'}{Match}{'00001000'}{Channel} = "04" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'0'}{Match}{'00010000'}{Channel} = "05" ;

   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'1'}{Name} = "Channel status" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'1'}{Match}{'%......00'}{Info} = "Channel normal" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'1'}{Match}{'%......01'}{Info} = "Channel inhibted" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'1'}{Match}{'%......10'}{Info} = "Channel forced on" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'1'}{Match}{'%......11'}{Info} = "Channel disabled" ;

   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'2'}{Name} = "Relay status" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'2'}{Match}{'%......00'}{Info} = "Relay channel off" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'2'}{Match}{'%......00'}{openHAB} = "OFF:Relay" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'2'}{Match}{'%......01'}{Info} = "Relay channel on" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'2'}{Match}{'%......01'}{openHAB} = "ON:Relay" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'2'}{Match}{'%......11'}{Info} = "Relay channel interval timer on" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'2'}{Match}{'%......11'}{openHAB} = "ON:Relay" ;

   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'3'}{Name} = "LED status" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'3'}{Match}{'00000000'}{Info} = "LED off" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'3'}{Match}{'10000000'}{Info} = "LED on" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'3'}{Match}{'01000000'}{Info} = "LED slow blinking" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'3'}{Match}{'00100000'}{Info} = "LED fast blinking" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{'3'}{Match}{'00010000'}{Info} = "LED very fast blinking" ;

################### Dimmers: messages
# Dimmer module: VMB1DM
# 0F = COMMAND_SLIDER_STATUS"
$global{Cons}{ModuleTypes}{'07'}{Messages}{'0F'}{Data}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'0F'}{Data}{'0'}{Match}{'01'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'0F'}{Data}{'1'}{Name} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'0F'}{Data}{'1'}{Match}{'%.'}{openHAB} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'0F'}{Data}{'1'}{Match}{'%.'}{Convert} = "Procent" ;

# PWM LED strip dimmer module: VMB1LED
# 0F = COMMAND_SLIDER_STATUS"
$global{Cons}{ModuleTypes}{'0F'}{Messages}{'0F'}{Data}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'0F'}{Data}{'0'}{Match}{'01'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'0F'}{Data}{'1'}{Name} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'0F'}{Data}{'1'}{Match}{'%.'}{openHAB} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'0F'}{Data}{'1'}{Match}{'%.'}{Convert} = "Procent" ;

# 0/1 to 10V dimmer controller module: VMB4DC
# 07 = COMMAND_SET_DIMVALUE
$global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{'0'}{Match}{'01'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{'0'}{Match}{'02'}{Channel} = "02" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{'0'}{Match}{'04'}{Channel} = "03" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{'0'}{Match}{'08'}{Channel} = "04" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{'1'}{Name} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{'1'}{Match}{'%.'}{Convert} = "Procent" ;

   # 0F = COMMAND_SLIDER_STATUS
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'0F'}{Data}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'0F'}{Data}{'0'}{Match}{'01'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'0F'}{Data}{'0'}{Match}{'02'}{Channel} = "02" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'0F'}{Data}{'0'}{Match}{'04'}{Channel} = "03" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'0F'}{Data}{'0'}{Match}{'08'}{Channel} = "04" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'0F'}{Data}{'1'}{Name} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'0F'}{Data}{'1'}{Match}{'%.'}{openHAB} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'0F'}{Data}{'1'}{Match}{'%.'}{Convert} = "Procent" ;

   # B8 = COMMAND_DIMMERCONTROLLER_STATUS: answer to 07 = COMMAND_SET_DIMVALUE
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'0'}{Match}{'00000001'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'0'}{Match}{'00000010'}{Channel} = "02" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'0'}{Match}{'00000100'}{Channel} = "03" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'0'}{Match}{'00001000'}{Channel} = "04" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'1'}{Name} = "Channel status" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'1'}{Match}{'%......00'}{Info} = "Channel normal" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'1'}{Match}{'%......01'}{Info} = "Channel inhibted" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'1'}{Match}{'%......10'}{Info} = "Channel forced on" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'1'}{Match}{'%......11'}{Info} = "Channel disabled" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'2'}{Name} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'2'}{Match}{'%.'}{Convert} = "Procent" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'2'}{Match}{'%.'}{openHAB} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'3'}{Name} = "LED status" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'3'}{Match}{'00000000'}{Info} = "LED off" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'3'}{Match}{'10000000'}{Info} = "LED on" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'3'}{Match}{'01000000'}{Info} = "LED slow blinking" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'3'}{Match}{'00100000'}{Info} = "LED fast blinking" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{'3'}{Match}{'00010000'}{Info} = "LED very fast blinking" ;

# Dimmer module: VMBDME
# 0F = COMMAND_SLIDER_STATUS"
$global{Cons}{ModuleTypes}{'14'}{Messages}{'0F'}{Data}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'14'}{Messages}{'0F'}{Data}{'0'}{Match}{'01'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'14'}{Messages}{'0F'}{Data}{'1'}{Name} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'14'}{Messages}{'0F'}{Data}{'1'}{Match}{'%.'}{openHAB} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'14'}{Messages}{'0F'}{Data}{'1'}{Match}{'%.'}{Convert} = "Procent" ;

# Velbus dimmer for resistive orinductive load:    VMBDMI
# 0F = COMMAND_SLIDER_STATUS"
$global{Cons}{ModuleTypes}{'15'}{Messages}{'0F'}{Data}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'15'}{Messages}{'0F'}{Data}{'0'}{Match}{'01'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'15'}{Messages}{'0F'}{Data}{'1'}{Name} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'15'}{Messages}{'0F'}{Data}{'1'}{Match}{'%.'}{openHAB} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'15'}{Messages}{'0F'}{Data}{'1'}{Match}{'%.'}{Convert} = "Procent" ;

################### Blinds: messages
# Blind Control Module: VMB1BL
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

# 2-channel Blind Control Module: VMB2BL
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

# 2 channel blind module: VMB2BLE
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
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'4'}{Match}{'%.'}{openHAB} = "Blind" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{'4'}{Match}{'%.'}{Convert} = "Procent" ;

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

################### Touch panels: messages
# One, two or four touch buttonsmodule: VMBGP1
$global{Cons}{ModuleTypes}{'1E'}{Messages}{'00'}{Data}{'0'}{Name} = "Channel just pressed" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Info} = "pressed" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{openHAB} = "PRESSED:Button" ;

   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'00'}{Data}{'1'}{Name} = "Channel just released" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Info} = "released" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{openHAB} = "RELEASED:Button" ;

   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'00'}{Data}{'2'}{Name} = "Channel long pressed" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Info} = "longpressed" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{openHAB} = "LONGPRESSED:Button" ;

   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Name} = "Operating mode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.......1'}{Info} = "Mode push button locked" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.......0'}{Info} = "Mode push button unlocked" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%X....11.'}{Info} = "Disable mode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.....01.'}{Info} = "Manual mode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.....10.'}{Info} = "Sleep timer mode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.....00.'}{Info} = "Run mode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%....1...'}{Info} = "Auto send sensor temperature enabled" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%....0...'}{Info} = "Auto send sensor temperature disabled" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.100....'}{Name} = "Temperature mode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.100....'}{Info} = "Comfort mode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.100....'}{openHAB} = "1:TemperatureMode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.010....'}{Name} = "Temperature mode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.010....'}{Info} = "Day mode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.010....'}{openHAB} = "2:TemperatureMode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.001....'}{Name} = "Temperature mode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.001....'}{Info} = "Night mode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.001....'}{openHAB} = "3:TemperatureMode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.000....'}{Name} = "Temperature mode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.000....'}{Info} = "Safe temp mode (anti frost)" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.000....'}{openHAB} = "4:TemperatureMode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%1.......'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%1.......'}{Info} = "Cooler mode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%1.......'}{openHAB} = "1:TemperatureCoHeMode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%0.......'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%0.......'}{Info} = "Heater mode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'0'}{Match}{'%0.......'}{openHAB} = "0:TemperatureCoHeMode" ;

   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'DF'}{Data}{'0'}{Match}{'%........'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'DF'}{Data}{'0'}{Match}{'%........'}{Info} = "Cooler mode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'DF'}{Data}{'0'}{Match}{'%........'}{openHAB} = "1:TemperatureCoHeMode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'E0'}{Data}{'0'}{Match}{'%........'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'E0'}{Data}{'0'}{Match}{'%........'}{Info} = "Heater mode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'E0'}{Data}{'0'}{Match}{'%........'}{openHAB} = "0:TemperatureCoHeMode" ;

   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'1'}{Name} = "Program step mode" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.....0..'}{Info} = "No sensor program group 1" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.....1..'}{Info} = "Sensor program group 1 available" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'1'}{Match}{'%....0...'}{Info} = "No sensor program group 2" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'1'}{Match}{'%....1...'}{Info} = "Sensor program group 2 available" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'1'}{Match}{'%0.......'}{Info} = "No sensor program group 3" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'1'}{Match}{'%1.......'}{Info} = "Sensor program group 3 available" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.100....'}{Info} = "Comfort program step received" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.010....'}{Info} = "Day program step received" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.001....'}{Info} = "Night program step received" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'1'}{Match}{'%X000....'}{Info} = "Safe temperature program step received" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'1'}{Match}{'%......1.'}{Info} = "Enable unjamming heater valve" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'1'}{Match}{'%......0.'}{Info} = "Disable unjamming heater valve" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.......1'}{Info} = "Enable unjamming pump" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.......0'}{Info} = "Disable unjamming pump" ;

   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'2'}{Name} = "Output status" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.......0'}{Info} = "Heater off" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.......1'}{Info} = "Heater on" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'2'}{Match}{'%......0.'}{Info} = "Boost heater/cooler off" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'2'}{Match}{'%......1.'}{Info} = "Boost heater/cooler on" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.....0..'}{Info} = "Pump off" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.....1..'}{Info} = "Pump on" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'2'}{Match}{'%....0...'}{Info} = "Cooler off" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'2'}{Match}{'%....1...'}{Info} = "Cooler on" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'2'}{Match}{'%...0....'}{Info} = "Temperature alarm 1 off" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'2'}{Match}{'%...1....'}{Info} = "Temperature alarm 1 on" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'2'}{Match}{'%..0.....'}{Info} = "Temperature alarm 2 off" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'2'}{Match}{'%..1.....'}{Info} = "Temperature alarm 2 on" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.0......'}{Info} = "Temperature alarm 3 off" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.1......'}{Info} = "Temperature alarm 3 on" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'2'}{Match}{'%0.......'}{Info} = "Temperature alarm 4 off" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'2'}{Match}{'%1.......'}{Info} = "Temperature alarm 4 on" ;

   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'3'}{Name} = "Current temperature" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'3'}{Match}{'%.'}{Convert} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'4'}{Name} = "Current temperature set" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'4'}{Match}{'%.'}{Convert} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{'4'}{Match}{'%.'}{openHAB} = "TemperatureTarget" ;

# One, two or four touch buttonsmodule: VMBGP2
$global{Cons}{ModuleTypes}{'1F'}{Messages}{'00'}{Data}{'0'}{Name} = "Channel just pressed" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Info} = "pressed" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{openHAB} = "PRESSED:Button" ;

   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'00'}{Data}{'1'}{Name} = "Channel just released" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Info} = "released" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{openHAB} = "RELEASED:Button" ;

   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'00'}{Data}{'2'}{Name} = "Channel long pressed" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Info} = "longpressed" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{openHAB} = "LONGPRESSED:Button" ;

   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Name} = "Operating mode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.......1'}{Info} = "Mode push button locked" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.......0'}{Info} = "Mode push button unlocked" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%X....11.'}{Info} = "Disable mode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.....01.'}{Info} = "Manual mode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.....10.'}{Info} = "Sleep timer mode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.....00.'}{Info} = "Run mode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%....1...'}{Info} = "Auto send sensor temperature enabled" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%....0...'}{Info} = "Auto send sensor temperature disabled" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.100....'}{Name} = "Temperature mode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.100....'}{Info} = "Comfort mode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.100....'}{openHAB} = "1:TemperatureMode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.010....'}{Name} = "Temperature mode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.010....'}{Info} = "Day mode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.010....'}{openHAB} = "2:TemperatureMode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.001....'}{Name} = "Temperature mode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.001....'}{Info} = "Night mode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.001....'}{openHAB} = "3:TemperatureMode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.000....'}{Name} = "Temperature mode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.000....'}{Info} = "Safe temp mode (anti frost)" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.000....'}{openHAB} = "4:TemperatureMode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%1.......'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%1.......'}{Info} = "Cooler mode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%1.......'}{openHAB} = "1:TemperatureCoHeMode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%0.......'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%0.......'}{Info} = "Heater mode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'0'}{Match}{'%0.......'}{openHAB} = "0:TemperatureCoHeMode" ;

   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'DF'}{Data}{'0'}{Match}{'%........'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'DF'}{Data}{'0'}{Match}{'%........'}{Info} = "Cooler mode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'DF'}{Data}{'0'}{Match}{'%........'}{openHAB} = "1:TemperatureCoHeMode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'E0'}{Data}{'0'}{Match}{'%........'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'E0'}{Data}{'0'}{Match}{'%........'}{Info} = "Heater mode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'E0'}{Data}{'0'}{Match}{'%........'}{openHAB} = "0:TemperatureCoHeMode" ;

   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'1'}{Name} = "Program step mode" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.....0..'}{Info} = "No sensor program group 1" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.....1..'}{Info} = "Sensor program group 1 available" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'1'}{Match}{'%....0...'}{Info} = "No sensor program group 2" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'1'}{Match}{'%....1...'}{Info} = "Sensor program group 2 available" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'1'}{Match}{'%0.......'}{Info} = "No sensor program group 3" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'1'}{Match}{'%1.......'}{Info} = "Sensor program group 3 available" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.100....'}{Info} = "Comfort program step received" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.010....'}{Info} = "Day program step received" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.001....'}{Info} = "Night program step received" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'1'}{Match}{'%X000....'}{Info} = "Safe temperature program step received" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'1'}{Match}{'%......1.'}{Info} = "Enable unjamming heater valve" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'1'}{Match}{'%......0.'}{Info} = "Disable unjamming heater valve" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.......1'}{Info} = "Enable unjamming pump" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.......0'}{Info} = "Disable unjamming pump" ;

   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'2'}{Name} = "Output status" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.......0'}{Info} = "Heater off" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.......1'}{Info} = "Heater on" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'2'}{Match}{'%......0.'}{Info} = "Boost heater/cooler off" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'2'}{Match}{'%......1.'}{Info} = "Boost heater/cooler on" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.....0..'}{Info} = "Pump off" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.....1..'}{Info} = "Pump on" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'2'}{Match}{'%....0...'}{Info} = "Cooler off" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'2'}{Match}{'%....1...'}{Info} = "Cooler on" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'2'}{Match}{'%...0....'}{Info} = "Temperature alarm 1 off" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'2'}{Match}{'%...1....'}{Info} = "Temperature alarm 1 on" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'2'}{Match}{'%..0.....'}{Info} = "Temperature alarm 2 off" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'2'}{Match}{'%..1.....'}{Info} = "Temperature alarm 2 on" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.0......'}{Info} = "Temperature alarm 3 off" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.1......'}{Info} = "Temperature alarm 3 on" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'2'}{Match}{'%0.......'}{Info} = "Temperature alarm 4 off" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'2'}{Match}{'%1.......'}{Info} = "Temperature alarm 4 on" ;

   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'3'}{Name} = "Current temperature" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'3'}{Match}{'%.'}{Convert} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'4'}{Name} = "Current temperature set" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'4'}{Match}{'%.'}{Convert} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{'4'}{Match}{'%.'}{openHAB} = "TemperatureTarget" ;

# One, two or four touch buttonsmodule: VMBGP4
$global{Cons}{ModuleTypes}{'20'}{Messages}{'00'}{Data}{'0'}{Name} = "Channel just pressed" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Info} = "pressed" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{openHAB} = "PRESSED:Button" ;

   $global{Cons}{ModuleTypes}{'20'}{Messages}{'00'}{Data}{'1'}{Name} = "Channel just released" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Info} = "released" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{openHAB} = "RELEASED:Button" ;

   $global{Cons}{ModuleTypes}{'20'}{Messages}{'00'}{Data}{'2'}{Name} = "Channel long pressed" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Info} = "longpressed" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{openHAB} = "LONGPRESSED:Button" ;

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
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.100....'}{openHAB} = "1:TemperatureMode" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.010....'}{Name} = "Temperature mode" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.010....'}{Info} = "Day mode" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.010....'}{openHAB} = "2:TemperatureMode" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.001....'}{Name} = "Temperature mode" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.001....'}{Info} = "Night mode" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.001....'}{openHAB} = "3:TemperatureMode" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.000....'}{Name} = "Temperature mode" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.000....'}{Info} = "Safe temp mode (anti frost)" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.000....'}{openHAB} = "4:TemperatureMode" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%1.......'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%1.......'}{Info} = "Cooler mode" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%1.......'}{openHAB} = "1:TemperatureCoHeMode" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%0.......'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%0.......'}{Info} = "Heater mode" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'0'}{Match}{'%0.......'}{openHAB} = "0:TemperatureCoHeMode" ;

   $global{Cons}{ModuleTypes}{'20'}{Messages}{'DF'}{Data}{'0'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'DF'}{Data}{'0'}{Match}{'%........'}{Info} = "Cooler mode" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'DF'}{Data}{'0'}{Match}{'%........'}{openHAB} = "1:TemperatureCoHeMode" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'E0'}{Data}{'0'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'E0'}{Data}{'0'}{Match}{'%........'}{Info} = "Heater mode" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'E0'}{Data}{'0'}{Match}{'%........'}{openHAB} = "0:TemperatureCoHeMode" ;

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
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'3'}{Match}{'%.'}{Convert} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'4'}{Name} = "Current temperature set" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'4'}{Match}{'%.'}{Convert} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{'4'}{Match}{'%.'}{openHAB} = "TemperatureTarget" ;

# Four touch buttons with PIR detectormodule: VMBGP4PIR
$global{Cons}{ModuleTypes}{'2D'}{Messages}{'00'}{Data}{'0'}{Name} = "Channel just pressed" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Info} = "pressed" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{openHAB} = "PRESSED:Button" ;

   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'00'}{Data}{'1'}{Name} = "Channel just released" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Info} = "released" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{openHAB} = "RELEASED:Button" ;

   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'00'}{Data}{'2'}{Name} = "Channel long pressed" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Info} = "longpressed" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{openHAB} = "LONGPRESSED:Button" ;

   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Name} = "Operating mode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.......1'}{Info} = "Mode push button locked" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.......0'}{Info} = "Mode push button unlocked" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%X....11.'}{Info} = "Disable mode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.....01.'}{Info} = "Manual mode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.....10.'}{Info} = "Sleep timer mode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.....00.'}{Info} = "Run mode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%....1...'}{Info} = "Auto send sensor temperature enabled" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%....0...'}{Info} = "Auto send sensor temperature disabled" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.100....'}{Name} = "Temperature mode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.100....'}{Info} = "Comfort mode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.100....'}{openHAB} = "1:TemperatureMode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.010....'}{Name} = "Temperature mode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.010....'}{Info} = "Day mode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.010....'}{openHAB} = "2:TemperatureMode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.001....'}{Name} = "Temperature mode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.001....'}{Info} = "Night mode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.001....'}{openHAB} = "3:TemperatureMode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.000....'}{Name} = "Temperature mode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.000....'}{Info} = "Safe temp mode (anti frost)" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.000....'}{openHAB} = "4:TemperatureMode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%1.......'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%1.......'}{Info} = "Cooler mode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%1.......'}{openHAB} = "1:TemperatureCoHeMode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%0.......'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%0.......'}{Info} = "Heater mode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'0'}{Match}{'%0.......'}{openHAB} = "0:TemperatureCoHeMode" ;

   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'DF'}{Data}{'0'}{Match}{'%........'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'DF'}{Data}{'0'}{Match}{'%........'}{Info} = "Cooler mode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'DF'}{Data}{'0'}{Match}{'%........'}{openHAB} = "1:TemperatureCoHeMode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'E0'}{Data}{'0'}{Match}{'%........'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'E0'}{Data}{'0'}{Match}{'%........'}{Info} = "Heater mode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'E0'}{Data}{'0'}{Match}{'%........'}{openHAB} = "0:TemperatureCoHeMode" ;

   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'1'}{Name} = "Program step mode" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.....0..'}{Info} = "No sensor program group 1" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.....1..'}{Info} = "Sensor program group 1 available" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'1'}{Match}{'%....0...'}{Info} = "No sensor program group 2" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'1'}{Match}{'%....1...'}{Info} = "Sensor program group 2 available" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'1'}{Match}{'%0.......'}{Info} = "No sensor program group 3" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'1'}{Match}{'%1.......'}{Info} = "Sensor program group 3 available" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.100....'}{Info} = "Comfort program step received" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.010....'}{Info} = "Day program step received" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.001....'}{Info} = "Night program step received" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'1'}{Match}{'%X000....'}{Info} = "Safe temperature program step received" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'1'}{Match}{'%......1.'}{Info} = "Enable unjamming heater valve" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'1'}{Match}{'%......0.'}{Info} = "Disable unjamming heater valve" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.......1'}{Info} = "Enable unjamming pump" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'1'}{Match}{'%.......0'}{Info} = "Disable unjamming pump" ;

   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'2'}{Name} = "Output status" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.......0'}{Info} = "Heater off" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.......1'}{Info} = "Heater on" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'2'}{Match}{'%......0.'}{Info} = "Boost heater/cooler off" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'2'}{Match}{'%......1.'}{Info} = "Boost heater/cooler on" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.....0..'}{Info} = "Pump off" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.....1..'}{Info} = "Pump on" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'2'}{Match}{'%....0...'}{Info} = "Cooler off" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'2'}{Match}{'%....1...'}{Info} = "Cooler on" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'2'}{Match}{'%...0....'}{Info} = "Temperature alarm 1 off" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'2'}{Match}{'%...1....'}{Info} = "Temperature alarm 1 on" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'2'}{Match}{'%..0.....'}{Info} = "Temperature alarm 2 off" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'2'}{Match}{'%..1.....'}{Info} = "Temperature alarm 2 on" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.0......'}{Info} = "Temperature alarm 3 off" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'2'}{Match}{'%.1......'}{Info} = "Temperature alarm 3 on" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'2'}{Match}{'%0.......'}{Info} = "Temperature alarm 4 off" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'2'}{Match}{'%1.......'}{Info} = "Temperature alarm 4 on" ;

   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'3'}{Name} = "Current temperature" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'3'}{Match}{'%.'}{Convert} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'4'}{Name} = "Current temperature set" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'4'}{Match}{'%.'}{Convert} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{'4'}{Match}{'%.'}{openHAB} = "TemperatureTarget" ;

# Touch panel with Oled display: VMBGPOD
$global{Cons}{ModuleTypes}{'28'}{Messages}{'00'}{Data}{'0'}{Name} = "Channel just pressed" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Info} = "pressed" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{openHAB} = "PRESSED:Button" ;

   $global{Cons}{ModuleTypes}{'28'}{Messages}{'00'}{Data}{'1'}{Name} = "Channel just released" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Info} = "released" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{openHAB} = "RELEASED:Button" ;

   $global{Cons}{ModuleTypes}{'28'}{Messages}{'00'}{Data}{'2'}{Name} = "Channel long pressed" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Info} = "longpressed" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{openHAB} = "LONGPRESSED:Button" ;

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
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.100....'}{openHAB} = "1:TemperatureMode" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.010....'}{Name} = "Temperature mode" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.010....'}{Info} = "Day mode" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.010....'}{openHAB} = "2:TemperatureMode" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.001....'}{Name} = "Temperature mode" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.001....'}{Info} = "Night mode" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.001....'}{openHAB} = "3:TemperatureMode" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.000....'}{Name} = "Temperature mode" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.000....'}{Info} = "Safe temp mode (anti frost)" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%.000....'}{openHAB} = "4:TemperatureMode" ;

   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%1.......'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%1.......'}{Info} = "Cooler mode" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%1.......'}{openHAB} = "1:TemperatureCoHeMode" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%0.......'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%0.......'}{Info} = "Heater mode" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'0'}{Match}{'%0.......'}{openHAB} = "0:TemperatureCoHeMode" ;

   $global{Cons}{ModuleTypes}{'28'}{Messages}{'DF'}{Data}{'0'}{Match}{'%........'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'DF'}{Data}{'0'}{Match}{'%........'}{Info} = "Cooler mode" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'DF'}{Data}{'0'}{Match}{'%........'}{openHAB} = "1:TemperatureCoHeMode" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'E0'}{Data}{'0'}{Match}{'%........'}{Name} = "Temperature CoHe mode" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'E0'}{Data}{'0'}{Match}{'%........'}{Info} = "Heater mode" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'E0'}{Data}{'0'}{Match}{'%........'}{openHAB} = "0:TemperatureCoHeMode" ;

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
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'3'}{Match}{'%.'}{Convert} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'4'}{Name} = "Current temperature set" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'4'}{Match}{'%.'}{Convert} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{'4'}{Match}{'%.'}{openHAB} = "TemperatureTarget" ;

################### Input: messages
# 8-channel Push button interface module: VMB8PB
$global{Cons}{ModuleTypes}{'01'}{Messages}{'00'}{Data}{'0'}{Name} = "Channel just pressed" ;
   $global{Cons}{ModuleTypes}{'01'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'01'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Info} = "pressed" ;
   $global{Cons}{ModuleTypes}{'01'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{openHAB} = "PRESSED:Button" ;

   $global{Cons}{ModuleTypes}{'01'}{Messages}{'00'}{Data}{'1'}{Name} = "Channel just released" ;
   $global{Cons}{ModuleTypes}{'01'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'01'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Info} = "released" ;
   $global{Cons}{ModuleTypes}{'01'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{openHAB} = "RELEASED:Button" ;

   $global{Cons}{ModuleTypes}{'01'}{Messages}{'00'}{Data}{'2'}{Name} = "Channel long pressed" ;
   $global{Cons}{ModuleTypes}{'01'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'01'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Info} = "longpressed" ;
   $global{Cons}{ModuleTypes}{'01'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{openHAB} = "LONGPRESSED:Button" ;

# 6-Channel Input Module :VMB6IN
$global{Cons}{ModuleTypes}{'05'}{Messages}{'00'}{Data}{'0'}{Name} = "Channel just pressed" ;
   $global{Cons}{ModuleTypes}{'05'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'05'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Info} = "pressed" ;
   $global{Cons}{ModuleTypes}{'05'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{openHAB} = "PRESSED:Button" ;

   $global{Cons}{ModuleTypes}{'05'}{Messages}{'00'}{Data}{'1'}{Name} = "Channel just released" ;
   $global{Cons}{ModuleTypes}{'05'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'05'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Info} = "released" ;
   $global{Cons}{ModuleTypes}{'05'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{openHAB} = "RELEASED:Button" ;

   $global{Cons}{ModuleTypes}{'05'}{Messages}{'00'}{Data}{'2'}{Name} = "Channel long pressed" ;
   $global{Cons}{ModuleTypes}{'05'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'05'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Info} = "longpressed" ;
   $global{Cons}{ModuleTypes}{'05'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{openHAB} = "LONGPRESSED:Button" ;

# 8-channel Push button interface module: VMB8PBU
$global{Cons}{ModuleTypes}{'16'}{Messages}{'00'}{Data}{'0'}{Name} = "Channel just pressed" ;
   $global{Cons}{ModuleTypes}{'16'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'16'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Info} = "pressed" ;
   $global{Cons}{ModuleTypes}{'16'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{openHAB} = "PRESSED:Button" ;

   $global{Cons}{ModuleTypes}{'16'}{Messages}{'00'}{Data}{'1'}{Name} = "Channel just released" ;
   $global{Cons}{ModuleTypes}{'16'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'16'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Info} = "released" ;
   $global{Cons}{ModuleTypes}{'16'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{openHAB} = "RELEASED:Button" ;

   $global{Cons}{ModuleTypes}{'16'}{Messages}{'00'}{Data}{'2'}{Name} = "Channel long pressed" ;
   $global{Cons}{ModuleTypes}{'16'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'16'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Info} = "longpressed" ;
   $global{Cons}{ModuleTypes}{'16'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{openHAB} = "LONGPRESSED:Button" ;

# 7 channel input module: VMB7IN
$global{Cons}{ModuleTypes}{'22'}{Messages}{'00'}{Data}{'0'}{Name} = "Channel just pressed" ;
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Info} = "pressed" ;
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{openHAB} = "PRESSED:Button" ;

   $global{Cons}{ModuleTypes}{'22'}{Messages}{'00'}{Data}{'1'}{Name} = "Channel just released" ;
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Info} = "released" ;
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{openHAB} = "RELEASED:Button" ;

   $global{Cons}{ModuleTypes}{'22'}{Messages}{'00'}{Data}{'2'}{Name} = "Channel long pressed" ;
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Info} = "longpressed" ;
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{openHAB} = "LONGPRESSED:Button" ;

   $global{Cons}{ModuleTypes}{'22'}{Messages}{'BE'}{Data}{'0'}{Match}{'%........'}{Convert} = "Divider" ;
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'BE'}{Data}{'1'}{Match}{'%.'}{Convert} = "Counter" ;
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'BE'}{Data}{'2'}{Match}{'%.'}{Convert} = "Counter" ;
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'BE'}{Data}{'3'}{Match}{'%.'}{Convert} = "Counter" ;
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'BE'}{Data}{'4'}{Match}{'%.'}{Convert} = "Counter" ;

# Push button and timer panel: VMB4PD
$global{Cons}{ModuleTypes}{'0B'}{Messages}{'00'}{Data}{'0'}{Name} = "Channel just pressed" ;
   $global{Cons}{ModuleTypes}{'0B'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'0B'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Info} = "pressed" ;
   $global{Cons}{ModuleTypes}{'0B'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{openHAB} = "PRESSED:Button" ;

   $global{Cons}{ModuleTypes}{'0B'}{Messages}{'00'}{Data}{'1'}{Name} = "Channel just released" ;
   $global{Cons}{ModuleTypes}{'0B'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'0B'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Info} = "released" ;
   $global{Cons}{ModuleTypes}{'0B'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{openHAB} = "RELEASED:Button" ;

   $global{Cons}{ModuleTypes}{'0B'}{Messages}{'00'}{Data}{'2'}{Name} = "Channel long pressed" ;
   $global{Cons}{ModuleTypes}{'0B'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'0B'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Info} = "longpressed" ;
   $global{Cons}{ModuleTypes}{'0B'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{openHAB} = "LONGPRESSED:Button" ;

################### PIR Sensors: Messages
# Mini PIR detector module: VMBPIRM
$global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'0'}{Name} = "Channel just pressed" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Info} = "pressed" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{openHAB} = "PRESSED:Button" ;

   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'0'}{Match}{'%.......1'}{Info} = "Dark output" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'0'}{Match}{'%......1.'}{Info} = "Light output" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'0'}{Match}{'%.....1..'}{Info} = "Motion 1 output" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'0'}{Match}{'%....1...'}{Info} = "Light depending motion 1 output" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'0'}{Match}{'%...1....'}{Info} = "Motion 2 output" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'0'}{Match}{'%..1.....'}{Info} = "Light depending motion 2 output" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'0'}{Match}{'%.1......'}{Info} = "Absence output" ;

   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'1'}{Name} = "Channel just released" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Info} = "released" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{openHAB} = "RELEASED:Button" ;

   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'1'}{Match}{'%.......1'}{Info} = "Dark output" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'1'}{Match}{'%......1.'}{Info} = "Light output" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'1'}{Match}{'%.....1..'}{Info} = "Motion 1 output" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'1'}{Match}{'%....1...'}{Info} = "Light depending motion 1 output" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'1'}{Match}{'%...1....'}{Info} = "Motion 2 output" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'1'}{Match}{'%..1.....'}{Info} = "Light depending motion 2 output" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'1'}{Match}{'%.1......'}{Info} = "Absence output" ;

   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'2'}{Name} = "Channel long pressed" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Info} = "longpressed" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{openHAB} = "LONGPRESSED:Button" ;

   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'2'}{Match}{'%.......1'}{Info} = "Dark output" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'2'}{Match}{'%......1.'}{Info} = "Light output" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'2'}{Match}{'%.....1..'}{Info} = "Motion 1 output" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'2'}{Match}{'%....1...'}{Info} = "Light depending motion 1 output" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'2'}{Match}{'%...1....'}{Info} = "Motion 2 output" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'2'}{Match}{'%..1.....'}{Info} = "Light depending motion 2 output" ;
   $global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{Data}{'2'}{Match}{'%.1......'}{Info} = "Absence output" ;

   $global{Cons}{ModuleTypes}{'Temperature'}{Messages}{'00'}{Name} = "COMMAND_OUTPUT_STATUS" ;
   $global{Cons}{ModuleTypes}{'Temperature'}{Messages}{'00'}{Data}{'0'}{Name} = "Output channel just activated" ;
   $global{Cons}{ModuleTypes}{'Temperature'}{Messages}{'00'}{Data}{'0'}{Match}{'%.......1'}{Info} = "Heater just activated" ;
   $global{Cons}{ModuleTypes}{'Temperature'}{Messages}{'00'}{Data}{'0'}{Match}{'%......1.'}{Info} = "Boost heater/cooler just activated" ;
   $global{Cons}{ModuleTypes}{'Temperature'}{Messages}{'00'}{Data}{'0'}{Match}{'%.....1..'}{Info} = "Pump just activated" ;
   $global{Cons}{ModuleTypes}{'Temperature'}{Messages}{'00'}{Data}{'0'}{Match}{'%....1...'}{Info} = "Cooler just activated" ;
   $global{Cons}{ModuleTypes}{'Temperature'}{Messages}{'00'}{Data}{'0'}{Match}{'%...1....'}{Info} = "Temperature alarm 1 just activated" ;
   $global{Cons}{ModuleTypes}{'Temperature'}{Messages}{'00'}{Data}{'0'}{Match}{'%..1.....'}{Info} = "Temperature alarm 2 alarm activated" ;
   $global{Cons}{ModuleTypes}{'Temperature'}{Messages}{'00'}{Data}{'0'}{Match}{'%.1......'}{Info} = "Temperature alarm 3 just activated" ;
   $global{Cons}{ModuleTypes}{'Temperature'}{Messages}{'00'}{Data}{'0'}{Match}{'%1.......'}{Info} = "Temperature alarm 4 alarm activated" ;

   $global{Cons}{ModuleTypes}{'Temperature'}{Messages}{'00'}{Data}{'1'}{Name} = "Output channel just deactivated" ;
   $global{Cons}{ModuleTypes}{'Temperature'}{Messages}{'00'}{Data}{'1'}{Match}{'%.......1'}{Info} = "Heater just deactivated" ;
   $global{Cons}{ModuleTypes}{'Temperature'}{Messages}{'00'}{Data}{'1'}{Match}{'%......1.'}{Info} = "Boost heater/cooler just deactivated" ;
   $global{Cons}{ModuleTypes}{'Temperature'}{Messages}{'00'}{Data}{'1'}{Match}{'%.....1..'}{Info} = "Pump just deactivated" ;
   $global{Cons}{ModuleTypes}{'Temperature'}{Messages}{'00'}{Data}{'1'}{Match}{'%....1...'}{Info} = "Cooler just deactivated" ;
   $global{Cons}{ModuleTypes}{'Temperature'}{Messages}{'00'}{Data}{'1'}{Match}{'%...1....'}{Info} = "Temperature alarm 1 just deactivated" ;
   $global{Cons}{ModuleTypes}{'Temperature'}{Messages}{'00'}{Data}{'1'}{Match}{'%..1.....'}{Info} = "Temperature alarm 2 alarm deactivated" ;
   $global{Cons}{ModuleTypes}{'Temperature'}{Messages}{'00'}{Data}{'1'}{Match}{'%.1......'}{Info} = "Temperature alarm 3 just deactivated" ;
   $global{Cons}{ModuleTypes}{'Temperature'}{Messages}{'00'}{Data}{'1'}{Match}{'%1.......'}{Info} = "Temperature alarm 4 alarm deactivated" ;

# Outdour PIR sensor: VMBPIRO
$global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'0'}{Name} = "Channel just pressed" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{Info} = "pressed" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'0'}{Match}{'%.'}{openHAB} = "PRESSED:Button" ;

   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'0'}{Match}{'%.......1'}{Info} = "Dark output" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'0'}{Match}{'%......1.'}{Info} = "Light output" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'0'}{Match}{'%.....1..'}{Info} = "Motion 1 output" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'0'}{Match}{'%....1...'}{Info} = "Light depending motion 1 output" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'0'}{Match}{'%...1....'}{Info} = "Motion 2 output" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'0'}{Match}{'%..1.....'}{Info} = "Light depending motion 2 output" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'0'}{Match}{'%.1......'}{Info} = "Absence output" ;

   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'1'}{Name} = "Channel just released" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{Info} = "released" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'1'}{Match}{'%.'}{openHAB} = "RELEASED:Button" ;

   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'1'}{Match}{'%.......1'}{Info} = "Dark output" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'1'}{Match}{'%......1.'}{Info} = "Light output" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'1'}{Match}{'%.....1..'}{Info} = "Motion 1 output" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'1'}{Match}{'%....1...'}{Info} = "Light depending motion 1 output" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'1'}{Match}{'%...1....'}{Info} = "Motion 2 output" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'1'}{Match}{'%..1.....'}{Info} = "Light depending motion 2 output" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'1'}{Match}{'%.1......'}{Info} = "Absence output" ;

   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'2'}{Name} = "Channel long pressed" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{Info} = "longpressed" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'2'}{Match}{'%.'}{openHAB} = "LONGPRESSED:Button" ;

   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'2'}{Match}{'%.......1'}{Info} = "Dark output" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'2'}{Match}{'%......1.'}{Info} = "Light output" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'2'}{Match}{'%.....1..'}{Info} = "Motion 1 output" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'2'}{Match}{'%....1...'}{Info} = "Light depending motion 1 output" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'2'}{Match}{'%...1....'}{Info} = "Motion 2 output" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'2'}{Match}{'%..1.....'}{Info} = "Light depending motion 2 output" ;
   $global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{Data}{'2'}{Match}{'%.1......'}{Info} = "Absence output" ;

return 1 ;
