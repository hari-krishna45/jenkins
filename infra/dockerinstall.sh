#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null
then
    # Docker is not installed, so install it
    echo "Docker is not installed. Installing Docker..."
    sudo apt update
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    # Add Docker repository
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt update
    sudo apt install -y docker-ce
    echo "Docker installed successfully."
else
    echo "Docker is already installed. Skipping installation."
fi
