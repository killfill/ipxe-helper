#!/usr/bin/env bash

#set -o xtrace

function log {
	echo "[$(date +"%D %T")] - $@"
}

function error {
	echo "[$(date +"%D %T")] - ERROR: $@"
	exit 1
}

function copy_template {
	NAME=$1
	cp $TEMPLATES/$NAME . || error "Failed to copy $NAME"
}


ROOT="$(pwd)"
TEMPLATES="$ROOT/templates"
WORK="$ROOT/work"
IMAGES="$ROOT/images"

mkdir -p $WORK $IMAGES
cd $WORK

log "(Start)"
echo 