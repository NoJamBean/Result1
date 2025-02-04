#!/bin/bash

hostnamectl --static set-hostname Seoul-AWS-Web1
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
yum install -y httpd lynx
systemctl start httpd && systemctl enable httpd

cat<<EOT >> /etc/resolv.conf
nameserver 10.1.3.250
nameserver 10.1.4.250
EOT

mkdir /var/www/inc
curl -o /var/www/inc/dbinfo.inc php https://raw.githubusercontent.com/NoJamBean/Result1/refs/heads/main/dbinfo.inc
curl -o /var/www/html/db.php https://raw.githubusercontent.com/NoJamBean/Result1/refs/heads/main/db.php
rm -rf /var/www/html/index.html
echo "<h1>SeoulRegion - Web1</h1>" > /var/www/html/index.html
curl -o /opt/pingcheck.sh https://cloudneta-book.s3.ap-northeast-2.amazonaws.com/chapter8/pingchecker.sh
chmod +x /opt/pingcheck.sh
cat <<EOT>> /etc/crontab
*/3 * * * * root /opt/pingcheck.sh
EOT
echo "1" > /var/www/html/HealthCheck.txt 