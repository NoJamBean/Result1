#!/bin/bash
hostnamectl --static set-hostname SP-IDC-DNSSRV
sed -i "s/^127.0.0.1 localhost/127.0.0.1 localhost VPC2-SP-IDC-DNSSRV/g" /etc/hosts
yum update -y
yum install bind9 bind9-doc language-pack-ko -y

cat <<EOT> /etc/bind/named.conf.options
options {
  directory "/var/cache/bind";
  recursion yes;
  allow-query { any; };
  forwarders {
        8.8.8.8;
        };
  forward only;
  auth-nxdomain no;
};
zone "awsseoul.internal" {
    type forward;
    forward only;
    forwarders { 10.1.3.250; 10.1.4.250; };
};
zone "awssp.internal" {
    type forward;
    forward only;
    forwarders { 10.3.3.250; 10.3.4.250; };
};
EOT

cat <<EOT> /etc/bind/named.conf.local
zone "idcsp.internal" {
    type master;
    file "/etc/bind/db.idcsp.internal";
};

zone ".10.in-addr.arpa" {
    type master;
    file "/etc/bind/db.10.4";
};
EOT

cat <<EOT> /etc/bind/db.idcsp.internal
\$TTL 30
@ IN SOA idcsp.internal. root.idcsp.internal. (
  2019122114 ; serial
  3600       ; refresh
  900        ; retry
  604800     ; expire
  86400      ; minimum ttl
)

; dns server
@      IN NS ns1.idcsp.internal.

; ip address of dns server
ns1    IN A  10.4.1.200

; Hosts
db   IN A  10.4.1.100
dns   IN A  10.4.1.200
EOT

cat <<EOT> /etc/bind/db.10.4
\$TTL 30
@ IN SOA idcsp.internal. root.idcsp.internal. (
  2019122114 ; serial
  3600       ; refresh
  900        ; retry
  604800     ; expire
  86400      ; minimum ttl
)

; dns server
@      IN NS ns1.idcsp.internal.

; ip address of dns server
3      IN PTR  ns1.idcsp.internal.

; A Record list
100.1    IN PTR  db.idcsp.internal.
200.1    IN PTR  dns.idcsp.internal.
EOT

systemctl start bind9 && systemctl enable bind9