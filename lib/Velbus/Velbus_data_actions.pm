$global{Cons}{ActionType}{Blind}{Info} = "Reading and controlling the blinds" ;
$global{Cons}{ActionType}{Blind}{Modules} = "03,09,1D,2E" ; # 03=VMB1BL, 09=VMB2BL, 1D=VMB2BLE, 2E=VMB1BLS
$global{Cons}{ActionType}{Blind}{Action}{Get}{Message}  = "EC" ;
$global{Cons}{ActionType}{Blind}{Action}{Get}{openHAB}{ItemIcon}        = "rollershutter" ;
$global{Cons}{ActionType}{Blind}{Action}{Get}{openHAB}{ItemStateFormat} = "[%s %%]" ;
$global{Cons}{ActionType}{Blind}{Action}{Get}{openHAB}{ItemType}        = "Rollershutter" ;
$global{Cons}{ActionType}{Blind}{Action}{Set}{Message} = "" ;
$global{Cons}{ActionType}{Blind}{SetAction}{Down}{Message}     = "06" ;
$global{Cons}{ActionType}{Blind}{SetAction}{Position}{Message} = "1C" ;
$global{Cons}{ActionType}{Blind}{SetAction}{Stop}{Message}     = "04" ;
$global{Cons}{ActionType}{Blind}{SetAction}{Up}{Message}       = "05" ;

$global{Cons}{ActionType}{Button}{Info} = "Reading and simulating a button, input or sensor" ;
$global{Cons}{ActionType}{Button}{Modules} = "01,05,0B,16,17,18,1E,1F,20,21,22,28,2A,2B,2C,2D,34,35,36,37,3A,3B,3C,3D,3E" ; # 01=VMB8PB, 05=VMB6IN, 0B=VMB4PD, 16=VMB8PBU, 17=VMB6PBN, 18=VMB2PBN, 1E=VMBGP1, 1F=VMBGP2, 20=VMBGP4, 21=VMBGPO, 22=VMB7IN, 28=VMBGPOD, 2A=VMBPIRM, 2B=VMBPIR, 2C=VMBPIRO, 2D=VMBGP4PIR, 34= VMBEL1, 35=: VMBEL2, 36=VMBEL4, 37=VMBELO, 3A=VMBGP1-2, 3B=VMBGP2-2, 3C=VMBGP4-2, 3D=VMBGPOD-2, 3E=VMBGP4PIR-2
$global{Cons}{ActionType}{Button}{Action}{Get}{Message}  = "00" ;
$global{Cons}{ActionType}{Button}{Action}{Get}{openHAB}{ItemType} = "Switch" ;
$global{Cons}{ActionType}{Button}{Action}{Set}{Message} = "00" ; # button_pressed

# ButtonLong is the same as Button except for Append2Name
$global{Cons}{ActionType}{ButtonLong}{Info} = "Reading and simulating a button, input or sensor" ;
$global{Cons}{ActionType}{ButtonLong}{Modules} = "01,05,0B,16,17,18,1E,1F,20,22,28,2A,2B,2C,2D" ; # 01=VMB8PB, 05=VMB6IN, 0B=VMB4PD, 16=VMB8PBU, 17=VMB6PBN, 18=VMB2PBN, 1E=VMBGP1, 1F=VMBGP2, 20=VMBGP4, 22=VMB7IN, 28=VMBGPOD, 2A=VMBPIRM, 2C=VMBPIRO, 2D=VMBGP4PIR
$global{Cons}{ActionType}{ButtonLong}{Action}{Get}{Message}  = "00" ;
$global{Cons}{ActionType}{ButtonLong}{Action}{Get}{openHAB}{Append2Name} = "Long" ;
$global{Cons}{ActionType}{ButtonLong}{Action}{Get}{openHAB}{HttpType}    = "Button" ;
$global{Cons}{ActionType}{ButtonLong}{Action}{Get}{openHAB}{ItemType}    = "Switch" ;
$global{Cons}{ActionType}{ButtonLong}{Action}{Set}{Message} = "00" ; # button_pressed

