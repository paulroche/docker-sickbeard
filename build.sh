#!/bin/bash

# grab global vars
source vars

DOCKER=$(which docker)
BUILD_TAG=master

${DOCKER} build -t ${IMAGE_NAME}:${BUILD_TAG} .

${DOCKER} tag ${IMAGE_NAME}:${BUILD_TAG} ${IMAGE_NAME}:latest
