#!/bin/bash

cat<<EOT >> /etc/resolv.conf
nameserver 10.3.3.250
nameserver 10.3.4.250
EOT

hostnamectl --static set-hostname SP-AWS-Web1
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
yum install -y httpd lynx
systemctl start httpd && systemctl enable httpd

m -rf /var/www/html/index.html
curl -o /var/www/html/index.html https://raw.githubusercontent.com/NoJamBean/Result1/refs/heads/main/testindex.html
sed -i "s/메인 제목/SPRegion - Web/g" /etc/hosts

curl -o /var/www/html/sp_insert.php https://raw.githubusercontent.com/NoJamBean/Result1/refs/heads/main/sp_insert.php
curl -o /var/www/html/sp_select.php https://raw.githubusercontent.com/NoJamBean/Result1/refs/heads/main/sp_select.php
curl -o /var/www/html/sp_result.php https://raw.githubusercontent.com/NoJamBean/Result1/refs/heads/main/sp_result.php

curl -o /opt/pingcheck.sh https://cloudneta-book.s3.ap-northeast-2.amazonaws.com/chapter8/pingchecker.sh
chmod +x /opt/pingcheck.sh
cat <<EOT>> /etc/crontab
*/3 * * * * root /opt/pingcheck.sh
EOT
echo "1" > /var/www/html/HealthCheck.txt

systemctl restart httpd