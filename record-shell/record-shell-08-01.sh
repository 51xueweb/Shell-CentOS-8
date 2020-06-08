#!/usr/bin/bash

######################################## File Description ########################################
# Creation time：2020-05-30
# Project：08
# Task: 01
# Execute example：bash record-shell-x-x.sh
# Detailed description：
# About：http://linux.book.51xueweb.cn
##################################################################################################

#reback start
yum remove bind -y
echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear
#reback end

#***************record shell start***************
echo -e "---------------install bind---------------\n"
sleep 5s

echo "[root@Project-08-Task-01 ~]# yum install -y bind"
sleep 3s
yum install -y bind
sleep 3s

echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear

echo -e "---------------configure named---------------\n"
sleep 5s

echo "[root@Project-08-Task-01 ~]# systemctl start named"
sleep 3s
systemctl start named
sleep 3s

echo "[root@Project-08-Task-01 ~]# systemctl status named | head -n 10"
sleep 3s
systemctl status named | head -n 10
sleep 3s

echo "[root@Project-08-Task-01 ~]# systemctl enable named"
sleep 3s
systemctl enable named
sleep 3s

echo "[root@Project-08-Task-01 ~]# systemctl list-unit-files | grep named.service"
sleep 3s
systemctl list-unit-files | grep named.service
sleep 3s

#***************record shell end*****************
echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear