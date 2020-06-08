#!/usr/bin/bash

######################################## File Description ########################################
# Creation time：2020-05-31
# Project：05
# Task: 01
# Execute example：bash record-shell-x-x.sh
# Detailed description：
# About：http://linux.book.51xueweb.cn
##################################################################################################

# reback start
yum remove MariaDB -y
# reback end

#***************record shell start***************

echo "[root@Project-05-Task-01 ~]# clear"
sleep 3s
clear 

echo -e "---------------Configure MariaDB YUM---------------\n"
sleep 5s

# Configure MariaDB YUM
echo "[root@Project-05-Task-01 ~]# touch /etc/yum.repos.d/MariaDB.repo"
sleep 3s
touch /etc/yum.repos.d/MariaDB.repo
sleep 3s

echo "[root@Project-05-Task-01 ~]# echo [mariadb] > /etc/yum.repos.d/MariaDB.repo"
sleep 3s
echo [mariadb] > /etc/yum.repos.d/MariaDB.repo
sleep 3s

echo "[root@Project-05-Task-01 ~]# echo name=MariaDB >> /etc/yum.repos.d/MariaDB.repo"
sleep 3s
echo name = MariaDB >> /etc/yum.repos.d/MariaDB.repo
sleep 3s

echo "[root@Project-05-Task-01 ~]# echo baseurl=https://mirrors.aliyun.com/mariadb/yum/10.4/centos8-amd64 >> /etc/yum.repos.d/MariaDB.repo"
sleep 3s
echo baseurl = https://mirrors.aliyun.com/mariadb/yum/10.4/centos8-amd64 >> /etc/yum.repos.d/MariaDB.repo
sleep 3s

echo "[root@Project-05-Task-01 ~]# echo module_hotfixes=1 >> /etc/yum.repos.d/MariaDB.repo"
sleep 3s
echo module_hotfixes=1 >> /etc/yum.repos.d/MariaDB.repo
sleep 3s

echo "[root@Project-05-Task-01 ~]# echo gpgkey= https://mirrors.aliyun.com/mariadb/yum/RPM-GPG-KEY-MariaDB >> /etc/yum.repos.d/MariaDB.repo"
sleep 3s
echo gpgkey = https://mirrors.aliyun.com/mariadb/yum/RPM-GPG-KEY-MariaDB >> /etc/yum.repos.d/MariaDB.repo
sleep 3s

echo "[root@Project-05-Task-01 ~]# echo gpgcheck=1 >> /etc/yum.repos.d/MariaDB.repo"
sleep 3s
echo gpgcheck = 1 >> /etc/yum.repos.d/MariaDB.repo
sleep 3s

echo "[root@Project-05-Task-01 ~]# clear"
sleep 3s
clear 

# Install MariaDB
echo -e "---------------Install MariaDB---------------\n"
sleep 5s

echo "[root@Project-05-Task-01 ~]# yum install MariaDB-server -y"
sleep 3s
yum install MariaDB-server -y
sleep 3s

echo "[root@Project-05-Task-01 ~]# clear"
sleep 3s
clear 

# Start mariadb
echo "[root@Project-05-Task-01 ~]# systemctl start mariadb"
sleep 3s
systemctl start mariadb
sleep 3s

# View MariaDB run information
echo "[root@Project-05-Task-01 ~]# systemctl status mariadb | head  -10"
sleep 3s
systemctl status mariadb | head  -10
sleep 3s

# Configure the mariadb service and boot
echo "[root@Project-05-Task-01 ~]# systemctl enable mariadb"
sleep 3s
systemctl enable mariadb
sleep 3s

echo "[root@Project-05-Task-01 ~]# systemctl is-enabled mariadb"
sleep 3s
systemctl is-enabled mariadb
sleep 3s

echo "[root@Project-05-Task-01 ~]# clear"
sleep 3s
clear 

echo -e "---------------MariaDB Initial root permission---------------\n"
sleep 5s

echo '[root@Project-05-Task-01 ~]# mysql -e "set password = password("centos@mariadb#123");"'
sleep 3s
mysql -e "set password = password('centos@mariadb#123');"
sleep 3s

echo "[root@Project-05-Task-01 ~]# clear"
sleep 3s
clear 

echo -e "---------------Manage the database using the MariaDB client---------------\n"
sleep 5s

echo '[root@Project-05-Task-01 ~]# mysql -e "create database firstdb;"'
sleep 3s
mysql -e "create database firstdb;"
sleep 3s

echo '[root@Project-05-Task-01 ~]# mysql -e "show databases;"'
sleep 3s
mysql -e "show databases;"
sleep 3s

echo '[root@Project-05-Task-01 ~]# mysql -e "show databases;"'
sleep 3s
mysql -e "show databases;"
sleep 3s

echo '[root@Project-05-Task-01 ~]# mysql -e "use firstdb;create table test_table(id int(11),name varchar(20),sex enum('0','1','2'),primary key (id));"'
sleep 3s
mysql -e "use firstdb;create table test_table(id int(11),name varchar(20),sex enum('0','1','2'),primary key (id));"
sleep 3s

echo '[root@Project-05-Task-01 ~]# mysql -e "use firstdb;show tables;"'
sleep 3s
mysql -e "use firstdb;show tables;"
sleep 3s

echo "[root@Project-05-Task-01 ~]# clear"
sleep 3s
clear 

#***************record shell end***************