$global{Cons}{ActionType}{Counter}{Info} = "Reading the counter value" ;
$global{Cons}{ActionType}{Counter}{Modules} = "22" ; # 22=VMB7IN
$global{Cons}{ActionType}{Counter}{Action}{Get}{Message}  =  "BE" ;
$global{Cons}{ActionType}{Counter}{Action}{Get}{openHAB}{ItemIcon} = "chart" ;
$global{Cons}{ActionType}{Counter}{Action}{Get}{openHAB}{ItemType} = "Number" ;
$global{Cons}{ActionType}{Counter}{Action}{GetCurrent}{Message}  =  "BE" ;
$global{Cons}{ActionType}{Counter}{Action}{GetCurrent}{openHAB}{ItemIcon} = "chart" ;
$global{Cons}{ActionType}{Counter}{Action}{GetCurrent}{openHAB}{ItemType} = "Number" ;
$global{Cons}{ActionType}{Counter}{Action}{GetCurrent}{openHAB}{Type} = "CounterCurrent" ;
$global{Cons}{ActionType}{Counter}{Action}{GetDivider}{Message}  =  "BE" ;
$global{Cons}{ActionType}{Counter}{Action}{GetDivider}{openHAB}{ItemType} = "Number" ;
$global{Cons}{ActionType}{Counter}{Action}{GetDivider}{openHAB}{Type} = "Divider" ;
$global{Cons}{ActionType}{Counter}{Action}{GetRaw}{Message}  =  "BE" ;
$global{Cons}{ActionType}{Counter}{Action}{GetRaw}{openHAB}{ItemIcon} = "chart" ;
$global{Cons}{ActionType}{Counter}{Action}{GetRaw}{openHAB}{ItemType} = "Number" ;
$global{Cons}{ActionType}{Counter}{Action}{GetRaw}{openHAB}{Type} = "CounterRaw" ;

$global{Cons}{ActionType}{Dimmer}{Info} = "Reading and setting the dim value" ;
$global{Cons}{ActionType}{Dimmer}{Modules} = "07,0F,12,14,15" ; # 07=VMB1DM, 0F=VMB1LED, 12=VMB4DC, 14=VMBDME, 15=VMBDMI
$global{Cons}{ActionType}{Dimmer}{Action}{Get}{Message} = "0F,B8" ; # B8 is for VMB4DC (12): 0/1 to 10V dimmer controller module and VMBDMI-R (15): Velbus dimmer for resistive or inductive load
$global{Cons}{ActionType}{Dimmer}{Action}{Get}{openHAB}{ItemIcon} = "slider" ;
$global{Cons}{ActionType}{Dimmer}{Action}{Get}{openHAB}{ItemStateFormat} = "[%s %%]" ;
$global{Cons}{ActionType}{Dimmer}{Action}{Get}{openHAB}{ItemType} = "Dimmer" ;
$global{Cons}{ActionType}{Dimmer}{Action}{Set}{Message} = "07" ; # &dim_value
$global{Cons}{ActionType}{Memo}{Info} = "Displaying a memo text" ;
$global{Cons}{ActionType}{Memo}{Modules} = "28" ; # VMBGPOD

$global{Cons}{ActionType}{Memo}{Action}{Set}{Message} = "AC" ; # &send_memo

$global{Cons}{ActionType}{Relay}{Info} = "Reading and setting the relay state" ;
$global{Cons}{ActionType}{Relay}{Modules} = "02,08,10,11,1B,29" ; # 02=VMB1RY 08 VMB4RY 10=VMB4RYLD 11=VMB4RYNO 1B=VMB1RYNO 29=VMB1RYNOS
$global{Cons}{ActionType}{Relay}{Action}{Get}{Message} = "FB" ;
$global{Cons}{ActionType}{Relay}{Action}{Get}{openHAB}{ItemIcon} = "switch" ;
$global{Cons}{ActionType}{Relay}{Action}{Get}{openHAB}{ItemType} = "Switch" ;
$global{Cons}{ActionType}{Relay}{Action}{Set}{Message} = "" ;
$global{Cons}{ActionType}{Relay}{SetAction}{OFF}{Message} = "01" ; # &relay_off
$global{Cons}{ActionType}{Relay}{SetAction}{ON}{Message}  = "02" ; # &relay_on

$global{Cons}{ActionType}{Sensor}{Modules} = "2A,2C,2D" ; # 2A=VMBPIRM, 2C=VMBPIRO, 2D=VMBGP4PIR
$global{Cons}{ActionType}{Sensor}{Action}{Get}{Message} = "00" ;
$global{Cons}{ActionType}{Sensor}{Action}{Get}{openHAB}{ItemType} = "Switch" ;

$global{Cons}{ActionType}{SensorNumber}{Info} = "Reading the analog sensor value" ;
$global{Cons}{ActionType}{SensorNumber}{Modules} = "32,31" ; # 32=VMB4AN, 31=VMBMETEO
$global{Cons}{ActionType}{SensorNumber}{Action}{Get}{Message} = "AC" ;
$global{Cons}{ActionType}{SensorNumber}{Action}{Get}{openHAB}{ItemType} = "Number" ;

