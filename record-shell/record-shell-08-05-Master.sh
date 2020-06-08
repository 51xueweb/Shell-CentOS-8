#!/usr/bin/bash

######################################## File Description ########################################
# Creation time：2020-05-31
# Project：08
# Task: 05
# Execute example：bash record-shell-x-x.sh
# Detailed description：
# About：http://linux.book.51xueweb.cn
##################################################################################################

# reback start
cd /etc/yum.repos.d
cp CentOS-Base.repo CentOS-Base.repo.bak
cp CentOS-AppStream.repo CentOS-AppStream.repo.bak
cp CentOS-Extras.repo CentOS-Extras.repo.bak

sed -i 's|mirrorlist=|#mirrorlist=|g' CentOS-Base.repo CentOS-AppStream.repo CentOS-Extras.repo
sed -i 's|#baseurl=|baseurl=|g' CentOS-Base.repo CentOS-AppStream.repo CentOS-Extras.repo
sed -i 's|http://mirror.centos.org|https://mirrors.aliyun.com|g' CentOS-Base.repo CentOS-AppStream.repo CentOS-Extras.repo

cp -f /etc/named.conf.bak1 /etc/named.conf
yum remove -y bind-utils 
rm -f /var/named/com-domain-area
rm -f /var/named/10.10.3.area
rm -f /var/named/com-domain-common
rm -f /var/named/10.10.4.common
yum remove -y bind
yum clean all
echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear
# reback end

#***************record shell start***************
echo "[root@Project-08-Task-01 ~]# nmcli"
sleep 3s
nmcli
sleep 3s

echo -e "\n"
read -n1 -p "---------------Please execute Script on Server Slave---------------"
echo -e "\n"

echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear

echo  -e "---------------Install bind---------------\n"
sleep 5s

echo "[root@Project-08-Task-01 ~]# yum install -y bind"
sleep 3s
yum install -y bind
sleep 3s

echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear

echo  -e "---------------Configure named---------------\n"
sleep 5s

echo "[root@Project-08-Task-01 ~]# systemctl start named"
sleep 3s
systemctl start named
sleep 3s

echo "[root@Project-08-Task-01 ~]# systemctl status named | head -10"
sleep 3s
systemctl status named | head -10
sleep 3s

echo "[root@Project-08-Task-01 ~]# systemctl enable named.service"
sleep 3s
systemctl enable named.service
sleep 3s

echo "[root@Project-08-Task-01 ~]# systemctl list-unit-files | grep named.service"
sleep 3s
systemctl list-unit-files | grep named.service
sleep 3s

echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear

echo  -e "---------------Reload named---------------\n"
sleep 5s

echo "[root@Project-08-Task-01 ~]# systemctl reload named"
sleep 3s
systemctl reload named
sleep 3s

echo "[root@Project-08-Task-01 ~]# systemctl stop firewalld"
sleep 3s
systemctl stop firewalld
sleep 3s

echo "[root@Project-08-Task-01 ~]# setenforce 0"
sleep 3s
setenforce 0
sleep 3s

echo -e "\n"
read -n1 -p "---------------Please execute Script on Server Slave---------------"
echo -e "\n"

echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear

echo -e "---------------Configure DNS master as the primary domain name resolution service---------------\n"
sleep 5s

#generate TSIG key on DNS master
echo "[root@Project-08-Task-01 ~]# cp -f /etc/named.conf /etc/named.conf.bak1"
sleep 3s
cp -f /etc/named.conf /etc/named.conf.bak1
sleep 3s

echo "[root@Project-08-Task-01 ~]# yum install -y bind-utils"
sleep 3s
yum install -y bind-utils
sleep 3s

echo "[root@Project-08-Task-01 ~]# tsig-keygen -a hmac-md5 area-key"
sleep 3s
tsig-keygen -a hmac-md5 area-key
sleep 3s

echo "[root@Project-08-Task-01 ~]# tsig-keygen -a hmac-md5 common-key"
sleep 3s
tsig-keygen -a hmac-md5 common-key
sleep 3s

