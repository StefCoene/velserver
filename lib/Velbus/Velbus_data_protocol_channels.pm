# This is a list of channels
# The format is easy to understand

# Possible '{Type}' options:
#   Button
#   ButtonCounter
#   Dimmer
#   Relay
#   Sensor
#   SensorNumber
#   Temperature

################### Relays: Channel names
# 1-channel relay module: VMB1RY
$global{Cons}{ModuleTypes}{'02'}{Channels}{"01"}{Name} = "Relay 1" ;
   $global{Cons}{ModuleTypes}{'02'}{Channels}{"01"}{Type} = "Relay" ;

# 4-channel relay module: VMB4RY
$global{Cons}{ModuleTypes}{'08'}{Channels}{"01"}{Name} = "Relay 1" ;
   $global{Cons}{ModuleTypes}{'08'}{Channels}{"01"}{Type} = "Relay" ;
   $global{Cons}{ModuleTypes}{'08'}{Channels}{"02"}{Name} = "Relay 2" ;
   $global{Cons}{ModuleTypes}{'08'}{Channels}{"02"}{Type} = "Relay" ;
   $global{Cons}{ModuleTypes}{'08'}{Channels}{"03"}{Name} = "Relay 3" ;
   $global{Cons}{ModuleTypes}{'08'}{Channels}{"03"}{Type} = "Relay" ;
   $global{Cons}{ModuleTypes}{'08'}{Channels}{"04"}{Name} = "Relay 4" ;
   $global{Cons}{ModuleTypes}{'08'}{Channels}{"04"}{Type} = "Relay" ;

# 4-channel voltage-out relay module: VMB4RYLD
$global{Cons}{ModuleTypes}{'10'}{Channels}{"01"}{Name} = "Relay 1" ;
   $global{Cons}{ModuleTypes}{'10'}{Channels}{"01"}{Type} = "Relay" ;
   $global{Cons}{ModuleTypes}{'10'}{Channels}{"02"}{Name} = "Relay 2" ;
   $global{Cons}{ModuleTypes}{'10'}{Channels}{"02"}{Type} = "Relay" ;
   $global{Cons}{ModuleTypes}{'10'}{Channels}{"03"}{Name} = "Relay 3" ;
   $global{Cons}{ModuleTypes}{'10'}{Channels}{"03"}{Type} = "Relay" ;
   $global{Cons}{ModuleTypes}{'10'}{Channels}{"04"}{Name} = "Relay 4" ;
   $global{Cons}{ModuleTypes}{'10'}{Channels}{"04"}{Type} = "Relay" ;
   $global{Cons}{ModuleTypes}{'10'}{Channels}{"05"}{Name} = "Virtual relay" ;
   $global{Cons}{ModuleTypes}{'10'}{Channels}{"05"}{Type} = "Relay" ;

# 4-channel relay module: VMB4RYNO
$global{Cons}{ModuleTypes}{'11'}{Channels}{"01"}{Name} = "Relay 1" ;
   $global{Cons}{ModuleTypes}{'11'}{Channels}{"01"}{Type} = "Relay" ;
   $global{Cons}{ModuleTypes}{'11'}{Channels}{"02"}{Name} = "Relay 2" ;
   $global{Cons}{ModuleTypes}{'11'}{Channels}{"02"}{Type} = "Relay" ;
   $global{Cons}{ModuleTypes}{'11'}{Channels}{"03"}{Name} = "Relay 3" ;
   $global{Cons}{ModuleTypes}{'11'}{Channels}{"03"}{Type} = "Relay" ;
   $global{Cons}{ModuleTypes}{'11'}{Channels}{"04"}{Name} = "Relay 4" ;
   $global{Cons}{ModuleTypes}{'11'}{Channels}{"04"}{Type} = "Relay" ;
   $global{Cons}{ModuleTypes}{'11'}{Channels}{"05"}{Name} = "Virtual relay" ;
   $global{Cons}{ModuleTypes}{'11'}{Channels}{"05"}{Type} = "Relay" ;

