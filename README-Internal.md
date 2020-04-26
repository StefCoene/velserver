# General
All the information is stored in `%global`.

- `$global{Cons}` contains all the fixed data
  - this is defined in the `Velbus_data_*.pm` files and will never change
- `$global{Vars}` contains all variable data
  - this is all the information extracted from the messages

# Parsing messages
When a message is parsed, the data about the that message is stored in %message:

- `$message{address}`: the address of this message.
- `$message{MessageType}`: the hex code of the message

We also check for correct STX, ETX, Prio and checksum.

Messages are parsed with subfunction process_message in file `lib/Velbus.pm`.

## Scan message
A Scan message has a RTR of 40.

This is saved in the database.

## FF message: answer to a scan
What info do we extract from the message:
- ModuleType: found in message
  - saved in `$message{ModuleType}`
- SerialLow, SerialHigh, MemoryMap, Buildyear and BuildWeek
   - found in message, but location depends on ModuleType

What information do we need:
- location of SerialLow, SerialHigh, MemoryMap, Buildyear and BuildWeek per ModuleType:
  - `$global{Cons}{ModuleTypes}{$message{ModuleType}}{SerialLow}`
  - `$global{Cons}{ModuleTypes}{$message{ModuleType}}{SerialHigh}`
  - `$global{Cons}{ModuleTypes}{$message{ModuleType}}{MemoryMap}`
  - `$global{Cons}{ModuleTypes}{$message{ModuleType}}{Buildyear}`
  - `$global{Cons}{ModuleTypes}{$message{ModuleType}}{BuildWeek}`

What do we remember:
- mapping bewtween address and ModuleType: address -> ModuleType
  - `$global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type}` = `$message{ModuleType}`

## All other message
For all messages, the message hex code is stored in `$message{MessageType}`.

Most of the messages will give some information about channels. This information will be stored in `%ChannelInfo`.
When the message is parsed, the data in `%ChannelInfo` will be processed.

## Simple messages
### This is done for all messages:
What info do we extract from the message:
- Check the address from the message:
  - if the address is 00, this is a broadcast message and we don't have a ModuleType
  - if the address is not 00, we know the ModuleType (see FF message: answer to a scan)
    - ModuleType can be found in `$global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{type}`
- Check for a name for the message based on `$message{MessageType}`:
  - search in the list of broadcast messages for a match
  - or search in the list of messages per ModuleType for a match

What information do we need:
- list of broadcast messages with key = MessageType
  - `$global{Cons}{MessagesBroadCast}{$message{MessageType}}{Name}`
- list of messages per ModuleType with key = MessageType
  - `$global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}}{Name}`

### B0: answer to a scan, contains module sub type
What info do we extract from the message:
- list of SubAddresses if defined
  - this is for touch panels, each page has it's own SubAddress
- Thermostat address if defined
  - this is for touch panels, it's the address used for the Thermostat and it's the last SubAddress for the touch panel

What information do we need:
- What SubAddress is the address for the thermostat:
  - `$global{Cons}{ModuleTypes}{$ModuleType}{ThermostatAddr}`
  - this is 0 or 3 depending on the type of touch panel

What do we remember
- `$global{Vars}{Modules}{SubAddress}{$SubAddr}{MasterAddress}` =` $message{address}`
  - This allows us to find the MasterAddress for a SubAddress
- `$global{Vars}{Modules}{SubAddress}{$SubAddr}{ChannelOffset}` = $counter * 8
  - This is the channel offset for a SubAddress
  - Channel 1 on the first SubAddress is channel 9 on the MasterAddress
- `$global{Vars}{Modules}{Address}{$message{address}}{ModuleInfo}{"SubAddr$counter"}` = `$SubAddr`
  - We need a list of SubAddresses for each MasterAddress

### D8 and B7: Realtime clock update
We extract the date and time from the message and print it.

### E6: temperature
What info do we extract from the message:
- Reported temperature

