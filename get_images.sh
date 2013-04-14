#!/usr/bin/env bash

. common.sh

function SmartOS {

	name="platform-$SMARTOS_VERSION"

	log "SmartOS - $name"

	#Check if its already there
	test -d "$IMAGES/smartos/platform" && log " Skipping" && return 0;

	#Download if not already there
	test -e "$name.tgz" || curl -O "https://download.joyent.com/pub/iso/$name.tgz" || error "Could not download image"
	
	#Prepare the directory
	tar zxf $name.tgz || error
	mkdir -p $IMAGES/smartos/

	mv $name $IMAGES/smartos/platform

}

function SystemRescue {

	name="systemrescuecd-x86-3.5.0.iso"

	log "SystemRescue - $name"

	test -e "$IMAGES/systemrescue/$name" && log " Skipping" && return 0

	test -e "$name" || curl -O "http://ufpr.dl.sourceforge.net/project/systemrescuecd/sysresccd-x86/3.5.0/$name" || error "Could not download image"

	mkdir -p $IMAGES/systemrescue/
	cp $name $IMAGES/systemrescue/

}

function MemTest86 {

	name=memtest86+-4.20.bin

	log "MemTest86 - $name"

	test -e "$IMAGES/memtest86/$name" && log " Skipping" && return 0

	test -e "$name.gz" || curl -O "http://www.memtest.org/download/4.20/$name.gz" || error "Could not download image"

	cat "$name.gz" | gunzip > $name

	mkdir -p $IMAGES/memtest86/
	cp $name $IMAGES/memtest86/

}

function end {
	echo
	log "Done, copy $IMAGES over your http server"
}

#CONFIG
SMARTOS_VERSION=20130405T010449Z

#RUN
SmartOS && SystemRescue && MemTest86 && end

