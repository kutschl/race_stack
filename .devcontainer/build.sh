#!/bin/bash

# Get the directory of the script
SCRIPT_DIR=$(dirname "$0")
# Get the parent directory of the script directory
PROJECT_DIR=$(cd "$SCRIPT_DIR/.." && pwd)

# Parameters for the Docker build
USERNAME=$(whoami)
ROS_DISTRO="humble"
REPO_NAME="race_stack"
DOCKER_REPO=""
IMAGE_SUFFIX=""
TARGETARCH=$(uname -m)
USER_UID="${USER_UID:-1000}"
USER_GID="${USER_GID:-$USER_UID}"

if [ "$TARGETARCH" == "aarch64" ] || [ "$TARGETARCH" == "arm64" ]; then
    DOCKER_REPO="arm64v8/ros"
    IMAGE_SUFFIX="-ros-base"
elif [ "$TARGETARCH" == "x86_64" ] || [ "$TARGETARCH" == "amd64" ]; then
    DOCKER_REPO="osrf/ros"
    IMAGE_SUFFIX="-desktop-full"
else
    echo "Unsupported architecture: $TARGETARCH"
    exit 1
fi

# Define the Docker image name
IMAGE_NAME="${REPO_NAME}:${ROS_DISTRO}-${TARGETARCH}"

# Execute the Docker build
docker build \
    --build-arg USERNAME="$USERNAME" \
    --build-arg USER_UID="$USER_UID" \
    --build-arg USER_GID="$USER_GID" \
    --build-arg ROS_DISTRO="$ROS_DISTRO" \
    --build-arg TARGETARCH="$TARGETARCH" \
    --build-arg DOCKER_REPO="$DOCKER_REPO" \
    --build-arg IMAGE_SUFFIX="$IMAGE_SUFFIX" \
    -t $IMAGE_NAME \
    -f Dockerfile .

echo "Docker image $IMAGE_NAME built successfully."