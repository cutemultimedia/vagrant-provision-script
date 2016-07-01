#!/bin/bash

sudo apt-get install -y apache2


sudo a2enmod rewrite
sudo a2enmod ssl
sudo a2ensite default-ss

apache2 -v