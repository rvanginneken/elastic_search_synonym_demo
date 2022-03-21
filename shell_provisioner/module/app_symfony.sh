#!/bin/bash

# Symfony application

cd /vagrant/htdocs

# Install vendors
composer.phar install

# Download local security checker
wget -qO /vagrant/htdocs/bin/local-php-security-checker https://github.com/fabpot/local-php-security-checker/releases/download/v1.2.0/local-php-security-checker_1.2.0_linux_amd64
chmod +x /vagrant/htdocs/bin/local-php-security-checker