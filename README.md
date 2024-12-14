# RPi - OpenVPN for Docker
## Raspberry Pi version builder for OpenVPN server in a Docker container

This repository contains the script to build the Raspberry Pi version of the [kylemanna/openvpn](https://github.com/kylemanna/docker-openvpn) image.

For more info about this image and its usage, click [here](https://github.com/kylemanna/docker-openvpn/blob/master/README.md).
(And remember to replace kylemanna/openvpn with rvben/rpi-openvpn if you want to use the image built for the Raspberry Pi.)


For convenience, a copy of the 'Quick Start' section of [kylemanna/openvpn](https://github.com/kylemanna/docker-openvpn) is included below:

## Quick Start

* Pick a name for the `$OVPN_DATA` data volume container. It's recommended to
  use the `ovpn-data-` prefix to operate seamlessly with the reference systemd
  service.  Users are encourage to replace `example` with a descriptive name of
  their choosing.

        OVPN_DATA="ovpn-data-example"

* Initialize the `$OVPN_DATA` container that will hold the configuration files
  and certificates.  The container will prompt for a passphrase to protect the
  private key used by the newly generated certificate authority.

        docker volume create --name $OVPN_DATA
        docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm rvben/rpi-openvpn ovpn_genconfig -u udp://VPN.SERVERNAME.COM
        docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it rvben/rpi-openvpn ovpn_initpki

* Start OpenVPN server process

        docker run -v $OVPN_DATA:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN --device=/dev/net/tun rvben/rpi-openvpn

* Generate a client certificate without a passphrase

        docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm -it rvben/rpi-openvpn easyrsa build-client-full CLIENTNAME nopass

* Retrieve the client configuration with embedded certificates

        docker run -v $OVPN_DATA:/etc/openvpn --log-driver=none --rm rvben/rpi-openvpn ovpn_getclient CLIENTNAME > CLIENTNAME.ovpn
