# General

The subfunction channel_convert is used to get the correct channel and address.
Input:
  * address
  * channel
  * case

The correct channel depends on the module type and the case for which we need to convert the channel.
Since the scripts have a list of modules per address, the address can be used to find the module type.

The function returns the channel but also the address we need to use.
This is needed for touch panels with multiple addresses where the address that needs to be used can change if the input address and channel is that of one of the sub addresses.

# json syntax
Some module types have a ChannelNumbers configuration:
```
{
    "ModuleTypes": {
        "<ModuleType>": {
            "ChannelNumbers": {
                "<Case>": {
                    "Map": {
                        "<ChannelFrom>": "<ChannelTo>"
                    },
                    "Convert": "hex",
                }
            }
        }
    }
}
```

Some messages have a Convert option:
```
{
    "ModuleTypes": {
        "<ModuleType>": {
            "Messages": {
                "<MessageType>": {
                    "Data>": {
                        "PerMessage": {
                            "Convert": "MemoText",
                        }
                    }
                }
            }
        }
    }
}
```

With possible values for <Case>:
* Name
  * used when message F0/F1/F2 is received
  * these messages contains the channel name
* SensorNumber
  * used when PerMessage :: Convert = SensorNumber or MemoText
* ConvertChannel
  * used when PerByte :: Convert = Channel
* ChannelBitStatus
  * used when PerByte :: Convert = ChannelBitStatus:
* MakeMessage
  * used when we place a message on the bus
* SimulateButtonPressed
  * used when we create a message that simulates a buutton press

# Logic:
* if there is a "Map" for "<Case>" and "<ChannelFrom>" for the module type
  * return "<ChannelTo>"
* if there is a "Convert": "hex" for the module type
  * convert input channel from hex to decimal and return the value
* if <Case> = Name
  * convert input channel from hex to binary and count the 0's after the 1 and return the value
* if <Case> = SensorNumber
  * convert input channel from hex to decimal and return the value
* if <Case> = ChannelBitStatus
  * input channel is already in binary so count the 0's after the 1 and return the value
* if <Case> = ConvertChannel
  * convert input channel from hex to decimal
  * if the address is a sub address, return the master address and add the required offset to the channel
* if <Case> = MakeMessage or SimulateButtonPressed
  * if channel > 24: use the third sub address and decrease the channel with 24
  * if channel > 16: use the second sub address and decrease the channel with 16
  * if channel > 8: use the first sub address and decrease the channel with 8
  * return the channel in hex format
