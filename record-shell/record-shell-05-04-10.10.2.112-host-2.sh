#!/bin/bash

######################################## File Description ########################################
# Creation time：2020-05-31
# Project：05
# Task： 04-2
# Execute example：bash reader-shell-x-x.sh
# Detailed description：
# About：http：//linux.book.51xueweb.cn
##################################################################################################

# reback start
yum remove -y MariaDB-server 
rm -f /etc/yum.repos.d/MariaDB.repo
echo "[root@Project-05-Task-03 ~]# clear"
sleep 3s
clear
# raback end

#***************record shell start***************

echo "[root@Project-05-Task-03 ~]# nmcli"
sleep 3s
nmcli
sleep 3s

echo -e "\n"
read -n1 -p "---------------Please continue---------------"

echo "[root@Project-05-Task-03 ~]# clear"
sleep 3s
clear

echo -e "---------------Configuration information---------------\n"
sleep 5s

# Create a YUM source file
echo "[root@Project-05-Task-03 ~]# touch /etc/yum.repos.d/MariaDB.repo"
sleep 3s
touch /etc/yum.repos.d/MariaDB.repo
sleep 3s

# MariaDB YUM SOURCE CONFIGURATION INFORMATION WRITE FILE
echo "[root@Project-05-Task-03 ~]# echo [mariadb] > /etc/yum.repos.d/MariaDB.repo"
sleep 3s
echo [mariadb] > /etc/yum.repos.d/MariaDB.repo
sleep 3s

echo "[root@Project-05-Task-03 ~]# echo name = MariaDB >> /etc/yum.repos.d/MariaDB.repo"
sleep 3s
echo name = MariaDB >> /etc/yum.repos.d/MariaDB.repo
sleep 3s

echo "[root@Project-05-Task-03 ~]# echo baseurl = https：//mirrors.aliyun.com/mariadb/yum/10.4/centos8-amd64 >> /etc/yum.repos.d/MariaDB.repo"
sleep 3s
echo baseurl = https://mirrors.aliyun.com/mariadb/yum/10.4/centos8-amd64 >> /etc/yum.repos.d/MariaDB.repo
sleep 3s

echo "[root@Project-05-Task-03 ~]# echo module_hotfixes = 1 >> /etc/yum.repos.d/MariaDB.repo"
sleep 3s
echo module_hotfixes = 1 >> /etc/yum.repos.d/MariaDB.repo
sleep 3s

echo "[root@Project-05-Task-03 ~]# echo gpgkey = https：//mirrors.aliyun.com/mariadb/yum/RPM-GPG-KEY-MariaDB >> /etc/yum.repos.d/MariaDB.repo"
sleep 3s
echo gpgkey = https://mirrors.aliyun.com/mariadb/yum/RPM-GPG-KEY-MariaDB >> /etc/yum.repos.d/MariaDB.repo
sleep 3s

echo "[root@Project-05-Task-03 ~]# echo gpgcheck = 1 >> /etc/yum.repos.d/MariaDB.repo"
sleep 3s
echo gpgcheck = 1 >> /etc/yum.repos.d/MariaDB.repo
sleep 3s

echo "[root@Project-05-Task-03 ~]# clear"
sleep 3s
clear

echo -e "---------------Install MariaDB---------------\n"
sleep 5s

echo "[root@Project-05-Task-03 ~]# yum install -y MariaDB-server "
sleep 3s
yum install -y MariaDB-server
sleep 3s

echo "[root@Project-05-Task-03 ~]# clear"
sleep 3s
clear

echo -e "---------------Start MariaDB---------------\n"
sleep 5s

echo "[root@Project-05-Task-03 ~]# systemctl start mariadb"
sleep 3s
systemctl start mariadb
sleep 3s

# View MariaDB run information
echo "[root@Project-05-Task-03 ~]# systemctl status mariadb | head  -10"
sleep 3s
systemctl status mariadb | head  -10
sleep 3s

echo "[root@Project-05-Task-03 ~]# clear"
sleep 3s
clear

# Configure the mariadb service as A boot-on
echo -e "---------------Configure the mariadb service as A boot-on---------------\n"
sleep 5s

echo "[root@Project-05-Task-03 ~]# systemctl enable mariadb"
sleep 3s
systemctl enable mariadb
sleep 3s

# Verify that the mariadb service is boot-on
echo "[root@Project-05-Task-03 ~]# systemctl is-enabled mariadb"
sleep 3s
systemctl is-enabled mariadb
sleep 3s

