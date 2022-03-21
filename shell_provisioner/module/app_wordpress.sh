#!/bin/bash

# WordPress application

cd /vagrant/htdocs

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Install webpack:
# As the default for bunddling assets or as transpiler.
npm install --global webpack webpack-cli
