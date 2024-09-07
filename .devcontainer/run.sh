#!/bin/bash

# Get the directory of the script
SCRIPT_DIR=$(dirname "$0")
HOST_WORKSPACE_DIR=$(cd "$SCRIPT_DIR/.." && pwd)
WORKSPACE_DIR="/race_stack"

# Parameters for the Docker build
CONTAINER_NAME="race_stack_container"
ROS_DISTRO="humble"
TARGETARCH="$(uname -m)"
REPO_NAME="race_stack"
USERNAME=$(whoami)
HOST_WORKSPACE_FOLDER="$(pwd)"

IMAGE_NAME="$REPO_NAME:$ROS_DISTRO-$TARGETARCH"


# Stop container if it is currently running
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Stopping and removing existing container: $CONTAINER_NAME"
    docker rm -f $CONTAINER_NAME
fi

# Run the Docker container
docker run -it --rm \
  --name $CONTAINER_NAME \
  --privileged \
  --net=host \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /dev/dri:/dev/dri \
  -v $HOME/.ssh:/home/$USERNAME/.ssh \
  -v $HOST_WORKSPACE_DIR:$WORKSPACE_DIR \
  -v /dev/sensors:/dev/sensors \
  -v /dev/input:/dev/input \
  -w $WORKSPACE_DIR \
  $IMAGE_NAME
  
echo "Container started successfully: $CONTAINER_NAME"