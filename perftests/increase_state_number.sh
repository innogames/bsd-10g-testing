#!/bin/sh

. $(dirname "$0")/../lib/init.sh

. $WDIR/config


for STATES in 1 10 25 50 100 250 500 750 1000 2500; do
	TXT_LOG=$(logname ${QUEUES}_txt)
	IPGEN_LOG=$(logname ${QUEUES}_ipgen)
	date | tee -a $TXT_LOG
	STATES=$(( $STATES * 1000 ))
	echo "Running test with $STATES states" | tee -a $TXT_LOG
	echo "180 tx1 46 3000000" > $TMPSCRIPT
	$UDIR/ipgen.sh $GW_TX $GW_RX $STATES $TMPSCRIPT $IPGEN_LOG
	ssh $GW_TX 'time /sbin/pfct -Fs'
	sleep 30
done

