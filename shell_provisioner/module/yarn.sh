#!/bin/bash

# Frontend modules

# Install Yarn first
wget -qO - https://dl.yarnpkg.com/debian/pubkey.gpg | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt-get update
apt-get install -y yarn

# Remove default Node.js dependency
apt-get remove -y nodejs nodejs-doc

# Install correct Node.js version as dependency for Yarn
curl -sL https://deb.nodesource.com/setup_16.x | bash -
apt-get install -y nodejs

# Install module dependencies
apt-get install -y gcc g++ make
