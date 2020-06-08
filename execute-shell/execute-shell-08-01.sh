#!/usr/bin/bash

######################################## File Description ########################################
# Creation time：2020-05-30
# Project：08
# Task: 01
# Execute example：bash reader-shell-x-x.sh
# Detailed description：
# About：http://linux.book.51xueweb.cn
##################################################################################################

#reback start
yum remove bind -y
#reback end

#***************reader shell start***************

#install bind
yum install -y bind

#configure named
systemctl start named
systemctl status named | head -n 10
systemctl enable named
systemctl list-unit-files | grep named.service

cp -f /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak1

#***************reader shell end*****************