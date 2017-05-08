#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

apt-get install -y apt-transport-https ca-certificates curl software-properties-common
apt-get install python3-pip -y && sudo pip3 install pyyaml
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get -o Dpkg::Options::="--force-confnew" install --force-yes -y docker-ce="${DOCKER_VERSION}"

sudo pip install docker-compose=="${DOCKER_COMPOSE_VERSION}"

docker version

docker-compose version
