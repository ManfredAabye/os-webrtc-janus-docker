# os-webrtc-janus-docker

This project is for building and running a [Janus-Gateway] service for
supporting WebRTC based voice in [OpenSimulator]. This is used
in conjunction with [os-webrtc-janus] which is an addon-module for
[OpenSimulator].

This project builds a [Docker] image of [Janus-Gateway] with configuration
scripts for easy setup when used with [os-webrtc-janus].

The [Janus-Gateway] image can be run either with the central grid service
(Robust server) or alongside a region simulator for local spatial voice.
See the documentation of [os-webrtc-janus] for details on [OpenSimulator]
configuration.

Since [OpenSimulator] has both regional spacial voice and grid-wide
group voice channels, this voice server can be run with the region simulator
as well as with the central grid server. There are thus two possible
setups:

- the central grid service runs a [Janus] server that supports all
    the voice use on the grid;
- a region runs a [Janus] server to provide the local, spatial voice
    for that region.

NOTE: as of Dec 2024, this does not provide spatial voice for [OpenSimulator].
This is a feature that must be added through changes to the
[Janus] service (modify AudioBridge to read the data channel and
change the stereo settings for the channels) and that is a future
project.

Instructions for:

- [Building Docker Image](#Building)
- [Configuration](#Configuration)
- [Running Docker Image on Linux](#Docker_Linux)
- [Running Docker Image on Windows using WSL](#Docker_WSL)

<a id="Building"></a>
## BUILDING

One process is to check the repository out onto the Docker running machine,
edit the `env` and `secrets` files, build the [Janus] image, and then run
it. This creates the Janus Docker image on that machine and then runs
it with your configuration.

Once you have Docker on your Linux system, the steps on Linux are:

```
git clone https://github.com/Misterblue/os-webrtc-janus-docker
cd os-webrtc-janus-docker
# Edit "secrets" with API keys
./build-janus.sh
./run-janus.sh
```

`build-janus.sh` builds the local Docker image and
`run-janus.sh` configures the configuration file and runs
the Docker image.

For building on Windows, there have been some attempts to build
on Windows but [Janus] have many, many package dependencies
and those attempts have not been smooth.
The best bet is to use Windows System for Linux (WSL)
which is a standard Microsoft addition to Windows.
See below for some instructions on WSL.

The scripts build only for architecture "X86_64".
If you have success building for other architectures, please
submit an issue or pull request so your solution can be
integrated.

<a id="Configuration"></a>
## CONFIGURATION

There are two files, `env` and `secrets` that contain all the usual
configuration settings. The `etc/janus` directory has all the unmodified [Janus]
configuration files from the distribution. When `run-janus.sh` is 
run, it updates values in the configuration files based on the
values in `env` and `secrets`. You can update the [Janus] configuration
files manually.

#### OPENSIMULATOR CONFIGURATION

[OpenSimulator] uses the [Janus] API so the Janus configuration just
needs the API passwords set. Set the same passwords in both
the Janus `secrets` file and in the INI configuration files on the
region/grid server.

For instance, on the Janus server, the `secrets` file could be:

```
# Secret parameters for running Janus
# This are usually the access tokens and are merging into the configuration
#     files by the updateConfiguration.sh script.

# THESE ARE SECRETS!!!!
# NEVER, NEVER, NEVER CHECK THEM IN!!!

JS_ADMIN_TOKEN=cde086df-bab3-446d-9af1-50714eacb405
JS_API_TOKEN=63f54171-7f8a-44bb-8f6b-532a0f1c3204
```

And, on [OpenSimulator] server , `bin/config/os-webrtc-janus.ini` could be:

```
[WebRtcVoice]
    Enabled=true
    SpacialVoiceService=WebRtcJanusService.dll:WebRtcJanusService
    NonSpacialVoiceService=WebRtcJanusService.dll:WebRtcJanusService

[JanusWebRtcVoice]
    JanusGatewayURI=http://janus.example.org:14223/voice
    APIToken=cde086df-bab3-446d-9af1-50714eacb405
    JanusGatewayAdminURI=http://janus.example.org:14225/voiceAdmin
    AdminAPIToken=63f54171-7f8a-44bb-8f6b-532a0f1c3204

```

The API tokens are just strings so it can be almost anything. In this
example, I generated unique GUIDs (Linux command `uuidgen`).

See [os-webrtc-janus] for details on the [OpenSimulator] setup.

<a id="Docker_Linux"></a>
## Running Docker Image on Linux

Install the Docker engine on your Linux system. You can use the packaging
system for your Linux or follow the instuctions at
[https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/).

With Docker installed, checkout this repository and build the image.

```
# Clone repository
git clone https://github.com/Misterblue/os-webrtc-janus-docker.git
cd os-webrtc-janus-docker

# Build the Janus-Gateway image
./build-janus.sh
# you can see  the built image with "docker images"

# Edit configuration files
#   "env" probably doesn't need any changes
#   "secrets" needs new API tokens (generate random UUIDs with 'uuidgen')

# Start the Janus image in a new container
./run-janus.sh

```

<a id="Docker_WSL"></a>
## Running Docker Image on Windows using WSL

The Janus Docker image can be run using the Windows Subsystem for Linux (WSL).
This involves installing WSL2 on your Windows System and then either
installing Docker in a WSL2 instance or installing [Docker Desktop].

#### WSL

Microsoft provides instructions for installing and setting up WSL at
[https://learn.microsoft.com/en-us/windows/wsl/setup/environment](https://learn.microsoft.com/en-us/windows/wsl/setup/environment)
I've been using the Ubuntu distributions but you many have other preferences.

In a 'cmd' window:

```
# Install WSL on your Windows system
c:\Users\Me> wsl --install -d Ubuntu-24.04

# Start a Linux image and switch the console to that image (you're now talking to Linux)
c:\Users\Me> ubuntu

# setup initial account info. Follow the prompts.

# Install any updates to the Ubuntu distribution
$ sudo apt-get update && apt-get upgrade -y

# Install Docker on the Ubuntu WSL image
# Instructions at https://docs.docker.com/engine/install/ubuntu/
# Simple install script version:
$ curl -fsSL https://get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh

# Clone repository
$ git clone https://github.com/Misterblue/os-webrtc-janus-docker.git
$ cd os-webrtc-janus-docker

# Build the Janus-Gateway image
$ ./build-janus.sh
# you can see  the built image with "docker images"

# Edit configuration files
#   "env" probably doesn't need any changes
#   "secrets" needs new API tokens (generate random UUIDs with 'uuidgen')

# Start the Janus image in a new container
$ ./run-janus.sh

# Exit this command session. The Janus Docker container will continue running.
$ exit
   
C:\Users\Me>
```

You can see the docker image running with the 'cmd' command `docker ps`.

At any time, you can switch into the Linux image and manage the running
Docker container. The scripts `stop-janus.sh` or `restart-janus.sh`
can be run thusly:

```
c:\Users\Me> ubuntu
$ cd os-webrtc-janus-docker
$ ./stop-janus.sh
$ exit
c:\Users\Me>
```

Lot's of good Docker and Windows information on [Austin Tate's Blog] in
[Windows Subsystem for Linux – LSL – Resources].

#### Docker Desktop

[Docker Desktop] is a user interface and Docker runtime system that uses
WSL to run Docker containers 
It is nice in that it provides a GUI to the underlying Docker system so you
can easily see and manage the images running.
Installing [Docker Desktop] also installs Docker in such a way that the
Docker command line commands are available in 'cmd' windows.

Follow the instructions at
[https://docs.docker.com/desktop/setup/install/windows-install/](https://docs.docker.com/desktop/setup/install/windows-install/)
to download and install Docker Desktop.

Once installed, you can build and run the Janus Docker image as explained above
and then view and control the running container with the Docker Desktop UI.

[Docker]: https://www.docker.com/
[Docker Desktop]: https://docs.docker.com/desktop/
[OpenSimulator]: http://opensimulator.org
[WebRTC]: https://webrtc.org/
[Janus]: https://janus.conf.meetecho.com/
[Janus-Gateway]: https://janus.conf.meetecho.com/
[os-webrtc-janus]: https://github.com/Misterblue/os-webrtc-janus
[Windows Subsystem for Linux – LSL – Resources]: https://blog.inf.ed.ac.uk/atate/2024/12/31/wsl-resources/
[Austin Tate's Blog]: https://blog.inf.ed.ac.uk/atate/
