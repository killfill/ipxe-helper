#!/usr/bin/env bash

. common.sh


git clone -q git://git.ipxe.org/ipxe.git 

log "Updating ipxe"; 
cd ipxe; 
git pull || error "No git?..."


log "Preparing binary"
cd src
copy_template bootstrap.ipxe
make bin/undionly.kpxe EMBED=bootstrap.ipxe > /dev/null || error "Could not compile :("

echo 
log "Done, copy $(pwd)/bin/undionly.kpxe to the TFTP server"
