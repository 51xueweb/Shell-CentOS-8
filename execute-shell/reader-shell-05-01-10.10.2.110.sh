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
yum remove MariaDB-server -y
rm -f /etc/yum.repos.d/MariaDB.repo
# reback end

#***************reader shell start***************

# Configure MariaDB 
touch /etc/yum.repos.d/MariaDB.repo
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
# systemctl status mariadb | head  -10
systemctl status mariadb
# Configuration mariadb
systemctl enable mariadb
systemctl is-enabled mariadb

# Use the initial root permission for the MariaDB client
mysql -e "set password = password('centos@mariadb#123');"

# Use MariaDB
mysql -e "create database firstdb;"
mysql -e "show databases;"
mysql -e "use firstdb;create table test_table(id int(11),name varchar(20),sex enum('0','1','2'),primary key (id));"
mysql -e "use firstdb;show tables;"

#***************reader shell end***************