# 1-channel relay module: VMB1RYNO
$global{Cons}{ModuleTypes}{'1B'}{Channels}{"01"}{Name} = "Relay" ;
   $global{Cons}{ModuleTypes}{'1B'}{Channels}{"01"}{Type} = "Relay" ;
   $global{Cons}{ModuleTypes}{'1B'}{Channels}{"02"}{Name} = "Virtual relay 1" ;
   $global{Cons}{ModuleTypes}{'1B'}{Channels}{"02"}{Type} = "Relay" ;
   $global{Cons}{ModuleTypes}{'1B'}{Channels}{"03"}{Name} = "Virtual relay 2" ;
   $global{Cons}{ModuleTypes}{'1B'}{Channels}{"03"}{Type} = "Relay" ;
   $global{Cons}{ModuleTypes}{'1B'}{Channels}{"04"}{Name} = "Virtual relay 3" ;
   $global{Cons}{ModuleTypes}{'1B'}{Channels}{"04"}{Type} = "Relay" ;
   $global{Cons}{ModuleTypes}{'1B'}{Channels}{"05"}{Name} = "Virtual relay 4" ;
   $global{Cons}{ModuleTypes}{'1B'}{Channels}{"05"}{Type} = "Relay" ;

################### Dimmers: Channel names
# 1-channel 0(1)-10V control: VMB1DM
$global{Cons}{ModuleTypes}{'07'}{Channels}{"01"}{Name} = "Dimmer 1" ;
   $global{Cons}{ModuleTypes}{'07'}{Channels}{"01"}{Type} = "Dimmer" ;

# 1-channel LED: VMB1LED
$global{Cons}{ModuleTypes}{'0F'}{Channels}{"01"}{Name} = "Dimmer 1" ;
   $global{Cons}{ModuleTypes}{'0F'}{Channels}{"01"}{Type} = "Dimmer" ;

# 4-channel 0(1)-10V control: VMB4DC
$global{Cons}{ModuleTypes}{'12'}{Channels}{"01"}{Name} = "Dimmer 1" ;
   $global{Cons}{ModuleTypes}{'12'}{Channels}{"01"}{Type} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'12'}{Channels}{"02"}{Name} = "Dimmer 2" ;
   $global{Cons}{ModuleTypes}{'12'}{Channels}{"02"}{Type} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'12'}{Channels}{"03"}{Name} = "Dimmer 3" ;
   $global{Cons}{ModuleTypes}{'12'}{Channels}{"03"}{Type} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'12'}{Channels}{"04"}{Name} = "Dimmer 4" ;
   $global{Cons}{ModuleTypes}{'12'}{Channels}{"04"}{Type} = "Dimmer" ;

# 1-channel Dimmer: VMBDME
$global{Cons}{ModuleTypes}{'14'}{Channels}{"01"}{Name} = "Dimmer 1" ;
   $global{Cons}{ModuleTypes}{'14'}{Channels}{"01"}{Type} = "Dimmer" ;

# 1-channel Dimmer: VMBDMI
$global{Cons}{ModuleTypes}{'15'}{Channels}{"01"}{Name} = "Dimmer 1" ;
   $global{Cons}{ModuleTypes}{'15'}{Channels}{"01"}{Type} = "Dimmer" ;

################### Blinds: Channel names
# 1-channel blind control module: VMB1BL
$global{Cons}{ModuleTypes}{'03'}{Channels}{"01"}{Name} = "Blind 1" ;
   $global{Cons}{ModuleTypes}{'03'}{Channels}{"01"}{Type} = "Blind" ;

# 2-channel blind control module: VMB2BL
$global{Cons}{ModuleTypes}{'09'}{Channels}{"01"}{Name} = "Blind 1" ;
   $global{Cons}{ModuleTypes}{'09'}{Channels}{"01"}{Type} = "Blind" ;
   $global{Cons}{ModuleTypes}{'09'}{Channels}{"02"}{Name} = "Blind 2" ;
   $global{Cons}{ModuleTypes}{'09'}{Channels}{"02"}{Type} = "Blind" ;

