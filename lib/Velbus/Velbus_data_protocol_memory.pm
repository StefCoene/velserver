# This files contains all information needed when reading the memory of the modules.
# Some information like the name of the module can only be found by reading the memory.
# For some modules, different memory addresses are needed depending on the build of the module.
# The Memory Map Version is either detected when scanning for modules or it's based on the Build version.

# VMB1TC
$global{Cons}{ModuleTypes}{'0E'}{MemoryMatch}{1}{Build}   = ">= 1" ;
$global{Cons}{ModuleTypes}{'0E'}{MemoryMatch}{1}{Version} = "1" ;
$global{Cons}{ModuleTypes}{'0E'}{Memory}{1}{ModuleName} = "00F0-00FF" ;

# VMB1TS
$global{Cons}{ModuleTypes}{'0C'}{MemoryMatch}{1}{Build}   = ">= 1" ;
$global{Cons}{ModuleTypes}{'0C'}{MemoryMatch}{1}{Version} = "1" ;
$global{Cons}{ModuleTypes}{'0C'}{Memory}{1}{ModuleName} = "00F0-00FF" ;

# VMB4RYLD
$global{Cons}{ModuleTypes}{'10'}{Memory}{'01'}{ModuleName} = "00E3-00EF;01E3-01EF;02E3-02EF;03E3-03EF;04E3-04EE" ;

# VMB4RYNO
$global{Cons}{ModuleTypes}{'11'}{Memory}{'01'}{ModuleName} = "00E3-00EF;01E3-01EF;02E3-02EF;03E3-03EF;04E3-04EE" ;

# VMB4DC
$global{Cons}{ModuleTypes}{'12'}{Memory}{'03'}{ModuleName} = "00E0-00EF;01E0-01EF" ;

# VMBDMI
$global{Cons}{ModuleTypes}{'15'}{MemoryMatch}{1}{Build}   = "< 1410" ;
$global{Cons}{ModuleTypes}{'15'}{MemoryMatch}{1}{Version} = "0" ;
$global{Cons}{ModuleTypes}{'15'}{MemoryMatch}{2}{Build}   = ">= 1410" ;
$global{Cons}{ModuleTypes}{'15'}{MemoryMatch}{2}{Version} = "1" ;
$global{Cons}{ModuleTypes}{'15'}{Memory}{1}{ModuleName} = "00B0-00EF" ;

# VMB8PBU
$global{Cons}{ModuleTypes}{'16'}{MemoryMatch}{1}{Build}   = ">= 1409" ;
$global{Cons}{ModuleTypes}{'16'}{MemoryMatch}{1}{Version} = "1" ;
$global{Cons}{ModuleTypes}{'16'}{Memory}{1}{ModuleName} = "03C0-03FF" ;

# VMB6PBN
$global{Cons}{ModuleTypes}{'17'}{MemoryMatch}{1}{Build}   = ">= 1409" ;
$global{Cons}{ModuleTypes}{'17'}{MemoryMatch}{1}{Version} = "1" ;
$global{Cons}{ModuleTypes}{'17'}{Memory}{1}{ModuleName} = "03C0-03FF" ;

# VMB2PBN
$global{Cons}{ModuleTypes}{'18'}{MemoryMatch}{1}{Build}   = ">= 1409" ;
$global{Cons}{ModuleTypes}{'18'}{MemoryMatch}{1}{Version} = "1" ;
$global{Cons}{ModuleTypes}{'18'}{Memory}{1}{ModuleName} = "03C0-03FF" ;

# VMB2BLE
$global{Cons}{ModuleTypes}{'1D'}{Memory}{'00'}{ModuleName} = "004C-008B" ;

# VMBGP1D
$global{Cons}{ModuleTypes}{'1E'}{Memory}{'01'}{ModuleName} = "03C0-03FF" ;

# VMBGP2D
$global{Cons}{ModuleTypes}{'1F'}{Memory}{'01'}{ModuleName} = "03C0-03FF" ;

# VMBGP4D
$global{Cons}{ModuleTypes}{'20'}{Memory}{'01'}{ModuleName} = "03C0-03FF" ;

# VMB7IN
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{ModuleName} = "03AC-03EB" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'1'}{'%......00'}{Value} = "reserved" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'1'}{'%......01'}{Value} = "liter" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'1'}{'%......10'}{Value} = "m3" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'1'}{'%......11'}{Value} = "kWh" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'1'}{'%......[01][01]'}{Channel} = "01" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'1'}{'%......[01][01]'}{SubName} = "Unit" ;

$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'2'}{'%....00..'}{Value} = "reserved" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'2'}{'%....01..'}{Value} = "liter" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'2'}{'%....10..'}{Value} = "m3" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'2'}{'%....11..'}{Value} = "kWh" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'2'}{'%....[01][01]..'}{Channel} = "02" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'2'}{'%....[01][01]..'}{SubName} = "Unit" ;

