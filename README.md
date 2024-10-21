# os-webrtc-janus-docker

Voice for the the [OpenSimulator] family of virtual world simulators requires
a [WebRTC] service to mix and distribute the spacially modified voice streams.

This project is for building and running a [Docker] image to run as a service
with a region simulator and a grid server to supply voice for the space and
groups.

# BUILDING

One process is to check the repository out onto the Docker running machine,
edit the `env` and `secrets` files, build the [Janus] image, and then run
it. This creates the Janus Docker image on that machine and then runs
it with your configuration.

# CONFIGURATION

There are two files, `env` and `secrets` that contain all the usual
configuration settings. The `etc/janus` directory has all the unmodified [Janus]
configuration files from the distribution. When `run-janus.sh` is 
run, it updates values in the configuration files based on the
values in `env` and `secrets`. You can update the [Janus] configuration
files manually.

# OPENSIMULATOR CONFIGURATION

**TODO**


[Docker]: https://www.docker.com/
[OpenSimulator]: http://opensimulator.org
[WebRTC]: https://webrtc.org/
[Janus]: https://janus.conf.meetecho.com/