# 2-channel blind control module: VMB2BLE
$global{Cons}{ModuleTypes}{'1D'}{Channels}{"01"}{Name} = "Blind 1" ;
   $global{Cons}{ModuleTypes}{'1D'}{Channels}{"01"}{Type} = "Blind" ;
   $global{Cons}{ModuleTypes}{'1D'}{Channels}{"02"}{Name} = "Blind 2" ;
   $global{Cons}{ModuleTypes}{'1D'}{Channels}{"02"}{Type} = "Blind" ;

################### Touch panels: Channel names
# VMBGP1
$global{Cons}{ModuleTypes}{'1E'}{Channels}{"01"}{Name} = "Push button 1" ;
   $global{Cons}{ModuleTypes}{'1E'}{Channels}{"01"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'1E'}{Channels}{"02"}{Name} = "Virtual button 2" ;
   $global{Cons}{ModuleTypes}{'1E'}{Channels}{"02"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'1E'}{Channels}{"03"}{Name} = "Virtual button 3" ;
   $global{Cons}{ModuleTypes}{'1E'}{Channels}{"03"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'1E'}{Channels}{"04"}{Name} = "Virtual button 4" ;
   $global{Cons}{ModuleTypes}{'1E'}{Channels}{"04"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'1E'}{Channels}{"05"}{Name} = "Virtual button 5" ;
   $global{Cons}{ModuleTypes}{'1E'}{Channels}{"05"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'1E'}{Channels}{"06"}{Name} = "Virtual button 6" ;
   $global{Cons}{ModuleTypes}{'1E'}{Channels}{"06"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'1E'}{Channels}{"07"}{Name} = "Virtual button 7" ;
   $global{Cons}{ModuleTypes}{'1E'}{Channels}{"07"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'1E'}{Channels}{"08"}{Name} = "Virtual button 8" ;
   $global{Cons}{ModuleTypes}{'1E'}{Channels}{"08"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'1E'}{Channels}{"09"}{Name} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'1E'}{Channels}{"09"}{Type} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'1E'}{TemperatureChannel} = "09" ;

# VMBGP2
$global{Cons}{ModuleTypes}{'1F'}{Channels}{"01"}{Name} = "Push button 1" ;
   $global{Cons}{ModuleTypes}{'1F'}{Channels}{"01"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'1F'}{Channels}{"02"}{Name} = "Push button 2" ;
   $global{Cons}{ModuleTypes}{'1F'}{Channels}{"02"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'1F'}{Channels}{"03"}{Name} = "Virtual button 3" ;
   $global{Cons}{ModuleTypes}{'1F'}{Channels}{"03"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'1F'}{Channels}{"04"}{Name} = "Virtual button 4" ;
   $global{Cons}{ModuleTypes}{'1F'}{Channels}{"04"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'1F'}{Channels}{"05"}{Name} = "Virtual button 5" ;
   $global{Cons}{ModuleTypes}{'1F'}{Channels}{"05"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'1F'}{Channels}{"06"}{Name} = "Virtual button 6" ;
   $global{Cons}{ModuleTypes}{'1F'}{Channels}{"06"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'1F'}{Channels}{"07"}{Name} = "Virtual button 7" ;
   $global{Cons}{ModuleTypes}{'1F'}{Channels}{"08"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'1F'}{Channels}{"08"}{Name} = "Virtual button 8" ;
   $global{Cons}{ModuleTypes}{'1F'}{Channels}{"09"}{Name} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'1F'}{Channels}{"09"}{Type} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'1F'}{TemperatureChannel} = "09" ;

