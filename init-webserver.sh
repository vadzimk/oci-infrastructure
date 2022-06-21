#!/bin/bash

# --------- Create 8G Swap file --------- #
sudo swapoff /swapfile
sudo fallocate -l 8G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon --show
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# ---------- Install Docker ---------- #
sudo apt update
sudo apt remove -y docker docker-engine docker.io containerd runc
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common


sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg


echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-cache policy docker-ce
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose

# ----------- Start docker ----------- #

sudo systemctl start docker
sudo usermod -aG docker ubuntu
newgrp - docker