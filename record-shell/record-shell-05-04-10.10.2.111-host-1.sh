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
yum remove -y  MariaDB-server 
yum -y clean all
rm -rf /var/lib/mysql/
rm -f /etc/yum.repos.d/MariaDB.repo
rm -f /etc/my.cnf
echo "[root@Project-05-Task-02 ~]# clear"
sleep 3s
clear
# reback end 

#***************record shell start***************
echo "[root@Project-05-Task-02 ~]# nmcli"
sleep 3s
nmcli
echo -e "\n"
sleep 3s


read -n1 -p "---------------Please continue---------------"
echo -e '\n'

echo "[root@Project-05-Task-02 ~]# clear"
sleep 3s
clear

echo -e "---------------Configuration information---------------\n"
sleep 5s

echo "[root@Project-05-Task-02 ~]# touch /etc/yum.repos.d/MariaDB.repo"
sleep 3s
touch /etc/yum.repos.d/MariaDB.repo
sleep 3s

# MariaDB YUM SOURCE CONFIGURATION INFORMATION WRITE FILE
echo "[root@Project-05-Task-02 ~]# echo [mariadb] > /etc/yum.repos.d/MariaDB.repo"
sleep 3s
echo [mariadb] > /etc/yum.repos.d/MariaDB.repo
sleep 3s

echo "[root@Project-05-Task-02 ~]# echo name = MariaDB >> /etc/yum.repos.d/MariaDB.repo"
sleep 3s
echo name = MariaDB >> /etc/yum.repos.d/MariaDB.repo
sleep 3s

echo "[root@Project-05-Task-02 ~]# echo baseurl = https://mirrors.aliyun.com/mariadb/yum/10.4/centos8-amd64 >> /etc/yum.repos.d/MariaDB.repo"
sleep 3s
echo baseurl = https://mirrors.aliyun.com/mariadb/yum/10.4/centos8-amd64 >> /etc/yum.repos.d/MariaDB.repo
sleep 3s

echo "[root@Project-05-Task-02 ~]# echo module_hotfixes=1 >> /etc/yum.repos.d/MariaDB.repo"
sleep 3s
echo module_hotfixes=1 >> /etc/yum.repos.d/MariaDB.repo
sleep 3s

echo "[root@Project-05-Task-02 ~]# echo gpgkey= https://mirrors.aliyun.com/mariadb/yum/RPM-GPG-KEY-MariaDB >> /etc/yum.repos.d/MariaDB.repo"
sleep 3s
echo gpgkey= https://mirrors.aliyun.com/mariadb/yum/RPM-GPG-KEY-MariaDB >> /etc/yum.repos.d/MariaDB.repo
sleep 3s

echo "[root@Project-05-Task-02 ~]# echo gpgcheck=1 >> /etc/yum.repos.d/MariaDB.repo"
sleep 3s
echo gpgcheck=1 >> /etc/yum.repos.d/MariaDB.repo
sleep 3s

echo "[root@Project-05-Task-02 ~]# clear"
sleep 3s
clear

echo -e "---------------Install MariaDB---------------\n"
sleep 5s

echo "[root@Project-05-Task-02 ~] yum install -y MariaDB-server "
sleep 3s
yum install -y MariaDB-server 
sleep 3s

echo "[root@Project-05-Task-02 ~]# clear"
sleep 3s
clear

echo -e "---------------Start MariaDB---------------\n"
sleep 5s

echo "[root@Project-05-Task-02 ~]# systemctl start mariadb"
sleep 3s
systemctl start mariadb
sleep 3s

echo "[root@Project-05-Task-02 ~]# clear"
sleep 3s
clear

echo -e "---------------View MariaDB---------------\n"
sleep 5s

# systemctl status mariadb
echo "[root@Project-05-Task-02 ~]# systemctl status mariadb | head  -10"
sleep 3s
systemctl status mariadb | head  -10
sleep 3s

echo "[root@Project-05-Task-02 ~]# clear"
sleep 3s
clear

echo -e "---------------Configure the mariadb service as A boot-on---------------\n"
sleep 5s

# Configure the mariadb service as A boot-on
echo "[root@Project-05-Task-02 ~]# systemctl enable mariadb"
sleep 3s
systemctl enable mariadb
sleep 3s

# Verify that the mariadb service is boot-on
echo "[root@Project-05-Task-02 ~]# systemctl is-enabled mariadb"
sleep 3s
systemctl is-enabled mariadb
sleep 3s

echo "[root@Project-05-Task-02 ~]# systemctl stop firewalld"
sleep 3s
systemctl stop firewalld
sleep 3s

