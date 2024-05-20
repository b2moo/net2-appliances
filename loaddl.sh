#!/bin/sh
# called by aria2c when torrent dowload is over
# $1 = gid, $2 = number of files, $3 = one of the files' path
#

DIR="$(dirname "$3")"
for n in $(ls "$DIR"); do
  echo "Loading $n into docker"
  docker load -i "$DIR/$n"
done

cat << "EOF"
  _   _ ______ _______ ___    _                          _       
 | \ | |  ____|__   __|__ \  (_)                        | |      
 |  \| | |__     | |     ) |  _ ___   _ __ ___  __ _  __| |_   _ 
 | . ` |  __|    | |    / /  | / __| | '__/ _ \/ _` |/ _` | | | |
 | |\  | |____   | |   / /_  | \__ \ | | |  __/ (_| | (_| | |_| |
 |_| \_|______|  |_|  |____| |_|___/ |_|  \___|\__,_|\__,_|\__, |
                                                            __/ |
                                                           |___/ 
EOF
