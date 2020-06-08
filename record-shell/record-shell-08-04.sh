#!/usr/bin/bash

######################################## File Description ########################################
# Creation time：2020-05-31
# Project：08
# Task: 04
# Execute example：bash record-shell-x-x.sh
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
echo "[root@Project-08-Task-04 ~]# clear"
sleep 3s
clear
#reback end

#***************reader shell start***************
echo -e "---------------install bind---------------\n"
sleep 5s

echo "[root@Project-08-Task-04 ~]# yum install -y bind"
sleep 3s
yum install -y bind
sleep 3s

#configure named
echo "[root@Project-08-Task-04 ~]# systemctl start named"
sleep 3s
systemctl start named
sleep 3s

echo "[root@Project-08-Task-04 ~]# systemctl status named | head -10"
sleep 3s
systemctl status named | head -10
sleep 3s

echo "[root@Project-08-Task-04 ~]# systemctl enable named"
sleep 3s
systemctl enable named
sleep 3s

echo "[root@Project-08-Task-04 ~]# systemctl list-unit-files | grep named.service"
sleep 3s
systemctl list-unit-files | grep named.service
sleep 3s

echo "[root@Project-08-Task-04 ~]# clear"
sleep 3s
clear

echo -e "---------------using bind to implement DNS query service---------------\n"
sleep 5s

#modify configuration file of named
echo "[root@Project-08-Task-04 ~]# cp /etc/named.conf /etc/named.conf.bak1"
sleep 3s
cp /etc/named.conf /etc/named.conf.bak1
sleep 3s

echo "[root@Project-08-Task-04 ~]# sed -i 's/127.0.0.1/10.10.2.120/g' /etc/named.conf"
sleep 3s
sed -i 's/127.0.0.1/10.10.2.120/g' /etc/named.conf
sleep 3s

echo "[root@Project-08-Task-04 ~]# sed -i 's/localhost/any/g' /etc/named.conf"
sleep 3s
sed -i 's/localhost/any/g' /etc/named.conf
sleep 3s

#reload named
echo "[root@Project-08-Task-04 ~]# systemctl reload named"
sleep 3s
systemctl reload named
sleep 3s

#turn off firewall tempporarilly
echo "[root@Project-08-Task-04 ~]# systemctl stop firewalld"
sleep 3s
systemctl stop firewalld
sleep 3s

echo "[root@Project-08-Task-04 ~]# setenforce 0"
sleep 3s
setenforce 0
sleep 3s

#install the dig tool
echo "[root@Project-08-Task-04 ~]# yum install -y bind-utils"
sleep 3s
yum install -y bind-utils
sleep 3s

#start DNS query test
echo "[root@Project-08-Task-04 ~]# dig -t A www.baidu.com @10.10.2.120"
sleep 3s
dig -t A www.baidu.com @10.10.2.120
sleep 3s

echo "[root@Project-08-Task-04 ~]# clear"
sleep 3s
clear

echo -e "---------------configure intelligent domain name resolution service---------------\n"
sleep 5s

#configure intelligent domain name resolution service
echo "[root@Project-08-Task-04 ~]# sed -i '/zone "." IN {/,+3d' /etc/named.conf"
sleep 3s
sed -i '/zone "." IN {/,+3d' /etc/named.conf
sleep 3s

echo "[root@Project-08-Task-04 ~]# sed -i '/named.rfc1912.zones/d' /etc/named.conf"
sleep 3s
sed -i '/named.rfc1912.zones/d' /etc/named.conf
sleep 3s

