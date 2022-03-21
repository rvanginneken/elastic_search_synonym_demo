#!/bin/bash

# Percona server (MySQL)

# Add repository
wget -q https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb
dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb

apt-get update

# Set version 8.0
percona-release enable-only ps-80

apt-get update

# Install server and client
echo "percona-server-server percona-server-server/data-dir note" | debconf-set-selections
echo "percona-server-server percona-server-server/remove-data-dir boolean false" | debconf-set-selections
echo "percona-server-server percona-server-server/root-pass password vagrant" | debconf-set-selections
echo "percona-server-server percona-server-server/re-root-pass password vagrant" | debconf-set-selections
echo "percona-server-server percona-server-server/default-auth-override select Use Strong Password Encryption (RECOMMENDED)" | debconf-set-selections

apt-get install -y percona-server-server percona-server-client

# Add database (charset/collation default from testing / mysql 8 default)
MYSQLCMD="mysql -uroot -pvagrant -e"
${MYSQLCMD} "CREATE DATABASE ${APP_DBNAME} DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;"
# mysql_native_password because MySQL 8 defaults to caching_sha2_password for passwords which PhpMyAdmin does not support yet
${MYSQLCMD} "CREATE USER ${APP_DBUSER}@localhost IDENTIFIED WITH mysql_native_password BY '${APP_DBPASSWORD}';"
${MYSQLCMD} "GRANT ALL PRIVILEGES ON ${APP_DBNAME}.* TO ${APP_DBUSER}@localhost;"

${MYSQLCMD} "CREATE USER root@'192.168.33.1' IDENTIFIED BY 'vagrant';"
${MYSQLCMD} "GRANT ALL PRIVILEGES ON *.* TO root@'192.168.33.1';"

${MYSQLCMD} "FLUSH PRIVILEGES;"

# Install Percona toolkit and enable functions
${MYSQLCMD} "CREATE FUNCTION fnv1a_64 RETURNS INTEGER SONAME 'libfnv1a_udf.so'"
${MYSQLCMD} "CREATE FUNCTION fnv_64 RETURNS INTEGER SONAME 'libfnv_udf.so'"
${MYSQLCMD} "CREATE FUNCTION murmur_hash RETURNS INTEGER SONAME 'libmurmur_udf.so'"

cat << EOF >>/etc/mysql/mysql.conf.d/mysqld.cnf
# Use mysql_native_password by default
default-authentication-plugin=mysql_native_password
max_allowed_packet=16M
skip-log-bin=yes
EOF

systemctl restart mysql

# Allow root login
cat << EOF >/root/.my.cnf
[client]
host     = localhost
user     = root
password = vagrant
socket   = /var/run/mysqld/mysqld.sock

[mysql_upgrade]
host     = localhost
user     = root
password = vagrant
socket   = /var/run/mysqld/mysqld.sock
basedir  = /usr
EOF

# Install Percona toolkit and xtrabackup
percona-release enable tools

apt-get update

apt-get install -y percona-toolkit percona-xtrabackup-80

