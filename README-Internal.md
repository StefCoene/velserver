# General
All the information is stored in %global.

- $global{Cons} contains all the fixed data
  - this is defined in the Velbus_data_*.pm files and will never change
- $global{Vars} contains all variabele data
  - this is all the information extracted from the messages

# Parsing messages
We store information about the current message in %message.

- $message{address}: the address of this message.
- $message{MessageType}: the hex code of the message

## Scan message
A Scan message has RTR of 40.

This is saved in the database.

## FF message: answer to a scan
What info do we extract from the message:
- ModuleType: found in message
  - saved in $message{ModuleType}
- SerialLow, SerialHigh, MemoryMap, Buildyear and BuildWeek
   - found in message, but location depends on ModuleType

What information do we need:
- location of SerialLow, SerialHigh, MemoryMap, Buildyear and BuildWeek per ModuleType
  - $global{Cons}{ModuleType}{$message{ModuleType}}{SerialLow}

What do we remember:
- mapping bewtween address and ModuleType: address -> ModuleType
  - $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type} = $message{ModuleType}

## Simple messages
### This is done for all messages:
What info do we extract from the message:
- extract the address from the message
  - if the address is 00, this is a broadcast message and we don't need a ModuleType
  - if the address is not 00, we know the ModuleType (see FF message: answer to a scan)
    - ModuleType can be found in $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type}
- extract the message hex code and search the name of the message
  - search in the list of broadcast messages for a match
  - or search in the list of messages per module type for a match

What information do we need:
- list of broadcast messages with key = message hex code
  - $global{Cons}{MessagesBroadCast}{$message{MessageType}}{Name}
- list of messages per module type with key = message hex code
  - $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Name}

### B0: Module sub type
What info do we extract from the message:
- list of sub addresses
- Thermostat address

What information do we need:
- What sub address is the address for the thermostat:
  - $global{Cons}{ModuleTypes}{$ModuleType}{ThermostatAddr}
  - this is 0 or 3 depending on the type of touch

What do we remember
- $global{Vars}{Modules}{SubAddress}{$SubAddr}{MasterAddress} = $message{address}
  - We need the MasterAddress for a SubAddress
- $global{Vars}{Modules}{SubAddress}{$SubAddr}{ChannelOffset}= $counter * 8
  - We need the ChannelOffset for a SubAddress
- $global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{"SubAddr$counter"} = $SubAddr
  - We need a list of SubAddresses for each MasterAddress

### D8 and B7: Realtime clock update
We just extract the date and time from the message and print it.

### E6: temperature
What info do we extract from the message:
- temperature

What information do we need:
- What channel is the temperature chanel?
  - $global{Cons}{ModuleTypes}{$ModuleType}{TemperatureChannel}

### F0, F1, F2: channel name
What info do we extract from the message:
- channel number
- channel name

What information do we need:
- We need to extract the channel number from the message. There al multiple options:
  - For some messages we simply use a mapping:
    - $global{Cons}{ModuleTypes}{'03'}{ChannelNumbers}{Name}{Map}{'03'}
    - $global{Cons}{ModuleTypes}{'09'}{ChannelNumbers}{Name}{Map}{'03'}
    - $global{Cons}{ModuleTypes}{'09'}{ChannelNumbers}{Name}{Map}{'0C'}
    - $global{Cons}{ModuleTypes}{'2C'}{ChannelNumbers}{Name}{Map}{'01'}
    - $global{Cons}{ModuleGeneral}{Touch124Temperature}{ChannelNumbers}{Name}{Map}{'09'}
    - $global{Cons}{ModuleGeneral}{TouchOTemperature}{ChannelNumbers}{Name}{Map}{'21'}
  - For some we need to convert them as hex:
    - $global{Cons}{ModuleTypes}{'32'}{ChannelNumbers}{Name}{Convert} = "hex" ;
    - $global{Cons}{ModuleGeneral}{Touch1}{ChannelNumbers}{Name}{Convert} = "hex" ;
    - $global{Cons}{ModuleGeneral}{Touch2}{ChannelNumbers}{Name}{Convert} = "hex" ;
    - $global{Cons}{ModuleGeneral}{Touch4}{ChannelNumbers}{Name}{Convert} = "hex" ;
    - $global{Cons}{ModuleGeneral}{TouchO}{ChannelNumbers}{Name}{Convert} = "hex" ;
  - For the others, we convert the bit format to a number by counting the 0's after the 1

