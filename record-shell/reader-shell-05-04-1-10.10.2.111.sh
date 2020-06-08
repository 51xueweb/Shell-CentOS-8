#!/bin/bash

######################################## File Description ########################################
# Creation time：2020-05-31
# Project：05
# Task: 04-1
# Execute example：bash reader-shell-x-x.sh
# Detailed description：
# About：http://linux.book.51xueweb.cn
##################################################################################################

# reback start 
yum remove MariaDB-server -y
# reback end 

#***************reader shell start***************

# echo "---------------Configuration MariaDB---------------"
# Create YUM
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

# Start MariaDB
# echo "---------------Start MariaDB---------------"
systemctl start mariadb

# View MariaDB INFO
# echo "---------------View MariaDB INFO---------------"

# systemctl status mariadb
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
echo server_id=1 >> /etc/my.cnf
echo log-basename= db-cluster-mariadb >> /etc/my.cnf

# Restart the mariadb service for the profile to take effect
systemctl restart mariadb

# Create and authorize accounts for synchronization
mysql -e "CREATE USER 'replication_user1'@'%' IDENTIFIED BY 'centos@mariadb#1234';"
mysql -e "GRANT REPLICATION SLAVE ON *.* TO 'replication_user'@'%';"
mysql -e "show master status;"

echo "Please record file value and Position value，Press 【Enter】 to continue"
read -n 1

echo "Please execute Script 2 on server-2 and press 【Enter】 to continue after execution"
read -n 1

# Add data to the database server primary node
mysql -e "create database fourthdb;"

mysql -e "use fourthdb;create table test_table(id int(11),name varchar(20),sex enum('0','1','2'),primary key (id));"
mysql -e "use fourthdb;insert into test_table ( id, name,sex ) VALUES ( 1, 'name1','0' );"
mysql -e "use fourthdb;select * from test_table;"