What information do we need:
- What channel is the temperature chanel for the ModuleType?
  - `$global{Cons}{ModuleTypes}{$ModuleType}{TemperatureChannel}`

### F0, F1, F2: channel name
What info do we extract from the message:
- channel number
- channel name

What information do we need:
- We need to extract the channel number from the message. There al multiple options:
  - For some channels we use a fixed mapping:
    - `$global{Cons}{ModuleTypes}{'03'}{ChannelNumbers}{Name}{Map}{'03'}`
    - `$global{Cons}{ModuleTypes}{'09'}{ChannelNumbers}{Name}{Map}{'03'}`
    - `$global{Cons}{ModuleTypes}{'09'}{ChannelNumbers}{Name}{Map}{'0C'}`
    - `$global{Cons}{ModuleTypes}{'2C'}{ChannelNumbers}{Name}{Map}{'01'}`
    - `$global{Cons}{ModuleGeneral}{Touch124Temperature}{ChannelNumbers}{Name}{Map}{'09'}`
    - `$global{Cons}{ModuleGeneral}{TouchOTemperature}{ChannelNumbers}{Name}{Map}{'21'}`
  - For some we need to convert them as hex:
    - `$global{Cons}{ModuleTypes}{'32'}{ChannelNumbers}{Name}{Convert} = "hex"`
    - `$global{Cons}{ModuleGeneral}{Touch1}{ChannelNumbers}{Name}{Convert} = "hex"`
    - `$global{Cons}{ModuleGeneral}{Touch2}{ChannelNumbers}{Name}{Convert} = "hex"`
    - `$global{Cons}{ModuleGeneral}{Touch4}{ChannelNumbers}{Name}{Convert} = "hex"`
    - `$global{Cons}{ModuleGeneral}{TouchO}{ChannelNumbers}{Name}{Convert} = "hex"`
  - For the others, we convert the bit format to a number by counting the 0's after the 1

### CC: memory
What info do we extract from the message:
- the memory content

What information do we need
- per ModuleType we have list of memory address and what's in the memory address
- we have these type of memory addesses:
  - ModuleName: `$global{Cons}{ModuleTypes}{$message{ModuleType}}{Memory}{$MemoryKey}{Address}{$memory}{ModuleName}`
  - SensorName: `$global{Cons}{ModuleTypes}{$message{ModuleType}}{Memory}{$MemoryKey}{Address}{$memory}{SensorName}`
  - Unit: $global{Cons}{ModuleTypes}{$message{ModuleType}}{Memory}{$MemoryKey}{Address}{$memory}{Unit}
- if the address is not 1 of the above types, we may have a memory that we need to match with a regex.
  - Example to match the unit of the counter on channel 01 of a VMB7IN
    - `$global{Cons}{ModuleTypes}{'22'}{Memory}{'1'}{Address}{'03FE'}{Match}{'1'}{'%......00'}{Value} = "reserved"`
    - `$global{Cons}{ModuleTypes}{'22'}{Memory}{'1'}{Address}{'03FE'}{Match}{'1'}{'%......01'}{Value} = "liter"`
    - `$global{Cons}{ModuleTypes}{'22'}{Memory}{'1'}{Address}{'03FE'}{Match}{'1'}{'%......10'}{Value} = "m3"`
    - `$global{Cons}{ModuleTypes}{'22'}{Memory}{'1'}{Address}{'03FE'}{Match}{'1'}{'%......11'}{Value} = "kWh"`
    - `$global{Cons}{ModuleTypes}{'22'}{Memory}{'1'}{Address}{'03FE'}{Match}{'1'}{'%......[01][01]'}{Channel} = "01"`
    - `$global{Cons}{ModuleTypes}{'22'}{Memory}{'1'}{Address}{'03FE'}{Match}{'1'}{'%......[01][01]'}{SubName} = "Unit"`

