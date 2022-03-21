#!/bin/bash

if [[ ! -f /usr/bin/yarn ]]; then
  source ${MODULE_PATH}/node.sh
fi

# Add pm2
yarn global add pm2

# nuxt vhosts
cat ${CONFIG_PATH}/apache/ssr.vhost.conf > /etc/apache2/sites-available/ssr.${APP_DOMAIN}.conf

a2ensite ssr.${APP_DOMAIN}.conf
systemctl restart apache2

# create example ecosystem config file
if [[ ! -f /vagrant/htdocs/ecosystem.config.js ]]; then
mkdir -p /vagrant/htdocs/
touch /vagrant/htdocs/ecosystem.config.js
cat << EOF >/vagrant/htdocs/ecosystem.config.js
module.exports = {
  apps: [
    {
      name: '${JIRACODE}',
      script: 'node_modules/nuxt/bin/nuxt.js',
      args: 'start',
      // Options reference: http://pm2.keymetrics.io/docs/usage/application-declaration/
      autorestart: true,
      watch: false,
      exec_mode: 'cluster', // enables clustering
      instances: 'max', // or an integer
      max_memory_restart: '512M'
    }
  ]
}
EOF
fi
