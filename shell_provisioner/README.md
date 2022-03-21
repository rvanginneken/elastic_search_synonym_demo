# ITR VM

A collection of scripts to ease Vagrant box provisioning using the [shell](https://www.vagrantup.com/docs/provisioning/shell.html) method.

It will install the following on a Debian 11 (Bullseye) Linux VM:

* PHP 8.1
    * Xdebug
    * Composer
    * PHPUnit
* Apache 2.4
* MySQL (Percona) 8.0
* phpMyAdmin 5.1.1
* Node.js 16 + Yarn
* MailHog 1.0.0
* Optional:
    * Blackfire
    * ElasticSearch 7
    * Varnish
    * RabbitMQ 3.7
    * Nuxt SSR with PM2 Process manager

## Extra software/utilities

By default, this VM includes the extras listed above.
In order to enable/install those, just run ```source set_vars.sh``` and ```source /vagrant/shell_provisioner/module/{module}``` and change ```{module}``` with:

    blackfire
    elasticsearch

And uncomment these in ```run.sh``` to install these by default.

Note: not all the scripts are idempotent. Using ```vagrant provision``` will cause problems

## Re-generate certificates

```bash
rm /vagrant/cert.tar
source /vagrant/shell_provisioner/set_vars.sh
bash /vagrant/shell_provisioner/module/cert.sh
```

Note: the certificaat is gesigned by the Intracto CA. By default, this is not trusted by your browser. You can get the root certificate from https://controller.testing.intracto.local/ca/

Add this cert to your browser, eg:

In Firefox = Edit -> Preferences -> Advanced -> Certificates -> View certificates -> Authorities -> Import -> (select cert) -> Trust for identifying websites -> Ok.

In Chrome = Edit -> Preferences -> Settings -> Show advanced -> HTTPS/SSL -> Manage certificates -> Authorities -> Import -> (select cert) -> Trust for identifying websites -> Done.

## Nuxt SSR with PM2 Process manager

Uncomment `nuxt_ssr` to enable the nuxt SSR PM2 module.

The ecosystem.config.js file will be generated in the htdocs/ folder.

After creating your nuxt app, run `yarn build` and `pm2 start` to load the ecosystem.config.js.

Check the status by running `pm2 list` or `pm2 logs`.

More info at [https://pm2.keymetrics.io/](https://pm2.keymetrics.io/)

## Development tools

* phpMyAdmin at [phpmyadmin.elastic-synonym-demo.dev.intracto.com](https://phpmyadmin.elastic-synonym-demo.dev.intracto.com)
    * [Website](https://www.phpmyadmin.net/)
* MailHog at [mails.elastic-synonym-demo.dev.intracto.com](https://mails.elastic-synonym-demo.dev.intracto.com)
    * [Website](https://github.com/mailhog/MailHog)

