#!/bin/sh

CONFIG=~/GNS3
REGISTRY=registry.cri.epita.fr/daniel.stan/net2-appliances

docker login registry.cri.epita.fr -u students23 -p PYXYgjQAkesJa12YtKs7

# download stuff by hand, because GNS3 seems to fail this :(
echo "### PULL DOCKER IMAGES"
docker pull $REGISTRY/net2-internet
docker pull $REGISTRY/net2-secretuser
docker pull $REGISTRY/net2-pebble
docker pull $REGISTRY/net2-router
docker pull $REGISTRY/net2-webserver


# custom symbols
echo "### INSTALL custom symbols"
cp internet.png $CONFIG/symbols/
cp letsencrypt-logo.png $CONFIG/symbols/
cp linux_guest.svg $CONFIG/symbols/
cp secret_user.svg $CONFIG/symbols/
cp webserver.svg $CONFIG/symbols/


echo "### IMPORTING APPLIANCES"
wget http://localhost:3080/v2/templates --post-file=./net2-internet.tpl -O -
wget http://localhost:3080/v2/templates --post-file=./net2-router.tpl -O -
wget http://localhost:3080/v2/templates --post-file=./net2-machine.tpl -O -
wget http://localhost:3080/v2/templates --post-file=./net2-secretuser.tpl -O -
wget http://localhost:3080/v2/templates --post-file=./net2-pebble.tpl -O -
wget http://localhost:3080/v2/templates --post-file=./net2-webserver.tpl -O -