echo -e "\n"
read -p "---------------Please record the two generated keys in time---------------"
echo -e "\n"

echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear

echo -e "---------------Configure primary and secondary synchronization and view---------------"
sleep 5s

#configure primary and secondary synchronization and view on DNS master
echo "[root@Project-08-Task-01 ~]# sed -i '/zone \".\" IN {/,+3d' /etc/named.conf"
sleep 3s
sed -i '/zone "." IN {/,+3d' /etc/named.conf
sleep 3s

echo "[root@Project-08-Task-01 ~]# sed -i '/named.rfc1912.zones/d' /etc/named.conf"
sleep 3s
sed -i '/named.rfc1912.zones/d' /etc/named.conf
sleep 3s

echo "[root@Project-08-Task-01 ~]# sed -i 's/127.0.0.1/10.10.2.120/g' /etc/named.conf"
sleep 3s
sed -i 's/127.0.0.1/10.10.2.120/g' /etc/named.conf
sleep 3s

echo "[root@Project-08-Task-01 ~]# sed -i 's/localhost/any/g' /etc/named.conf"
sleep 3s
sed -i 's/localhost/any/g' /etc/named.conf
sleep 3s

echo "[root@Project-08-Task-01 ~]# sed -i \"/allow-query/a allow-transfer {10.10.2.122;};\nalso-notify {10.10.2.122;};\nnotify yes;\nmasterfile-format text;\" /etc/named.conf"
sleep 3s
sed -i "/allow-query/a allow-transfer {10.10.2.122;};\nalso-notify {10.10.2.122;};\nnotify yes;\nmasterfile-format text;" /etc/named.conf
sleep 3s

echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear

echo "[root@Project-08-Task-01 ~]# cat >> /etc/named.conf <<EOF"
sleep 3s
echo "> key \"area-key\" {"
sleep 3s
echo ">         algorithm hmac-md5;"
sleep 3s
echo ">         secret \"areaSecret\";"
sleep 3s
echo "> };"
sleep 3s
echo "> key \"common-key\" {"
sleep 3s
echo ">         algorithm hmac-md5;"
sleep 3s
echo ">         secret \"commonSecret\";"
sleep 3s
echo "> };"
sleep 3s
echo "> EOF"
sleep 3s

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
sleep 3s

