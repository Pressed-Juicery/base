#!/bin/bash

set -e

printf "\n[-] Installing base OS dependencies...\n\n"

apt-get update
apt-get install -y --no-install-recommends \
  build-essential \
  bsdtar \
  bzip2 \
  ca-certificates \
  curl \
  git \
  graphicsmagick \
  graphicsmagick-imagemagick-compat \
  python \
  wget


# Install gosu to build and run the app as a non-root user
# https://github.com/tianon/gosu
dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"

wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"
wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"

export GNUPGHOME="$(mktemp -d)"

gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu

rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc

chmod +x /usr/local/bin/gosu

gosu nobody true

apt-get purge -y --auto-remove wget


# install reaction-cli
printf "\n[-] Installing Reaction CLI...\n\n"
npm i -g reaction-cli
