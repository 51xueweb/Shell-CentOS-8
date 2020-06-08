#!/usr/bin/bash

######################################## File Description ########################################
# Creation time：2020-05-31
# Project：08
# Task: 04
# Execute example：bash reader-shell-x-x.sh
# Detailed description：
# About：http://linux.book.51xueweb.cn
##################################################################################################

#reback start
yum remove bind -y
cp -f /etc/named.conf.bak1 /etc/named.conf
systemctl start firewalld
setenforce 1
yum remove bind-utils -y
rm -f /var/named/com-domain-area
rm -f /var/named/10.10.3.area
rm -f /var/named/com-domain-common
rm -f /var/named/10.10.4.common
#reback end

#***************reader shell start***************

#install bind
yum install -y bind

#configure named
systemctl start named
systemctl status named | head -10
systemctl enable named
systemctl list-unit-files | grep named.service

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

#configure intelligent domain name resolution service
sed -i '/zone "." IN {/,+3d' /etc/named.conf
sed -i '/named.rfc1912.zones/d' /etc/named.conf
cat >> /etc/named.conf <<EOF
view "area" {
	match-clients{10.10.2.0/26;};
	zone "." IN {
		type hint;
		file "named.ca";
	};
	zone "domain.com" IN {
		type master;
		file "com-domain-area";
		allow-update {none;};
	};
	zone "3.10.10.in-addr.arpa" IN {
		type master;
		file "10.10.3.area";
	};
};
view "common" {
	match-clients{any;};
	zone "." IN {
		type hint;
		file "named.ca";
	};
	zone "domain.com" IN {
		type master;
		file "com-domain-common";
		allow-update {none;};
	};
	zone "4.10.10.in-addr.arpa" IN {
		type master;
		file "10.10.4.common";
	};
};
EOF

#configure domain name records for specific regions

#configure the forward resolution zone profile com-domain-area
cp /var/named/named.localhost /var/named/com-domain-area
chown named.named /var/named/com-domain-area
chmod 640 /var/named/com-domain-area
cat > /var/named/com-domain-area <<EOF 
\$TTL 1D
@ IN SOA ns.domain.com. root.domain.com. (
	0 ; serial
	1D ; refresh
	1H ; retry
	1W ; expire
3H ) ; minimum
@ IN NS ns.domain.com.
ns IN A 10.10.2.120
www IN A 10.10.3.200
ftp IN A 10.10.3.200
EOF

#configure the reverse resolution zone profile 10.10.3.area
cp /var/named/named.loopback /var/named/10.10.3.area
chown named.named /var/named/10.10.3.area
chmod 640 /var/named/10.10.3.area
cat > /var/named/10.10.3.area <<EOF
\$TTL 1D
@ IN SOA ns.domain.com. root.domain.com. (
	0 ; serial
	1D ; refresh
	1H ; retry
	1W ; expire
3H ) ; minimum
@ IN NS ns.domain.com.
120 IN PTR ns.domain.com.
200 IN PTR www.domain.com.
200 IN PTR ftp.domain.com.
EOF

#configure domain name records for universal regions

#configure the forward resolution zone profile com-domain-area
cp /var/named/named.localhost /var/named/com-domain-common
chown named.named /var/named/com-domain-common
chmod 640 /var/named/com-domain-common
cat > /var/named/com-domain-common <<EOF
\$TTL 1D
@ IN SOA ns.domain.com. root.domain.com. (
	0 ; serial
	1D ; refresh
	1H ; retry
	1W ; expire
3H ) ; minimum
@ IN NS ns.domain.com.
ns IN A 10.10.2.120
www IN A 10.10.4.200
ftp IN A 10.10.4.200
EOF

#configure the reverse resolution zone profile 10.10.4.common
cp /var/named/named.loopback /var/named/10.10.4.common
chown named.named /var/named/10.10.4.common
chmod 640 /var/named/10.10.4.common
cat > /var/named/10.10.4.common <<EOF
\$TTL 1D
@ IN SOA ns.domain.com. root.domain.com. (
	0 ; serial
	1D ; refresh
	1H ; retry
	1W ; expire
3H ) ; minimum
@ IN NS ns.domain.com.
120 IN PTR ns.domain.com.
200 IN PTR www.domain.com.
EOF

#verify the correctness of the configuration file
named-checkconf /etc/named.conf
named-checkzone domain.com /var/named/com-domain-area
named-checkzone 3.10.10.in-addr.arpa /var/named/10.10.3.area
named-checkzone domain.com /var/named/com-domain-common
named-checkzone 4.10.10.in-addr.arpa /var/named/10.10.4.common

#reload named
systemctl reload named

#start DNS query test
dig www.domain.com @10.10.2.120
dig -x 10.10.4.200 @10.10.2.120

#***************reader shell end*****************