echo "[root@Project-08-Task-01 ~]# sed -i 's#areaSecret#'''$areaSecret'''#g' /etc/named.conf"
sleep 3s
sed -i 's#areaSecret#'''$areaSecret'''#g' /etc/named.conf
sleep 3s

read -p "Please enter the secret value in the common-key: " commonSecret
sleep 3s

echo "[root@Project-08-Task-01 ~]# sed -i 's#commonSecret#'''$commonSecret'''#g' /etc/named.conf"
sleep 3s
sed -i 's#commonSecret#'''$commonSecret'''#g' /etc/named.conf
sleep 3s

echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear

echo "[root@Project-08-Task-01 ~]# cat >> /etc/named.conf <<EOF"
sleep 3s
echo "> view \"area\" {"
sleep 3s
echo "> 	match-clients{key area-key; 10.10.2.0/26;};"
sleep 3s
echo "> 	server 10.10.2.122 { keys area-key; };"
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
echo "> view \"common\" {"
sleep 3s
echo "> 	match-clients { key common-key; any;};"
sleep 3s
echo "> 	server 10.10.2.122 { keys common-key; };"
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

echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear

echo -e "---------------Configure domain name records for specific zones---------------"
sleep 5s

#configure domain name records for specific zones on DNS master
echo "[root@Project-08-Task-01 ~]# cat > /var/named/com-domain-area <<EOF"
sleep 3s
echo "> \\\$TTL 1D"
sleep 3s
echo "> @ IN SOA ns.domain.com. root.domain.com. ("
sleep 3s
echo "> 	1 ; serial"
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
echo "> @ IN NS ns1.domain.com."
sleep 3s
echo "> ns IN A 10.10.2.120"
sleep 3s
echo "> ns1 IN A 10.10.2.122"
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

echo "[root@Project-08-Task-01 ~]# cat > /var/named/10.10.3.area <<EOF"
sleep 3s
echo "> \\\$TTL 1D"
sleep 3s
echo "> @ IN SOA ns.domain.com. root.domain.com. ("
sleep 3s
echo "> 	1 ; serial"
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
echo "> @ IN NS ns1.domain.com."
sleep 3s
echo "> 120 IN PTR ns.domain.com."
sleep 3s
echo "> 122 IN PTR ns1.domain.com."
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

echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear

echo -e "---------------Configure the universal zone domain name record---------------\n"
sleep 5s

#configure the universal zone domain name record on DNS master
echo "[root@Project-08-Task-01 ~]# cat > /var/named/com-domain-common <<EOF"
sleep 3s
echo "> \\\$TTL 1D"
sleep 3s
echo "> @ IN SOA ns.domain.com. root.domain.com. ("
sleep 3s
echo "> 	1 ; serial"
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
echo "> @ IN NS ns1.domain.com."
sleep 3s
echo "> ns IN A 10.10.2.120"
sleep 3s
echo "> ns1 IN A 10.10.2.122"
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

echo "[root@Project-08-Task-01 ~]# cat > /var/named/10.10.4.common <<EOF"
sleep 3s
echo "> \\\$TTL 1D"
sleep 3s
echo "> @ IN SOA ns.domain.com. root.domain.com. ("
sleep 3s
echo "> 	1 ; serial"
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
echo "> @ IN NS ns1.domain.com."
sleep 3s
echo "> 120 IN PTR ns.domain.com."
sleep 3s
echo "> 122 IN PTR ns1.domain.com."
sleep 3s
echo "> 200 IN PTR www.domain.com."
sleep 3s
echo "> 200 IN PTR ftp.domain.com."
sleep 3s
echo "> EOF"
sleep 3s

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

echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear

echo -e "---------------Verify and reload the bind profile on DNS master---------------\n"
sleep 5s

#verify and reload the bind profile on DNS master
echo "[root@Project-08-Task-01 ~]# named-checkconf /etc/named.conf"
sleep 3s
named-checkconf /etc/named.conf
sleep 3s

echo "[root@Project-08-Task-01 ~]# named-checkzone domain.com /var/named/com-domain-area"
sleep 3s
named-checkzone domain.com /var/named/com-domain-area
sleep 3s

echo "[root@Project-08-Task-01 ~]# named-checkzone 3.10.10.in-addr.arpa /var/named/10.10.3.area"
sleep 3s
named-checkzone 3.10.10.in-addr.arpa /var/named/10.10.3.area
sleep 3s

echo "[root@Project-08-Task-01 ~]# named-checkzone domain.com /var/named/com-domain-common"
sleep 3s
named-checkzone domain.com /var/named/com-domain-common
sleep 3s

echo "[root@Project-08-Task-01 ~]# named-checkzone 4.10.10.in-addr.arpa /var/named/10.10.4.common"
sleep 3s
named-checkzone 4.10.10.in-addr.arpa /var/named/10.10.4.common
sleep 3s

echo "[root@Project-08-Task-01 ~]# systemctl reload named"
sleep 3s
systemctl reload named
sleep 3s

echo -e "\n"
read -n1 -p "---------------Please execute Script on Server Slave---------------"
echo -e "\n"

echo "[root@Project-08-Task-01 ~]# clear"
sleep 3s
clear

echo -e "---------------Testing domain name resolution service on DNS master---------------\n"
sleep 5s

echo "[root@Project-08-Task-01 ~]# dig www.domain.com @10.10.2.120"
sleep 3s
dig www.domain.com @10.10.2.120
sleep 3s

echo "[root@Project-08-Task-01 ~]# dig www.domain.com @10.10.2.122"
sleep 3s
dig www.domain.com @10.10.2.122
sleep 3s

#***************record shell end*****************