# Use the base image that already contains ROS 2 Humble and Ubuntu 22.04
FROM tiryoh/ros2-desktop-vnc

# Install additional dependencies for TurtleBot3 build
RUN apt-get update && apt-get install -y \
    python3-argcomplete \
    python3-colcon-common-extensions \
    libboost-system-dev \
    build-essential \
    libudev-dev \
    && rm -rf /var/lib/apt/lists/*

# Install ROS packages required for TurtleBot3
RUN apt-get update && apt-get install -y \
    ros-humble-hls-lfcd-lds-driver \
    ros-humble-turtlebot3-msgs \
    ros-humble-dynamixel-sdk \
    ros-humble-nav2-* \
    ros-humble-slam-toolbox \
    && rm -rf /var/lib/apt/lists/*
