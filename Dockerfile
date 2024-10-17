# Container for Janus-gateway for OpenSimulator webrtc voice
#

ARG ARCH=x86_64

# Initially using prebuilt dependencies
# TODO: build own and/or include the building here
FROM shivanshtalwar0/januscoredeps:${ARCH}

ARG BUILD_DATE=YYYYMMDD.HHMM
ARG BUILD_DAY=YYYYMMDD

ARG JANUS_GIT_REPO=https://github.com/meetecho/janus-gateway.git
ARG JANUS_GIT_BRANCH=master
ARG JANUS_BUILD_TARGET=Release

# The container parameters
ARG IMAGE_OWNER=misterblue
ARG IMAGE_NAME=janus-gateway
ARG IMAGE_VERSION=latest
ARG DOCKER_IMAGE="${IMAGE_OWNER}/${IMAGE_NAME}:${IMAGE_VERSION}"

LABEL maintainer="Robert Adams <misterblue@misterblue.com"
LABEL description="Janus Gateway for OpenSimulator Voice"

# Build Janus and initialize configuration
RUN cd ~ \
    && git clone --depth=1 -b $JANUS_GIT_BRANCH --single-branch $JANUS_GIT_REPO janus-gateway \
    && cd janus-gateway \
    && sh autogen.sh \
    && ./configure \
        --prefix=/opt/janus  \
        --disable-rabbitmq \
        --disable-mqtt \
        --disable-linux-sockets \
    && make \
    && make install \
    && make configs

# TODO: Start a new image and install needed libraries and copy Janus binaries

# The configuration directory mounted when run
VOLUME /opt/janus/etc/janus/

# API connections
EXPOSE 7088 8088 8188 8089 7188

# the webrtc streams created
EXPOSE 10000-10200/udp

CMD /opt/janus/bin/janus