echo "[root@Project-05-Task-02 ~]# setenforce 0"
sleep 3s
setenforce 0
sleep 3s

echo "[root@Project-05-Task-02 ~]# clear"
sleep 3s
clear

# Configure the first database server as the primary node
echo -e "---------------Configure database server---------------\n"
sleep 5s

echo "[root@Project-05-Task-02 ~]# echo [mariadb] >> /etc/my.cnf"
sleep 3s
echo [mariadb] >> /etc/my.cnf
sleep 3s

echo "[root@Project-05-Task-02 ~]# echo log-bin >> /etc/my.cnf"
sleep 3s
echo log-bin >> /etc/my.cnf
sleep 3s

echo "[root@Project-05-Task-02 ~]# echo server_id=1 >> /etc/my.cnf"
sleep 3s
echo server_id=1 >> /etc/my.cnf
sleep 3s

echo "[root@Project-05-Task-02 ~]# echo log-basename = db-cluster-mariadb >> /etc/my.cnf"
sleep 3s
echo log-basename= db-cluster-mariadb >> /etc/my.cnf
sleep 3s

echo "[root@Project-05-Task-02 ~]# clear"
sleep 3s
clear

# Restart the mariadb service for the profile to take effect
echo -e "---------------Restart the mariadb service---------------\n"
sleep 5s

echo "[root@Project-05-Task-02 ~]# systemctl restart mariadb"
sleep 3s
systemctl restart mariadb
sleep 3s

echo "[root@Project-05-Task-02 ~]# clear"
sleep 3s
clear

# Create and authorize accounts for synchronization
echo -e "---------------Create and authorize accounts for synchronization---------------\n"
sleep 5s

echo -e "[root@Project-05-Task-02 ~]# mysql -e \"CREATE USER 'replication_user'@'%' IDENTIFIED BY 'centos@mariadb#123';\""

sleep 3s
mysql -e "CREATE USER 'replication_user'@'%' IDENTIFIED BY 'centos@mariadb#123';"
sleep 3s

echo -e "[root@Project-05-Task-02 ~]# mysql -e \"GRANT REPLICATION SLAVE ON *.* TO 'replication_user'@'%';\""
sleep 3s
mysql -e "GRANT REPLICATION SLAVE ON *.* TO 'replication_user'@'%'"
sleep 3s

echo '[root@Project-05-Task-02 ~]# mysql -e "show master status;"'
sleep 3s
mysql -e "show master status;"
sleep 3s

echo -e "\n"
read -n1 -p "---------------Record File values and Position values---------------"
sleep 3s
echo -e '\n'
read -n1 -p "---------------Please execute Script  2  on server-2 ---------------"
echo -e "\n"
sleep 3s

echo "[root@Project-05-Task-02 ~]# clear"
sleep 3s
clear

# Add data to the database server primary node
echo -e "---------------Add data to the database server primary node---------------\n"
sleep 5s

echo '[root@Project-05-Task-02 ~]# mysql -e "create database fourthdb;"'
sleep 3s
mysql -e "create database fourthdb;"
sleep 3s

echo -e "[root@Project-05-Task-02 ~]# mysql -e \"use fourthdb;create table test_table(id int(11),name varchar(20),sex enum('0','1','2'),primary key (id));\""
sleep 3s
mysql -e "use fourthdb;create table test_table(id int(11),name varchar(20),sex enum('0','1','2'),primary key (id));"
sleep 3s

echo -e "[root@Project-05-Task-02 ~]# mysql -e \"use fourthdb;insert into test_table (id,name,sex) VALUES (1,'name1','0');\""
sleep 3s
mysql -e "use fourthdb;insert into test_table (id,name,sex) VALUES (1,'name1','0');"
sleep 3s


echo '[root@Project-05-Task-02 ~]# mysql -e "show databases;"'
sleep 3s
mysql -e "show databases;"
sleep 3s

echo '[root@Project-05-Task-02 ~]# mysql -e "use fourthdb;show tables;"'
sleep 3s
mysql -e "use fourthdb;show tables;"
sleep 3s

echo '[root@Project-05-Task-02 ~]# mysql -e "use fourthdb;select * from test_table;"'
sleep 3s
mysql -e "use fourthdb;select * from test_table;"
sleep 3s

echo -e '\n'
read -n1 -p "---------------Please execute Script 2 on server-2---------------"
echo -e '\n'
sleep 3s

read -n1 -p "---------------Please continue End---------------"
echo -e '\n'


echo "[root@Project-05-Task-02 ~]# clear"
sleep 3s
clear

#***************record shell end***************
