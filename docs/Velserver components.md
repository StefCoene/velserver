This describes the components of a velserver setup.

# 1: Physical connection to Velbus installation
A RS232 and/or USB connection is required to connect to a Velbus installation. If you do this on your computer, you can use VelbusLink to configure your Velbus installation.
But the disadvantage of this is that only a single application can do this.

The solution is to use a Velbus TCP server. This is a piece of software that you run on the computer connected with RS323 or USB to your Velbus installation. The benefit is that multiple programs can do this concurrently.
And an other benefit is that you can do this on a computer or Raspberry PI and put it somewhere out of sight and connect to it from anywhere in your network. 

So VelbusLink can use this Velbus TCP server, but velserver can do this too.

See https://github.com/StefCoene/velserver/wiki/TCP-server-for-Velbus for the possibilities.

# 2: Persistent storage
Velserver needs some persistent storage to store information like modules, names, status, ...

## 2a: MySQL database
I recommend using a MySQL database because it's the fastest solution.

## 2b:SQLite
When no MySQL database is available, velserver can use dbi:SQLite to store the information.
This can be an option if you want to run velserver on Windows and you don't want to bother to install a MySQL server on your computer.

This option is slower then using MySQL.
 
# 3: logger.pl
This is a daemon that should be running all the time. It uses the Velbus TCP server to connect to your Velbus installation. It monitors all the messages on the bus.

The message is parsed and processed. Depending on the message, information is forwarded to OpenHAB and/or stored in persistent storage.

# 4: Web service
Velserver provides a web service that can be used to query the status of channels and to send commands to the Velbus installation.

## 4a: apache cgi-bin
You can use apache for the web service by adding a cgi-bin.
This is the fastest option if your server can handle it.
For a PI, 4b is faster because spawning a command on each request is very costly.

## 4b: webserver.pl
This is a daemon that can be run instead of apache. It can be used it you are running velserver on Windows and you don't want to install apache.

# 5: OpenHAB
Velserver is developed for integration with OpenHAB. Velserver can generate the required items file so all channels are known to OpenHAB.
Messages on the Velbus installation that are changes are forwarded to the corresponding OpenHAB items in real time via the OpenHAB REST API.