$global{Cons}{ActionType}{LightSensor}{Info} = "Reading the current light sensor value" ;
$global{Cons}{ActionType}{LightSensor}{Modules} = "2A,2B,2C,2D,3E" ;
$global{Cons}{ActionType}{LightSensor}{Action}{Get}{Message} = "ED" ;
$global{Cons}{ActionType}{LightSensor}{Action}{Get}{openHAB}{ItemType} = "Number" ;
$global{Cons}{ActionType}{LightSensor}{Action}{Get}{openHAB}{ItemStateFormat} = "[%.0f]" ;

$global{Cons}{ActionType}{Temperature}{Info} = "Reading the current temperature sensor" ;
$global{Cons}{ActionType}{Temperature}{Modules} = "1E,1F,20,21,28,2C,2D,31,34,35,36,37,3A,3B,3C,3D,3E" ; # 1E=VMBGP1, 1F=VMBGP2, 20=VMBGP4, 28=VMBGPOD, 2C=VMBPIRO, 2D=VMBGP4PIR
$global{Cons}{ActionType}{Temperature}{Action}{Get}{Message} = "E6" ;
$global{Cons}{ActionType}{Temperature}{Action}{Get}{openHAB}{ItemIcon} = "temperature" ;
$global{Cons}{ActionType}{Temperature}{Action}{Get}{openHAB}{ItemStateFormat} = "[%.1f °C]" ;
$global{Cons}{ActionType}{Temperature}{Action}{Get}{openHAB}{ItemType} = "Number" ;

$global{Cons}{ActionType}{TemperatureCoHeMode}{Info} = "Reading and setting the cooling or heating mode" ;
$global{Cons}{ActionType}{TemperatureCoHeMode}{Modules} = "1E,1F,20,21,28,2D,34,35,36,37,3A,3B,3C,3D,3E" ; # 1E=VMBGP1, 1F=VMBGP2, 20=VMBGP4, 28=VMBGPOD, 2D=VMBGP4PIR
$global{Cons}{ActionType}{TemperatureCoHeMode}{Action}{Get}{Message} = "DF,E0" ;
$global{Cons}{ActionType}{TemperatureCoHeMode}{Action}{Get}{openHAB}{ItemIcon} = "temperature" ;
$global{Cons}{ActionType}{TemperatureCoHeMode}{Action}{Get}{openHAB}{Append2Name} = "Cool/Heat mode" ;
$global{Cons}{ActionType}{TemperatureCoHeMode}{Action}{Get}{openHAB}{ItemType} = "Number" ;
$global{Cons}{ActionType}{TemperatureCoHeMode}{Action}{Set}{Message} = "DF,E0" ; # &set_temperature_cohe_mode

$global{Cons}{ActionType}{TemperatureMode}{Info} = "Reading and setting the temperature mode" ;
$global{Cons}{ActionType}{TemperatureMode}{Modules} = "1E,1F,20,21,28,2D,34,35,36,37,3A,3B,3C,3D,3E" ; # 1E=VMBGP1, 1F=VMBGP2, 20=VMBGP4, 28=VMBGPOD, 2D=VMBGP4PIR
$global{Cons}{ActionType}{TemperatureMode}{Action}{Get}{Message} = "EA" ;
$global{Cons}{ActionType}{TemperatureMode}{Action}{Get}{openHAB}{ItemIcon} = "temperature" ;
$global{Cons}{ActionType}{TemperatureMode}{Action}{Get}{openHAB}{Append2Name} = "mode" ;
$global{Cons}{ActionType}{TemperatureMode}{Action}{Get}{openHAB}{ItemType} = "Number" ;
$global{Cons}{ActionType}{TemperatureMode}{Action}{Set}{Message} = "DB,DC,DD,DE" ; # &set_temperature_mode

$global{Cons}{ActionType}{TemperatureTarget}{Info} = "Reading and setting the target temperature" ;
$global{Cons}{ActionType}{TemperatureTarget}{Modules} = "1E,1F,20,21,28,2D,34,35,36,37,3A,3B,3C,3D,3E" ; # 1E=VMBGP1, 1F=VMBGP2, 20=VMBGP4, 28=VMBGPOD, 2D=VMBGP4PIR
$global{Cons}{ActionType}{TemperatureTarget}{Action}{Get}{Message} = "EA" ;
$global{Cons}{ActionType}{TemperatureTarget}{Action}{Get}{openHAB}{ItemIcon} = "temperature" ;
$global{Cons}{ActionType}{TemperatureTarget}{Action}{Get}{openHAB}{Append2Name} = "temperature target" ;
$global{Cons}{ActionType}{TemperatureTarget}{Action}{Get}{openHAB}{ItemStateFormat} = "[%.1f °C]" ;
$global{Cons}{ActionType}{TemperatureTarget}{Action}{Get}{openHAB}{ItemType} = "Number" ;
$global{Cons}{ActionType}{TemperatureTarget}{Action}{Set}{Message} = "E4" ; # &set_temperature
