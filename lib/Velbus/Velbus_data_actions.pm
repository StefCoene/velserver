# This files determines for each module what actions are supported.
# $global{ActionType}{<type acion>}: <type acion> = type parameter when calling the web based API
# $global{ActionType}{<type acion>}{Module}: list of modules that support this action
# $global{ActionType}{<type acion>}{Command}{Set}: command used, only modules with this command defined can be used with this type action
#
# Current temperature
$global{ActionType}{Temperature}{Module}{'1E'} = "yes" ; # VMBGP1
$global{ActionType}{Temperature}{Module}{'1F'} = "yes" ; # VMBGP2
$global{ActionType}{Temperature}{Module}{'20'} = "yes" ; # VMBGP4
$global{ActionType}{Temperature}{Module}{'28'} = "yes" ; # VMBGPOD
$global{ActionType}{Temperature}{Module}{'2C'} = "yes" ; # VMBPIRO
$global{ActionType}{Temperature}{Module}{'2D'} = "yes" ; # VMBGP4PIR

# Target temperature
$global{ActionType}{TemperatureTarget}{Module}{'1E'} = "yes" ; # VMBGP1
$global{ActionType}{TemperatureTarget}{Module}{'1F'} = "yes" ; # VMBGP2
$global{ActionType}{TemperatureTarget}{Module}{'20'} = "yes" ; # VMBGP4
$global{ActionType}{TemperatureTarget}{Module}{'28'} = "yes" ; # VMBGPOD
$global{ActionType}{TemperatureTarget}{Module}{'2D'} = "yes" ; # VMBGP4PIR
$global{ActionType}{TemperatureTarget}{Command}{Set} = "E4" ; # &set_temperature

# CoHeMode: &set_temperature_cohe_mode
$global{ActionType}{TemperatureCoHeMode}{Module}{'1E'} = "yes" ; # VMBGP1
$global{ActionType}{TemperatureCoHeMode}{Module}{'1F'} = "yes" ; # VMBGP2
$global{ActionType}{TemperatureCoHeMode}{Module}{'20'} = "yes" ; # VMBGP4
$global{ActionType}{TemperatureCoHeMode}{Module}{'28'} = "yes" ; # VMBGPOD
$global{ActionType}{TemperatureCoHeMode}{Module}{'2D'} = "yes" ; # VMBGP4PIR
$global{ActionType}{TemperatureCoHeMode}{Command}{Set} = "DF" ; # &set_temperature_cohe_mode
$global{ActionType}{TemperatureCoHeMode}{Command}{Set} = "E0" ; # &set_temperature_cohe_mode

# Temperature Mode: &set_temperature_mode
$global{ActionType}{TemperatureMode}{Module}{'1E'} = "yes" ; # VMBGP1
$global{ActionType}{TemperatureMode}{Module}{'1F'} = "yes" ; # VMBGP2
$global{ActionType}{TemperatureMode}{Module}{'20'} = "yes" ; # VMBGP4
$global{ActionType}{TemperatureMode}{Module}{'28'} = "yes" ; # VMBGPOD
$global{ActionType}{TemperatureMode}{Module}{'2D'} = "yes" ; # VMBGP4PIR
$global{ActionType}{TemperatureMode}{Command}{Set} = "DB" ; # &set_temperature_mode
$global{ActionType}{TemperatureMode}{Command}{Set} = "DC" ; # &set_temperature_mode
$global{ActionType}{TemperatureMode}{Command}{Set} = "DD" ; # &set_temperature_mode
$global{ActionType}{TemperatureMode}{Command}{Set} = "DE" ; # &set_temperature_mode

