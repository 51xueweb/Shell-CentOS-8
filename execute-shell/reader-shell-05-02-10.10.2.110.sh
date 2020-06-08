#!/bin/bash

######################################## File Description ########################################
# Creation time：2020-05-31
# Project：05
# Task: 02
# Execute example：bash record-shell-x-x.sh
# Detailed description：
# About：http://linux.book.51xueweb.cn
##################################################################################################

# reback start
yum remove -y httpd
yum remove -y php php-mysqlnd php-json
yum remove -y wget
# reback end

#***************reader shell start***************

# Apache installation and configuration
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# Complete the installation of PHP and support modules
yum install -y php php-mysqlnd php-json

# Verify that the system environment meets deployment requirements
httpd -v
php -v
mysql --version

# Install wget
yum install -y wget

# Get phpMyAdmin
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-all-languages.tar.gz

# Unzip the phpMyAdmin installer to/var/www directory
yum install -y tar
tar -zxvf phpMyAdmin-5.0.1-all-languages.tar.gz -C /var/www/
cd /var/www/
mv phpMyAdmin-5.0.1-all-languages phpmyadmin

# Set phpmyadmin
chown -R apache:apache /var/www/phpmyadmin

# Configure Apache
sed -i 's/DocumentRoot "\/var\/www\/html"/DocumentRoot "\/var\/www\/phpmyadmin"/g' /etc/httpd/conf/httpd.conf
sed -i 's/<Directory "\/var\/www\/html">/<Directory "\/var\/www\/phpmyadmin">/g' /etc/httpd/conf/httpd.conf
rm -f /etc/httpd/conf.d/welcome.conf
systemctl restart httpd

# Turn off the firewall
systemctl stop firewalld
setenforce 0

#***************reader shell end***************