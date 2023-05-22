#!/bin/sh

CONFIG=~/GNS3

docker login registry.cri.epita.fr -u students23 -p PYXYgjQAkesJa12YtKs7

# download stuff by hand, because GNS3 seems to fail this :(
docker pull registry.cri.epita.fr/daniel.stan/net2-appliances/net2-internet
docker pull registry.cri.epita.fr/daniel.stan/net2-appliances/net2-machine
#docker pull registry.cri.epita.fr/daniel.stan/net2-appliances/net2-pebble
docker pull registry.cri.epita.fr/daniel.stan/net2-appliances/net2-router


# custom symbols
cp internet.png $CONFIG/symbols/
cp letsencrypt-logo.png $CONFIG/symbols/
cp linux_guest.svg $CONFIG/symbols/
