# This is a list of messages with extra options.
# The format is easy to understand
#

###################
# Temperature Sensor Module : VMB1TS
$global{Cons}{ModuleTypes}{'0C'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "01" ; # Temperature sensor is CH10
   $global{Cons}{ModuleTypes}{'0C'}{Messages}{'EA'}{Data}{PerByte}{'4'}{Match}{'%.'}{Channel} = "01" ; # Temperature sensor is CH10
   $global{Cons}{ModuleTypes}{'0C'}{Messages}{'EA'}{General} = "Thermostat" ;

   #$global{Cons}{ModuleTypes}{'0C'}{Messages}{'00'}{General} = "ButtonPress" ;

################### Relays: messages
# 1-channel relay module: VMB1RY
$global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000001'}{Channel} = "01" ;

   $global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Name} = "Status" ;
   $global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000000'}{Value} = "OFF" ;
   $global{Cons}{ModuleTypes}{'02'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000001'}{Value} = "ON" ;

# 4-channel relay module: VMB4RY
$global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000001'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000010'}{Channel} = "02" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000100'}{Channel} = "03" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00001000'}{Channel} = "04" ;

   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Name} = "Status" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000000'}{Value} = "OFF" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000001'}{Value} = "ON" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000010'}{Value} = "ON" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000100'}{Value} = "ON" ;
   $global{Cons}{ModuleTypes}{'08'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00001000'}{Value} = "ON" ;

# 4 channel relay module with directload connections: VMB4RYLD
# FB = COMMAND_RELAY_STATUS
$global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000001'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000010'}{Channel} = "02" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000100'}{Channel} = "03" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00001000'}{Channel} = "04" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00010000'}{Channel} = "05" ; # Virtual channel

   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Name} = "Status" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......00'}{Value} = "OFF" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......01'}{Value} = "ON" ;
   $global{Cons}{ModuleTypes}{'10'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......11'}{Value} = "ON" ; # Timer on

# 4 channel relay module with normalopen contacts: VMB4RYNO
# FB = COMMAND_RELAY_STATUS
$global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000001'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000010'}{Channel} = "02" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000100'}{Channel} = "03" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00001000'}{Channel} = "04" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00010000'}{Channel} = "05" ; # Virtual channel

   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Name} = "Status" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......00'}{Value} = "OFF" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......01'}{Value} = "ON" ;
   $global{Cons}{ModuleTypes}{'11'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......11'}{Value} = "ON" ; # Timer on

# 4 channel relay module with normalopen contacts: VMB1RYNO
# FB = COMMAND_RELAY_STATUS
$global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000001'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000010'}{Channel} = "02" ; # Virtual channel
   $global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000100'}{Channel} = "03" ; # Virtual channel
   $global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00001000'}{Channel} = "04" ; # Virtual channel
   $global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00010000'}{Channel} = "05" ; # Virtual channel

   $global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Name} = "Status" ;
   $global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......00'}{Value} = "OFF" ;
   $global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......01'}{Value} = "ON" ;
   $global{Cons}{ModuleTypes}{'1B'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'%......11'}{Value} = "ON" ; # Timer on

