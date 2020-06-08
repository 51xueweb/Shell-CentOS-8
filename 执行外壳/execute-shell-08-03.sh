#!/usr/bin/bash

######################################## File Description ########################################
# Creation time：2020-05-31
# Project：08
# Task: 03
# Execute example：bash reader-shell-x-x.sh
# Detailed description：
# About：http://linux.book.51xueweb.cn
##################################################################################################

#reback start
cp -f /etc/named.conf.bak2 /etc/named.conf
rm -f /var/named/domain.com.zone
rm -f /var/named/10.10.3.zone
rm -f /var/named/demo.cn.zone
rm -f /var/named/10.10.4.zone
#reback end

#***************reader shell start***************

#add configuration information for forward resolution and reverse resolution
cat >> /etc/named.conf <<EOF
zone "domain.com" IN {
	type master;
	file "domain.com.zone";
	allow-update { none; };
};
zone "3.10.10.in-addr.arpa" IN {
	type master;
	file "10.10.3.zone";
	allow-update { none; };
};
zone "demo.cn" IN {
	type master;
	file "demo.cn.zone";
	allow-update { none; };
};
zone "4.10.10.in-addr.arpa" IN {
	type master;
	file "10.10.4.zone";
	allow-update { none; };
};
EOF

#configure the forward resolution zone profile for domain name domain.com
cp /var/named/named.localhost /var/named/domain.com.zone
chown named.named /var/named/domain.com.zone
chmod 640 /var/named/domain.com.zone
cat > /var/named/domain.com.zone <<EOF
\$TTL 1D
@ IN SOA ns.domain.com. root.domain.com. (
	0 ; serial
	1D ; refresh
	1H ; retry
	1W ; expire
	3H ) ; minimum
@ IN NS ns.domain.com.
@ IN MX 10 mail.domain.com.
ns IN A 10.10.2.120
mail IN A 10.10.3.200
www IN A 10.10.3.200
ftp IN A 10.10.3.200
www IN AAAA 1080::8:800:200C:417A
web IN CNAME www.domain.com.
EOF

#configure the reverse resolution zone profile for domain name domain.com
cp /var/named/named.loopback /var/named/10.10.3.zone
chown named.named /var/named/10.10.3.zone
chmod 640 /var/named/10.10.3.zone
cat > /var/named/10.10.3.zone <<EOF
\$TTL 1D
@ IN SOA ns.domain.com. root.domain.com. (
	0 ; serial
	1D ; refresh
	1H ; retry
	1W ; expire
	3H ) ; minimum
@ IN NS ns.domain.com.
120 IN PTR ns.domain.com.
200 IN PTR mail.domain.com.
EOF

#configure the forward resolution zone profile for domain name domain.cn
cp /var/named/named.localhost /var/named/demo.cn.zone
chown named.named /var/named/demo.cn.zone
chmod 640 /var/named/demo.cn.zone
cat > /var/named/demo.cn.zone <<EOF
\$TTL 1D
@ IN SOA ns.demo.cn. root.demo.cn. (
	0 ; serial
	1D ; refresh
	1H ; retry
	1W ; expire
	3H ) ; minimum
@ IN NS ns.demo.cn.
@ IN MX 10 mail.demo.cn.
ns IN A 10.10.2.120
mail IN A 10.10.4.200
www IN A 10.10.4.200
ftp IN A 10.10.4.200
www IN AAAA FF60:0:0:0610:BC:0:0:05D7
web IN CNAME www.demo.cn.
EOF

#configure the reverse resolution zone profile for domain name domain.cn
cp /var/named/named.loopback /var/named/10.10.4.zone
chown named.named /var/named/10.10.4.zone
chmod 640 /var/named/10.10.4.zone
cat > /var/named/10.10.4.zone <<EOF
\$TTL 1D
@ IN SOA ns.demo.cn. root.demo.cn. (
	0 ; serial
	1D ; refresh
	1H ; retry
	1W ; expire
	3H ) ; minimum
@ IN NS ns.demo.cn.
120 IN PTR ns.demo.cn.
200 IN PTR mail.demo.cn
EOF

#use the named-checkconf tool to verify the correctness of the main configuration file
named-checkconf /etc/named.conf
named-checkzone domain.com /var/named/domain.com.zone
named-checkzone 3.10.10.in-addr.arpa /var/named/10.10.3.zone
named-checkzone demo.cn /var/named/demo.cn.zone
named-checkzone 4.10.10.in-addr.arpa /var/named/10.10.4.zone

#reload named
systemctl reload named

#***************reader shell end*****************