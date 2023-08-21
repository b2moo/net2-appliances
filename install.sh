#!/bin/sh

DATA_DIR=~/GNS3
REGISTRY=registry.cri.epita.fr/daniel.stan/net2-appliances
CONF=~/.config/GNS3/2.2/gns3_server.conf
HOST=localhost:3080

if grep -iq "^auth *= *True" $CONF; then
    login=$(sed "s/^user *= *\(.*\)$/\1/; t; d" $CONF)
    pass=$(sed "s/^password *= *\(.*\)$/\1/; t; d" $CONF)
    HOST=$login:$pass@$HOST
fi

docker login registry.cri.epita.fr -u rattrapage2023 -p s8KGxaPWBYfCR899beCy

# download stuff by hand, because GNS3 seems to fail this :(
echo "### PULL DOCKER IMAGES"
docker pull $REGISTRY/net2-internet
docker pull $REGISTRY/net2-secretuser
docker pull $REGISTRY/net2-pebble
docker pull $REGISTRY/net2-router
docker pull $REGISTRY/net2-webserver


# custom symbols
echo "### INSTALL custom symbols"
cp internet.png $DATA_DIR/symbols/
cp letsencrypt-logo.png $DATA_DIR/symbols/
cp linux_guest.svg $DATA_DIR/symbols/
cp secret_user.svg $DATA_DIR/symbols/
cp webserver.svg $DATA_DIR/symbols/


echo "### IMPORTING APPLIANCES"
wget http://$HOST/v2/templates --post-file=./net2-internet.tpl -O -
wget http://$HOST/v2/templates --post-file=./net2-router.tpl -O -
wget http://$HOST/v2/templates --post-file=./net2-machine.tpl -O -
wget http://$HOST/v2/templates --post-file=./net2-secretuser.tpl -O -
wget http://$HOST/v2/templates --post-file=./net2-pebble.tpl -O -
wget http://$HOST/v2/templates --post-file=./net2-webserver.tpl -O -