# 1 channel relay module: VMB1RYNOS
$global{Cons}{ModuleTypes}{'29'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'29'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000001'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'29'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000010'}{Channel} = "02" ; # Virtual channel
   $global{Cons}{ModuleTypes}{'29'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00000100'}{Channel} = "03" ; # Virtual channel
   $global{Cons}{ModuleTypes}{'29'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00001000'}{Channel} = "04" ; # Virtual channel
   $global{Cons}{ModuleTypes}{'29'}{Messages}{'FB'}{Data}{PerByte}{'0'}{Match}{'00010000'}{Channel} = "05" ; # Virtual channel

   $global{Cons}{ModuleTypes}{'29'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Name} = "Status" ;
   $global{Cons}{ModuleTypes}{'29'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000000'}{Value} = "OFF" ;
   $global{Cons}{ModuleTypes}{'29'}{Messages}{'FB'}{Data}{PerByte}{'2'}{Match}{'00000001'}{Value} = "ON" ;

################### Dimmers: messages
# Dimmer module: VMB1DM
# 0F = COMMAND_SLIDER_STATUS
$global{Cons}{ModuleTypes}{'07'}{Messages}{'0F'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'0F'}{Data}{PerByte}{'0'}{Match}{'01'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'0F'}{Data}{PerByte}{'1'}{Name} = "Status" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'0F'}{Data}{PerByte}{'1'}{Match}{'%.'}{Convert} = "Procent" ;

   # EE = COMMAND_DIMMER_STATUS
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'EE'}{Data}{PerByte}{'1'}{Name} = "Status" ;
   $global{Cons}{ModuleTypes}{'07'}{Messages}{'EE'}{Data}{PerByte}{'1'}{Match}{'%.'}{Convert} = "Procent" ;

# PWM LED strip dimmer module: VMB1LED
# 0F = COMMAND_SLIDER_STATUS
$global{Cons}{ModuleTypes}{'0F'}{Messages}{'0F'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'0F'}{Data}{PerByte}{'0'}{Match}{'01'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'0F'}{Data}{PerByte}{'1'}{Name} = "Status" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'0F'}{Data}{PerByte}{'1'}{Match}{'%.'}{Convert} = "Procent" ;

   # EE = COMMAND_DIMMER_STATUS
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'EE'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'EE'}{Data}{PerByte}{'1'}{Name} = "Status" ;
   $global{Cons}{ModuleTypes}{'0F'}{Messages}{'EE'}{Data}{PerByte}{'1'}{Match}{'%.'}{Convert} = "Procent" ;

# 0/1 to 10V dimmer controller module: VMB4DC
# 07 = COMMAND_SET_DIMVALUE
$global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{PerByte}{'0'}{Match}{'01'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{PerByte}{'0'}{Match}{'02'}{Channel} = "02" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{PerByte}{'0'}{Match}{'04'}{Channel} = "03" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{PerByte}{'0'}{Match}{'08'}{Channel} = "04" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{PerByte}{'1'}{Name} = "Status" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'07'}{Data}{PerByte}{'1'}{Match}{'%.'}{Convert} = "Procent" ;

   # B8 = COMMAND_DIMMERCONTROLLER_STATUS: answer to 07 = COMMAND_SET_DIMVALUE
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{PerByte}{'0'}{Match}{'00000001'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{PerByte}{'0'}{Match}{'00000010'}{Channel} = "02" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{PerByte}{'0'}{Match}{'00000100'}{Channel} = "03" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{PerByte}{'0'}{Match}{'00001000'}{Channel} = "04" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{PerByte}{'2'}{Name} = "Status" ;
   $global{Cons}{ModuleTypes}{'12'}{Messages}{'B8'}{Data}{PerByte}{'2'}{Match}{'%.'}{Convert} = "Procent" ;

# Dimmer module: VMBDME
# 0F = COMMAND_SLIDER_STATUS
$global{Cons}{ModuleTypes}{'14'}{Messages}{'0F'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'14'}{Messages}{'0F'}{Data}{PerByte}{'0'}{Match}{'01'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'14'}{Messages}{'0F'}{Data}{PerByte}{'1'}{Name} = "Status" ;
   $global{Cons}{ModuleTypes}{'14'}{Messages}{'0F'}{Data}{PerByte}{'1'}{Match}{'%.'}{Convert} = "Procent" ;

# Velbus dimmer for resistive orinductive load:    VMBDMI
# 0F = COMMAND_SLIDER_STATUS
$global{Cons}{ModuleTypes}{'15'}{Messages}{'0F'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'15'}{Messages}{'0F'}{Data}{PerByte}{'0'}{Match}{'01'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'15'}{Messages}{'0F'}{Data}{PerByte}{'1'}{Name} = "Status" ;
   $global{Cons}{ModuleTypes}{'15'}{Messages}{'0F'}{Data}{PerByte}{'1'}{Match}{'%.'}{Convert} = "Procent" ;

################### Blinds: messages
# Blind Control Module: VMB1BL
# EC = COMMAND_BLIND_STATUS
$global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{PerByte}{'0'}{Match}{'03'}{Channel} = "01" ;

   # Blind status
   # No Procent in Byte 4
   $global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Name} = "Status" ;
   $global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00000000'}{Value} = "Blinds off" ;
   $global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00000001'}{Value} = "Blind 1 up" ;
   $global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00000001'}{openHAB} = "0" ;
   $global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00000001'}{Channel} = "01" ;

   $global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00000010'}{Value} = "Blind 1 down" ;
   $global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00000010'}{openHAB} = "100" ;
   $global{Cons}{ModuleTypes}{'03'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00000010'}{Channel} = "01" ;


# 2-channel Blind Control Module: VMB2BL
# EC = COMMAND_BLIND_STATUS
$global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'0'}{Match}{'03'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'0'}{Match}{'0C'}{Channel} = "02" ;

   # Blind status
   # No Procent in Byte 4
   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Name} = "Status" ;
   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00000000'}{Value} = "Blinds off" ;
   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00000001'}{Value} = "Blind 1 up" ;
   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00000001'}{openHAB} = "0" ;
   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00000001'}{Channel} = "01" ;

   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00000010'}{Value} = "Blind 1 down" ;
   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00000010'}{openHAB} = "100" ;
   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00000010'}{Channel} = "01" ;

   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00000100'}{Value} = "Blind 2 up" ;
   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00000100'}{openHAB} = "0" ;
   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00000100'}{Channel} = "02" ;

   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00001000'}{Value} = "Blind 2 down" ;
   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00001000'}{openHAB} = "100" ;
   $global{Cons}{ModuleTypes}{'09'}{Messages}{'EC'}{Data}{PerByte}{'2'}{Match}{'00001000'}{Channel} = "02" ;


