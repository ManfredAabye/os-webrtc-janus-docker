#! /bin/bash
# Push the local image named "opensim-opensim" to the repository.
# The image tag is set to "latest".

# The repository image name can be over-ridden with the environment variable REPO_IMAGE.

export IMAGE_OWNER=${IMAGE_OWNER:-misterblue}
export IMAGE_NAME=${IMAGE_NAME:-os-webrtc-janus-docker}
export IMAGE_VERSION=${IMAGE_VERSION:-latest}

VERSIONLABEL=$(cat VERSION)

echo "Pushing docker image for opensim version ${VERSIONLABEL}"

for tagg in ${VERSIONLABEL} ${IMAGE_VERSION} ; do
    IMAGE=${IMAGE_OWNER}/${IMAGE_NAME}:${tagg}
    docker tag ${IMAGE_NAME} ${IMAGE}
    echo "   Pushing ${IMAGE}"
    docker push ${IMAGE}
done
