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

[OpenSimulator] uses the [Janus] API so the Janus configuration just
needs the API passwords set. Just set the same passwords in both
the Janus `secrets` file and in the INI configuration files on the
region/grid server.

For instance, on the Janus server, the `secrets` file could be:

```
# Secret parameters for running Janus
# This are usually the access tokens and are mergeing into the configuration
#     files by the updateConfiguration.sh script.

# THESE ARE SECRETS!!!!
# NEVER, NEVER, NEVER CHECK THEM IN!!!

JS_ADMIN_TOKEN=cde086df-bab3-446d-9af1-50714eacb405
JS_API_TOKEN=63f54171-7f8a-44bb-8f6b-532a0f1c3204
```

And, on a region server, `bin/config/os-webrtc-janus.ini` could be:

```
[WebRtcVoice]
    Enabled=true
    ; Module to use for spacial WebRtcVoice
    SpacialVoiceService=WebRtcJanusService.dll:WebRtcJanusService
    ; Module to use for non-spacial WebRtcVoice
    NonSpacialVoiceService=WebRtcJanusService.dll:WebRtcJanusService
    ; URL for the grid service that is providing the WebRtcVoiceService
    WebRtcVoiceServerURI = ${Const|PrivURL}:${Const|PrivatePort}

[JanusWebRtcVoice]
    JanusGatewayURI=http://janus.example.org:14223/voice
    APIToken=cde086df-bab3-446d-9af1-50714eacb405
    JanusGatewayAdminURI=http://janus.example.org:14225/voiceAdmin
    AdminAPIToken=63f54171-7f8a-44bb-8f6b-532a0f1c3204

```

The API tokens are just strings so it can be most anything. In this
example, I generated unique GUIDs (Linux command `uuidgen`).

See the [os-webrtc-janus] repository instructions for details on
the [OpenSimulator] setup.


[Docker]: https://www.docker.com/
[OpenSimulator]: http://opensimulator.org
[WebRTC]: https://webrtc.org/
[Janus]: https://janus.conf.meetecho.com/
[os-webrtc-janus]: https://github.com/Misterblue/os-webrtc-janus
