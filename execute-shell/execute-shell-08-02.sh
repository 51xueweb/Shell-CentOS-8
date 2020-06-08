#!/usr/bin/bash

######################################## File Description ########################################
# Creation time：2020-05-30
# Project：08
# Task: 02
# Execute example：bash reader-shell-x-x.sh
# Detailed description：
# About：http://linux.book.51xueweb.cn
##################################################################################################

#reback start
cp -f /etc/named.conf.bak1 /etc/named.conf
systemctl start firewalld
setenforce 1
yum remove bind-utils -y
#reback end

#***************reader shell start***************

#modify configuration file of named
cp /etc/named.conf /etc/named.conf.bak1
sed -i 's/127.0.0.1/10.10.2.120/g' /etc/named.conf
sed -i 's/localhost/any/g' /etc/named.conf

#reload named
systemctl reload named

#turn off firewall tempporarilly
systemctl stop firewalld
setenforce 0

#install the dig tool
yum install -y bind-utils

#start DNS query test
dig -t A www.baidu.com @10.10.2.120

cp -f /etc/named.conf /etc/named.conf.bak2

#***************reader shell end*****************