echo "[root@Project-08-Task-04 ~]# cat >> /etc/named.conf <<EOF"
sleep 3s
echo "> view \"area\" {"
sleep 3s
echo "> 	match-clients{10.10.2.0/26;};"
sleep 3s
echo "> 	zone \".\" IN {"
sleep 3s
echo "> 		type hint;"
sleep 3s
echo "> 		file \"named.ca\";"
sleep 3s
echo "> 	};"
sleep 3s
echo "> 	zone \"domain.com\" IN {"
sleep 3s
echo "> 		type master;"
sleep 3s
echo "> 		file \"com-domain-area\";"
sleep 3s
echo "> 		allow-update {none;};"
sleep 3s
echo "> 	};"
sleep 3s
echo "> 	zone \"3.10.10.in-addr.arpa\" IN {"
sleep 3s
echo "> 		type master;"
sleep 3s
echo "> 		file \"10.10.3.area\";"
sleep 3s
echo "> 	};"
sleep 3s
echo "> };"
sleep 3s
echo "> view "common" {"
sleep 3s
echo "> 	match-clients{any;};"
sleep 3s
echo "> 	zone \".\" IN {"
sleep 3s
echo "> 		type hint;"
sleep 3s
echo "> 		file \"named.ca\";"
sleep 3s
echo "> 	};"
sleep 3s
echo "> 	zone \"domain.com\" IN {"
sleep 3s
echo "> 		type master;"
sleep 3s
echo "> 		file \"com-domain-common\";"
sleep 3s
echo "> 		allow-update {none;};"
sleep 3s
echo "> 	};"
sleep 3s
echo "> 	zone \"4.10.10.in-addr.arpa\" IN {"
sleep 3s
echo "> 		type master;"
sleep 3s
echo "> 		file \"10.10.4.common\";"
sleep 3s
echo "> 	};"
sleep 3s
echo "> };"
sleep 3s
echo "> EOF"
sleep 3s

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

echo "[root@Project-08-Task-04 ~]# clear"
sleep 3s
clear

echo -e "---------------configure domain name records for specific regions---------------\n"
sleep 5s

#configure the forward resolution zone profile com-domain-area
echo "[root@Project-08-Task-04 ~]# cp /var/named/named.localhost /var/named/com-domain-area"
sleep 3s
cp /var/named/named.localhost /var/named/com-domain-area
sleep 3s

echo "[root@Project-08-Task-04 ~]# chown named.named /var/named/com-domain-area"
sleep 3s
chown named.named /var/named/com-domain-area
sleep 3s

echo "[root@Project-08-Task-04 ~]# chmod 640 /var/named/com-domain-area"
sleep 3s
chmod 640 /var/named/com-domain-area
sleep 3s

echo "[root@Project-08-Task-04 ~]# cat > /var/named/com-domain-area <<EOF "
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
echo "> 3H ) ; minimum"
sleep 3s
echo "> @ IN NS ns.domain.com."
sleep 3s
echo "> ns IN A 10.10.2.120"
sleep 3s
echo "> www IN A 10.10.3.200"
sleep 3s
echo "> ftp IN A 10.10.3.200"
sleep 3s
echo "> EOF"
sleep 3s

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
echo "[root@Project-08-Task-04 ~]# cp /var/named/named.loopback /var/named/10.10.3.area"
sleep 3s
cp /var/named/named.loopback /var/named/10.10.3.area
sleep 3s

echo "[root@Project-08-Task-04 ~]# chown named.named /var/named/10.10.3.area"
sleep 3s
chown named.named /var/named/10.10.3.area
sleep 3s

echo "[root@Project-08-Task-04 ~]# chmod 640 /var/named/10.10.3.area"
sleep 3s
chmod 640 /var/named/10.10.3.area
sleep 3s

echo "[root@Project-08-Task-04 ~]# cat > /var/named/10.10.3.area <<EOF"
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
echo "> 3H ) ; minimum"
sleep 3s
echo "> @ IN NS ns.domain.com."
sleep 3s
echo "> 120 IN PTR ns.domain.com."
sleep 3s
echo "> 200 IN PTR www.domain.com."
sleep 3s
echo "> 200 IN PTR ftp.domain.com."
sleep 3s
echo "> EOF"
sleep 3s

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

echo "[root@Project-08-Task-04 ~]# clear"
sleep 3s
clear

echo -e "---------------configure domain name records for universal regions---------------\n"
sleep 5s

#configure the forward resolution zone profile com-domain-area
echo "[root@Project-08-Task-04 ~]# cp /var/named/named.localhost /var/named/com-domain-common"
sleep 3s
cp /var/named/named.localhost /var/named/com-domain-common
sleep 3s

