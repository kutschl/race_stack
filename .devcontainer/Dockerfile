ARG DOCKER_REPO="osrf/ros"
ARG ROS_DISTRO="humble"
ARG IMAGE_SUFFIX="-desktop-full"
FROM $DOCKER_REPO:$ROS_DISTRO$IMAGE_SUFFIX
ARG TARGETARCH
ARG USERNAME
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN apt-get update && apt-get upgrade -y 

RUN apt-get install -y \
    python3-pip \
    python-is-python3 \
    ssh \
    neovim \
    git \
    nano \
    build-essential \
    cmake \
    virtualenvwrapper

RUN apt-get install -y \
    ros-$ROS_DISTRO-ackermann-msgs \
    ros-$ROS_DISTRO-urg-node \
    ros-$ROS_DISTRO-joy \
    ros-$ROS_DISTRO-teleop-tools \
    ros-$ROS_DISTRO-serial-driver \
    ros-$ROS_DISTRO-joint-state-publisher \
    ros-$ROS_DISTRO-nav2-lifecycle-manager \
    ros-$ROS_DISTRO-nav2-map-server \
    ros-$ROS_DISTRO-nav2-amcl \
    ros-$ROS_DISTRO-robot-localization \
    ros-$ROS_DISTRO-tf-transformations \
    ros-$ROS_DISTRO-asio-cmake-module

RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir \
    numpy \
    pandas \
    transforms3d \
    opencv-python

# Set the default user
USER $USERNAME
ENV SHELL=/bin/bash
SHELL ["/bin/bash", "-c"] 

# F1TENTH gym
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        source /usr/share/virtualenvwrapper/virtualenvwrapper.sh && \
        mkvirtualenv gym_env && \
        workon gym_env && \
        cd ~ && \
        git clone https://github.com/f1tenth/f1tenth_gym && \
        cd f1tenth_gym && \
        pip install -e . && \
        pip install transforms3d; \
    fi

# Add .local/bin to PATH
RUN echo "export PATH=/home/$USERNAME/.local/bin${PATH:+:${PATH}}" >> /home/$USERNAME/.bashrc

# Source ROS environment automatically
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /home/$USERNAME/.bashrc
RUN echo "source /race_stack/install/setup.bash" >> /home/$USERNAME/.bashrc
RUN echo "source /usr/share/virtualenvwrapper/virtualenvwrapper.sh" >> /home/$USERNAME/.bashrc

CMD ["/bin/bash"]