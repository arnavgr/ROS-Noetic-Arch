#!/bin/bash

# Install distrobox if not already installed
if ! command -v distrobox &> /dev/null; then
    echo "distrobox is not installed. Installing distrobox..."
    sudo pacman -S distrobox --noconfirm
fi

# Start distrobox service
sudo systemctl start distrobox

# Create and start Ubuntu container
distrobox create ubuntu
distrobox start ubuntu

# Install ROS Noetic inside the Ubuntu container
distrobox exec ubuntu -- bash -c 'sudo apt update && sudo apt install -y gnupg2 lsb-release software-properties-common curl && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add - && sudo sh -c "echo \"deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main\" > /etc/apt/sources.list.d/ros1-latest.list" && sudo apt update && sudo apt install -y ros-noetic-desktop'

# Initialize ROS Noetic environment
distrobox exec ubuntu -- bash -c 'source /opt/ros/noetic/setup.bash'

# Run ROS Noetic
distrobox exec ubuntu -- bash -c 'roscore'

# Export ROS binaries to current directory on host machine
distrobox export ubuntu --all

echo "ROS Noetic binaries exported to current directory"
