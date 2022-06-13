#!/bin/bash
# ---------- Install Docker ---------- #
sudo apt update
sudo apt remove docker docker-engine docker.io containerd runc
sudo apt install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin
# ----------------- . ---------------- #

sudo systemctl start docker
sudo usermod -aG docker ubuntu