# VMBGP4
$global{Cons}{ModuleTypes}{'20'}{Channels}{"01"}{Name} = "Push button 1" ;
   $global{Cons}{ModuleTypes}{'20'}{Channels}{"01"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'20'}{Channels}{"02"}{Name} = "Push button 2" ;
   $global{Cons}{ModuleTypes}{'20'}{Channels}{"02"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'20'}{Channels}{"03"}{Name} = "Push button 3" ;
   $global{Cons}{ModuleTypes}{'20'}{Channels}{"03"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'20'}{Channels}{"04"}{Name} = "Push button 4" ;
   $global{Cons}{ModuleTypes}{'20'}{Channels}{"04"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'20'}{Channels}{"05"}{Name} = "Virtual button 5" ;
   $global{Cons}{ModuleTypes}{'20'}{Channels}{"05"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'20'}{Channels}{"06"}{Name} = "Virtual button 6" ;
   $global{Cons}{ModuleTypes}{'20'}{Channels}{"06"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'20'}{Channels}{"07"}{Name} = "Virtual button 7" ;
   $global{Cons}{ModuleTypes}{'20'}{Channels}{"07"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'20'}{Channels}{"08"}{Name} = "Virtual button 8" ;
   $global{Cons}{ModuleTypes}{'20'}{Channels}{"08"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'20'}{Channels}{"09"}{Name} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'20'}{Channels}{"09"}{Type} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'20'}{TemperatureChannel} = "09" ;

# Four touch buttons with PIR detectormodule: VMBGP4PIR
$global{Cons}{ModuleTypes}{'2D'}{Channels}{"01"}{Name} = "Push button 1" ;
   $global{Cons}{ModuleTypes}{'2D'}{Channels}{"01"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'2D'}{Channels}{"02"}{Name} = "Push button 2" ;
   $global{Cons}{ModuleTypes}{'2D'}{Channels}{"02"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'2D'}{Channels}{"03"}{Name} = "Push button 3" ;
   $global{Cons}{ModuleTypes}{'2D'}{Channels}{"03"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'2D'}{Channels}{"04"}{Name} = "Push button 4" ;
   $global{Cons}{ModuleTypes}{'2D'}{Channels}{"04"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'2D'}{Channels}{"05"}{Name} = "Dark/Light output" ;
   $global{Cons}{ModuleTypes}{'2D'}{Channels}{"05"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'2D'}{Channels}{"06"}{Name} = "Motion output" ;
   $global{Cons}{ModuleTypes}{'2D'}{Channels}{"06"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'2D'}{Channels}{"07"}{Name} = "Light Depending motion" ;
   $global{Cons}{ModuleTypes}{'2D'}{Channels}{"07"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'2D'}{Channels}{"08"}{Name} = "Absence output" ;
   $global{Cons}{ModuleTypes}{'2D'}{Channels}{"08"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'2D'}{Channels}{"09"}{Name} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'2D'}{Channels}{"09"}{Type} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'2D'}{TemperatureChannel} = "09" ; 

# Touch panel with Oled display: VMBGPOD
$global{Cons}{ModuleTypes}{'28'}{Channels}{"01"}{Name} = "Push button 1" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"01"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"02"}{Name} = "Push button 2" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"02"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"03"}{Name} = "Push button 3" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"03"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"04"}{Name} = "Push button 4" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"04"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"05"}{Name} = "Push button 5" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"05"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"06"}{Name} = "Push button 6" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"06"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"07"}{Name} = "Push button 7" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"07"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"08"}{Name} = "Push button 8" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"08"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"09"}{Name} = "Push button 9" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"09"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"10"}{Name} = "Push button 10" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"10"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"11"}{Name} = "Push button 11" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"11"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"12"}{Name} = "Push button 12" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"12"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"13"}{Name} = "Push button 13" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"13"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"14"}{Name} = "Push button 14" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"14"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"15"}{Name} = "Push button 15" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"15"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"16"}{Name} = "Push button 16" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"16"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"17"}{Name} = "Push button 17" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"17"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"18"}{Name} = "Push button 18" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"18"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"19"}{Name} = "Push button 19" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"19"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"20"}{Name} = "Push button 10" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"20"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"21"}{Name} = "Push button 21" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"21"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"22"}{Name} = "Push button 22" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"22"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"23"}{Name} = "Push button 23" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"23"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"24"}{Name} = "Push button 24" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"24"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"25"}{Name} = "Push button 25" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"25"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"26"}{Name} = "Push button 26" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"26"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"27"}{Name} = "Push button 27" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"27"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"28"}{Name} = "Push button 28" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"28"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"29"}{Name} = "Push button 29" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"29"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"30"}{Name} = "Push button 30" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"30"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"31"}{Name} = "Push button 31" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"31"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"32"}{Name} = "Push button 32" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"32"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"33"}{Name} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'28'}{Channels}{"33"}{Type} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'28'}{TemperatureChannel} = "33" ;

