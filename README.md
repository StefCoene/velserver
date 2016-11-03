velserver is a set of perl scripts that can be used to monitor the traffic of your velbus installation and send out control messages. This allows you to monitor what's happening on the bys and control the modules.

Velbus is domotica made by Velleman: http://www.velbus.eu/

This code helped me a lot and gave me a big jump start: http://leachy.homeip.net/velbus/

Features:
- written in perl
- daemon to monitor the bus that wil:
   - store all raw messages in mysql
   - store all processed information in perl
- web based service for getting the data in json format and controlling the modules

What works / features:
- trigger a scan on the bus
- discover the modules on the bus caused by a scan
- get a status of the modules and channels, get name of the channels
- put date & time on the bus (handy to sync the clock in case of a power failure and daylight saving time)
- process all messages on the bus
- get status of relays, temperature sensors, dimmers, shutters
- control relays, dimmers shutters
- control heater mode or desired temperature
- webservice for integration with OpenHAB or an other software
- generate velbus file for OpenHAB

TODO:
- upload protocol file + pdf2txt.pl
- document config files
- list modules + what's working
- XML output
- list needed perl modules
- mysql database export
- installation script (needed for library include path)
- OpenHAB sitemap examples
- process counter values
- merge information from http://www.docum.org/drupal/content/velbus-software
