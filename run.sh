#!/bin/bash

source vars

DOCKER=$(which docker)

# function to check if container is running
function check_container() {
  $DOCKER ps -a --filter "name=${CONTAINER_NAME}" --format "{{.ID}}"
}

# function to start new docker container
function start_container() {
  $DOCKER run --name=${CONTAINER_NAME} ${DOCKER_OPTS} \
              --restart=always                        \
              -p ${PORT}:${PORT}                      \
              --env=SICKBEARD_UID=${SICKBEARD_UID}    \
              --env=SICKBEARD_GID=${SICKBEARD_GID}    \
              --volume=${MEDIA_DIR}:${MEDIA_DIR}:rw   \
              --volume=${DATA_DIR}:${DATA_DIR}:rw     \
              --detach ${IMAGE_NAME}:latest > /dev/null
}

if [ "$(check_container)" != "" ]; then
  $DOCKER rename ${CONTAINER_NAME} "${CONTAINER_NAME}_orig" > /dev/null 2>&1
  $DOCKER stop "${CONTAINER_NAME}_orig" > /dev/null 2>&1
  start_container
    if [ "$(check_container)" != "" ]; then
      $DOCKER rm "${CONTAINER_NAME}_orig" > /dev/null 2>&1
    fi
  $DOCKER rmi $($DOCKER images -q ${IMAGE_NAME}) > /dev/null 2>&1
else
  start_container
fi
