#!/bin/bash

######################################## File Description ########################################
# Creation time：2020-05-31
# Project：05
# Task: 04-2
# Execute example：bash reader-shell-x-x.sh
# Detailed description：
# About：http://linux.book.51xueweb.cn
##################################################################################################

# reback start 
yum remove MariaDB-server -y
# reback end

#***************reader shell start***************

# Create a YUM source file
touch /etc/yum.repos.d/MariaDB.repo

# Write MariaDB YUM source configuration information to a file
echo [mariadb] > /etc/yum.repos.d/MariaDB.repo
echo name = MariaDB >> /etc/yum.repos.d/MariaDB.repo
echo baseurl = https://mirrors.aliyun.com/mariadb/yum/10.4/centos8-amd64 >> /etc/yum.repos.d/MariaDB.repo
echo module_hotfixes=1 >> /etc/yum.repos.d/MariaDB.repo
echo gpgkey= https://mirrors.aliyun.com/mariadb/yum/RPM-GPG-KEY-MariaDB >> /etc/yum.repos.d/MariaDB.repo
echo gpgcheck=1 >> /etc/yum.repos.d/MariaDB.repo

# Install MariaDB
yum install MariaDB-server -y

# Start mariadb
systemctl start mariadb

# Look MariaDB
systemctl status mariadb | head  -10

# Configure the mariadb service as A boot-on
systemctl enable mariadb

# Verify that the mariadb service is boot-on
systemctl is-enabled mariadb
systemctl stop firewalld
setenforce 0

# Configure the first database server as the primary node
echo [mariadb] >> /etc/my.cnf
echo log-bin >> /etc/my.cnf
echo server_id=2 >> /etc/my.cnf

# Restart mariadb
systemctl restart mariadb
read -p "Please enter the server-1 IP address:" server1_ip
read -p "Please enter the File value:" log_file
read -p "Please enter the Position value:" log_position

# Set the option to connect the primary server from the server
mysql -e "CHANGE MASTER TO
MASTER_HOST='$server1_ip',
MASTER_USER='replication_user',
MASTER_PASSWORD='centos@mariadb#123',
MASTER_PORT=3306,
MASTER_LOG_FILE='$log_file',
MASTER_LOG_POS=$log_position,
MASTER_CONNECT_RETRY=10;"

# Start replication
mysql -e "start slave;"

# View synchronization status by looking at the node 
mysql -e "show slave status \G"

echo "Please execute Script 1 on server-1 and press Enter to continue when you are finished"
read -n 1

# Verify that the server is synchronized from the database server
mysql -e "show databases;"
mysql -e "use fourthdb;show tables;"
mysql -e "use fourthdb;select * from test_table;"

#***************record shell start***************

