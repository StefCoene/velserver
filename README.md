velserver is a set of perl scripts that can be used to monitor the traffic of your velbus installation and send out control messages.

Features:
- written in perl
- daemon to monitor the bus that wil:
   - store all raw messages in mysql
   - store all processed information in perl
- web based service for getting the data and controlling the modules

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
