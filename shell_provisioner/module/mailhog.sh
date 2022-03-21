#!/bin/bash

# Remove Exim (default Debian)
apt-get purge -y exim4 exim4-base exim4-config exim4-daemon-light

# Postfix
echo "postfix postfix/mailname string ${POSTFIX_HOSTNAME}" | debconf-set-selections
echo "postfix postfix/myhostname string ${POSTFIX_HOSTNAME}" | debconf-set-selections
echo "postfix postfix/destinations string '${POSTFIX_HOSTNAME}, localhost'" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections

apt-get install -y postfix postfix-pcre

cat << EOF >>/etc/postfix/main.cf

relayhost = 127.0.0.1:1025
EOF

# Disable TLS (snakeoil cert)
sed -i 's/smtpd_use_tls=.*/smtpd_use_tls=no/' /etc/postfix/main.cf

systemctl restart postfix

# MailHog

wget -qO /usr/bin/mailhog https://github.com/mailhog/MailHog/releases/download/v1.0.0/MailHog_linux_amd64
chmod +x /usr/bin/mailhog

cat << EOF >/etc/supervisor/conf.d/mailhog.conf
[program:maildev]
command=/usr/bin/mailhog
autostart=true
autorestart=true
stderr_logfile=/var/log/mailhog.err.log
stdout_logfile=/var/log/mailhog.out.log
EOF

systemctl restart supervisor

# Add Apache vhost
a2enmod proxy_wstunnel
cat ${CONFIG_PATH}/apache/mails.vhost.conf > /etc/apache2/sites-available/mails.${APP_DOMAIN}.conf
a2ensite mails.${APP_DOMAIN}
systemctl restart apache2

# Install the mail command (for CLI debugging)
apt-get install -y mailutils
