#! /bin/bash
# Run the Janus server
# This script is run to start the Docker container that contains the Janus server
# The configuration files for Janus are in the local directory ./etc/janus
# Extra environment parameters are fetched from the file ./env

BASE=$(pwd)

# Update the configuration files with the contents of "./env" and "./secrets".
# Normally, the configuration files are the stock configuration files
#    from the Janus distribution and they are edited by the following
#    script.
# These local configuration files are mounted into the running container.
./updateConfiguration.sh

docker-compose \
    --file docker-compose.yml \
    --env-file ./env \
    --project-name janus-gateway \
    down \