# Blind Control Module: VMB1BLS
# EC = COMMAND_BLIND_STATUS
$global{Cons}{ModuleTypes}{'2E'}{Messages}{'EC'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'2E'}{Messages}{'EC'}{Data}{PerByte}{'0'}{Match}{'01'}{Channel} = "01" ;

   # blind position (0% = up...100%=down)
   $global{Cons}{ModuleTypes}{'2E'}{Messages}{'EC'}{Data}{PerByte}{'4'}{Name} = "Status" ;
   $global{Cons}{ModuleTypes}{'2E'}{Messages}{'EC'}{Data}{PerByte}{'4'}{Match}{'%.'}{Convert} = "Procent" ;

# 2 channel blind module: VMB2BLE
# EC = COMMAND_BLIND_STATUS
$global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'0'}{Name} = "Channel" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'0'}{Match}{'01'}{Channel} = "01" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'0'}{Match}{'02'}{Channel} = "02" ;

   # blind position (0% = up...100%=down)
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'4'}{Name} = "Status" ;
   $global{Cons}{ModuleTypes}{'1D'}{Messages}{'EC'}{Data}{PerByte}{'4'}{Match}{'%.'}{Convert} = "Procent" ;

################### Touch panels: messages
# One, two or four touch buttonsmodule: VMBGP1
$global{Cons}{ModuleTypes}{'1E'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "10" ; # Temperature sensor is CH10 in velbusLink
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{Data}{PerByte}{'4'}{Match}{'%.'}{Channel} = "10" ; # Temperature sensor is CH10 in velbusLink
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'EA'}{General} = "Thermostat ThermostatChannelTouch" ;
   $global{Cons}{ModuleTypes}{'1E'}{Messages}{'ED'}{General} = "ButtonChannelStatus" ;

# One, two or four touch buttonsmodule: VMBGP2
$global{Cons}{ModuleTypes}{'1F'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "10" ; # Temperature sensor is CH10 in velbusLink
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{Data}{PerByte}{'4'}{Match}{'%.'}{Channel} = "10" ; # Temperature sensor is CH10 in velbusLink
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'EA'}{General} = "Thermostat ThermostatChannelTouch" ;
   $global{Cons}{ModuleTypes}{'1F'}{Messages}{'ED'}{General} = "ButtonChannelStatus" ;

# One, two or four touch buttonsmodule: VMBGP4
$global{Cons}{ModuleTypes}{'20'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "10" ; # Temperature sensor is CH10 in velbusLink
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{Data}{PerByte}{'4'}{Match}{'%.'}{Channel} = "10" ; # Temperature sensor is CH10 in velbusLink
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'EA'}{General} = "Thermostat ThermostatChannelTouch" ;
   $global{Cons}{ModuleTypes}{'20'}{Messages}{'ED'}{General} = "ButtonChannelStatus" ;

