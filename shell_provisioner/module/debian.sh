#!/bin/bash

# Debian

# Locales
sed -i 's/# nl_BE.UTF-8 UTF-8/nl_BE.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
# echo 'LANG=nl_BE.UTF-8' > /etc/default/locale

# Timezone
timedatectl set-timezone Europe/Brussels

# Custom bash prompt
echo "PS1='[\[\033[00;34m\]\u@\h \e[1mDEV\[\033[00m\] \[\033[00;31m\]\w\[\033[00m\]]\n\\$ '" >> /etc/bash.bashrc
echo "PS1='[\[\033[00;34m\]\u@\h \e[1mDEV\[\033[00m\] \[\033[00;31m\]\w\[\033[00m\]]\n\\$ '" >> /home/vagrant/.bashrc

# Console keyboard
sed -i 's/XKBLAYOUT=.*/XKBLAYOUT="be"/' /etc/default/keyboard
setupcon --force

# Host file
cat ${CONFIG_PATH}/hosts.txt >> /etc/hosts

# Enable backports
echo -e "\ndeb http://ftp.de.debian.org/debian $(lsb_release -sc)-backports main" >> /etc/apt/sources.list

# Sync package index files
apt-get update --allow-releaseinfo-change
apt-get install -y apt-transport-https lsb-release ca-certificates gnupg2
apt-get -y upgrade

# Configure motd
cat << EOF >/etc/update-motd.d/50-intracto
#!/bin/bash
cat << EOFF
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Hi iO dev!

 - Documentation at https://confluence.hosted-tools.com/display/HRT/Technology
 - Contact #vagrant on Slack if you need help!

May the source be with you!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EOFF
EOF
chmod a+x /etc/update-motd.d/50-intracto
cat /dev/null > /etc/motd
