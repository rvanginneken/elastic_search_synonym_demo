#!/bin/bash

# Shopware application

cd /vagrant/htdocs

# Install vendors
composer.phar install

SHOPWARE_APP_SECRET=$(echo aaaabbbbccccddddeeeeffffgggghhhhiiiijjjjkkkkllllmmmmnnnnooooppppqqqqrrrrssssttttuuuuvvvvwwwwxxxxyyyyzzzz00011122233344455566677788889999 | fold -w1 | shuf | tr -d '\n')
SHOPWARE_INSTANCE_ID=$(echo abcdefghijklmnopqrstuvwxyz012345 | fold -w1 | shuf | tr -d '\n')

# Configure system
cat << EOF >.env
SHOPWARE_ES_HOSTS="elasticsearch:9200"
SHOPWARE_ES_ENABLED="0"
SHOPWARE_ES_INDEXING_ENABLED="0"
SHOPWARE_ES_INDEX_PREFIX="sw"
SHOPWARE_HTTP_CACHE_ENABLED="1"
SHOPWARE_HTTP_DEFAULT_TTL="7200"
SHOPWARE_CDN_STRATEGY_DEFAULT="id"
APP_ENV="dev"
APP_URL="https://${APP_DOMAIN}"
APP_SECRET="${SHOPWARE_APP_SECRET}"
INSTANCE_ID="$SHOPWARE_INSTANCE_ID"
DATABASE_URL="mysql://${APP_DBUSER}:${APP_DBPASSWORD}@127.0.0.1:3306/${APP_DBNAME}"
EOF

./bin/console system:install --create-database --basic-setup
./bin/console system:generate-jwt-secret

