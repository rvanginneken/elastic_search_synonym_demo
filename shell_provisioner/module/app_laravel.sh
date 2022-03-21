#!/bin/bash

# Laravel application

composer global require laravel/installer

cd /vagrant/htdocs

composer.phar install

npm install
npm run dev

php artisan config:clear
php artisan storage:link
php artisan migrate