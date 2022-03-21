#!/bin/bash

# RabbitMQ

apt-get install -y rabbitmq-server

# Remove guest user

rabbitmqctl delete_user guest

# Add user

rabbitmqctl add_user ${RABBITMQ_USER} ${RABBITMQ_PASSWORD}
rabbitmqctl set_user_tags ${RABBITMQ_USER} administrator
rabbitmqctl set_permissions -p / ${RABBITMQ_USER} ".*" ".*" ".*"

# Enable admin

rabbitmq-plugins enable rabbitmq_management

wget -qO /usr/local/sbin/rabbitmqadmin http://localhost:15672/cli/rabbitmqadmin
chmod +x /usr/local/sbin/rabbitmqadmin

