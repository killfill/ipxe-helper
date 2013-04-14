#!/usr/bin/env bash

. common.sh

function SmartOS {

	name="platform-$SMARTOS_VERSION"

	#Check if its already there
	test -d "$IMAGES/smartos/$SMARTOS_VERSION" && log "Skipping SmartOS" && return 0;

	log "SmartOS - $name"

	#Download if not already there
	test -e "$name.tgz" || curl -O "https://download.joyent.com/pub/iso/$name.tgz" || error "Could not download image"
	
	#Prepare the directory
	tar zxf $name.tgz || error
	mkdir -p $IMAGES/smartos/$SMARTOS_VERSION

	mv $name $IMAGES/smartos/$SMARTOS_VERSION/platform

}

function end {
	echo
	log "Done, copy $IMAGES over your http server"
}

#CONFIG
SMARTOS_VERSION=20130405T010449Z

#RUN
SmartOS && end