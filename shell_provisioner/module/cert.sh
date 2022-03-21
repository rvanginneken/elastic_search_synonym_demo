#!/bin/bash

# Cert

if [[ ! -f /vagrant/cert.tar ]]; then
    echo -n 'cn=' > /tmp/openssl.payload
    cat ${CONFIG_PATH}/hosts.txt | grep -v '^#' | cut -d' ' -f2 | grep -v '^$' | sed -n '1p' | tr '\n' '&' >> /tmp/openssl.payload
    echo -n 'acn=' >> /tmp/openssl.payload
    cat ${CONFIG_PATH}/hosts.txt | grep -v '^#' | cut -d' ' -f2 | grep -v '^$' | sed -n '1!p' | tr '\n' ' ' >> /tmp/openssl.payload

    curl -X POST -d@/tmp/openssl.payload -k https://controller.testing.intracto.local/ca/createcert.php > /vagrant/cert.tar
fi

tar --no-same-owner -xvf /vagrant/cert.tar
mv ${APP_DOMAIN}.crt /etc/ssl/certs/${APP_DOMAIN}.crt
mv ${APP_DOMAIN}.key /etc/ssl/private/${APP_DOMAIN}.key
mv ${APP_DOMAIN}.all.crt /etc/ssl/certs/${APP_DOMAIN}.all.crt
