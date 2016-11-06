# velserver
velserver is a set of perl scripts that can be used to monitor the traffic of your velbus installation and send out control messages. This allows you to monitor what's happening on the bus and control the modules.

Velbus is domotica made by the Belgium company Velleman: http://www.velbus.eu/

Velbus has no native external interface. You can buy a 'Home Center' (http://homecenter.be/), but I prefer openHAB.
The main goal of velserver is to integrate the velbus domotica with http://www.openhab.org/, but it's not that hard to change the code so integration with other products is possible.

Voor wie deze zin verstaat, ikzelf woon in Vlaanderen. Je kan me dus ook vragen in het Nederlands stellen.

This code helped me a lot and gave me a big jump start: http://leachy.homeip.net/velbus/

This code is not finished. It does the basic stuff, but I'm constantly updating it.

# Features and other stuff
## Features:
- written in perl
- daemon to monitor the bus that wil:
   - store all raw messages in mysql
   - store all processed information in perl
- web based service for getting the data in json format and controlling the modules

## What works / features:
- trigger a scan on the bus
- discover the modules on the bus caused by a scan
- get a status of the modules and channels, get name of the channels
- put date & time on the bus (handy to sync the clock in case of a power failure and daylight saving time)
- process all messages on the bus
- get status of relays, temperature sensors, dimmers, shutters
- control relays, dimmers shutters
- control heater mode or desired temperature
- webservice for integration with openHAB or an other software
- generate velbus file for openHAB
- auto process the velbus protocol file and extract the needed information

## TODO:
- upload protocol files + pdf2txt.pl
- document config files
- list modules + what's working
- XML output
- list needed perl modules
- mysql database export
- installation script (needed for library include path)
- openHAB sitemap examples
- process counter values
- merge information from http://www.docum.org/drupal/content/velbus-software
- install instructions

## DONE
- can https://github.com/openhab/openhab/wiki/MQTT-Binding be used so the logger can push changes?
   - not needed: solved by using the openHAB REST API

# Bugs
I found some bugs in the code of velbus.
The third part of the name of the second blind channel is not correct, it returns the third part of the name of the first channel.

# Documentation
## logger.pl
This is the basic daemon that should be running all the time.
I run it from screen so it runs in the background, but I can reconnect to the screen session to see what's happening.

## commands.pl
This is can be used to send commands to the bus.
I use it for testing, but it can also used to trigger a scan or send the current date and time to the modules on the bus.

## pdf2txt.pl
This script reads the velbus protocol pdf files and extract all the information regarding the available commands.