# VMBGPO (21): Touch panel with Oled display
$global{Cons}{ModuleTypes}{'21'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'21'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "34" ; # Temperature sensor is CH34 in velbusLink
   $global{Cons}{ModuleTypes}{'21'}{Messages}{'EA'}{Data}{PerByte}{'4'}{Match}{'%.'}{Channel} = "34" ; # Temperature sensor is CH34 in velbusLink
   $global{Cons}{ModuleTypes}{'21'}{Messages}{'EA'}{General} = "Thermostat ThermostatChannelTouch" ;
   $global{Cons}{ModuleTypes}{'21'}{Messages}{'ED'}{General} = "ButtonChannelStatus" ;

# Four touch buttons with PIR detectormodule: VMBGP4PIR
$global{Cons}{ModuleTypes}{'2D'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "10" ; # Temperature sensor is CH10 in velbusLink
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{Data}{PerByte}{'4'}{Match}{'%.'}{Channel} = "10" ; # Temperature sensor is CH10 in velbusLink
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'EA'}{General} = "Thermostat ThermostatChannelTouch" ;
   $global{Cons}{ModuleTypes}{'2D'}{Messages}{'ED'}{General} = "ButtonChannelStatus LightSensorChannelStatus7" ;

# Touch panel with Oled display: VMBGPOD
$global{Cons}{ModuleTypes}{'28'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "34" ; # Temperature sensor is CH34 in velbusLink
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{Data}{PerByte}{'4'}{Match}{'%.'}{Channel} = "34" ; # Temperature sensor is CH34 in velbusLink
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'EA'}{General} = "Thermostat ThermostatChannelTouch" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'AC'}{Data}{PerMessage}{Convert} = "MemoText" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'AC'}{Data}{PerMessage}{Channel} = "99" ;
   $global{Cons}{ModuleTypes}{'28'}{Messages}{'ED'}{General} = "ButtonChannelStatus" ;