## Other messages
To parse the other messages, the content of the message is defined per MessageType and per ModuleType.
This is defined `Velbus_data_protocol_messages.pm`.

We either parse the message byte per byte or we parse the message in total:
- `$global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}{Data}{PerByte}`
- `$global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}{Data}{PerMessage}`

For PerByte it's also possible to have different defintions based on the number of bytes in the message. This is done like this:
- `$global{Cons}{ModuleTypes}{$message{ModuleType}}{Messages}{$message{MessageType}{Data}{PerByte:<number of bytes>}`

### PerByte
We loop the 8 possible bytes in the message. Only do something if there is something defined for the byte (obviously).

Per byte we can have multiple matches. This can be in binary format or in hex format. This can also be a regex and this is matched to the binary format.
Example for ModuleTypes=07, MessageType=07 and byte 1:
- `$global{Cons}{ModuleTypes}{'07'}{Messages}{'0F'}{Data}{PerByte}{'1'}{Match}`

Per match we can have this information:
- Value: this can be informational text or the state of the channel (like ON, OFF, ...)
- Channel: the channel number
- Name
- Convert: convert the byte to something else
  - Channel: calculate channel by counting the 0's after the 1
    - We also take in account the ChannelOffset (this is for touch panels with multiple addresses)
      - `$global{Vars}{Modules}{SubAddress}{$address}{ChannelOffset}`
    - We also change the address to the MasterAddress
      - `$global{Vars}{Modules}{SubAddress}{$address}{MasterAddress}`
  - ChannelBitStatus:7 and ChannelBitStatus:8: the locations of the 1's in the byte in bit determines the channels that are on
  - Counter: the byte in hex is the Value, there can multiple bytes so we have to append them together
  - Decimal: get the Value by converting the byte to decimal
  - Divider: extract Value (first 5 bits) and channel (last 3 bits) from the byte
  - Temperature: calculate temperature from the byte and store as Value
  - openHAB: do we have to update openHAB

Once all the bytes are processed, we can save the result. We need at least Channel and Value to do somehting useful with the data.

If openHAB info is found, push the status to openHAB.

### PerMessage
There are 2 options how to convert the message:
- SensorNumber & MemoText
  - parse all bytes and extract the text
- LightSensor
  - take 2 bytes from the message and convert them to decimal

## Processing %ChannelInfo
This contains all information extracter from the message.
The primary key is the address and the secondary key is the channel:
- `$ChannelInfo{$address}{$Channel}`

Some additional processing is needed for all information found in `$ChannelInfo{$address}{$Channel}`.
We loop the keys in `$ChannelInfo{$address}{$Channel}` as `$Name`:
- `$Name=ThermostatChannel`: calculate the correct channel by using $global{Cons}{ModuleTypes}{$message{ModuleType}}{TemperatureChannel}
- `$Name=CounterHex`: we have a counter and this means we have to update and calculate some extra information:
  - CounterRaw
  - Counter: `$CounterRaw / $ChannelInfo{$address}{$ChannelLoop}{Divider}{Value}`
  - CounterCurrent: calculate difference with previous Counter. This also uses the `$global{Vars}{Modules}{Address}{$message{address}}{ChannelInfo}{$Channel}{Unit}{value}`
  - CounterRaw, Counter and CounterCurrent is pushed to openHAB
- `$Name=SensorType`: this contains the sensortype
- `$Name=Divider,Temperature,ThermostatTarget`
  - Value is pushed to openHAB
- `$ChannelType=ButtonCounter`: do nothing, data is already processed
- `$ChannelType=Dimmer,Blind,SensorNumber,LightSensor,Relay`
  - Value is pushed to openHAB
- `$ChannelType=Button`
  - if `$value=released`: set ON + OFF to openHAB for Button + OFF for ButtonLong
  - if `$value=longpressed`: set ON + OFF to openHAB for ButtonLong
- `$ChannelType=Sensor,ThermostatChannel`
  - Value is pushed to openHAB
