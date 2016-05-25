#!/bin/sh

usage() {
	echo "I expect the following parameters:"
	echo " - IP of remote server to send traffic to"
	echo " - IP of remote server to receive traffic from"
	exit 1
}

[ -z "$1" ] || [ -z "$2" ] && usage
GW_TX=$1
GW_RX=$2

STEP=100
SCRIPT=/tmp/ipgen.script

WDIR=$(dirname "$0")
UDIR=$WDIR/../utils
LOGBASE=$(basename "$0")

for QUEUES in `seq 1 6`; do
	LOG="${LOGBASE}_$QUEUES.log"
	$UDIR/set_num_queues.sh $GW_TX $QUEUES
	$UDIR/gen_ipgen_script.sh $STEP 10000 > $SCRIPT
	$UDIR/ipgen.sh $GW_TX $GW_RX 1000 $SCRIPT $LOG
done