### CC: memory
What info do we extract from the message:
- the memory content

What information do we need
- per ModuleType we have list of memory address and what's in the memory address
- we have these type of memory addesses:
  - ModuleName: $global{Cons}{ModuleTypes}{$message{ModuleType}}{Memory}{$MemoryKey}{Address}{$memory}{ModuleName}
  - SensorName: $global{Cons}{ModuleTypes}{$message{ModuleType}}{Memory}{$MemoryKey}{Address}{$memory}{SensorName}
  - Unit: $global{Cons}{ModuleTypes}{$message{ModuleType}}{Memory}{$MemoryKey}{Address}{$memory}{Unit}
- if the address is not 1 of the above types, we may have a memory that we need to match with a regex.
  - Example to match the unit of the counter on channel 01 of a VMB7IN
    - $global{Cons}{ModuleTypes}{'22'}{Memory}{'1'}{Address}{'03FE'}{Match}{'1'}{'%......00'}{Value} = "reserved" ;
    - $global{Cons}{ModuleTypes}{'22'}{Memory}{'1'}{Address}{'03FE'}{Match}{'1'}{'%......01'}{Value} = "liter" ;
    - $global{Cons}{ModuleTypes}{'22'}{Memory}{'1'}{Address}{'03FE'}{Match}{'1'}{'%......10'}{Value} = "m3" ;
    - $global{Cons}{ModuleTypes}{'22'}{Memory}{'1'}{Address}{'03FE'}{Match}{'1'}{'%......11'}{Value} = "kWh" ;
    - $global{Cons}{ModuleTypes}{'22'}{Memory}{'1'}{Address}{'03FE'}{Match}{'1'}{'%......[01][01]'}{Channel} = "01" ;
    - $global{Cons}{ModuleTypes}{'22'}{Memory}{'1'}{Address}{'03FE'}{Match}{'1'}{'%......[01][01]'}{SubName} = "Unit" ;

## Complex messages
The other messages are more complex to parse. How we have to parse them is defined in Velbus_data_protocol_messages.pm.

We either parse the message byte per byte or we parse the message in total:
- $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}{Data}{PerByte}
- $global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}{Data}{PerMessage}

### PerByte
We loop the 8 possible bytes in the message. Only do something if there is something defined for the byte (obviously).

Per byte we can have multiple matches. This can be in binary format or in hex format. This can also be a regex and this is matched to the binary format.
Example:
- $global{Cons}{ModuleTypes}{'07'}{Messages}{'0F'}{Data}{PerByte}{'1'}{Match}

Per match we can have this information if the byte matches:
- Convert: convert the byte to something usefull
  - Channel: calculate channel by counting the 0's after the 1
    - We also take in account the ChannelOffset (this is for touch panels with multiple addresses)
      - $global{Vars}{Modules}{SubAddress}{$address}{ChannelOffset}
    - We also change the address to the MasterAddress
      - $global{Vars}{Modules}{SubAddress}{$address}{MasterAddress}
  - ChannelBitStatus:7 and ChannelBitStatus:8: count 0's after the 1 for the channel number
  - Counter: the byte in hex is the Value, there can multiple bytes so we have to append it to Value
  - Decimal: get the Value by converting the byte to decimal
  - Divider: extract channel and Value from the byte
  - Temperature: calculate temperature from the byte and store as Value
- Value: this can be informational text or the state of the channel (like ON, OFF, ...)
- Channel: the channel number
- Name
- openHAB: do we have to update openHAB

Once all the bytes are processed, we can save the result. We need at least Channel and Value to do somehting usefull with the data.

if openHAB is found, push the stat to openHAB.

### PerMessage
There are only 2 options how to convert the message:
- SensorNumber & MemoText
  - parse all bytes and extract the text
- LightSensor
  - take 2 bytes from the message and convert them to decimal
