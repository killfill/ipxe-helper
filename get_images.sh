#!/usr/bin/env bash

. common.sh

function SmartOS {

	version="$1"
	file="platform-${version}"

	log "SmartOS - $version"

	#Check if its already there
	test -d "$IMAGES/smartos/platform" && log " Skipping" && return 0;

	#Download if not already there
	test -e "$file.tgz" || curl -O "http://us-east.manta.joyent.com/Joyent_Dev/public/SmartOS/$version/$file.tgz" || error "Could not download image"
	
	#Prepare the directory
	tar zxf $file.tgz || error
	mkdir -p $IMAGES/smartos/
	mv $file $IMAGES/smartos/platform

}

function SystemRescue {

	version=$1
	name="systemrescuecd-x86-${version}.iso"

	log "SystemRescue - $version"

	test -e "$IMAGES/systemrescue/$name" && log " Skipping" && return 0

	test -e "$name" || curl -O "http://ufpr.dl.sourceforge.net/project/systemrescuecd/sysresccd-x86/$version/$name" || error "Could not download image"

	mkdir -p $IMAGES/systemrescue/
	cp $name $IMAGES/systemrescue/

}

function MemTest86 {

	log "MemTest86 - $name"

	filezip="memtest86-iso.zip"
	fileiso="Memtest86-6.1.0.iso"

	test -e "$IMAGES/memtest86/${fileiso}" && log " Skipping" && return 0

	test -e "${filezip}" || curl -O "http://www.memtest86.com/downloads/${filezip}" || error "Could not download image"

	unzip memtest86-iso.zip

	mkdir -p $IMAGES/memtest86/
	cp $fileiso $IMAGES/memtest86/

}

#Hardware Detection Tool
function HDT {
	version=$1
	file="hdt-0.5.2.iso"

	log "HDT - $version"

	test -e "$IMAGES/hdt/$file" && log " Skipping" && return 0
	test -e "$file" || curl -O "http://www.hdt-project.org/raw-attachment/wiki/hdt-0.5.0/$file" || error "Could not download image"

	mkdir -p $IMAGES/hdt/
	cp $file $IMAGES/hdt/

}

function Ubuntu {

	#URLs from http://cdimage.ubuntu.com/netboot/

	version=$1
	arch=$2

	log "Ubuntu netinstall - $version $arch"

	test -e "$IMAGES/ubuntu/linux" && log " Skipping" && return 0

	mkdir -p ubuntu
	cd ubuntu

	url="http://archive.ubuntu.com/ubuntu/dists/${version}-updates/main/installer-${arch}/current/images/netboot/ubuntu-installer/${arch}"

	test -e initrd.gz || wget $url/initrd.gz || error "Could not download initrd.gz"
	test -e linux || wget $url/linux || error "Could not download linux"

	cd ..
	cp -rip ubuntu $IMAGES
}

function end {
	echo
	log "Done, sync $IMAGES over your http server"
	log "i.e. rsync -av templates/* root@your-fw:/usr/local/www/"
	log "     rsync -av images root@your-fw:/usr/local/www/"
	log ""
	log "Tip: SmartOS needs ln -s /usr/local/www/images/smartos /usr/local/www/smartos"
}

#RUN

#Need to check out ubuntu... probable will need a preseed.cfg file.. :S
#SmartOS 20150430T082110Z && SystemRescue 4.5.2 && MemTest86 && HDT 0.5.2 && Ubuntu 14.04.2 && end

SmartOS 20150430T082110Z && Ubuntu trusty amd64 && SystemRescue 4.5.2 && MemTest86 && HDT 0.5.2 && end