################### Input: Channel names
# 8-channel Push button interface module: VMB8PB
$global{Cons}{ModuleTypes}{'01'}{Channels}{"01"}{Name} = "Push button 1" ;
   $global{Cons}{ModuleTypes}{'01'}{Channels}{"01"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'01'}{Channels}{"02"}{Name} = "Push button 2" ;
   $global{Cons}{ModuleTypes}{'01'}{Channels}{"02"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'01'}{Channels}{"03"}{Name} = "Push button 3" ;
   $global{Cons}{ModuleTypes}{'01'}{Channels}{"03"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'01'}{Channels}{"04"}{Name} = "Push button 4" ;
   $global{Cons}{ModuleTypes}{'01'}{Channels}{"04"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'01'}{Channels}{"05"}{Name} = "Push button 5" ;
   $global{Cons}{ModuleTypes}{'01'}{Channels}{"05"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'01'}{Channels}{"06"}{Name} = "Push button 6" ;
   $global{Cons}{ModuleTypes}{'01'}{Channels}{"06"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'01'}{Channels}{"07"}{Name} = "Push button 7" ;
   $global{Cons}{ModuleTypes}{'01'}{Channels}{"07"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'01'}{Channels}{"08"}{Name} = "Push button 8" ;
   $global{Cons}{ModuleTypes}{'01'}{Channels}{"08"}{Type} = "Button" ;

# 6-channel input: VMB6IN
$global{Cons}{ModuleTypes}{'05'}{Channels}{"01"}{Name} = "Push button 1" ;
   $global{Cons}{ModuleTypes}{'05'}{Channels}{"01"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'05'}{Channels}{"02"}{Name} = "Push button 2" ;
   $global{Cons}{ModuleTypes}{'05'}{Channels}{"02"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'05'}{Channels}{"03"}{Name} = "Push button 3" ;
   $global{Cons}{ModuleTypes}{'05'}{Channels}{"03"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'05'}{Channels}{"04"}{Name} = "Push button 4" ;
   $global{Cons}{ModuleTypes}{'05'}{Channels}{"04"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'05'}{Channels}{"05"}{Name} = "Push button 5" ;
   $global{Cons}{ModuleTypes}{'05'}{Channels}{"05"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'05'}{Channels}{"06"}{Name} = "Push button 6" ;
   $global{Cons}{ModuleTypes}{'05'}{Channels}{"06"}{Type} = "Button" ;

# 8-channel Push button interface module: VMB8PBU
$global{Cons}{ModuleTypes}{'16'}{Channels}{"01"}{Name} = "Push button 1" ;
   $global{Cons}{ModuleTypes}{'16'}{Channels}{"01"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'16'}{Channels}{"02"}{Name} = "Push button 2" ;
   $global{Cons}{ModuleTypes}{'16'}{Channels}{"02"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'16'}{Channels}{"03"}{Name} = "Push button 3" ;
   $global{Cons}{ModuleTypes}{'16'}{Channels}{"03"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'16'}{Channels}{"04"}{Name} = "Push button 4" ;
   $global{Cons}{ModuleTypes}{'16'}{Channels}{"04"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'16'}{Channels}{"05"}{Name} = "Push button 5" ;
   $global{Cons}{ModuleTypes}{'16'}{Channels}{"05"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'16'}{Channels}{"06"}{Name} = "Push button 6" ;
   $global{Cons}{ModuleTypes}{'16'}{Channels}{"06"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'16'}{Channels}{"07"}{Name} = "Push button 7" ;
   $global{Cons}{ModuleTypes}{'16'}{Channels}{"07"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'16'}{Channels}{"08"}{Name} = "Push button 8" ;
   $global{Cons}{ModuleTypes}{'16'}{Channels}{"08"}{Type} = "Button" ;

