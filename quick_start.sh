#!/bin/bash
set -e

NAME=mypurpose
OVPN_DATA=ovpn-data-$NAME
IMAGE=rvben/rpi-openvpn
SERVER=vpn.example.com
CLIENT=client

docker volume create --name $OVPN_DATA
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm $IMAGE ovpn_genconfig -u udp://$SERVER
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it $IMAGE ovpn_initpki

docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it $IMAGE easyrsa build-client-full $CLIENT nopass
docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm $IMAGE ovpn_getclient $CLIENT > $CLIENT.ovpn

curl -L https://raw.githubusercontent.com/kylemanna/docker-openvpn/master/init/docker-openvpn%40.service | sed -e "s|kylemanna/openvpn|${IMAGE}|" | sudo tee /etc/systemd/system/docker-openvpn@.service

systemctl enable docker-openvpn@$NAME
systemctl start docker-openvpn@$NAME
