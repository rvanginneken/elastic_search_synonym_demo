#!/bin/bash

# Install Java
apt-get install -y default-jre-headless ca-certificates-java

# Add ElasticSearch key
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add -

# Add Elastic repo
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" > /etc/apt/sources.list.d/elastic.list

# Update sources
apt-get update

# Install ElasticSearch
apt-get install -y elasticsearch

# Lower the amount of RAM needed for ElasticSearch
cat << EOF >>/etc/elasticsearch/jvm.options.d/heap.options
-Xms512m
-Xmx512m
EOF

# ElasticSearch configuration
cat << EOF >>/etc/elasticsearch/elasticsearch.yml

# Configuration set on vagrant provisioning
cluster.name: intracto
node.name: "${ELASTICSEARCH_NODE}"
network.bind_host: 0.0.0.0
network.publish_host: 0.0.0.0
network.host: 0.0.0.0
discovery.seed_hosts: []
discovery.type: single-node
EOF

# Improve performance by setting
#index.number_of_replicas: 0
#index.number_of_shards: 2

# Create and start the service
systemctl enable elasticsearch
systemctl start elasticsearch