# Switch: touch, input, sensors: &button_pressed
$global{ActionType}{Switch}{Module}{'01'} = "yes" ; # VMB8PB
$global{ActionType}{Switch}{Module}{'05'} = "yes" ; # VMB6IN
$global{ActionType}{Switch}{Module}{'0B'} = "yes" ; # VMB4PD: Push button and timer panel
$global{ActionType}{Switch}{Module}{'16'} = "yes" ; # VMB8PBU
$global{ActionType}{Switch}{Module}{'17'} = "yes" ; # VMB6PBN
$global{ActionType}{Switch}{Module}{'18'} = "yes" ; # VMB2PBN
$global{ActionType}{Switch}{Module}{'1E'} = "yes" ; # VMBGP1
$global{ActionType}{Switch}{Module}{'1F'} = "yes" ; # VMBGP2
$global{ActionType}{Switch}{Module}{'20'} = "yes" ; # VMBGP4
$global{ActionType}{Switch}{Module}{'22'} = "yes" ; # VMB7IN
$global{ActionType}{Switch}{Module}{'28'} = "yes" ; # VMBGPOD
$global{ActionType}{Switch}{Module}{'2A'} = "yes" ; # VMBPIRM: Indoor sensor
$global{ActionType}{Switch}{Module}{'2C'} = "yes" ; # VMBPIRO: Outdoor sensor
$global{ActionType}{Switch}{Module}{'2D'} = "yes" ; # VMBGP4PIR
$global{ActionType}{Switch}{Command}{Set} = "00" ; # button_pressed

# Dimmer: &dim_value
$global{ActionType}{Dimmer}{Module}{'07'} = "yes" ; # VMB1DM
$global{ActionType}{Dimmer}{Module}{'0F'} = "yes" ; # VMB1LED
$global{ActionType}{Dimmer}{Module}{'12'} = "yes" ; # VMB4DC
$global{ActionType}{Dimmer}{Module}{'14'} = "yes" ; # VMBDME
$global{ActionType}{Dimmer}{Module}{'15'} = "yes" ; # VMBDMI
$global{ActionType}{Dimmer}{Command}{Set} = "07" ; # &dim_value

# Blinds: &blind_up, &blind_down, &blind_stop, &blind_pos
$global{ActionType}{Blind}{Module}{'03'} = "yes" ; # VMB1BL
$global{ActionType}{Blind}{Module}{'09'} = "yes" ; # VMB2BL
$global{ActionType}{Blind}{Module}{'1D'} = "yes" ; # VMB2BLE
$global{ActionType}{Blind}{Module}{'2E'} = "yes" ; # VMB1BLS

$global{ActionType}{Blind}{Command}{Stop} = "04" ; # VMB1BL
$global{ActionType}{Blind}{Command}{Up}   = "05" ; # VMB1BL
$global{ActionType}{Blind}{Command}{Down} = "06" ; # VMB1BL
$global{ActionType}{Blind}{Command}{Pos}  = "1C" ; # VMB1BLS

# Relay
$global{ActionType}{Relay}{Module}{'02'} = "yes" ; # VMB1RY
$global{ActionType}{Relay}{Module}{'08'} = "yes" ; # VMB4RY
$global{ActionType}{Relay}{Module}{'10'} = "yes" ; # VMB4RYLD
$global{ActionType}{Relay}{Module}{'11'} = "yes" ; # VMB4RYNO
$global{ActionType}{Relay}{Module}{'1B'} = "yes" ; # VMB1RYNO
$global{ActionType}{Relay}{Module}{'29'} = "yes" ; # VMB1RYNOS

$global{ActionType}{Relay}{Command}{OFF} = "01" ; # &relay_off
$global{ActionType}{Relay}{Command}{ON}  = "02" ; # &relay_on

# SensorNumber
$global{ActionType}{SensorNumber}{Module}{'32'} = "yes" ; # VMB4AN

# Counter
$global{ActionType}{Counter}{Module}{'22'} = "yes" ; # VMB7IN

# Memo
$global{ActionType}{Memo}{Module}{'28'} = "yes" ; # VMBGPOD
$global{ActionType}{Memo}{Command}{Set} = "AC" ; # &send_memo

return 1 ;
