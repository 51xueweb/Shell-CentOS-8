#!/usr/bin/bash

######################################## File Description ########################################
# Creation time：2020-05-30
# Project：08
# Task: 02
# Execute example：bash record-shell-x-x.sh
# Detailed description：
# About：http://linux.book.51xueweb.cn
##################################################################################################

#reback start
cp -f /etc/named.conf.bak1 /etc/named.conf
systemctl start firewalld
setenforce 1
yum remove bind-utils -y
echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear
#reback end

#***************record shell start***************

echo -e "---------------modify configuration file of named---------------\n"
sleep 5s

echo "[root@Project-08-Task-01 ~]# cp /etc/named.conf /etc/named.conf.bak1"
sleep 3s
cp /etc/named.conf /etc/named.conf.bak1
sleep 3s

echo "[root@Project-08-Task-01 ~]# sed -i 's/127.0.0.1/10.10.2.120/g' /etc/named.conf"
sleep 3s
sed -i 's/127.0.0.1/10.10.2.120/g' /etc/named.conf
sleep 3s

echo "[root@Project-08-Task-01 ~]# sed -i 's/localhost/any/g' /etc/named.conf"
sleep 3s
sed -i 's/localhost/any/g' /etc/named.conf
sleep 3s

echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear

echo -e "---------------reload named---------------\n"
sleep 5s

echo "[root@Project-08-Task-01 ~]# systemctl reload named"
sleep 3s
systemctl reload named
sleep 3s

echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear

echo -e "---------------turn off firewall tempporarilly---------------\n"
sleep 5s

echo "[root@Project-08-Task-01 ~]# systemctl stop firewalld"
sleep 3s
systemctl stop firewalld
sleep 3s

echo "[root@Project-08-Task-01 ~]# setenforce 0"
sleep 3s
setenforce 0
sleep 3s

echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear

echo -e "---------------install the dig tool---------------\n"
sleep 5s

echo "[root@Project-08-Task-01 ~]# yum install -y bind-utils"
sleep 3s
yum install -y bind-utils
sleep 3s

echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear

echo -e "---------------start DNS query test---------------\n"
sleep 5s

echo "[root@Project-08-Task-01 ~]# dig -t A www.baidu.com @10.10.2.120"
sleep 3s
dig -t A www.baidu.com @10.10.2.120
sleep 3s

echo "[root@Project-08-Task-01 ~]# cp -f /etc/named.conf /etc/named.conf.bak2"
sleep 3s
cp -f /etc/named.conf /etc/named.conf.bak2
sleep 3s

#***************record shell end*****************
echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear