#!/bin/bash

# Install Docker if not already installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing Docker..."
    sudo pacman -S docker --noconfirm
fi

# Start Docker service
sudo systemctl start docker

# Pull Ubuntu Docker image
sudo docker pull ubuntu

# Create and start Docker container from Ubuntu image
sudo docker run -it --name ubuntu_ros --privileged ubuntu /bin/bash

# Inside Docker container, install ROS Noetic
docker exec -it ubuntu_ros bash -c 'apt-get update && apt-get install -y gnupg2 && apt-get install -y lsb-release && apt-get install -y software-properties-common && apt-get install -y curl && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - && sh -c "echo \"deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main\" > /etc/apt/sources.list.d/ros1-latest.list" && apt-get update && apt-get install -y ros-noetic-desktop'

# Initialize ROS Noetic environment
docker exec -it ubuntu_ros bash -c 'source /opt/ros/noetic/setup.bash'

# Run ROS Noetic
docker exec -it ubuntu_ros bash -c 'roscore'

