# $global{Cons}{ModuleTypes}{<Module Type>}{Memory}{<MemoryMap Version>}{<Memory address>}{Match}{<counter>}{'%......00'}{Value} = "..." ;
#   We need Value, Channel and SubName

# VMB7IN
$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'1'}{'%......00'}{Value} = "reserved" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'1'}{'%......01'}{Value} = "liter" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'1'}{'%......10'}{Value} = "m3" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'1'}{'%......11'}{Value} = "kWh" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'1'}{'%......[01][01]'}{Channel} = "01" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'1'}{'%......[01][01]'}{SubName} = "Unit" ;

$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'2'}{'%....00..'}{Value} = "reserved" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'2'}{'%....01..'}{Value} = "liter" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'2'}{'%....10..'}{Value} = "m3" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'2'}{'%....11..'}{Value} = "kWh" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'2'}{'%....[01][01]..'}{Channel} = "02" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'2'}{'%....[01][01]..'}{SubName} = "Unit" ;

$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'3'}{'%..00....'}{Value} = "reserved" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'3'}{'%..01....'}{Value} = "liter" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'3'}{'%..10....'}{Value} = "m3" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'3'}{'%..11....'}{Value} = "kWh" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'3'}{'%..[01][01]....'}{Channel} = "03" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'3'}{'%..[01][01]....'}{SubName} = "Unit" ;

$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'4'}{'%00......'}{Value} = "reserved" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'4'}{'%01......'}{Value} = "liter" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'4'}{'%10......'}{Value} = "m3" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'4'}{'%11......'}{Value} = "kWh" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'4'}{'%[01][01]......'}{Channel} = "04" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'03FE'}{Match}{'4'}{'%[01][01]......'}{SubName} = "Unit" ;

# Not used $global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'00E4'}{Match}{'1'}{'%........'}{Value} = "PulsePerUnits" ;
# Not used $global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'00E4'}{Match}{'1'}{'%........'}{SubName} = "Divider" ;
# Not used $global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'00E4'}{Match}{'1'}{'%........'}{Channel} = "01" ;

# Not used $global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'00E9'}{Match}{'1'}{'%........'}{Value} = "PulsePerUnits" ;
# Not used $global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'00E9'}{Match}{'1'}{'%........'}{SubName} = "Divider" ;
# Not used $global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'00E9'}{Match}{'1'}{'%........'}{Channel} = "02" ;

# Not used $global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'00EE'}{Match}{'1'}{'%........'}{Value} = "PulsePerUnits" ;
# Not used $global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'00EE'}{Match}{'1'}{'%........'}{SubName} = "Divider" ;
# Not used $global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'00EE'}{Match}{'1'}{'%........'}{Channel} = "03" ;

# Not used $global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'00F3'}{Match}{'1'}{'%........'}{Value} = "PulsePerUnits" ;
# Not used $global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'00F3'}{Match}{'1'}{'%........'}{SubName} = "Divider" ;
# Not used $global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{Address}{'00F3'}{Match}{'1'}{'%........'}{Channel} = "04" ;

# VMB1TC
$global{Cons}{ModuleTypes}{'0E'}{Memory}{'01'}{ModuleName} = "00F0:00FF" ;
# VMB2BLE
$global{Cons}{ModuleTypes}{'1D'}{Memory}{'01'}{ModuleName} = "004C:008B" ;
# VMB7IN
$global{Cons}{ModuleTypes}{'22'}{Memory}{'03'}{ModuleName} = "03AC:03EB" ;
# VMBGPOD
$global{Cons}{ModuleTypes}{'10'}{Memory}{'01'}{ModuleName} = "09BE:09FD" ;
$global{Cons}{ModuleTypes}{'28'}{Memory}{'01'}{ModuleName} = "09BE:09FD" ;
# VMBPIRC
$global{Cons}{ModuleTypes}{'2B'}{Memory}{'01'}{ModuleName} = "00B0:00EF" ;
# VMBPIRM
$global{Cons}{ModuleTypes}{'2A'}{Memory}{'01'}{ModuleName} = "00B0:00EF" ;
# VMBPIRO
$global{Cons}{ModuleTypes}{'2C'}{Memory}{'01'}{ModuleName} = "00B0:00EF" ;
