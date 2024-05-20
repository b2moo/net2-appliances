#!/bin/sh
# called by aria2c when torrent dowload is over
# $1 = gid, $2 = number of files, $3 = one of the files' path
#

DIR="$(dirname "$3")"
for n in $(ls "$DIR"); do
  echo "Loading $n into docker"
  docker load -i "$DIR/$n"
done
