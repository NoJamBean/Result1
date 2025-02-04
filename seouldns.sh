#!/bin/bash

cat<<EOT > /etc/resolv.conf
nameserver 10.2.1.200
nameserver 8.8.8.8
nameserver 8.8.4.4
EOT

hostnamectl --static set-hostname Seoul-IDC-DNS

yum clean all
yum update -y
yum install -y bind bind-utils glibc-langpack-ko

cat <<EOT > /etc/named.conf
options {
        listen-on port 53 { any; };
        listen-on-v6 port 53 { none; };
        directory       "/var/named";
        dump-file       "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";
        recursing-file  "/var/named/data/named.recursing";
        secroots-file   "/var/named/data/named.secroots";
dump-file       "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";
        recursing-file  "/var/named/data/named.recursing";
        secroots-file   "/var/named/data/named.secroots";
        allow-query     { any; };

        recursion yes;

        dnssec-enable no;
        dnssec-validation no;

        bindkeys-file "/etc/named.root.key";

        managed-keys-directory "/var/named/dynamic";

        pid-file "/run/named/named.pid";
        session-keyfile "/run/named/session.key";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

zone "." IN {
        type hint;
        file "named.ca";
};

include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";                                                                                                                                        14,29-36      12%
EOT

cat <<EOT >> /etc/named.rfc1912.zones
zone "idcseoul.internal" {
    type master;
    file "/var/named/idcseoul.internal.zone";
};

zone "awsseoul.internal" {
    type forward;
    forwarders { 10.1.3.250; 10.1.4.250; };
};

zone "awssp.internal" {
    type forward;
    forwarders { 10.3.3.250; 10.3.4.250; };
};

zone "idcsp.internal" {
    type forward;
    forwarders { 10.4.1.200; };
};
EOT

cat <<EOT > /var/named/idcseoul.internal.zone
\$TTL 86400
@   IN  SOA     ns.idcseoul.internal. admin.idcseoul.internal. (
        2025010801 ; Serial
        3600       ; Refresh
        1800       ; Retry
        1209600    ; Expire
        86400 )    ; Minimum TTL
@       IN  NS      ns.idcseoul.internal.
ns      IN  A       10.2.1.200
dns     IN  A       10.2.1.200
db      IN  A       10.2.1.100
EOT

chown root:named /etc/named.conf /var/named/idcseoul.internal.zone
chmod 640 /etc/named.conf
chmod 640 /var/named/idcseoul.internal.zone

systemctl enable named
systemctl start named