echo "[root@Project-08-Task-04 ~]# chown named.named /var/named/com-domain-common"
sleep 3s
chown named.named /var/named/com-domain-common
sleep 3s

echo "[root@Project-08-Task-04 ~]# chmod 640 /var/named/com-domain-common"
sleep 3s
chmod 640 /var/named/com-domain-common
sleep 3s

echo "[root@Project-08-Task-04 ~]# cat > /var/named/com-domain-common <<EOF"
sleep 3s
echo "> \\\$TTL 1D"
sleep 3s
echo "@ IN SOA ns.domain.com. root.domain.com. ("
sleep 3s
echo "> 	0 ; serial"
sleep 3s
echo "> 	1D ; refresh"
sleep 3s
echo "> 	1H ; retry"
sleep 3s
echo "> 	1W ; expire"
sleep 3s
echo "> 3H ) ; minimum"
sleep 3s
echo "> @ IN NS ns.domain.com."
sleep 3s
echo "> ns IN A 10.10.2.120"
sleep 3s
echo "> www IN A 10.10.4.200"
sleep 3s
echo "> ftp IN A 10.10.4.200"
sleep 3s
echo "> EOF"
sleep 3s

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
echo "[root@Project-08-Task-04 ~]# cp /var/named/named.loopback /var/named/10.10.4.common"
sleep 3s
cp /var/named/named.loopback /var/named/10.10.4.common
sleep 3s

echo "[root@Project-08-Task-04 ~]# chown named.named /var/named/10.10.4.common"
sleep 3s
chown named.named /var/named/10.10.4.common
sleep 3s

echo "[root@Project-08-Task-04 ~]# chmod 640 /var/named/10.10.4.common"
sleep 3s
chmod 640 /var/named/10.10.4.common
sleep 3s

echo "[root@Project-08-Task-04 ~]# cat > /var/named/10.10.4.common <<EOF"
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
echo "> 3H ) ; minimum"
sleep 3s
echo "> @ IN NS ns.domain.com."
sleep 3s
echo "> 120 IN PTR ns.domain.com."
sleep 3s
echo "> 200 IN PTR www.domain.com."
sleep 3s
echo "> EOF"
sleep 3s

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

echo "[root@Project-08-Task-04 ~]# clear"
sleep 3s
clear

echo -e "---------------correctness verification and reload named---------------\n"
sleep 5s

#verify the correctness of the configuration file
echo "[root@Project-08-Task-04 ~]# named-checkconf /etc/named.conf"
sleep 3s
named-checkconf /etc/named.conf
sleep 3s

echo "[root@Project-08-Task-04 ~]# named-checkzone domain.com /var/named/com-domain-area"
sleep 3s
named-checkzone domain.com /var/named/com-domain-area
sleep 3s

echo "[root@Project-08-Task-04 ~]# named-checkzone 3.10.10.in-addr.arpa /var/named/10.10.3.area"
sleep 3s
named-checkzone 3.10.10.in-addr.arpa /var/named/10.10.3.area
sleep 3s

echo "[root@Project-08-Task-04 ~]# named-checkzone domain.com /var/named/com-domain-common"
sleep 3s
named-checkzone domain.com /var/named/com-domain-common
sleep 3s

echo "[root@Project-08-Task-04 ~]# named-checkzone 4.10.10.in-addr.arpa /var/named/10.10.4.common"
sleep 3s
named-checkzone 4.10.10.in-addr.arpa /var/named/10.10.4.common
sleep 3s

#reload named
echo "[root@Project-08-Task-04 ~]# systemctl reload named"
sleep 3s
systemctl reload named
sleep 3s

#start DNS query test
echo "[root@Project-08-Task-04 ~]# dig www.domain.com @10.10.2.120"
sleep 3s
dig www.domain.com @10.10.2.120
sleep 3s

echo "[root@Project-08-Task-04 ~]# dig -x 10.10.4.200 @10.10.2.120"
sleep 3s
dig -x 10.10.4.200 @10.10.2.120
sleep 3s

#***************reader shell end*****************
echo "[root@Project-08-Task-04 ~]# clear"
sleep 3s
clear