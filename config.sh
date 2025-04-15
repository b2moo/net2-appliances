#!/bin/sh


if ! which jq > /dev/null; then
    echo "Please install \"jq\" first !"
    echo "Ubuntu/Debian: sudo apt install jq"
    echo "nixOS: nix-shell -p jq"
    exit 1
fi

# useless ?
REGISTRY=registry.cri.epita.fr/daniel.stan/net2-appliances
# Gitlab/Registry credidentials
LOGIN=net2-2025
PASS=FrVHiU2qspikoqzRtsJ_

# Template files for GNS3
TEMPLATES="net2-internet.tpl net2-router.tpl net2-machine.tpl net2-secretuser.tpl net2-ca.tpl net2-webserver.tpl"

# Docker images of these templates
IMAGES=$(for t in $TEMPLATES; do jq -r '.image + ""' $t; done | sort | uniq)

# Symbols (icons in GNS3) of these templates
SYMBOLS=$(for t in $TEMPLATES; do jq -r '.symbol + ""' $t; done | grep -v "^:" | sort | uniq)

DATA_DIR=~/GNS3
CONF=~/.config/GNS3/2.2/gns3_server.conf
HOST=localhost:3080

# Look for a password protected GNS3
if grep -iq "^auth *= *True" $CONF; then
    login=$(sed "s/^user *= *\(.*\)$/\1/; t; d" $CONF)
    pass=$(sed "s/^password *= *\(.*\)$/\1/; t; d" $CONF)
    HOST=$login:$pass@$HOST
fi

TORRENT=docker-v1.5.torrent
