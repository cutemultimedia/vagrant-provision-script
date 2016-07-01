#!/bin/bash

sudo apt-get install -y apache2


sudo a2enmod rewrite
sudo a2enmod ssl

apache2 -v