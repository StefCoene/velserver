###################
# Temperature sensor module: VMB1TS
$global{Cons}{ModuleTypes}{'0C'}{Channels}{"01"}{Name} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'0C'}{Channels}{"01"}{Type} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'0C'}{Thermostat} = "yes" ;

# Do not add the extra channels! The code is written for Touch Panels and this will not work
#$global{Cons}{ModuleTypes}{'0C'}{Channels}{"01"}{Name} = "Heater" ;
#   $global{Cons}{ModuleTypes}{'0C'}{Channels}{"01"}{Type} = "ThermostatChannel" ;
#   $global{Cons}{ModuleTypes}{'0C'}{Channels}{"02"}{Name} = "Boost Heater" ;
#   $global{Cons}{ModuleTypes}{'0C'}{Channels}{"02"}{Type} = "ThermostatChannel" ;
#   $global{Cons}{ModuleTypes}{'0C'}{Channels}{"03"}{Name} = "Central heating" ;
#   $global{Cons}{ModuleTypes}{'0C'}{Channels}{"03"}{Type} = "ThermostatChannel" ;
#   $global{Cons}{ModuleTypes}{'0C'}{Channels}{"04"}{Name} = "Cooler" ;
#   $global{Cons}{ModuleTypes}{'0C'}{Channels}{"04"}{Type} = "ThermostatChannel" ;
#   $global{Cons}{ModuleTypes}{'0C'}{Channels}{"05"}{Name} = "Pump" ;
#   $global{Cons}{ModuleTypes}{'0C'}{Channels}{"05"}{Type} = "ThermostatChannel" ;
#   $global{Cons}{ModuleTypes}{'0C'}{Channels}{"06"}{Name} = "Low alarm" ;
#   $global{Cons}{ModuleTypes}{'0C'}{Channels}{"06"}{Type} = "ThermostatChannel" ;
#   $global{Cons}{ModuleTypes}{'0C'}{Channels}{"07"}{Name} = "High alarm" ;
#   $global{Cons}{ModuleTypes}{'0C'}{Channels}{"07"}{Type} = "ThermostatChannel" ;

################### Relays: Channel names
# 1-channel relay module: VMB1RY
$global{Cons}{ModuleTypes}{'02'}{Channels}{"01"}{Name} = "Relay" ;
   $global{Cons}{ModuleTypes}{'02'}{Channels}{"01"}{Type} = "Relay" ;

# 4-channel relay module: VMB4RY
$global{Cons}{ModuleTypes}{'08'}{General} = "Relay4" ;

# 4-channel voltage-out relay module: VMB4RYLD
$global{Cons}{ModuleTypes}{'10'}{General} = "Relay4" ;
   $global{Cons}{ModuleTypes}{'10'}{Channels}{"05"}{Name} = "Virtual relay" ;
   $global{Cons}{ModuleTypes}{'10'}{Channels}{"05"}{Type} = "Relay" ;

# 4-channel relay module: VMB4RYNO
$global{Cons}{ModuleTypes}{'11'}{General} = "Relay4" ;
   $global{Cons}{ModuleTypes}{'11'}{Channels}{"05"}{Name} = "Virtual relay" ;
   $global{Cons}{ModuleTypes}{'11'}{Channels}{"05"}{Type} = "Relay" ;

# 1-channel relay module: VMB1RYNO
$global{Cons}{ModuleTypes}{'1B'}{General} = "Relay1" ;

# VMB1RYNOS (29): 1 channel relay module
$global{Cons}{ModuleTypes}{'29'}{General} = "Relay1" ;

################### Dimmers: Channel names
# 1-channel 0(1)-10V control: VMB1DM
$global{Cons}{ModuleTypes}{'07'}{Channels}{"01"}{Name} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'07'}{Channels}{"01"}{Type} = "Dimmer" ;

# 1-channel LED: VMB1LED
$global{Cons}{ModuleTypes}{'0F'}{Channels}{"01"}{Name} = "Dimmer" ;
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
$global{Cons}{ModuleTypes}{'14'}{Channels}{"01"}{Name} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'14'}{Channels}{"01"}{Type} = "Dimmer" ;

# 1-channel Dimmer: VMBDMI
$global{Cons}{ModuleTypes}{'15'}{Channels}{"01"}{Name} = "Dimmer" ;
   $global{Cons}{ModuleTypes}{'15'}{Channels}{"01"}{Type} = "Dimmer" ;

################### Blinds: Channel names
# 1-channel blind control module: VMB1BL
$global{Cons}{ModuleTypes}{'03'}{Channels}{"01"}{Name} = "Blind" ;
   $global{Cons}{ModuleTypes}{'03'}{Channels}{"01"}{Type} = "Blind" ;
   $global{Cons}{ModuleTypes}{'03'}{ChannelNumbers}{Name}{Map}{'03'} = "01" ; # 00000011 = 03 bin

