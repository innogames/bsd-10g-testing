#!/bin/sh

WDIR=$(dirname "$0")
LOGBASE=$(basename "$0")
UDIR=$WDIR/../utils
LOGDIR=$WDIR/../logs
TMPSCRIPT=/tmp/ipgen.script

logname () {
	echo "${LOGDIR}/${LOGBASE}_$1.log"
}