# VMBEL1 (34): Edge-lit one, two or four touch buttons module
$global{Cons}{ModuleTypes}{'34'}{Messages}{'00'}{General} = "ButtonPress OpenCollectorChannelStatus124" ;
   $global{Cons}{ModuleTypes}{'34'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "09" ; # Temperature sensor is CH09 in velbusLink
   $global{Cons}{ModuleTypes}{'34'}{Messages}{'EA'}{Data}{PerByte}{'4'}{Match}{'%.'}{Channel} = "09" ; # Temperature sensor is CH09 in velbusLink
   $global{Cons}{ModuleTypes}{'34'}{Messages}{'EA'}{General} = "Thermostat ThermostatChannelTouch" ;
   $global{Cons}{ModuleTypes}{'34'}{Messages}{'ED'}{General} = "ButtonChannelStatus" ;

# VMBEL2 (35): Edge-lit one, two or four touch buttons module
$global{Cons}{ModuleTypes}{'35'}{Messages}{'00'}{General} = "ButtonPress OpenCollectorChannelStatus124" ;
   $global{Cons}{ModuleTypes}{'35'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "09" ; # Temperature sensor is CH09 in velbusLink
   $global{Cons}{ModuleTypes}{'35'}{Messages}{'EA'}{Data}{PerByte}{'4'}{Match}{'%.'}{Channel} = "09" ; # Temperature sensor is CH09 in velbusLink
   $global{Cons}{ModuleTypes}{'35'}{Messages}{'EA'}{General} = "Thermostat ThermostatChannelTouch" ;
   $global{Cons}{ModuleTypes}{'35'}{Messages}{'ED'}{General} = "ButtonChannelStatus" ;

# VMBEL4 (36): Edge-lit one, two or four touch buttons module
$global{Cons}{ModuleTypes}{'36'}{Messages}{'00'}{General} = "ButtonPress OpenCollectorChannelStatus124" ;
   $global{Cons}{ModuleTypes}{'36'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "09" ; # Temperature sensor is CH09 in velbusLink
   $global{Cons}{ModuleTypes}{'36'}{Messages}{'EA'}{Data}{PerByte}{'4'}{Match}{'%.'}{Channel} = "09" ; # Temperature sensor is CH09 in velbusLink
   $global{Cons}{ModuleTypes}{'36'}{Messages}{'EA'}{General} = "Thermostat ThermostatChannelTouch" ;
   $global{Cons}{ModuleTypes}{'36'}{Messages}{'ED'}{General} = "ButtonChannelStatus" ;

# VMBELO (37): Edge-lit touch panel with Oled display
$global{Cons}{ModuleTypes}{'37'}{Messages}{'00'}{General} = "ButtonPress OpenCollectorChannelStatusO" ;
   $global{Cons}{ModuleTypes}{'37'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "33" ; # Temperature sensor is CH33 in velbusLink
   $global{Cons}{ModuleTypes}{'37'}{Messages}{'EA'}{Data}{PerByte}{'4'}{Match}{'%.'}{Channel} = "33" ; # Temperature sensor is CH33 in velbusLink
   $global{Cons}{ModuleTypes}{'37'}{Messages}{'EA'}{General} = "Thermostat ThermostatChannelTouch" ;
   $global{Cons}{ModuleTypes}{'37'}{Messages}{'ED'}{General} = "ButtonChannelStatus" ;

# VMBGP1-2 (3A): One, two or four touch buttons module (ed2)e
$global{Cons}{ModuleTypes}{'3A'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'3A'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "10" ; # Temperature sensor is CH10 in velbusLink
   $global{Cons}{ModuleTypes}{'3A'}{Messages}{'EA'}{Data}{PerByte}{'4'}{Match}{'%.'}{Channel} = "10" ; # Temperature sensor is CH10 in velbusLink
   $global{Cons}{ModuleTypes}{'3A'}{Messages}{'EA'}{General} = "Thermostat ThermostatChannelTouch" ;
   $global{Cons}{ModuleTypes}{'3A'}{Messages}{'ED'}{General} = "ButtonChannelStatus" ;

# VMBGP2-2 (3B): One, two or four touch buttons module (ed2)e
$global{Cons}{ModuleTypes}{'3B'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'3B'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "10" ; # Temperature sensor is CH10 in velbusLink
   $global{Cons}{ModuleTypes}{'3B'}{Messages}{'EA'}{Data}{PerByte}{'4'}{Match}{'%.'}{Channel} = "10" ; # Temperature sensor is CH10 in velbusLink
   $global{Cons}{ModuleTypes}{'3B'}{Messages}{'EA'}{General} = "Thermostat ThermostatChannelTouch" ;
   $global{Cons}{ModuleTypes}{'3B'}{Messages}{'ED'}{General} = "ButtonChannelStatus" ;

# VMBGP4-2 (3C): One, two or four touch buttons module (ed2)e
$global{Cons}{ModuleTypes}{'3C'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'3C'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "10" ; # Temperature sensor is CH10 in velbusLink
   $global{Cons}{ModuleTypes}{'3C'}{Messages}{'EA'}{Data}{PerByte}{'4'}{Match}{'%.'}{Channel} = "10" ; # Temperature sensor is CH10 in velbusLink
   $global{Cons}{ModuleTypes}{'3C'}{Messages}{'EA'}{General} = "Thermostat ThermostatChannelTouch" ;
   $global{Cons}{ModuleTypes}{'3C'}{Messages}{'ED'}{General} = "ButtonChannelStatus" ;

# VMBGPOD-2 (3D): Touch panel with Oled display (ed2)
$global{Cons}{ModuleTypes}{'3D'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'3D'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "34" ; # Temperature sensor is CH34 in velbusLink
   $global{Cons}{ModuleTypes}{'3D'}{Messages}{'EA'}{Data}{PerByte}{'4'}{Match}{'%.'}{Channel} = "34" ; # Temperature sensor is CH34 in velbusLink
   $global{Cons}{ModuleTypes}{'3D'}{Messages}{'EA'}{General} = "Thermostat ThermostatChannelTouch" ;
   $global{Cons}{ModuleTypes}{'3D'}{Messages}{'ED'}{General} = "ButtonChannelStatus" ;
   $global{Cons}{ModuleTypes}{'3D'}{Messages}{'ED'}{General} = "ButtonChannelStatus" ;

# VMBGP4PIR-2 (3E): Four touch buttons with PIR detector module (ed2)
$global{Cons}{ModuleTypes}{'3E'}{Messages}{'00'}{General} = "ButtonPress" ;
   $global{Cons}{ModuleTypes}{'3E'}{Messages}{'EA'}{Data}{PerByte}{'0'}{Match}{'%.'}{Channel} = "34" ; # Temperature sensor is CH34 in velbusLink
   $global{Cons}{ModuleTypes}{'3E'}{Messages}{'EA'}{Data}{PerByte}{'4'}{Match}{'%.'}{Channel} = "34" ; # Temperature sensor is CH34 in velbusLink
   $global{Cons}{ModuleTypes}{'3E'}{Messages}{'EA'}{General} = "Thermostat ThermostatChannelTouch" ;
   $global{Cons}{ModuleTypes}{'3E'}{Messages}{'ED'}{General} = "ButtonChannelStatus LightSensorChannelStatus7" ;

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
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'BE'}{Data}{PerByte}{'0'}{Match}{'%........'}{Name} = "Divider" ;
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'BE'}{Data}{PerByte}{'1'}{Match}{'%.'}{Convert} = "Counter" ;
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'BE'}{Data}{PerByte}{'2'}{Match}{'%.'}{Convert} = "Counter" ;
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'BE'}{Data}{PerByte}{'3'}{Match}{'%.'}{Convert} = "Counter" ;
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'BE'}{Data}{PerByte}{'4'}{Match}{'%.'}{Convert} = "Counter" ;
   $global{Cons}{ModuleTypes}{'22'}{Messages}{'ED'}{General} = "ButtonChannelStatus" ;

# Push button and timer panel: VMB4PD
$global{Cons}{ModuleTypes}{'0B'}{Messages}{'00'}{General} = "ButtonPress" ;

# Push button module for 1 or 2 NIKO push buttons : VMB2PBN
$global{Cons}{ModuleTypes}{'18'}{Messages}{'00'}{General} = "ButtonPress" ;

# Push button interface module for 4 or 6 NIKO push buttons : VMB6PBN
$global{Cons}{ModuleTypes}{'17'}{Messages}{'00'}{General} = "ButtonPress" ;

################### PIR Sensors: Messages
# Mini PIR detector module: VMBPIRM
$global{Cons}{ModuleTypes}{'2A'}{Messages}{'00'}{General} = "PirOutput" ;
$global{Cons}{ModuleTypes}{'2A'}{Messages}{'ED'}{General} = "LightSensorChannelStatus7" ;

# VMBPIRC (2B): Ceiling PIR detector module
$global{Cons}{ModuleTypes}{'2B'}{Messages}{'00'}{General} = "PirOutput" ;
$global{Cons}{ModuleTypes}{'2B'}{Messages}{'ED'}{General} = "LightSensorChannelStatus7" ;

# Outdour PIR sensor: VMBPIRO
$global{Cons}{ModuleTypes}{'2C'}{Messages}{'00'}{General} = "PirOutput" ;
$global{Cons}{ModuleTypes}{'2C'}{Messages}{'ED'}{General} = "LightSensorChannelStatus8" ;

################### Other
# VMBMETEO (31): Meteo station
$global{Cons}{ModuleTypes}{'31'}{Messages}{'00'}{General} = "PirOutput" ;
$global{Cons}{ModuleTypes}{'31'}{Messages}{'AC'}{Data}{PerMessage}{Convert} = "SensorNumber" ;

# VMB4AN (32): Analog I/O module
$global{Cons}{ModuleTypes}{'32'}{Messages}{'AC'}{Data}{PerMessage}{Convert} = "SensorNumber" ;

# VMBVP1 (33): Doorbird interface module
$global{Cons}{ModuleTypes}{'33'}{Messages}{'00'}{General} = "ButtonPress" ;

################### General messages that can be used in different modules
$global{Cons}{ModuleGeneral}{Messages}{ButtonPress}{Data}{PerByte}{'0'}{Name} = "Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{ButtonPress}{Data}{PerByte}{'0'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleGeneral}{Messages}{ButtonPress}{Data}{PerByte}{'0'}{Match}{'%.'}{Value} = "pressed" ;

   $global{Cons}{ModuleGeneral}{Messages}{ButtonPress}{Data}{PerByte}{'1'}{Name} = "Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{ButtonPress}{Data}{PerByte}{'1'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleGeneral}{Messages}{ButtonPress}{Data}{PerByte}{'1'}{Match}{'%.'}{Value} = "released" ;

   $global{Cons}{ModuleGeneral}{Messages}{ButtonPress}{Data}{PerByte}{'2'}{Name} = "Button" ;
   $global{Cons}{ModuleGeneral}{Messages}{ButtonPress}{Data}{PerByte}{'2'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleGeneral}{Messages}{ButtonPress}{Data}{PerByte}{'2'}{Match}{'%.'}{Value} = "longpressed" ;

# Thermostat info: used in touch panels and in VMB1TS
$global{Cons}{ModuleGeneral}{Messages}{Thermostat}{Data}{PerByte}{'0'}{Name} = "Operating mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{Thermostat}{Data}{PerByte}{'0'}{Match}{'%.100....'}{Name} = "ThermostatMode" ;
   $global{Cons}{ModuleGeneral}{Messages}{Thermostat}{Data}{PerByte}{'0'}{Match}{'%.100....'}{Value} = "Comfort mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{Thermostat}{Data}{PerByte}{'0'}{Match}{'%.100....'}{openHAB} = "1" ;
   $global{Cons}{ModuleGeneral}{Messages}{Thermostat}{Data}{PerByte}{'0'}{Match}{'%.010....'}{Name} = "ThermostatMode" ;
   $global{Cons}{ModuleGeneral}{Messages}{Thermostat}{Data}{PerByte}{'0'}{Match}{'%.010....'}{Value} = "Day mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{Thermostat}{Data}{PerByte}{'0'}{Match}{'%.010....'}{openHAB} = "2" ;
   $global{Cons}{ModuleGeneral}{Messages}{Thermostat}{Data}{PerByte}{'0'}{Match}{'%.001....'}{Name} = "ThermostatMode" ;
   $global{Cons}{ModuleGeneral}{Messages}{Thermostat}{Data}{PerByte}{'0'}{Match}{'%.001....'}{Value} = "Night mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{Thermostat}{Data}{PerByte}{'0'}{Match}{'%.001....'}{openHAB} = "3" ;
   $global{Cons}{ModuleGeneral}{Messages}{Thermostat}{Data}{PerByte}{'0'}{Match}{'%.000....'}{Name} = "ThermostatMode" ;
   $global{Cons}{ModuleGeneral}{Messages}{Thermostat}{Data}{PerByte}{'0'}{Match}{'%.000....'}{Value} = "Safe temp mode (anti frost)" ;
   $global{Cons}{ModuleGeneral}{Messages}{Thermostat}{Data}{PerByte}{'0'}{Match}{'%.000....'}{openHAB} = "4" ;
   $global{Cons}{ModuleGeneral}{Messages}{Thermostat}{Data}{PerByte}{'0'}{Match}{'%1.......'}{Name} = "ThermostatCoHeMode" ;
   $global{Cons}{ModuleGeneral}{Messages}{Thermostat}{Data}{PerByte}{'0'}{Match}{'%1.......'}{Value} = "Cooler mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{Thermostat}{Data}{PerByte}{'0'}{Match}{'%1.......'}{openHAB} = "1" ;
   $global{Cons}{ModuleGeneral}{Messages}{Thermostat}{Data}{PerByte}{'0'}{Match}{'%0.......'}{Name} = "ThermostatCoHeMode" ;
   $global{Cons}{ModuleGeneral}{Messages}{Thermostat}{Data}{PerByte}{'0'}{Match}{'%0.......'}{Value} = "Heater mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{Thermostat}{Data}{PerByte}{'0'}{Match}{'%0.......'}{openHAB} = "0" ;

   $global{Cons}{ModuleGeneral}{Messages}{Thermostat}{Data}{PerByte}{'4'}{Name} = "ThermostatTarget" ;
   $global{Cons}{ModuleGeneral}{Messages}{Thermostat}{Data}{PerByte}{'4'}{Match}{'%.'}{Convert} = "Temperature" ;

# The Channels in byte 3 are calculated with an offset = TemperatureChannel for the touch panels
$global{Cons}{ModuleGeneral}{Messages}{ThermostatChannelTouch}{Data}{PerByte}{'3'}{Match}{'%.'}{Name} = "ThermostatChannel" ;
   $global{Cons}{ModuleGeneral}{Messages}{ThermostatChannelTouch}{Data}{PerByte}{'3'}{Match}{'%.'}{Convert} = "ChannelBitStatus:8" ;

# Not used anymore
$global{Cons}{ModuleGeneral}{Messages}{TouchCoolerMode}{Data}{PerByte}{'0'}{Match}{'%........'}{Name} = "ThermostatCoHeMode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchCoolerMode}{Data}{PerByte}{'0'}{Match}{'%........'}{Value} = "Cooler mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchCoolerMode}{Data}{PerByte}{'0'}{Match}{'%........'}{openHAB} = "1" ;
# Not used anymore
$global{Cons}{ModuleGeneral}{Messages}{TouchHeaterMode}{Data}{PerByte}{'0'}{Match}{'%........'}{Name} = "ThermostatCoHeMode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchHeaterMode}{Data}{PerByte}{'0'}{Match}{'%........'}{Value} = "Heater mode" ;
   $global{Cons}{ModuleGeneral}{Messages}{TouchHeaterMode}{Data}{PerByte}{'0'}{Match}{'%........'}{openHAB} = "0" ;

$global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{Name} = "Sensor" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'0'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'0'}{Match}{'%.'}{Value} = "pressed" ;

   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'1'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'1'}{Match}{'%.'}{Value} = "released" ;

   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'2'}{Match}{'%.'}{Convert} = "Channel" ;
   $global{Cons}{ModuleGeneral}{Messages}{PirOutput}{Data}{PerByte}{'2'}{Match}{'%.'}{Value} = "longpressed" ;

