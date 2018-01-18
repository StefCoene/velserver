# What is velserver?
[Velbus](https://www.velbus.eu/) is domotica hardware build by Velleman, a Belgium company.
It has no built-in option for communication with the rest of the world. You can buy https://www.velbus.eu/products/view?id=409732, but I find it rather expensive.
Luckily the protocol is well documented and publicly available.

So I wrote 'velserver' to monitor the messages on the Velbus bus. I integrated the OpenHAB REST API in my code so changes and updates are forwarded in real time to OpenHAB.
I also wrote a small webservice that can be used by OpenHAB or other software to put commands on the bus.

# Features and other stuff
## How it works
- written in perl
- daemon (logger.pl) that monitors the messages on the bus:
   - all messages are logged in mysql (preferable) or built-in SQLite database (slower)
   - changes are forwarded to openHAB (temperature, buttons, dimmers, relays, counters, ...)
- basic web interface and command line utility line to:
   - scan the bus
   - get status and settings of the connected modules
   - generate OpenHAB items file
   - put current date and time on the bus
- web service
   - used by openHAB (or other software) to poll for the status of channels
   - used by openHAB (or other software) to put commands on the bus to control the module channels
   - this can be implemented as an apache cgi-bin script (preferable) or via a built-in mini webserver

## What works / features:
- trigger a scan of all modules on the bus
- discover the modules on the bus caused by a scan
- get the name of the channels and the modules
- get status of relays, temperature sensors, dimmers, shutters, counters
- put date & time on the bus (handy to sync the clock in case of a power failure or daylight saving time changes)
- process all messages on the bus and push the changes to openHAB via REST API
   - TODO: make list of what's pushed to openHAB
- control relays, dimmers, shutters, heater mode and/or desired temperature
- webservice for integration with openHAB or other software
- generate Velbus items file for openHAB
- auto process the Velbus protocol files and extract the needed information

## TODO:
- in the list of discovered modules: print a warning for not-supported modules, check the firmware level
- document openHAB graphs and other 'nice to know'
- XML output for webservice (currently only json since this works for openHAB)
- installation script (needed for library include path, mysql initialisation)
- merge information from http://www.docum.org/drupal/content/velbus-software
- improve logging
- improve security by running scripts as a non-root user

# Velbus bugs
I found some bugs in the code of Velbus.
- The third part of the name of the second blind channel is not correct, it returns the third part of the name of the first channel. There is a new firmware for this issue.
- Channel names are truncated to 15 characters. There is a new velbuslink software release for this issue.

# Requirements: what do I need?
- Linux server (also tested on Windows), can be a cheap PI
- Working [Velbus](http://www.velbus.eu/) setup
- TCP server for velbus, see https://github.com/StefCoene/velserver/wiki/TCP-server-for-Velbus
- mysql database (optional: you can use built-in SQLite database, but makes the scripts slower)
- apache with perl module (optional: you can use a built-in mini webserver, but that's slower)
- openHAB with the http binding

# Install path
The scripts are developed with `/home/velbus/velserver` as install directory.
If you want to place the scripts somewhere else, you need to update these files and change all occurrences of `/home/velbus/velserver` in the following files:
* `bin/commands.pl`
* `bin/logger.pl`
* `bin/webserver.pl`
* `etc/apache-velserver.conf`
* `www/index.pl`
* `www/service.pl`