# Verify that the mariadb service is boot-on
echo "[root@Project-05-Task-03 ~]# systemctl stop firewalld"
sleep 3s
systemctl stop firewalld
sleep 3s

# Verify that the mariadb service is boot-on
echo "[root@Project-05-Task-03 ~]# setenforce 0"
sleep 3s
setenforce 0
sleep 3s

echo "[root@Project-05-Task-03 ~]# clear"
sleep 3s
clear

# Configure the first database server as the primary node
echo -e "---------------Configure database server---------------\n"
sleep 5s

echo "[root@Project-05-Task-03 ~]# echo [mariadb] >> /etc/my.cnf"
sleep 3s
echo [mariadb] >> /etc/my.cnf
sleep 3s

echo "[root@Project-05-Task-03 ~]# echo log-bin >> /etc/my.cnf"
sleep 3s
echo log-bin >> /etc/my.cnf
sleep 3s

echo "[root@Project-05-Task-03 ~]# echo server_id=2 >> /etc/my.cnf"
sleep 3s
echo server_id=2 >> /etc/my.cnf
sleep 3s

echo "[root@Project-05-Task-03 ~]# clear"
sleep 3s
clear

# Configure the first database server as the primary node
echo -e "---------------Restart mariadb server---------------\n"
sleep 5s

echo "[root@Project-05-Task-03 ~]# systemctl restart mariadb"
sleep 3s
systemctl restart mariadb
sleep 3s

echo -e "[root@Project-05-Task-03 ~]# read -p \"Please enter the server-1 IP address:\" server1_ip"
sleep 3s
read -p "Please enter the server-1 IP address:" server1_ip
sleep 3s

echo -e "[root@Project-05-Task-03 ~]# read -p \"Please enter the File value:\" log_file"
sleep 3s
read -p "Please enter the File value:" log_file
sleep 3s

echo -e "[root@Project-05-Task-03 ~]# read -p \"Please enter the Position value:\" log_position"
sleep 3s
read -p "Please enter the Position value:" log_position
sleep 3s

echo "[root@Project-05-Task-03 ~]# clear"
sleep 3s
clear

# Set the option to connect the primary server from the server
echo -e "---------------Set server---------------\n"
sleep 5s

echo -e "[root@Project-05-Task-03 ~]# mysql -e \"CHANGE MASTER TO MASTER_HOST='$server1_ip',MASTER_USER='replication_user',MASTER_PASSWORD='centos@mariadb#123',MASTER_PORT=3306,MASTER_LOG_FILE='$log_file',MASTER_LOG_POS='$log_position',MASTER_CONNECT_RETRY=10;\""
sleep 3s
mysql -e "CHANGE MASTER TO
MASTER_HOST='$server1_ip',
MASTER_USER='replication_user',
MASTER_PASSWORD='centos@mariadb#123',
MASTER_PORT=3306,
MASTER_LOG_FILE='$log_file',
MASTER_LOG_POS=$log_position,
MASTER_CONNECT_RETRY=10;"
sleep 3s

# Start replication
echo '[root@Project-05-Task-03 ~]# mysql -e "start slave;"'
sleep 3s
mysql -e "start slave;"
sleep 3s

# View synchronization status by looking at the node
echo '[root@Project-05-Task-03 ~]# mysql -e "show slave status \G"'
sleep 3s
mysql -e "show slave status \G"
sleep 3s

echo "[root@Project-05-Task-03 ~]# clear"
sleep 3s
clear

# Verify that the server is synchronized from the database server
echo -e "---------------Verify that the server is synchronized from the database server---------------\n"
sleep 5s

read -n1 -p "---------------Please execute Script 1 on server-1---------------"
sleep 3s
echo -e '\n'

echo '[root@Project-05-Task-03 ~]# mysql -e "show databases;"'
sleep 3s
mysql -e "show databases;"
sleep 3s

echo '[root@Project-05-Task-03 ~]# mysql -e "use fourthdb;show tables;"'
sleep 3s
mysql -e "use fourthdb;show tables;"
sleep 3s

echo '[root@Project-05-Task-03 ~]# mysql -e "use fourthdb;select * from test_table;"'
sleep 3s
mysql -e "use fourthdb;select * from test_table;"
sleep 3s

echo -e '\n'
read -n1 -p "---------------Please continue End---------------"
echo -e '\n'

echo "[root@Project-05-Task-03 ~]# clear"
sleep 3s
clear

#***************Record shell end***************