$global{Cons}{ModuleGeneral}{Messages}{ButtonChannelStatus}{Data}{PerByte}{'0'}{Name} = "Button" ;
$global{Cons}{ModuleGeneral}{Messages}{ButtonChannelStatus}{Data}{PerByte}{'0'}{Match}{'%.'}{Convert} = "ChannelBitStatus:8" ;

$global{Cons}{ModuleGeneral}{Messages}{OpenCollectorChannelStatus124}{Data}{PerByte}{'3'}{Name} = "Relay" ;
$global{Cons}{ModuleGeneral}{Messages}{OpenCollectorChannelStatus124}{Data}{PerByte}{'3'}{Match}{'0.......'}{Value} = "OFF" ;
$global{Cons}{ModuleGeneral}{Messages}{OpenCollectorChannelStatus124}{Data}{PerByte}{'3'}{Match}{'1.......'}{Value} = "ON" ;
$global{Cons}{ModuleGeneral}{Messages}{OpenCollectorChannelStatus124}{Data}{PerByte}{'3'}{Match}{'........'}{Channel} = "18" ;

$global{Cons}{ModuleGeneral}{Messages}{OpenCollectorChannelStatusO}{Data}{PerByte}{'3'}{Name} = "Relay" ;
$global{Cons}{ModuleGeneral}{Messages}{OpenCollectorChannelStatusO}{Data}{PerByte}{'3'}{Match}{'0.......'}{Value} = "OFF" ;
$global{Cons}{ModuleGeneral}{Messages}{OpenCollectorChannelStatusO}{Data}{PerByte}{'3'}{Match}{'1.......'}{Value} = "ON" ;
$global{Cons}{ModuleGeneral}{Messages}{OpenCollectorChannelStatusO}{Data}{PerByte}{'3'}{Match}{'........'}{Channel} = "42" ;

$global{Cons}{ModuleGeneral}{Messages}{LightSensorChannelStatus7}{Data}{PerMessage}{Convert} = "LightSensor" ;
$global{Cons}{ModuleGeneral}{Messages}{LightSensorChannelStatus7}{Data}{PerByte}{'0'}{Name} = "Sensor" ;
$global{Cons}{ModuleGeneral}{Messages}{LightSensorChannelStatus7}{Data}{PerByte}{'0'}{Match}{'%.'}{Convert} = "ChannelBitStatus:7" ;

$global{Cons}{ModuleGeneral}{Messages}{LightSensorChannelStatus8}{Data}{PerMessage}{Convert} = "LightSensor" ;
$global{Cons}{ModuleGeneral}{Messages}{LightSensorChannelStatus8}{Data}{PerByte}{'0'}{Name} = "Sensor" ;
$global{Cons}{ModuleGeneral}{Messages}{LightSensorChannelStatus8}{Data}{PerByte}{'0'}{Match}{'%.'}{Convert} = "ChannelBitStatus:8" ;

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