# 2-channel blind control module: VMB2BL
$global{Cons}{ModuleTypes}{'09'}{Channels}{"01"}{Name} = "Blind 1" ;
   $global{Cons}{ModuleTypes}{'09'}{Channels}{"01"}{Type} = "Blind" ;
   $global{Cons}{ModuleTypes}{'09'}{Channels}{"02"}{Name} = "Blind 2" ;
   $global{Cons}{ModuleTypes}{'09'}{Channels}{"02"}{Type} = "Blind" ;
   $global{Cons}{ModuleTypes}{'09'}{ChannelNumbers}{Name}{Map}{'03'} = "01" ; # 00000011 = 03 bin
   $global{Cons}{ModuleTypes}{'09'}{ChannelNumbers}{Name}{Map}{'0C'} = "02" ; # 00001100 = 12 bin = 0C hex


# 2-channel blind control module: VMB2BLE
$global{Cons}{ModuleTypes}{'1D'}{Channels}{"01"}{Name} = "Blind 1" ;
   $global{Cons}{ModuleTypes}{'1D'}{Channels}{"01"}{Type} = "Blind" ;
   $global{Cons}{ModuleTypes}{'1D'}{Channels}{"02"}{Name} = "Blind 2" ;
   $global{Cons}{ModuleTypes}{'1D'}{Channels}{"02"}{Type} = "Blind" ;

# VMB1BLS (2E): 1 channel blind module
$global{Cons}{ModuleTypes}{'2E'}{Channels}{"01"}{Name} = "Blind" ;
   $global{Cons}{ModuleTypes}{'2E'}{Channels}{"01"}{Type} = "Blind" ;

################### Touch panels: Channel names
# VMBGP1
$global{Cons}{ModuleTypes}{'1E'}{General} = "Touch1 Touch124Temperature" ;
$global{Cons}{ModuleTypes}{'1E'}{ChannelNumbers}{Name}{Map}{'09'} = "10" ; # Temperature channel name is reported on CH09

# VMBGP2
$global{Cons}{ModuleTypes}{'1F'}{General} = "Touch2 Touch124Temperature" ;
$global{Cons}{ModuleTypes}{'1F'}{ChannelNumbers}{Name}{Map}{'09'} = "10" ; # Temperature channel name is reported on CH09

# VMBGP4
$global{Cons}{ModuleTypes}{'20'}{General} = "Touch4 Touch124Temperature" ;
$global{Cons}{ModuleTypes}{'20'}{ChannelNumbers}{Name}{Map}{'09'} = "10" ; # Temperature channel name is reported on CH09

# VMBGPO (21): Touch panel with Oled display
$global{Cons}{ModuleTypes}{'21'}{General} = "TouchO TouchOTemperature" ;
$global{Cons}{ModuleTypes}{'21'}{ChannelNumbers}{Name}{Map}{'21'} = "34" ; # Temperature channel name is reported on CH33 (33 dec = 21 hex)

# Four touch buttons with PIR detectormodule: VMBGP4PIR
$global{Cons}{ModuleTypes}{'2D'}{General} = "TouchPIR Touch4 Touch124Temperature" ;
$global{Cons}{ModuleTypes}{'2D'}{ChannelNumbers}{Name}{Map}{'09'} = "10" ; # Temperature channel name is reported on CH09

# Touch panel with Oled display: VMBGPOD
$global{Cons}{ModuleTypes}{'28'}{General} = "TouchO TouchOTemperature" ;
$global{Cons}{ModuleTypes}{'28'}{ChannelNumbers}{Name}{Map}{'21'} = "34" ; # Temperature channel name is reported on CH33 (33 dec = 21 hex)

# VMBEL1 (34): Edge-lit one, two or four touch buttons module
$global{Cons}{ModuleTypes}{'34'}{General} = "Touch1 Touch124Temperature" ;
$global{Cons}{ModuleTypes}{'34'}{ChannelNumbers}{Name}{Map}{'09'} = "10" ; # Temperature channel name is reported on CH09

# VMBEL1 (35): Edge-lit one, two or four touch buttons module
$global{Cons}{ModuleTypes}{'35'}{General} = "Touch2 Touch124Temperature" ;
$global{Cons}{ModuleTypes}{'35'}{ChannelNumbers}{Name}{Map}{'09'} = "10" ; # Temperature channel name is reported on CH09

# VMBEL1 (36): Edge-lit one, two or four touch buttons module
$global{Cons}{ModuleTypes}{'36'}{General} = "Touch4 Touch124Temperature" ;
$global{Cons}{ModuleTypes}{'36'}{ChannelNumbers}{Name}{Map}{'09'} = "10" ; # Temperature channel name is reported on CH09

