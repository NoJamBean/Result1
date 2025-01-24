#!/bin/bash
(
echo "qwe123"
echo "qwe123"
) | passwd --stdin root
sed -i "s/^PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
sed -i "s/^#PermitRootLogin yes/PermitRootLogin yes/g" /etc/ssh/sshd_config
service sshd restart
hostnamectl --static set-hostname Seoul-AWS-Web2
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
yum install -y httpd lynx
systemctl start httpd && systemctl enable httpd
mkdir /var/www/inc
curl -o /var/www/inc/dbinfo.inc https://cloudneta-book.s3.ap-northeast-2.amazonaws.com/chapter8/dbinfo.inc
curl -o /var/www/html/db.php https://cloudneta-book.s3.ap-northeast-2.amazonaws.com/chapter8/db.php
rm -rf /var/www/html/index.html
echo "<h1>CloudNet@ FullLab - SeoulRegion - Web2</h1>" > /var/www/html/index.html
curl -o /opt/pingcheck.sh https://cloudneta-book.s3.ap-northeast-2.amazonaws.com/chapter8/pingchecker.sh
chmod +x /opt/pingcheck.sh
cat <<EOT>> /etc/crontab
*/3 * * * * root /opt/pingcheck.sh
EOT
echo "1" > /var/www/html/HealthCheck.txt