#!/bin/sh
hostnamectl --static set-hostname Seoul-IDC-VPN
yum -y install tcpdump openswan

word1=${aws_eip.seoul.public_ip}
word2=${aws_vpn_connection.seoul.tunnel1_address}
word3=${aws_vpn_connection.seoul.tunnel2_address}

cat<<EOT>> /etc/resolv.conf
nameserver 10.2.1.200
EOT

cat <<EOT>> /etc/sysctl.conf
net.ipv4.ip_forward=1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.eth0.send_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.eth0.accept_redirects = 0
net.ipv4.conf.ip_vti0.rp_filter = 0
net.ipv4.conf.eth0.rp_filter = 0
net.ipv4.conf.default.rp_filter = 0
net.ipv4.conf.all.rp_filter = 0
EOT
sysctl -p

cat <<EOT> /etc/ipsec.d/aws.conf
conn Tunnel1
  authby=secret
  auto=start
  left=%defaultroute
  leftid="$word1"
  right="$word2"
  type=tunnel
  ikelifetime=8h
  keylife=1h
  phase2alg=aes128-sha1;modp1024
  ike=aes128-sha1;modp1024
  keyingtries=%forever
  keyexchange=ike
  leftsubnet=10.2.0.0/16
  rightsubnet=10.1.0.0/16
  dpddelay=10
  dpdtimeout=30
  dpdaction=restart_by_peer

conn Tunnel2
  authby=secret
  auto=start
  left=%defaultroute
  leftid="$word1"
  right="$word3"
  type=tunnel
  ikelifetime=8h
  keylife=1h
  phase2alg=aes128-sha1;modp1024
  ike=aes128-sha1;modp1024
  keyingtries=%forever
  keyexchange=ike
  leftsubnet=10.2.0.0/16
  rightsubnet=10.1.0.0/16
  dpddelay=10
  dpdtimeout=30
  dpdaction=restart_by_peer
  overlapip=true
EOT
cat <<EOT> /etc/ipsec.d/aws.secrets
$word1 $word2 $word3 : PSK "cloudneta"
EOT

systemctl start ipsec
systemctl enable ipsec
