#!/bin/bash

echo "any script you want to run here"

sudo chown vagrant:vagrant /var/www
sudo chown vagrant:vagrant /var/www/html/
sudo chown vagrant:vagrant /var/www/html/* -R

PHP_INFO="<?php phpinfo(); ?>"

echo "$PHP_INFO" > /var/www/html/info.php