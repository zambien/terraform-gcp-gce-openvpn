#!/usr/bin/env bash

# get dat IP ADDR data
ENDPOINT_SERVER=$1

# if you are running this you must want to start from scratch with your certs... well I hope so at least...
rm -R pki

# setup the pki
if [[ ! -f pki/ca.crt ]];then
    docker run --user=$(id -u) -e OVPN_CN=$ENDPOINT_SERVER  -e OVPN_SERVER_URL=tcp://$ENDPOINT_SERVER:1194 -i -v $PWD:/etc/openvpn zambien/terraform-gcp-openvpn ovpn_initpki nopass $ENDPOINT_SERVER
fi