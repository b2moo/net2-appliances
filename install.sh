#!/bin/sh

DATA_DIR=~/GNS3
REGISTRY=registry.cri.epita.fr/daniel.stan/net2-appliances
CONF=~/.config/GNS3/2.2/gns3_server.conf
HOST=localhost:3080
# Gitlab credidentials
LOGIN=net2-2024
PASS=ZMddwrbApgpMMozoBh1L

# Is it the latest version of this repository ?
oldhash=$(git rev-parse HEAD)
echo "Checking repository for new version ..."
git pull
newhash=$(git rev-parse HEAD)
if [ "$oldhash" != "$newhash" ]; then
    echo "A new version has been pulled, I'll rerun the script"
    sleep 2
    exec ./install.sh
fi



# Look for a password protected GNS3
if grep -iq "^auth *= *True" $CONF; then
    login=$(sed "s/^user *= *\(.*\)$/\1/; t; d" $CONF)
    pass=$(sed "s/^password *= *\(.*\)$/\1/; t; d" $CONF)
    HOST=$login:$pass@$HOST
fi

# Checking that we can connect to GNS3 server
if wget http://$HOST/v2/computes -O /dev/null; then
    echo "Connected to server (./)"
else
    echo "!!!! Cannot connect to GNS3, launch it first !!!!"
    exit 1
fi


docker login registry.cri.epita.fr -u $LOGIN -p $PASS

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
for tpl in net2-internet.tpl net2-router.tpl net2-machine.tpl net2-secretuser.tpl net2-pebble.tpl; do
    echo -n "  deleting first $tpl ..."
    id=$(jq -r '.["template_id"]' $tpl)
    if wget --method=DELETE http://$HOST/v2/templates/$id -O /dev/null 2> /dev/null; then
        echo "success";
    else
        echo "failed"
    fi

    echo -n "  importing $tpl ..."
    if wget http://$HOST/v2/templates --post-file=./$tpl -O /dev/null 2> /dev/null; then
        echo "success";
    else
        echo "failed"
    fi
done
