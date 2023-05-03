#!/bin/sh

docker login registry.cri.epita.fr -u students23 -p PYXYgjQAkesJa12YtKs7

# download stuff by hand, because GNS3 seems to fail this :(
docker pull registry.cri.epita.fr/daniel.stan/net2-appliances/net2-internet
docker pull registry.cri.epita.fr/daniel.stan/net2-appliances/net2-router
