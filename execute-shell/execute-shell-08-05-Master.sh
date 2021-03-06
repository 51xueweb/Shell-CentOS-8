#!/usr/bin/bash

######################################## File Description ########################################
# Creation time：2020-05-31
# Project：08
# Task: 05
# Execute example：bash reader-shell-x-x.sh
# Detailed description：
# About：http://linux.book.51xueweb.cn
##################################################################################################

# reback start
cp -f /etc/named.conf.bak1 /etc/named.conf
yum remove bind-utils -y
rm -f /var/named/com-domain-area
rm -f /var/named/10.10.3.area
rm -f /var/named/com-domain-common
rm -f /var/named/10.10.4.common
yum remove -y bind
clear
# reback end

#***************record shell start***************
echo -e "---------------Implementing DNS-Master---------------\n"
yum install -y bind
clear
systemctl start named
systemctl status named | head -10
systemctl enable named.service
systemctl list-unit-files | grep named.service
systemctl reload named
systemctl stop firewalld
setenforce 0
echo -e "\n"
read -n1 -p "---------------Please execute Script on Server Slave---------------"
echo -e "\n"
echo -e "---------------Configure DNS master as the primary domain name resolution service---------------\n"

#generate TSIG key on DNS master
cp -f /etc/named.conf /etc/named.conf.bak1
yum install -y bind-utils
tsig-keygen -a hmac-md5 area-key
tsig-keygen -a hmac-md5 common-key
echo -e "\n"
read -p "---------------Please record the two generated keys in time---------------"
echo -e "\n"

#configure primary and secondary synchronization and view on DNS master
sed -i '/zone "." IN {/,+3d' /etc/named.conf
sed -i '/named.rfc1912.zones/d' /etc/named.conf
sed -i 's/127.0.0.1/10.10.2.120/g' /etc/named.conf
sed -i 's/localhost/any/g' /etc/named.conf
sed -i "/allow-query/a allow-transfer {10.10.2.122;};\nalso-notify {10.10.2.122;};\nnotify yes;\nmasterfile-format text;" /etc/named.conf
cat >> /etc/named.conf <<EOF
key "area-key" {
        algorithm hmac-md5;
        secret "areaSecret";
};
key "common-key" {
        algorithm hmac-md5;
        secret "commonSecret";
};
EOF

read -p "Please enter the secret value in the area-key: " areaSecret
sed -i 's#areaSecret#'''$areaSecret'''#g' /etc/named.conf
read -p "Please enter the secret value in the common-key: " commonSecret
sed -i 's#commonSecret#'''$commonSecret'''#g' /etc/named.conf
cat >> /etc/named.conf <<EOF
view "area" {
	match-clients{key area-key; 10.10.2.0/26;};
	server 10.10.2.122 { keys area-key; };
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
	match-clients { key common-key; any;};
	server 10.10.2.122 { keys common-key; };
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

#configure domain name records for specific zones on DNS master
cat > /var/named/com-domain-area <<EOF
\$TTL 1D
@ IN SOA ns.domain.com. root.domain.com. (
	1 ; serial
	1D ; refresh
	1H ; retry
	1W ; expire
3H ) ; minimum
@ IN NS ns.domain.com.
@ IN NS ns1.domain.com.
ns IN A 10.10.2.120
ns1 IN A 10.10.2.122
www IN A 10.10.3.200
ftp IN A 10.10.3.200
EOF

cat > /var/named/10.10.3.area <<EOF
\$TTL 1D
@ IN SOA ns.domain.com. root.domain.com. (
	1 ; serial
	1D ; refresh
	1H ; retry
	1W ; expire
3H ) ; minimum
@ IN NS ns.domain.com.
@ IN NS ns1.domain.com.
120 IN PTR ns.domain.com.
122 IN PTR ns1.domain.com.
200 IN PTR www.domain.com.
200 IN PTR ftp.domain.com.
EOF

#configure the universal zone domain name record on DNS master
cat > /var/named/com-domain-common <<EOF
\$TTL 1D
@ IN SOA ns.domain.com. root.domain.com. (
	1 ; serial
	1D ; refresh
	1H ; retry
	1W ; expire
3H ) ; minimum
@ IN NS ns.domain.com.
@ IN NS ns1.domain.com.
ns IN A 10.10.2.120
ns1 IN A 10.10.2.122
www IN A 10.10.4.200
ftp IN A 10.10.4.200
EOF

cat > /var/named/10.10.4.common <<EOF
\$TTL 1D
@ IN SOA ns.domain.com. root.domain.com. (
	1 ; serial
	1D ; refresh
	1H ; retry
	1W ; expire
3H ) ; minimum
@ IN NS ns.domain.com.
@ IN NS ns1.domain.com.
120 IN PTR ns.domain.com.
122 IN PTR ns1.domain.com.
200 IN PTR www.domain.com.
200 IN PTR ftp.domain.com.
EOF

#verify and reload the bind profile on DNS master
named-checkconf /etc/named.conf
named-checkzone domain.com /var/named/com-domain-area
named-checkzone 3.10.10.in-addr.arpa /var/named/10.10.3.area
named-checkzone domain.com /var/named/com-domain-common
named-checkzone 4.10.10.in-addr.arpa /var/named/10.10.4.common
systemctl reload named
echo -e "\n"
read -n1 -p "---------------Please execute Script on Server Slave---------------"
echo -e "\n"
echo -e "---------------Testing domain name resolution service on DNS master---------------\n"
dig www.domain.com @10.10.2.120
dig www.domain.com @10.10.2.122
echo -e "\n"
read -n1 -p "---------------Please execute Script on Server Slave---------------"

#***************record shell end*****************