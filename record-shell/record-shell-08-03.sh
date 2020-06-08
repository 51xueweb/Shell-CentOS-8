#!/usr/bin/bash

######################################## File Description ########################################
# Creation time：2020-05-31
# Project：08
# Task: 03
# Execute example：bash record-shell-x-x.sh
# Detailed description：
# About：http://linux.book.51xueweb.cn
##################################################################################################

#reback start
cp -f /etc/named.conf.bak2 /etc/named.conf
rm -f /var/named/domain.com.zone
rm -f /var/named/10.10.3.zone
rm -f /var/named/demo.cn.zone
rm -f /var/named/10.10.4.zone
echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear
#reback end

#***************reader shell start***************
echo -e "---------------add configuration information---------------\n"
sleep 5s

echo "[root@Project-08-Task-01 ~]# cat >> /etc/named.conf <<EOF"
sleep 3s
echo "> zone \"domain.com\" IN {"
sleep 3s
echo "> 	type master;"
sleep 3s
echo "> 	file \"domain.com.zone\";"
sleep 3s
echo "> 	allow-update { none; };"
sleep 3s
echo "> };"
sleep 3s

echo "> zone \"3.10.10.in-addr.arpa\" IN {"
sleep 3s
echo "> 	type master;"
sleep 3s
echo "> 	file \"10.10.3.zone\";"
sleep 3s
echo "> 	allow-update { none; };"
sleep 3s
echo "> };"
sleep 3s

echo "> zone \"demo.cn\" IN {"
sleep 3s
echo "> 	type master;"
sleep 3s
echo "> 	file \"demo.cn.zone\";"
sleep 3s
echo "> 	allow-update { none; };"
sleep 3s
echo "> };"
sleep 3s

echo "> zone \"4.10.10.in-addr.arpa\" IN {"
sleep 3s
echo "> 	type master;"
sleep 3s
echo "> 	file \"10.10.4.zone\";"
sleep 3s
echo "> 	allow-update { none; };"
sleep 3s
echo "> };"
sleep 3s

echo "> EOF"
sleep 3s

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

echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear

echo -e "---------------configure the zone profile for domain name domain.com---------------\n"
sleep 5s

#configure the forward resolution zone profile for domain name domain.com
echo "[root@Project-08-Task-01 ~]# cp /var/named/named.localhost /var/named/domain.com.zone"
sleep 3s
cp /var/named/named.localhost /var/named/domain.com.zone
sleep 3s

echo "[root@Project-08-Task-01 ~]# chown named.named /var/named/domain.com.zone"
sleep 3s
chown named.named /var/named/domain.com.zone
sleep 3s

echo "[root@Project-08-Task-01 ~]# chmod 640 /var/named/domain.com.zone"
sleep 3s
chmod 640 /var/named/domain.com.zone
sleep 3s

echo "[root@Project-08-Task-01 ~]# cat > /var/named/domain.com.zone <<EOF"
sleep 3s
echo "> \\\$TTL 1D"
sleep 3s
echo "> @ IN SOA ns.domain.com. root.domain.com. ("
sleep 3s
echo "> 	0 ; serial"
sleep 3s
echo "> 	1D ; refresh"
sleep 3s
echo "> 	1H ; retry"
sleep 3s
echo "> 	1W ; expire"
sleep 3s
echo "> 	3H ) ; minimum"
sleep 3s
echo "> @ IN NS ns.domain.com."
sleep 3s
echo "> @ IN MX 10 mail.domain.com."
sleep 3s
echo "> ns IN A 10.10.2.120"
sleep 3s
echo "> mail IN A 10.10.3.200"
sleep 3s
echo "> www IN A 10.10.3.200"
sleep 3s
echo "> ftp IN A 10.10.3.200"
sleep 3s
echo "> www IN AAAA 1080::8:800:200C:417A"
sleep 3s
echo "> web IN CNAME www.domain.com."
sleep 3s
echo "> EOF"
sleep 3s

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
echo "[root@Project-08-Task-01 ~]# cp /var/named/named.loopback /var/named/10.10.3.zone"
sleep 3s
cp /var/named/named.loopback /var/named/10.10.3.zone
sleep 3s

echo "[root@Project-08-Task-01 ~]# chown named.named /var/named/10.10.3.zone"
sleep 3s
chown named.named /var/named/10.10.3.zone
sleep 3s

echo "[root@Project-08-Task-01 ~]# chmod 640 /var/named/10.10.3.zone"
sleep 3s
chmod 640 /var/named/10.10.3.zone
sleep 3s

echo "[root@Project-08-Task-01 ~]# cat > /var/named/10.10.3.zone <<EOF"
sleep 3s
echo "> \\\$TTL 1D"
sleep 3s
echo "> @ IN SOA ns.domain.com. root.domain.com. ("
sleep 3s
echo "> 	0 ; serial"
sleep 3s
echo "> 	1D ; refresh"
sleep 3s
echo "> 	1H ; retry"
sleep 3s
echo "> 	1W ; expire"
sleep 3s
echo "> 	3H ) ; minimum"
sleep 3s
echo "> @ IN NS ns.domain.com."
sleep 3s
echo "> 120 IN PTR ns.domain.com."
sleep 3s
echo "> 200 IN PTR mail.domain.com."
sleep 3s
echo "> EOF"
sleep 3s

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

echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear

echo -e "---------------configure the zone profile for domain name domain.cn---------------\n"
sleep 5s

#configure the forward resolution zone profile for domain name domain.cn
echo "[root@Project-08-Task-01 ~]# cp /var/named/named.localhost /var/named/demo.cn.zone"
sleep 3s
cp /var/named/named.localhost /var/named/demo.cn.zone
sleep 3s

echo "[root@Project-08-Task-01 ~]# chown named.named /var/named/demo.cn.zone"
sleep 3s
chown named.named /var/named/demo.cn.zone
sleep 3s

echo "[root@Project-08-Task-01 ~]# chmod 640 /var/named/demo.cn.zone"
sleep 3s
chmod 640 /var/named/demo.cn.zone
sleep 3s

echo "[root@Project-08-Task-01 ~]# cat > /var/named/demo.cn.zone <<EOF"
sleep 3s
echo "> \\\$TTL 1D"
sleep 3s
echo "> @ IN SOA ns.demo.cn. root.demo.cn. ("
sleep 3s
echo "> 	0 ; serial"
sleep 3s
echo "> 	1D ; refresh"
sleep 3s
echo "> 	1H ; retry"
sleep 3s
echo "> 	1W ; expire"
sleep 3s
echo "> 	3H ) ; minimum"
sleep 3s
echo "> @ IN NS ns.demo.cn."
sleep 3s
echo "> @ IN MX 10 mail.demo.cn."
sleep 3s
echo "> ns IN A 10.10.2.120"
sleep 3s
echo "> mail IN A 10.10.4.200"
sleep 3s
echo "> www IN A 10.10.4.200"
sleep 3s
echo "> ftp IN A 10.10.4.200"
sleep 3s
echo "> www IN AAAA FF60:0:0:0610:BC:0:0:05D7"
sleep 3s
echo "> web IN CNAME www.demo.cn."
sleep 3s
echo "> EOF"
sleep 3s

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
echo "[root@Project-08-Task-01 ~]# cp /var/named/named.loopback /var/named/10.10.4.zone"
sleep 3s
cp /var/named/named.loopback /var/named/10.10.4.zone
sleep 3s

echo "[root@Project-08-Task-01 ~]# chown named.named /var/named/10.10.4.zone"
sleep 3s
chown named.named /var/named/10.10.4.zone
sleep 3s

echo "[root@Project-08-Task-01 ~]# chmod 640 /var/named/10.10.4.zone"
sleep 3s
chmod 640 /var/named/10.10.4.zone
sleep 3s

echo "[root@Project-08-Task-01 ~]# cat > /var/named/10.10.4.zone <<EOF"
sleep 3s
echo "> \\\$TTL 1D"
sleep 3s
echo "> @ IN SOA ns.demo.cn. root.demo.cn. ("
sleep 3s
echo "> 	0 ; serial"
sleep 3s
echo "> 	1D ; refresh"
sleep 3s
echo "> 	1H ; retry"
sleep 3s
echo "> 	1W ; expire"
sleep 3s
echo "> 	3H ) ; minimum"
sleep 3s
echo "> @ IN NS ns.demo.cn."
sleep 3s
echo "> 120 IN PTR ns.demo.cn."
sleep 3s
echo "> 200 IN PTR mail.demo.cn"
sleep 3s
echo "> EOF"
sleep 3s

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

echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear

echo -e "---------------verify the correctness of the main configuration file---------------\n"
sleep 5s

#use the named-checkconf tool to verify the correctness of the main configuration file
echo "[root@Project-08-Task-01 ~]# named-checkconf /etc/named.conf"
sleep 3s
named-checkconf /etc/named.conf
sleep 3s

echo "[root@Project-08-Task-01 ~]# named-checkzone domain.com /var/named/domain.com.zone"
sleep 3s
named-checkzone domain.com /var/named/domain.com.zone
sleep 3s

echo "[root@Project-08-Task-01 ~]# named-checkzone 3.10.10.in-addr.arpa /var/named/10.10.3.zone"
sleep 3s
named-checkzone 3.10.10.in-addr.arpa /var/named/10.10.3.zone
sleep 3s

echo "[root@Project-08-Task-01 ~]# named-checkzone demo.cn /var/named/demo.cn.zone"
sleep 3s
named-checkzone demo.cn /var/named/demo.cn.zone
sleep 3s

echo "[root@Project-08-Task-01 ~]# named-checkzone 4.10.10.in-addr.arpa /var/named/10.10.4.zone"
sleep 3s
named-checkzone 4.10.10.in-addr.arpa /var/named/10.10.4.zone
sleep 3s

echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear

echo -e "---------------reload named---------------\n"
sleep 5s

#reload named
echo "[root@Project-08-Task-01 ~]# systemctl reload named"
sleep 3s
systemctl reload named
sleep 3s

#***************reader shell end*****************
echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear