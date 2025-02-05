#!/bin/bash

hostnamectl --static set-hostname Seoul-AWS-Web1
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
yum install -y httpd lynx
systemctl start httpd && systemctl enable httpd

rm -rf /var/www/html/index.html
curl -o /var/www/html/index.html https://raw.githubusercontent.com/NoJamBean/Result1/refs/heads/main/testindex.html
sed -i "s/메인 제목/SeoulRegion - Web1/g" /var/www/html/index.html

curl -o /var/www/html/insert.php https://raw.githubusercontent.com/NoJamBean/Result1/refs/heads/main/insert.php
curl -o /var/www/html/select.php https://raw.githubusercontent.com/NoJamBean/Result1/refs/heads/main/select.php
curl -o /var/www/html/result.php https://raw.githubusercontent.com/NoJamBean/Result1/refs/heads/main/result.php

curl -o /opt/pingcheck.sh https://cloudneta-book.s3.ap-northeast-2.amazonaws.com/chapter8/pingchecker.sh
chmod +x /opt/pingcheck.sh
cat <<EOT>> /etc/crontab
*/3 * * * * root /opt/pingcheck.sh
EOT
echo "1" > /var/www/html/HealthCheck.txt 

systemctl restart httpd