# MBELO (37): Edge-lit touch panel with Oled display)
$global{Cons}{ModuleTypes}{'37'}{General} = "TouchO TouchOTemperature" ;
$global{Cons}{ModuleTypes}{'37'}{ChannelNumbers}{Name}{Map}{'21'} = "34" ; # Temperature channel name is reported on CH33 (33 dec = 21 hex)

# VMBGP1-2 (3A): One, two or four touch buttons module (ed2)
$global{Cons}{ModuleTypes}{'3A'}{General} = "Touch1 Touch124Temperature" ;
$global{Cons}{ModuleTypes}{'3A'}{ChannelNumbers}{Name}{Map}{'09'} = "10" ; # Temperature channel name is reported on CH09

# VMBGP2-2 (3B): One, two or four touch buttons module (ed2)
$global{Cons}{ModuleTypes}{'3B'}{General} = "Touch2 Touch124Temperature" ;
$global{Cons}{ModuleTypes}{'3B'}{ChannelNumbers}{Name}{Map}{'09'} = "10" ; # Temperature channel name is reported on CH09

# VMBGP4-2 (3C): One, two or four touch buttons module (ed2)
$global{Cons}{ModuleTypes}{'3C'}{General} = "Touch4 Touch124Temperature" ;
$global{Cons}{ModuleTypes}{'3C'}{ChannelNumbers}{Name}{Map}{'09'} = "10" ; # Temperature channel name is reported on CH09

# VMBGPOD-2 (3D): Touch panel with Oled display (ed2)
$global{Cons}{ModuleTypes}{'3D'}{General} = "TouchO TouchOTemperature" ;
$global{Cons}{ModuleTypes}{'3D'}{ChannelNumbers}{Name}{Map}{'21'} = "34" ; # Temperature channel name is reported on CH33 (33 dec = 21 hex)

# VMBGP4PIR-2 (3E): Four touch buttons with PIR detector module (ed2)
$global{Cons}{ModuleTypes}{'3E'}{General} = "TouchPIR Touch4 Touch124Temperature" ;
$global{Cons}{ModuleTypes}{'3E'}{ChannelNumbers}{Name}{Map}{'09'} = "10" ; # Temperature channel name is reported on CH09
 
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
   $global{Cons}{ModuleTypes}{'17'}{Channels}{"07"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'17'}{Channels}{"08"}{Name} = "Virtual button" ;
   $global{Cons}{ModuleTypes}{'17'}{Channels}{"08"}{Type} = "Button" ;

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
   $global{Cons}{ModuleTypes}{'22'}{Channels}{"08"}{Name} = "Virtual button" ;
   $global{Cons}{ModuleTypes}{'22'}{Channels}{"08"}{Type} = "Button" ;

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
$global{Cons}{ModuleTypes}{'2A'}{General} = "PIR" ;
   $global{Cons}{ModuleTypes}{'2A'}{Channels}{"07"}{Name} = "Absence output" ;
   $global{Cons}{ModuleTypes}{'2A'}{Channels}{"07"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'2A'}{Channels}{"99"}{Name} = "Light value" ;
   $global{Cons}{ModuleTypes}{'2A'}{Channels}{"99"}{Type} = "LightSensor" ;

# 	VMBPIRC (2B): Ceiling PIR detector module
$global{Cons}{ModuleTypes}{'2B'}{General} = "PIR" ;
   $global{Cons}{ModuleTypes}{'2B'}{Channels}{"07"}{Name} = "Absence output" ;
   $global{Cons}{ModuleTypes}{'2B'}{Channels}{"07"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'2B'}{Channels}{"99"}{Name} = "Light value" ;
   $global{Cons}{ModuleTypes}{'2B'}{Channels}{"99"}{Type} = "LightSensor" ;

# Outdoor PIR sensor: VMBPIRO
$global{Cons}{ModuleTypes}{'2C'}{General} = "PIR" ;
   $global{Cons}{ModuleTypes}{'2C'}{ChannelNumbers}{Name}{Map}{'01'} = "09" ;
   $global{Cons}{ModuleTypes}{'2C'}{AllChannelStatus} = "FF" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"07"}{Name} = "Low alarm" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"07"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"08"}{Name} = "High alarm" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"08"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"09"}{Name} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"09"}{Type} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"99"}{Name} = "Light value" ;
   $global{Cons}{ModuleTypes}{'2C'}{Channels}{"99"}{Type} = "LightSensor" ;

