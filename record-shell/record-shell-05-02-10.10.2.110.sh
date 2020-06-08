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

#***************record shell start***************
echo "[root@Project-05-Task-01 ~]# clear"
sleep 3s
clear 

echo -e "---------------Apache Install and configure---------------\n"
sleep 5s

echo "[root@Project-05-Task-01 ~]# yum install -y httpd"
sleep 3s
yum install -y httpd
sleep 3s

echo "[root@Project-05-Task-01 ~]# clear"
sleep 3s
clear 

echo -e "---------------Start Apache---------------\n"
sleep 5s

echo "[root@Project-05-Task-01 ~]# systemctl start httpd"
sleep 3s
systemctl start httpd
sleep 3s

echo "[root@Project-05-Task-01 ~]# systemctl enable httpd"
sleep 3s
systemctl enable httpd
sleep 3s

echo "[root@Project-05-Task-01 ~]# clear"
sleep 3s
clear 

echo -e "---------------PHP Installation of modules---------------\n"
sleep 5s

# Complete the installation of PHP and support modules
echo "[root@Project-05-Task-01 ~]# yum install -y php php-mysqlnd php-json"
sleep 3s
yum install -y php php-mysqlnd php-json
sleep 3s

echo "[root@Project-05-Task-01 ~]# clear"
sleep 3s
clear 

# Verify that the system environment meets deployment requirements
echo -e "---------------Verify the system environment---------------\n"
sleep 5s

echo "[root@Project-05-Task-01 ~]# httpd -v"
sleep 3s
httpd -v
sleep 3s

echo "[root@Project-05-Task-01 ~]# php -v"
sleep 3s
php -v
sleep 3s

echo "[root@Project-05-Task-01 ~]# mysql --version"
sleep 3s
mysql --version
sleep 3s

echo "[root@Project-05-Task-01 ~]# clear"
sleep 3s
clear 

# Install wget
echo -e "---------------Install Wget---------------\n"
sleep 5s

echo "[root@Project-05-Task-01 ~]# yum install -y wget"
sleep 3s
yum install -y wget
sleep 3s

echo "[root@Project-05-Task-01 ~]# clear"
sleep 3s
clear 

# Get phpMyAdmin
echo -e "---------------Get phpMyAdmin---------------\n"
sleep 5s

echo "[root@Project-05-Task-01 ~]# wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-all-languages.tar.gz"
sleep 3s
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-all-languages.tar.gz
sleep 3s

echo "[root@Project-05-Task-01 ~]# clear"
sleep 3s
clear 

# Unzip the phpMyAdmin installer to/var/www directory
echo -e "---------------phpMyAdmin installer unzips to/var/www directory---------------\n"
sleep 5s

echo "[root@Project-05-Task-01 ~]# tar -zxvf phpMyAdmin-5.0.1-all-languages.tar.gz -C /var/www/"
sleep 3s
tar -zxvf phpMyAdmin-5.0.1-all-languages.tar.gz -C /var/www/
sleep 3s

echo "[root@Project-05-Task-01 ~]# clear"
sleep 3s
clear 

echo -e "---------------Unzip the phpMyAdmin installer to/var/www directory---------------\n"
sleep 5s

echo "[root@Project-05-Task-01 ~]# cd /var/www/"
sleep 3s
cd /var/www/
sleep 3s

echo "[root@Project-05-Task-01 ~]# mv phpMyAdmin-5.0.1-all-languages phpmyadmin"
sleep 3s
mv phpMyAdmin-5.0.1-all-languages phpmyadmin
sleep 3s

echo "[root@Project-05-Task-01 ~]# chown -R apache:apache /var/www/phpmyadmin"
sleep 3s

# Set the phpmyadmin directory to belong to the user and group are apache
chown -R apache:apache /var/www/phpmyadmin
sleep 3s

echo "[root@Project-05-Task-01 ~]# sed -i 's/DocumentRoot "\/var\/www\/html"/DocumentRoot "\/var\/www\/phpmyadmin"/g' /etc/httpd/conf/httpd.conf"
sleep 3s

# Configure Apache publishing sites
sed -i 's/DocumentRoot "\/var\/www\/html"/DocumentRoot "\/var\/www\/phpmyadmin"/g' /etc/httpd/conf/httpd.conf
sleep 3s

echo "[root@Project-05-Task-01 ~]# sed -i 's/<Directory "\/var\/www\/html">/<Directory "\/var\/www\/phpmyadmin">/g' /etc/httpd/conf/httpd.conf"
sleep 3s
sed -i 's/<Directory "\/var\/www\/html">/<Directory "\/var\/www\/phpmyadmin">/g' /etc/httpd/conf/httpd.conf
sleep 3s

echo "[root@Project-05-Task-01 ~]# rm -f /etc/httpd/conf.d/welcome.conf"
sleep 3s
rm -f /etc/httpd/conf.d/welcome.conf
sleep 3s

echo "[root@Project-05-Task-01 ~]# systemctl restart httpd"
sleep 3s
systemctl restart httpd
sleep 3s

# Turn off the firewall
echo "[root@Project-05-Task-01 ~]# systemctl stop firewalld"
sleep 3s
systemctl stop firewalld
sleep 3s

echo "[root@Project-05-Task-01 ~]# setenforce 0"
sleep 3s
setenforce 0
sleep 3s

echo "[root@Project-05-Task-01 ~]# clear"
sleep 3s
clear 

#***************record shell end***************