# Push button module for 1 or 2 NIKO push buttons : VMB2PBN
$global{Cons}{ModuleTypes}{'18'}{Channels}{"01"}{Name} = "Push button 1" ;
   $global{Cons}{ModuleTypes}{'18'}{Channels}{"01"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'18'}{Channels}{"02"}{Name} = "Push button 2" ;
   $global{Cons}{ModuleTypes}{'18'}{Channels}{"02"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'18'}{Channels}{"03"}{Name} = "Virtual button" ;
   $global{Cons}{ModuleTypes}{'18'}{Channels}{"03"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'18'}{Channels}{"04"}{Name} = "Virtual button" ;
   $global{Cons}{ModuleTypes}{'18'}{Channels}{"04"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'18'}{Channels}{"05"}{Name} = "Virtual button" ;
   $global{Cons}{ModuleTypes}{'18'}{Channels}{"05"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'18'}{Channels}{"06"}{Name} = "Virtual button" ;
   $global{Cons}{ModuleTypes}{'18'}{Channels}{"06"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'18'}{Channels}{"07"}{Name} = "Virtual button" ;
   $global{Cons}{ModuleTypes}{'18'}{Channels}{"07"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'18'}{Channels}{"08"}{Name} = "Virtual button" ;
   $global{Cons}{ModuleTypes}{'18'}{Channels}{"08"}{Type} = "Button" ;

# Push button interface module for 4 or 6 NIKO push buttons : VMB6PBN
$global{Cons}{ModuleTypes}{'17'}{Channels}{"01"}{Name} = "Push button 1" ;
   $global{Cons}{ModuleTypes}{'17'}{Channels}{"01"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'17'}{Channels}{"02"}{Name} = "Push button 2" ;
   $global{Cons}{ModuleTypes}{'17'}{Channels}{"02"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'17'}{Channels}{"03"}{Name} = "Push button 3" ;
   $global{Cons}{ModuleTypes}{'17'}{Channels}{"03"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'17'}{Channels}{"04"}{Name} = "Push button 4" ;
   $global{Cons}{ModuleTypes}{'17'}{Channels}{"04"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'17'}{Channels}{"05"}{Name} = "Push button 5" ;
   $global{Cons}{ModuleTypes}{'17'}{Channels}{"05"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'17'}{Channels}{"06"}{Name} = "Push button 6" ;
   $global{Cons}{ModuleTypes}{'17'}{Channels}{"06"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'17'}{Channels}{"07"}{Name} = "Virtual button" ;
   $global{Cons}{ModuleTypes}{'17'}{Channels}{"08"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'17'}{Channels}{"08"}{Name} = "Virtual button" ;

# 7-channel input: VMB7IN
$global{Cons}{ModuleTypes}{'22'}{Channels}{"01"}{Name} = "Push button 1" ;
   $global{Cons}{ModuleTypes}{'22'}{Channels}{"01"}{Type} = "ButtonCounter" ;
   $global{Cons}{ModuleTypes}{'22'}{Channels}{"02"}{Name} = "Push button 2" ;
   $global{Cons}{ModuleTypes}{'22'}{Channels}{"02"}{Type} = "ButtonCounter" ;
   $global{Cons}{ModuleTypes}{'22'}{Channels}{"03"}{Name} = "Push button 3" ;
   $global{Cons}{ModuleTypes}{'22'}{Channels}{"03"}{Type} = "ButtonCounter" ;
   $global{Cons}{ModuleTypes}{'22'}{Channels}{"04"}{Name} = "Push button 4" ;
   $global{Cons}{ModuleTypes}{'22'}{Channels}{"04"}{Type} = "ButtonCounter" ;
   $global{Cons}{ModuleTypes}{'22'}{Channels}{"05"}{Name} = "Push button 5" ;
   $global{Cons}{ModuleTypes}{'22'}{Channels}{"05"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'22'}{Channels}{"06"}{Name} = "Push button 6" ;
   $global{Cons}{ModuleTypes}{'22'}{Channels}{"06"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'22'}{Channels}{"07"}{Name} = "Push button 7" ;
   $global{Cons}{ModuleTypes}{'22'}{Channels}{"07"}{Type} = "Button" ;