#	VMBMETEO (31): Meteo station
$global{Cons}{ModuleTypes}{'31'}{ChannelNumbers}{Name}{Convert} = "hex" ;
   $global{Cons}{ModuleTypes}{'31'}{ChannelNumbers}{SensorNumber}{Map}{'02'} = "11" ; # bin 00000010 = hex 02
   $global{Cons}{ModuleTypes}{'31'}{ChannelNumbers}{SensorNumber}{Map}{'04'} = "12" ; # bin 00000100 = hex 04
   $global{Cons}{ModuleTypes}{'31'}{ChannelNumbers}{SensorNumber}{Map}{'08'} = "13" ; # bin 00001000 = hex 08
   $global{Cons}{ModuleTypes}{'31'}{AllChannelStatus} = "FF" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"01"}{Name} = "Frost alarm" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"01"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"02"}{Name} = "Heat alarm" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"02"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"03"}{Name} = "Rain alarm" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"03"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"04"}{Name} = "Dawn alarm" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"04"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"05"}{Name} = "Dusk alarm" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"05"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"06"}{Name} = "Sun alarm" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"06"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"07"}{Name} = "Wind alarm" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"07"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"08"}{Name} = "Storm alarm" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"08"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"10"}{Name} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"10"}{Type} = "Temperature" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"11"}{Name} = "Rainfall" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"11"}{Type} = "SensorNumber" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"12"}{Name} = "Illuminance" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"12"}{Type} = "SensorNumber" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"13"}{Name} = "Wind speed" ;
   $global{Cons}{ModuleTypes}{'31'}{Channels}{"13"}{Type} = "SensorNumber" ;

# VMB4AN: Analog I/O module
$global{Cons}{ModuleTypes}{'32'}{ChannelNumbers}{Name}{Convert} = "hex" ;
   $global{Cons}{ModuleTypes}{'32'}{ChannelNumbers}{MakeMessage}{Convert} = "hex" ;
   $global{Cons}{ModuleTypes}{'32'}{AllChannelStatus} = "FF" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"01"}{Name} = "Alarm 1" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"01"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"02"}{Name} = "Alarm 2" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"02"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"03"}{Name} = "Alarm 3" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"03"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"04"}{Name} = "Alarm 4" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"04"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"05"}{Name} = "Alarm 5" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"05"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"06"}{Name} = "Alarm 6" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"06"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"07"}{Name} = "Alarm 7" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"07"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"08"}{Name} = "Alarm 8" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"08"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"09"}{Name} = "Sensor 1" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"09"}{Type} = "SensorNumber" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"10"}{Name} = "Sensor 2" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"10"}{Type} = "SensorNumber" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"11"}{Name} = "Sensor 3" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"11"}{Type} = "SensorNumber" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"12"}{Name} = "Sensor 4" ;
   $global{Cons}{ModuleTypes}{'32'}{Channels}{"12"}{Type} = "SensorNumber" ;

# VMBVP1 (33): Doorbird interface module
$global{Cons}{ModuleTypes}{'33'}{Channels}{"01"}{Name} = "Motion 1" ;
   $global{Cons}{ModuleTypes}{'33'}{Channels}{"01"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'33'}{Channels}{"02"}{Name} = "Motion 2" ;
   $global{Cons}{ModuleTypes}{'33'}{Channels}{"02"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'33'}{Channels}{"03"}{Name} = "Bell 1" ;
   $global{Cons}{ModuleTypes}{'33'}{Channels}{"03"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'33'}{Channels}{"04"}{Name} = "Bell 2" ;
   $global{Cons}{ModuleTypes}{'33'}{Channels}{"04"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'33'}{Channels}{"05"}{Name} = "Door 1" ;
   $global{Cons}{ModuleTypes}{'33'}{Channels}{"05"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'33'}{Channels}{"06"}{Name} = "Door 2" ;
   $global{Cons}{ModuleTypes}{'33'}{Channels}{"06"}{Type} = "Sensor" ;
   $global{Cons}{ModuleTypes}{'33'}{Channels}{"07"}{Name} = "Virtual button 1" ;
   $global{Cons}{ModuleTypes}{'33'}{Channels}{"07"}{Type} = "Button" ;
   $global{Cons}{ModuleTypes}{'33'}{Channels}{"08"}{Name} = "Virtual button 2" ;
   $global{Cons}{ModuleTypes}{'33'}{Channels}{"08"}{Type} = "Button" ;

