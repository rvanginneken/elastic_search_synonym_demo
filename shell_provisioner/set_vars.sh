#!/bin/bash

# Set provisioning variables

export MODULE_PATH='/vagrant/shell_provisioner/module'
export CONFIG_PATH='/vagrant/shell_provisioner/config'

# IP for the vagrant VM
export GUEST_IP='192.168.33.211'

# Set the variables below for your project

export JIRACODE='elastic-synonym-demo'

# Set to your app's local domainname
export APP_DOMAIN="${JIRACODE}.dev.intracto.com"

# Modify config/apache/app.vhost.conf and config/apache/hosts.txt to use the
# values for APP_DOMAIN and GUEST_IP set above

# App DB name and credentials
export APP_DBNAME="${JIRACODE}"
export APP_DBUSER="${JIRACODE}"
export APP_DBPASSWORD="${JIRACODE}"

# Hostname used by postfix
export POSTFIX_HOSTNAME='vagrantbox.dev.intracto.com'

# ElasticSearch nodes
export ELASTICSEARCH_NODE="${JIRACODE}"

# RabbitMQ
export RABBITMQ_USER="${JIRACODE}"
export RABBITMQ_PASSWORD="${JIRACODE}"
