#!/bin/bash

hostnamectl --static set-hostname Seoul-IDC-DB

yum install -y mariadb-server mariadb lynx
systemctl start mariadb && systemctl enable mariadb

cat <<EOT > /etc/my.cnf
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
symbolic-links=0
collation-server = utf8mb4_unicode_ci
init-connect='SET NAMES utf8'
character-set-server=utf8mb4
server-id=1
log-bin= /var/lib/mysql/binlog
binlog-format=ROW

[client]
default-character-set=utf8mb4

[mysql]
default-character-set=utf8mb4

[mysqld_safe]
log-error=/var/log/mariadb/mariadb.log
pid-file=/var/run/mariadb/mariadb.pid

!includedir /etc/my.cnf.d
EOT

systemctl restart mariadb

echo -e "\n\nqwe123\nqwe123\ny\ny\ny\ny\n" | /usr/bin/mysql_secure_installation
mysql -uroot -pqwe123 -e "CREATE USER 'user1'@'%' identified by 'p@ssw0rd';"
mysql -uroot -pqwe123 -e "GRANT all privileges ON *.* TO user1@'%' with grant option;"
mysql -uroot -pqwe123 -e "CREATE DATABASE sqlDB; GRANT ALL PRIVILEGES ON *.* TO 'user1'@'%' IDENTIFIED BY 'qwe123'; GRANT REPLICATION SLAVE ON *.* TO 'rep'@'%' IDENTIFIED BY 'qwe123'; flush privileges;"
mysql -uroot -pqwe123 -e "GRANT SELECT ON sqlDB.* TO 'rep'@'%' IDENTIFIED BY 'qwe123';FLUSH PRIVILEGES;"
mysql -uroot -pqwe123 -e "USE sqlDB;CREATE TABLE userTBL( userID CHAR(8) NOT NULL PRIMARY KEY, name NVARCHAR(50) NOT NULL, birthYear CHAR(10), email VARCHAR(30), mDATE DATE);"

mysql -uroot -pqwe123 -e "SHOW MASTER STATUS\G" > /tmp/master_status
MASTER_LOG_FILE=$(awk '/File:/ {print $2}' /tmp/master_status)
MASTER_LOG_POS=$(awk '/Position:/ {print $2}' /tmp/master_status)

echo "MASTER_LOG_FILE=$MASTER_LOG_FILE" >> /etc/environment
echo "MASTER_LOG_POS=$MASTER_LOG_POS" >> /etc/environment

cat << EOT > data.sql
USE sqlDB;
INSERT INTO userTBL(userID, name, birthYear, email, mDATE) 
VALUES('god', '신창섭', NULL, '2012-4-4');
INSERT INTO userTBL(userID, name, birthYear, email, mDATE) 
VALUES('trash', '강원기', '1950', 'sss@email.com', '2009-4-4');
INSERT INTO userTBL(userID, name, birthYear, email, mDATE)
VALUES('brg', '오한별', '1979', NULL, '2013-12-12');
INSERT INTO userTBL(userID, name, birthYear, email, mDATE)
VALUES('reboot', '황선영', '1963', NULL, '2009-9-9');
INSERT INTO userTBL(userID, name, birthYear, email, mDATE)
VALUES('gaga', '가가', '1963', 'jiho22@email.com','2009-9-9');
EOT

mysql -uroot -pqwe123 < data.sql

[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
symbolic-links=0           
log-bin=mysql-bin
server-id=1
[mysqld_safe]
log-error=/var/log/mariadb/mariadb.log
pid-file=/var/run/mariadb/mariadb.pid
!includedir /etc/my.cnf.d
EOT
systemctl restart mariadb
cat <<EOT> /home/ec2-user/list.txt
10.1.3.100
web1.awsseoul.internal
10.1.4.100
web2.awsseoul.internal
10.2.1.100
db.idcseoul.internal
10.2.1.200
dns.idcseoul.internal
10.3.3.100
web1.awssp.internal
10.4.1.100
db.idcsp.internal
10.4.1.200
dns.idcsp.internal
EOT
curl -o /home/ec2-user/pingall.sh https://cloudneta-book.s3.ap-northeast-2.amazonaws.com/chapter6/pingall.sh --s
chmod +x /home/ec2-user/pingall.sh