#################### General definitions that can be used in different modules
# 1 channel relay
$global{Cons}{ModuleGeneral}{Relay1}{Channels}{"01"}{Name} = "Relay" ;
   $global{Cons}{ModuleGeneral}{Relay1}{Channels}{"01"}{Type} = "Relay" ;
   $global{Cons}{ModuleGeneral}{Relay1}{Channels}{"02"}{Name} = "Virtual relay 1" ;
   $global{Cons}{ModuleGeneral}{Relay1}{Channels}{"02"}{Type} = "Relay" ;
   $global{Cons}{ModuleGeneral}{Relay1}{Channels}{"03"}{Name} = "Virtual relay 2" ;
   $global{Cons}{ModuleGeneral}{Relay1}{Channels}{"03"}{Type} = "Relay" ;
   $global{Cons}{ModuleGeneral}{Relay1}{Channels}{"04"}{Name} = "Virtual relay 3" ;
   $global{Cons}{ModuleGeneral}{Relay1}{Channels}{"04"}{Type} = "Relay" ;
   $global{Cons}{ModuleGeneral}{Relay1}{Channels}{"05"}{Name} = "Virtual relay 4" ;
   $global{Cons}{ModuleGeneral}{Relay1}{Channels}{"05"}{Type} = "Relay" ;

# 4 channel relay
$global{Cons}{ModuleGeneral}{Relay4}{Channels}{"01"}{Name} = "Relay 1" ;
   $global{Cons}{ModuleGeneral}{Relay4}{Channels}{"01"}{Type} = "Relay" ;
   $global{Cons}{ModuleGeneral}{Relay4}{Channels}{"02"}{Name} = "Relay 2" ;
   $global{Cons}{ModuleGeneral}{Relay4}{Channels}{"02"}{Type} = "Relay" ;
   $global{Cons}{ModuleGeneral}{Relay4}{Channels}{"03"}{Name} = "Relay 3" ;
   $global{Cons}{ModuleGeneral}{Relay4}{Channels}{"03"}{Type} = "Relay" ;
   $global{Cons}{ModuleGeneral}{Relay4}{Channels}{"04"}{Name} = "Relay 4" ;
   $global{Cons}{ModuleGeneral}{Relay4}{Channels}{"04"}{Type} = "Relay" ;

# Touch with 1 button
$global{Cons}{ModuleGeneral}{Touch1}{ChannelNumbers}{Name}{Convert} = "hex" ;
   $global{Cons}{ModuleGeneral}{Touch1}{AllChannelStatus} = "FF" ;
   $global{Cons}{ModuleGeneral}{Touch1}{ThermostatAddr} = "0" ;
   $global{Cons}{ModuleGeneral}{Touch1}{Channels}{"01"}{Name} = "Push button 1" ;
   $global{Cons}{ModuleGeneral}{Touch1}{Channels}{"01"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch1}{Channels}{"02"}{Name} = "Virtual button 2" ;
   $global{Cons}{ModuleGeneral}{Touch1}{Channels}{"02"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch1}{Channels}{"03"}{Name} = "Virtual button 3" ;
   $global{Cons}{ModuleGeneral}{Touch1}{Channels}{"03"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch1}{Channels}{"04"}{Name} = "Virtual button 4" ;
   $global{Cons}{ModuleGeneral}{Touch1}{Channels}{"04"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch1}{Channels}{"05"}{Name} = "Virtual button 5" ;
   $global{Cons}{ModuleGeneral}{Touch1}{Channels}{"05"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch1}{Channels}{"06"}{Name} = "Virtual button 6" ;
   $global{Cons}{ModuleGeneral}{Touch1}{Channels}{"06"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch1}{Channels}{"07"}{Name} = "Virtual button 7" ;
   $global{Cons}{ModuleGeneral}{Touch1}{Channels}{"07"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch1}{Channels}{"08"}{Name} = "Virtual button 8" ;
   $global{Cons}{ModuleGeneral}{Touch1}{Channels}{"08"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch1}{Channels}{"10"}{Name} = "Temperature" ;
   $global{Cons}{ModuleGeneral}{Touch1}{Channels}{"10"}{Type} = "Temperature" ;

# Touch with 2 buttons
$global{Cons}{ModuleGeneral}{Touch2}{ChannelNumbers}{Name}{Convert} = "hex" ;
   $global{Cons}{ModuleGeneral}{Touch2}{AllChannelStatus} = "FF" ;
   $global{Cons}{ModuleGeneral}{Touch2}{ThermostatAddr} = "0" ;
   $global{Cons}{ModuleGeneral}{Touch2}{Channels}{"01"}{Name} = "Push button 1" ;
   $global{Cons}{ModuleGeneral}{Touch2}{Channels}{"01"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch2}{Channels}{"02"}{Name} = "Push button 2" ;
   $global{Cons}{ModuleGeneral}{Touch2}{Channels}{"02"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch2}{Channels}{"03"}{Name} = "Virtual button 3" ;
   $global{Cons}{ModuleGeneral}{Touch2}{Channels}{"03"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch2}{Channels}{"04"}{Name} = "Virtual button 4" ;
   $global{Cons}{ModuleGeneral}{Touch2}{Channels}{"04"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch2}{Channels}{"05"}{Name} = "Virtual button 5" ;
   $global{Cons}{ModuleGeneral}{Touch2}{Channels}{"05"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch2}{Channels}{"06"}{Name} = "Virtual button 6" ;
   $global{Cons}{ModuleGeneral}{Touch2}{Channels}{"06"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch2}{Channels}{"07"}{Name} = "Virtual button 7" ;
   $global{Cons}{ModuleGeneral}{Touch2}{Channels}{"07"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch2}{Channels}{"08"}{Name} = "Virtual button 8" ;
   $global{Cons}{ModuleGeneral}{Touch2}{Channels}{"08"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch2}{Channels}{"10"}{Name} = "Temperature" ;
   $global{Cons}{ModuleGeneral}{Touch2}{Channels}{"10"}{Type} = "Temperature" ;