# Push button and timer panel: VMB4PD
$global{Cons}{ModuleTypes}{'0B'}{Channels}{"01"}{Name} = "Push button 1" ;
   $global{Cons}{ModuleTypes}{'0B'}{Channels}{"01"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'0B'}{Channels}{"02"}{Name} = "Push button 2" ;
   $global{Cons}{ModuleTypes}{'0B'}{Channels}{"02"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'0B'}{Channels}{"03"}{Name} = "Push button 3" ;
   $global{Cons}{ModuleTypes}{'0B'}{Channels}{"03"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'0B'}{Channels}{"04"}{Name} = "Push button 4" ;
   $global{Cons}{ModuleTypes}{'0B'}{Channels}{"04"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'0B'}{Channels}{"05"}{Name} = "Push button 5" ;
   $global{Cons}{ModuleTypes}{'0B'}{Channels}{"05"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'0B'}{Channels}{"06"}{Name} = "Push button 6" ;
   $global{Cons}{ModuleTypes}{'0B'}{Channels}{"06"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'0B'}{Channels}{"07"}{Name} = "Push button 7" ;
   $global{Cons}{ModuleTypes}{'0B'}{Channels}{"07"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'0B'}{Channels}{"08"}{Name} = "Push button 8" ;
   $global{Cons}{ModuleTypes}{'0B'}{Channels}{"08"}{Type} = "Button" ;

################### PIR Sensors: Channel names
# Mini PIR sensor: VMBPIRM
$global{Cons}{ModuleTypes}{'2A'}{Channels}{"01"}{Name} = "Dark output" ;
   $global{Cons}{ModuleTypes}{'2A'}{Channels}{"01"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'2A'}{Channels}{"02"}{Name} = "Light output" ;
   $global{Cons}{ModuleTypes}{'2A'}{Channels}{"02"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'2A'}{Channels}{"03"}{Name} = "Motion output 1" ;
   $global{Cons}{ModuleTypes}{'2A'}{Channels}{"03"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'2A'}{Channels}{"04"}{Name} = "Motion output 1 (LD)" ;
   $global{Cons}{ModuleTypes}{'2A'}{Channels}{"04"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'2A'}{Channels}{"05"}{Name} = "Motion output 2" ;
   $global{Cons}{ModuleTypes}{'2A'}{Channels}{"05"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'2A'}{Channels}{"06"}{Name} = "Motion output 2 (LD)" ;
   $global{Cons}{ModuleTypes}{'2A'}{Channels}{"06"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'2A'}{Channels}{"07"}{Name} = "Absence sensor" ;
   $global{Cons}{ModuleTypes}{'2A'}{Channels}{"07"}{Type} = "Sensor" ;

# Outdoor PIR sensor: VMBPIRO
$global{Cons}{ModuleTypes}{'2C'}{Channels}{"01"}{Name} = "Dark output" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"01"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"02"}{Name} = "Light output" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"02"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"03"}{Name} = "Motion output 1" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"03"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"04"}{Name} = "Motion output 1 (LD)" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"04"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"05"}{Name} = "Motion output 2" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"05"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"06"}{Name} = "Motion output 2 (LD)" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"06"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"07"}{Name} = "Low alarm" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"07"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"08"}{Name} = "High alarm" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"08"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"09"}{Name} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"09"}{Type} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'2C'}{TemperatureChannel} = "09" ;

# VMB4AN: Analog I/O module
$global{Cons}{ModuleTypes}{'32'}{Channels}{"09"}{Name} = "Sensor 1" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"09"}{Type} = "SensorNumber" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"10"}{Name} = "Sensor 2" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"10"}{Type} = "SensorNumber" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"11"}{Name} = "Sensor 3" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"11"}{Type} = "SensorNumber" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"12"}{Name} = "Sensor 4" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"12"}{Type} = "SensorNumber" ;

return 1 ;