$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'3'}{'%..00....'}{Value} = "reserved" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'3'}{'%..01....'}{Value} = "liter" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'3'}{'%..10....'}{Value} = "m3" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'3'}{'%..11....'}{Value} = "kWh" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'3'}{'%..[01][01]....'}{Channel} = "03" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'3'}{'%..[01][01]....'}{SubName} = "Unit" ;

$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'4'}{'%00......'}{Value} = "reserved" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'4'}{'%01......'}{Value} = "liter" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'4'}{'%10......'}{Value} = "m3" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'4'}{'%11......'}{Value} = "kWh" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'4'}{'%[01][01]......'}{Channel} = "04" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'03FE'}{Match}{'4'}{'%[01][01]......'}{SubName} = "Unit" ;

$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'00E4'}{Match}{'1'}{'%........'}{Value} = "PulsePerUnits" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'00E4'}{Match}{'1'}{'%........'}{SubName} = "Divider" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'00E4'}{Match}{'1'}{'%........'}{Channel} = "01" ;

$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'00E9'}{Match}{'1'}{'%........'}{Value} = "PulsePerUnits" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'00E9'}{Match}{'1'}{'%........'}{SubName} = "Divider" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'00E9'}{Match}{'1'}{'%........'}{Channel} = "02" ;

$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'00EE'}{Match}{'1'}{'%........'}{Value} = "PulsePerUnits" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'00EE'}{Match}{'1'}{'%........'}{SubName} = "Divider" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'00EE'}{Match}{'1'}{'%........'}{Channel} = "03" ;

$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'00F3'}{Match}{'1'}{'%........'}{Value} = "PulsePerUnits" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'00F3'}{Match}{'1'}{'%........'}{SubName} = "Divider" ;
$global{Cons}{ModuleTypes}{'22'}{Memory}{'00'}{Address}{'00F3'}{Match}{'1'}{'%........'}{Channel} = "04" ;

# VMBGPOD
$global{Cons}{ModuleTypes}{'28'}{Memory}{'01'}{ModuleName} = "09BE-09FD" ;

# VMB1RYNOS
$global{Cons}{ModuleTypes}{'29'}{MemoryMatch}{1}{Build}   = ">= 1" ;
$global{Cons}{ModuleTypes}{'29'}{MemoryMatch}{1}{Version} = "1" ;
$global{Cons}{ModuleTypes}{'29'}{Memory}{1}{ModuleName} = "00E3-00EF;01E3-01EF;02E3-02EF;03E3-03EF;04E3-04EE" ;

# VMB1BLS
$global{Cons}{ModuleTypes}{'29'}{MemoryMatch}{1}{Build}   = ">= 1" ;
$global{Cons}{ModuleTypes}{'29'}{MemoryMatch}{1}{Version} = "1" ;
$global{Cons}{ModuleTypes}{'29'}{Memory}{1}{ModuleName} = "00E3-00EF;01E3-01EF;02E3-02EF;03E3-03EF;04E3-04EE" ;

# VMBPIRM
$global{Cons}{ModuleTypes}{'2A'}{Memory}{'01'}{ModuleName} = "00B0-00EF" ;

# VMBPIRC
$global{Cons}{ModuleTypes}{'2B'}{MemoryMatch}{1}{Build}   = ">= 1" ;
$global{Cons}{ModuleTypes}{'2B'}{MemoryMatch}{1}{Version} = "1" ;
$global{Cons}{ModuleTypes}{'2B'}{Memory}{1}{ModuleName} = "00B0-00EF" ;

# VMBPIRO
$global{Cons}{ModuleTypes}{'2C'}{Memory}{'00'}{ModuleName} = "00B0-00EF" ;
$global{Cons}{ModuleTypes}{'2C'}{Memory}{'00'}{SensorName} = "0080-008F" ;
$global{Cons}{ModuleTypes}{'2C'}{Memory}{'00'}{SensorChannel} = "09" ; # Temperature sensor is CH9

# VMB1BLS
$global{Cons}{ModuleTypes}{'2E'}{MemoryMatch}{1}{Build}   = ">= 1" ;
$global{Cons}{ModuleTypes}{'2E'}{MemoryMatch}{1}{Version} = "1" ;
$global{Cons}{ModuleTypes}{'2E'}{Memory}{1}{ModuleName} = "004C-008B" ;

# VMB4AN
$global{Cons}{ModuleTypes}{'32'}{MemoryMatch}{1}{Build}   = "== 1818" ;
$global{Cons}{ModuleTypes}{'32'}{MemoryMatch}{1}{Version} = "1" ;
$global{Cons}{ModuleTypes}{'32'}{Memory}{1}{ModuleName} = "0000-003F" ;