# Touch with 4 buttons
$global{Cons}{ModuleGeneral}{Touch4}{ChannelNumbers}{Name}{Convert} = "hex" ;
   $global{Cons}{ModuleGeneral}{Touch4}{AllChannelStatus} = "FF" ;
   $global{Cons}{ModuleGeneral}{Touch4}{ThermostatAddr} = "0" ;
   $global{Cons}{ModuleGeneral}{Touch4}{Channels}{"01"}{Name} = "Push button 1" ;
   $global{Cons}{ModuleGeneral}{Touch4}{Channels}{"01"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch4}{Channels}{"02"}{Name} = "Push button 2" ;
   $global{Cons}{ModuleGeneral}{Touch4}{Channels}{"02"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch4}{Channels}{"03"}{Name} = "Push button 3" ;
   $global{Cons}{ModuleGeneral}{Touch4}{Channels}{"03"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch4}{Channels}{"04"}{Name} = "Push button 4" ;
   $global{Cons}{ModuleGeneral}{Touch4}{Channels}{"04"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch4}{Channels}{"05"}{Name} = "Virtual button 5" ;
   $global{Cons}{ModuleGeneral}{Touch4}{Channels}{"05"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch4}{Channels}{"06"}{Name} = "Virtual button 6" ;
   $global{Cons}{ModuleGeneral}{Touch4}{Channels}{"06"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch4}{Channels}{"07"}{Name} = "Virtual button 7" ;
   $global{Cons}{ModuleGeneral}{Touch4}{Channels}{"07"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch4}{Channels}{"08"}{Name} = "Virtual button 8" ;
   $global{Cons}{ModuleGeneral}{Touch4}{Channels}{"08"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{Touch4}{Channels}{"10"}{Name} = "Temperature" ;
   $global{Cons}{ModuleGeneral}{Touch4}{Channels}{"10"}{Type} = "Temperature" ;

$global{Cons}{ModuleGeneral}{Touch124Temperature}{Channels}{"11"}{Name} = "Heater" ;
   $global{Cons}{ModuleGeneral}{Touch124Temperature}{Channels}{"11"}{Type} = "ThermostatChannel" ;
   $global{Cons}{ModuleGeneral}{Touch124Temperature}{Channels}{"12"}{Name} = "Boost" ;
   $global{Cons}{ModuleGeneral}{Touch124Temperature}{Channels}{"12"}{Type} = "ThermostatChannel" ;
   $global{Cons}{ModuleGeneral}{Touch124Temperature}{Channels}{"13"}{Name} = "Pump" ;
   $global{Cons}{ModuleGeneral}{Touch124Temperature}{Channels}{"13"}{Type} = "ThermostatChannel" ;
   $global{Cons}{ModuleGeneral}{Touch124Temperature}{Channels}{"14"}{Name} = "Cooler" ;
   $global{Cons}{ModuleGeneral}{Touch124Temperature}{Channels}{"14"}{Type} = "ThermostatChannel" ;
   $global{Cons}{ModuleGeneral}{Touch124Temperature}{Channels}{"15"}{Name} = "Alarm 1" ;
   $global{Cons}{ModuleGeneral}{Touch124Temperature}{Channels}{"15"}{Type} = "ThermostatChannel" ;
   $global{Cons}{ModuleGeneral}{Touch124Temperature}{Channels}{"16"}{Name} = "Alarm 2" ;
   $global{Cons}{ModuleGeneral}{Touch124Temperature}{Channels}{"16"}{Type} = "ThermostatChannel" ;
   $global{Cons}{ModuleGeneral}{Touch124Temperature}{Channels}{"17"}{Name} = "Alarm 3" ;
   $global{Cons}{ModuleGeneral}{Touch124Temperature}{Channels}{"17"}{Type} = "ThermostatChannel" ;
   $global{Cons}{ModuleGeneral}{Touch124Temperature}{Channels}{"18"}{Name} = "Alarm 4" ;
   $global{Cons}{ModuleGeneral}{Touch124Temperature}{Channels}{"18"}{Type} = "ThermostatChannel" ;

# Touch with PIR sensor: sensor channels
$global{Cons}{ModuleGeneral}{TouchPIR}{Channels}{"05"}{Name} = "Dark/Light output" ;
   $global{Cons}{ModuleGeneral}{TouchPIR}{Channels}{"05"}{Type} = "Sensor" ;
   $global{Cons}{ModuleGeneral}{TouchPIR}{Channels}{"06"}{Name} = "Motion output" ;
   $global{Cons}{ModuleGeneral}{TouchPIR}{Channels}{"06"}{Type} = "Sensor" ;
   $global{Cons}{ModuleGeneral}{TouchPIR}{Channels}{"07"}{Name} = "Light Depending motion" ;
   $global{Cons}{ModuleGeneral}{TouchPIR}{Channels}{"07"}{Type} = "Sensor" ;
   $global{Cons}{ModuleGeneral}{TouchPIR}{Channels}{"08"}{Name} = "Absence output" ;
   $global{Cons}{ModuleGeneral}{TouchPIR}{Channels}{"08"}{Type} = "Sensor" ;
   $global{Cons}{ModuleGeneral}{TouchPIR}{Channels}{"99"}{Name} = "Light value" ;
   $global{Cons}{ModuleGeneral}{TouchPIR}{Channels}{"99"}{Type} = "LightSensor" ;

# Touch with OLED
$global{Cons}{ModuleGeneral}{TouchO}{ChannelNumbers}{Name}{Convert} = "hex" ;
   $global{Cons}{ModuleGeneral}{TouchO}{AllChannelStatus} = "FF" ;
   $global{Cons}{ModuleGeneral}{TouchO}{ThermostatAddr} = "3" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"01"}{Name} = "Push button 1" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"01"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"02"}{Name} = "Push button 2" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"02"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"03"}{Name} = "Push button 3" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"03"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"04"}{Name} = "Push button 4" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"04"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"05"}{Name} = "Push button 5" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"05"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"06"}{Name} = "Push button 6" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"06"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"07"}{Name} = "Push button 7" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"07"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"08"}{Name} = "Push button 8" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"08"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"09"}{Name} = "Push button 9" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"09"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"10"}{Name} = "Push button 10" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"10"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"11"}{Name} = "Push button 11" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"11"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"12"}{Name} = "Push button 12" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"12"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"13"}{Name} = "Push button 13" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"13"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"14"}{Name} = "Push button 14" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"14"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"15"}{Name} = "Push button 15" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"15"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"16"}{Name} = "Push button 16" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"16"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"17"}{Name} = "Push button 17" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"17"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"18"}{Name} = "Push button 18" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"18"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"19"}{Name} = "Push button 19" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"19"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"20"}{Name} = "Push button 10" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"20"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"21"}{Name} = "Push button 21" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"21"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"22"}{Name} = "Push button 22" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"22"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"23"}{Name} = "Push button 23" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"23"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"24"}{Name} = "Push button 24" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"24"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"25"}{Name} = "Push button 25" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"25"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"26"}{Name} = "Push button 26" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"26"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"27"}{Name} = "Push button 27" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"27"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"28"}{Name} = "Push button 28" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"28"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"29"}{Name} = "Push button 29" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"29"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"30"}{Name} = "Push button 30" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"30"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"31"}{Name} = "Push button 31" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"31"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"32"}{Name} = "Push button 32" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"32"}{Type} = "Button" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"34"}{Name} = "Temperature" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"34"}{Type} = "Temperature" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"99"}{Name} = "Memo Text" ;
   $global{Cons}{ModuleGeneral}{TouchO}{Channels}{"99"}{Type} = "Memo" ;

