#!/bin/sh

CONFIG=~/GNS3
REGISTRY=registry.cri.epita.fr/daniel.stan/net2-appliances

docker login registry.cri.epita.fr -u students23 -p PYXYgjQAkesJa12YtKs7

# download stuff by hand, because GNS3 seems to fail this :(
docker pull $REGISTRY/net2-internet
docker pull $REGISTRY/net2-secretuser
docker pull $REGISTRY/net2-pebble
docker pull $REGISTRY/net2-router


# custom symbols
cp internet.png $CONFIG/symbols/
cp letsencrypt-logo.png $CONFIG/symbols/
cp linux_guest.svg $CONFIG/symbols/
