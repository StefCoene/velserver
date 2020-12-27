# How to run

* Install docker and docker-compose
* Clone the github repository:
  * `git clone --recurse-submodules https://github.com/StefCoene/velserver.git`
* Copy over the example configuration files:
  * `rm -r velserver/etc`
  * `cp -r velserver/docker-compose/etc/ velserver/etc`
  * Change the host variables in **velserver/docker-compose/docker-compose.yml** 
    * **velbus**: ip of the host that tuns the TCIP velserver software
    * **Openhab**: ip of the host that runs the OpenHAB software
* Optional change the webserver port to an unsed port in **velserver/docker-compose/docker-compose.yml**
  * Example to use port 82: **"82:80"**
* Optional change **TZ** in **velserver/docker/velserver-perl/Dockerfile**
* Go to **velserver/docker-compose** and run `docker-compose up --build`
  * `cd velserver/docker-compose`
  * `docker-compose up --build`
    * This can take a while the first time since it needs to create a base image with some perl modules
* Points your browser to the host and optional the webserver port to see the GUI