$global{Cons}{ModuleGeneral}{TouchOTemperature}{Channels}{"35"}{Name} = "Heater" ;
   $global{Cons}{ModuleGeneral}{TouchOTemperature}{Channels}{"35"}{Type} = "ThermostatChannel" ;
   $global{Cons}{ModuleGeneral}{TouchOTemperature}{Channels}{"36"}{Name} = "Boost" ;
   $global{Cons}{ModuleGeneral}{TouchOTemperature}{Channels}{"36"}{Type} = "ThermostatChannel" ;
   $global{Cons}{ModuleGeneral}{TouchOTemperature}{Channels}{"37"}{Name} = "Pump" ;
   $global{Cons}{ModuleGeneral}{TouchOTemperature}{Channels}{"37"}{Type} = "ThermostatChannel" ;
   $global{Cons}{ModuleGeneral}{TouchOTemperature}{Channels}{"38"}{Name} = "Cooler" ;
   $global{Cons}{ModuleGeneral}{TouchOTemperature}{Channels}{"38"}{Type} = "ThermostatChannel" ;
   $global{Cons}{ModuleGeneral}{TouchOTemperature}{Channels}{"39"}{Name} = "Alarm 1" ;
   $global{Cons}{ModuleGeneral}{TouchOTemperature}{Channels}{"39"}{Type} = "ThermostatChannel" ;
   $global{Cons}{ModuleGeneral}{TouchOTemperature}{Channels}{"40"}{Name} = "Alarm 2" ;
   $global{Cons}{ModuleGeneral}{TouchOTemperature}{Channels}{"40"}{Type} = "ThermostatChannel" ;
   $global{Cons}{ModuleGeneral}{TouchOTemperature}{Channels}{"41"}{Name} = "Alarm 3" ;
   $global{Cons}{ModuleGeneral}{TouchOTemperature}{Channels}{"41"}{Type} = "ThermostatChannel" ;
   $global{Cons}{ModuleGeneral}{TouchOTemperature}{Channels}{"42"}{Name} = "Alarm 4" ;
   $global{Cons}{ModuleGeneral}{TouchOTemperature}{Channels}{"42"}{Type} = "ThermostatChannel" ;

