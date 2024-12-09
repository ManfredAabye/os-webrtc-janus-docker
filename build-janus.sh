#! /bin/bash
# Build Janus-gateway Docker image

BUILD_DATE=$(date "+%Y%m%d.%H%M")
BUILD_DAY=$(date "+%Y%m%d")

# The source parameters
JANUS_GIT_REPO=https://github.com/meetecho/janus-gateway.git
JANUS_GIT_BRANCH=master
JANUS_BUILD_TARGET=Release

ARCH=x86_64

# The container parameters
IMAGE_OWNER=misterblue
IMAGE_NAME=os-webrtc-janus-docker
IMAGE_VERSION=latest
DOCKER_IMAGE="${IMAGE_OWNER}/${IMAGE_NAME}:${IMAGE_VERSION}"

docker build \
    --build-arg BUILD_DATE=$BUILD_DATE \
    --build-arg BUILD_DAY=$BUILD_DAY \
    --build-arg JANUS_GIT_REPO=$JANUS_GIT_REPO \
    --build-arg JANUS_GIT_BRANCH=$JANUS_GIT_BRANCH \
    --build-arg JANUS_BUILD_TARGET=$JANUS_BUILD_TARGET \
    --build-arg ARCH=$ARCH \
    --build-arg IMAGE_OWNER=$IMAGE_OWNER \
    --build-arg IMAGE_NAME=$IMAGE_NAME \
    --build-arg IMAGE_VERSION=$IMAGE_VERSION \
    --build-arg DOCKER_IMAGE=$DOCKER_IMAGE \
    -t "$IMAGE_NAME" \
    -f "Dockerfile" \
    .
