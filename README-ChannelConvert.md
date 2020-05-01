# General
The subfunction channel_convert is used to find the channel and address.

Input parameters for the function:
  * address
  * channel
  * case

The function returns the channel but also the address we need to use.
This address is needed for touch panels with multiple addresses where the address that needs to be used can change if the input address and channel is that of one of the sub addresses.

The returned channel depends on the module type and the case for which we need to convert the channel.
Since the scripts have a list of modules per address, the address can be used to find the module type.

# json syntax
See also https://www.docum.org/velserver/?action=ChannelNumbers

Some messages have a Convert option in the PerMessage Data section and some in the PerByte Data section. This determines how we have to convert the content of the message to the correct channel:
```
{
    "ModuleTypes": {
        "<ModuleType>": {
            "Messages": {
                "<MessageType>": {
                    "Data>": {
                        "PerMessage": {
                            "Convert": "SensorNumber or MemoText",
                        }
                        "PerByte": {
                            "<byte>: {
                                "Match" : {
                                    <regexp>"" : {
                                       "Convert" : "Channel or Channel:<number>"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
```

Some modules types contains a special configuration on how we have to find the correct channel. This can be either a Fixed Map or Convert=hex (for now we only have hex as an option but this can change in the future):
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

The function channel_convert can have these values for input **case**:
* **Name**
   * used when message F0/F1/F2 is received (contains the channel name)
* **SensorNumber**
   * used when PerMessage :: Convert = SensorNumber or MemoText
* **Channel**
   * used when PerByte :: Convert = Channel
* **ChannelBitStatus**
   * used when PerByte :: Convert = ChannelBitStatus:
* **MakeMessage**
   * used when we place a message on the bus
* **SimulateButtonPressed**
   * used when we create a message that simulates a button press

# Logic
We have the module type, case and channel. We try to find a match:

1. if there is a "Map" for "case" and "channel" for the module type
   * return "ChannelTo"
1. if there is a "Convert": "hex" for the module type
   * convert input channel from hex to decimal and return the value
1. if input case = Name
   * convert input channel from hex to binary and count the 0's after the 1 and return the value
1. if input case = SensorNumber
   * convert input channel from hex to decimal and return the value
1. if input case = ChannelBitStatus
   * input channel is already in binary so count the 0's after the 1 and return the value
1. if input case = Channel
   * convert input channel from hex to decimal
   * if the address is a sub address, return the master address and add the required offset to the channel
1. if input case = MakeMessage or SimulateButtonPressed
   * if channel > 24: use the third sub address and decrease the channel with 24
   * if channel > 16: use the second sub address and decrease the channel with 16
   * if channel > 8: use the first sub address and decrease the channel with 8
   * return the channel in hex format
