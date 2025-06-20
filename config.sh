#!/bin/sh


DATA_DIR=~/GNS3
CONF=~/.config/GNS3/2.2/gns3_server.conf
# useless ?
REGISTRY=registry.cri.epita.fr/daniel.stan/net2-appliances
# Gitlab/Registry credidentials
LOGIN=net2-2025
PASS=FrVHiU2qspikoqzRtsJ_


if [ ! -f $CONF ]; then
    echo "Config file not found at $CONF, is GNS3 installed?"
    exit 1
fi

if ! which jq > /dev/null; then
    echo "Please install \"jq\" first !"
    echo "Ubuntu/Debian: sudo apt install jq"
    echo "nixOS: nix-shell -p jq"
    exit 1
fi

# Template files for GNS3
TEMPLATES="net2-internet.tpl net2-router.tpl net2-machine.tpl net2-secretuser.tpl net2-ca.tpl net2-webserver.tpl"

# Docker images of these templates
IMAGES=$(for t in $TEMPLATES; do jq -r '.image + ""' $t; done | sort | uniq)

# Symbols (icons in GNS3) of these templates
SYMBOLS=$(for t in $TEMPLATES; do jq -r '.symbol + ""' $t; done | grep -v "^:" | sort | uniq)

get_conf() {
    sed "s/^$1 *= \(.*\)$/\1/; t; d" $CONF
}

# Look for a host and port
HOST=$(get_conf host):$(get_conf port)


# Look for a password protected GNS3
if grep -iq "^auth *= *True" $CONF; then
    login=$(sed "s/^user *= *\(.*\)$/\1/; t; d" $CONF)
    pass=$(sed "s/^password *= *\(.*\)$/\1/; t; d" $CONF)
    HOST=$login:$pass@$HOST
fi

TORRENT=docker-v1.10.torrent
