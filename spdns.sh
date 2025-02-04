#!/bin/bash
cat<<EOT > /etc/resolv.conf
nameserver 10.4.1.200
nameserver 8.8.8.8
nameserver 8.8.4.4
EOT
hostnamectl --static set-hostname SP-IDC-DNS

yum clean all
yum update -y
yum install -y bind bind-utils glibc-langpack-ko

sed -i 's/listen-on port 53 { 127.0.0.1; };/listen-on port 53 { any; };/g' /etc/named.conf
sed -i 's/{ localhost; };/{ any; };/g' /etc/named.conf
sed -i 's/dnssec-validation yes;/dnssec-validation no;/g' /etc/named.conf
sed -i 's/dnssec-enable yes;/dnssec-enable no;/g' /etc/named.conf


cat <<EOT >> /etc/named.rfc1912.zones
zone "idcsp.internal" {
    type master;
    file "/var/named/idcsp.internal.zone";
};

zone "awsseoul.internal" {
    type forward;
    forwarders { 10.1.3.250; 10.1.4.250; };
};

zone "awssp.internal" {
    type forward;
    forwarders { 10.3.3.250; 10.3.4.250;};
};

zone "idcseoul.internal" {
    type forward;
    forwarders { 10.2.1.200; };
};
EOT

cat <<EOT > /var/named/idcsp.internal.zone
\$TTL 86400
@   IN  SOA     ns.idcsp.internal. admin.idcsp.internal. (
        2025010801 ; Serial
        3600       ; Refresh
        1800       ; Retry
        1209600    ; Expire
        86400 )    ; Minimum TTL
@       IN  NS      ns.idcsp.internal.
ns      IN  A       10.4.1.200
dns     IN  A       10.4.1.200
db      IN  A       10.4.1.100
EOT

chown root:named /etc/named.conf /var/named/idcsp.internal.zone
chmod 640 /etc/named.conf
chmod 640 /var/named/idcsp.internal.zone

systemctl enable named
systemctl start named