# PIR sensor
$global{Cons}{ModuleGeneral}{PIR}{Channels}{"01"}{Name} = "Dark output" ;
   $global{Cons}{ModuleGeneral}{PIR}{Channels}{"01"}{Type} = "Sensor" ;
   $global{Cons}{ModuleGeneral}{PIR}{Channels}{"02"}{Name} = "Light output" ;
   $global{Cons}{ModuleGeneral}{PIR}{Channels}{"02"}{Type} = "Sensor" ;
   $global{Cons}{ModuleGeneral}{PIR}{Channels}{"03"}{Name} = "Motion output 1" ;
   $global{Cons}{ModuleGeneral}{PIR}{Channels}{"03"}{Type} = "Sensor" ;
   $global{Cons}{ModuleGeneral}{PIR}{Channels}{"04"}{Name} = "Motion output 1 (LD)" ;
   $global{Cons}{ModuleGeneral}{PIR}{Channels}{"04"}{Type} = "Sensor" ;
   $global{Cons}{ModuleGeneral}{PIR}{Channels}{"05"}{Name} = "Motion output 2" ;
   $global{Cons}{ModuleGeneral}{PIR}{Channels}{"05"}{Type} = "Sensor" ;
   $global{Cons}{ModuleGeneral}{PIR}{Channels}{"06"}{Name} = "Motion output 2 (LD)" ;
   $global{Cons}{ModuleGeneral}{PIR}{Channels}{"06"}{Type} = "Sensor" ;

# Merge the {General} information
# Find the TemperatureChannel
foreach my $ModuleType (sort keys %{$global{Cons}{ModuleTypes}}) {
   if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{General} ) {
      foreach my $GeneralType (split " ", $global{Cons}{ModuleTypes}{$ModuleType}{General} ) { # No sort!
         if ( defined $global{Cons}{ModuleGeneral}{$GeneralType} ) {
            %{$global{Cons}{ModuleTypes}{$ModuleType}} = %{ merge( \%{$global{Cons}{ModuleTypes}{$ModuleType}}, \%{$global{Cons}{ModuleGeneral}{$GeneralType}} ) };
         }
      }
      delete $global{Cons}{ModuleTypes}{$ModuleType}{General}  ;
   }
   foreach my $Channel (sort keys %{$global{Cons}{ModuleTypes}{$ModuleType}{Channels}}) {
      if ( defined $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Type} ) {
         my $ChannelType = $global{Cons}{ModuleTypes}{$ModuleType}{Channels}{$Channel}{Type} ;
         if ( $ChannelType eq "Temperature" ) {
            $global{Cons}{ModuleTypes}{$ModuleType}{TemperatureChannel} = $Channel ;
         }
         $global{Cons}{ChannelTypes}{$ChannelType}{ModulesList}{$ModuleType} = "yes" ;
      } else {
         print "ERROR: no TYPE for ModuleType=$ModuleType, Channel = $Channel\n" ;
      }
   }
}

foreach my $ChannelType (sort keys %{$global{Cons}{ChannelTypes}} ) {
   my $Modules = join ",", sort keys %{$global{Cons}{ChannelTypes}{$ChannelType}{ModulesList}} ;
   $global{Cons}{ChannelTypes}{$ChannelType}{Modules} = $Modules ;
   delete $global{Cons}{ChannelTypes}{$ChannelType}{ModulesList} ;
}

return 1 ;
