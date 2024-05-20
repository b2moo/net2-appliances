#!/bin/sh

. ./config.sh

if [ "$1" = "" ] || (echo "$1" | grep -qv "^docker-"); then
  echo "Please provide a temp directory of the form docker-.*"
  exit 1
fi
TARGET="$1"

if [ -e "$TARGET" ] && [ "$2" != "--continue" ]; then
  echo "Directory $TARGET already there !"
  exit 2
elif [ ! -e "$TARGET" ]; then
  mkdir "$TARGET"
fi


for path in $IMAGES; do
  name=$(echo "$path" | sed "s/^.*\///")
  echo "Compressing $name with $path"
  if [ -e "$TARGET/$name.tar.gz" ]; then
    echo "  already there"
    continue
  fi
  docker save $path:latest | gzip > $TARGET/$name.tar.gz
done

rsync -rv $TARGET dstan@zamok.crans.org:www/net2/

mktorrent --no-date -a http://torrent.pie.cri.epita.fr:8000/announce \
  -w https://perso.crans.org/dstan/net2/ \
  $TARGET
