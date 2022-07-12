#!/bin/bash
./init-instance.sh
# --------- Install gitlab-runner --------- #
sudo apt get-update
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
sudo apt-get install -y gitlab-runner

gitlab-runner -version
sudo gitlab-runner status


