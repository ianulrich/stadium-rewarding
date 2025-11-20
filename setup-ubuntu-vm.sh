#!/bin/bash
set -e

echo "Setting up Ubuntu 22.04 VM (192.168.3.190) with Docker & Docker Compose"

# Update system
sudo apt update && sudo apt upgrade -y

# Install prerequisites
sudo apt install ca-certificates curl gnupg lsb-release -y

# Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine + Compose plugin
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

# Enable Docker and add user to docker group
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

echo ""
echo "Docker installed successfully!"
docker version
docker compose version
echo ""
echo "Log out and back in (or run 'newgrp docker') for permissions to take effect"
echo "Then run: cd ~/stadium-rewarding && docker compose up -d --build"
