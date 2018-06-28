
Dockerfile for an ardupilot SITL server. Forked shamelessly from https://github.com/gmyoungblood-parc/docker-alpine-ardupilot.git but with significantly different phylosophy.

License is obviously GPLv3 as the original.

The goal of this Dockerfile is that it is possible to just connect to standard ardupilot 5760 port and the for each connection a different SITL simulation will be spawned. When the connection is terminated the SITL simulator is automatically terminated.

I have done this so that I can spin this container in Jenkins and have my tests run against fresh simulators without intervention

# To start the container:
    docker run -i  --name ardupilot --rm airborne/ardupilot:latest

# To connect to it
    telnet <address of your docker> 5760

# Todo
* Be able to select different SITL executables and parameters
* Recycle instance numbers
