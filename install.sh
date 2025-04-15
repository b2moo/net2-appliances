#!/bin/sh

# Is it the latest version of this repository ?
oldhash=$(git rev-parse HEAD)
echo "Checking repository for new version ..."
git pull
newhash=$(git rev-parse HEAD)
if [ "$oldhash" != "$newhash" ]; then
    echo "A new version has been pulled, I'll rerun the script"
    sleep 2
    exec ./install.sh "$@"
fi

# Try to install jq
if (! which jq || ! which aria2c); then
    # with nix-shell ?
    if which nix-shell; then
        echo "### Install jq and aria2 with nix-shell"
        sleep 1
        exec nix-shell -p jq -p aria2 --run ./install.sh\ "$@"
    elif which apt; then
        echo "### Install jq and aria2 with apt"
        sleep 1
        sudo apt update
        sudo apt install jq aria2
    fi
fi

. ./config.sh

# Checking that we can connect to GNS3 server
if wget http://$HOST/v2/computes -O /dev/null 2> /dev/null; then
    echo "Connected to GNS3 server (./)"
else
    echo "/!\\ Cannot connect to GNS3, launch it first /!\\"
    exit 1
fi

# custom symbols
echo "### INSTALL custom symbols"
for symb in $SYMBOLS; do
    cp $symb $DATA_DIR/symbols/
done

echo "### IMPORTING APPLIANCES"
for tpl in $TEMPLATES; do
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

# Login so that all image pull work (by GNS3, or "by hand")
docker login $REGISTRY -u $LOGIN -p $PASS



# Download stuff by hand
if [ "$1" = "--pull" ]; then
    echo "### PULL DOCKER IMAGES"
    for img in $IMAGES; do
        docker pull $img
    done
fi

if ! which aria2c; then
    echo "/!\\ aria2c is missing:"
    echo " * install it: \"sudo apt install aria2\""
    echo " * or run ./install.sh --pull"
fi

# -V = seeding if file already here with correct hash
aria2c $TORRENT --enable-dht=false --enable-dht6=false \
    --seed-ratio=0 \
    --seed-time=1 \
	--on-bt-download-complete ./loaddl.sh -V

