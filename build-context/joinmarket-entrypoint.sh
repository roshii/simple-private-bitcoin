#!/bin/ash
set -eux

SSLDIR="/home/satoshi/.joinmarket/ssl"

if [ ! -e "${SSLDIR}/key.pem" ] ; then
  mkdir -p "$SSLDIR"
  openssl ecparam -name secp256k1 -genkey -noout -out "${SSLDIR}/key.pem"
  openssl ec -in "${SSLDIR}/key.pem" -pubout -out "${SSLDIR}/pub.pem"
  openssl req -new -x509 -key "${SSLDIR}/key.pem" -out "${SSLDIR}/cert.pem" -days 360 -nodes \
    -subj "/CN=joinmarket"
fi

"$@"