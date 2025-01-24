#!/bin/sh
read word1
read word2
read word3

cat <<EOF> /etc/ipsec.d/aws.conf
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
  leftsubnet=10.1.0.0/16
  rightsubnet=10.2.4.0/16
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
  leftsubnet=10.1.0.0/16
  rightsubnet=10.2.0.0/16
  dpddelay=10
  dpdtimeout=30
  dpdaction=restart_by_peer
  overlapip=true
EOF

cat <<EOF> /etc/ipsec.d/aws.secrets
$word1 $word2 $word3 : PSK "cloudneta"
EOF

systemctl start ipsec
systemctl enable ipsec
