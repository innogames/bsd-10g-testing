#!/bin/sh

. $(dirname "$0")/../lib/init.sh

. $WDIR/config

FLOWS=1000

for QUEUES in `seq 1 12`; do
	TXT_LOG=$(logname ${QUEUES}_txt)
	IPGEN_LOG=$(logname ${QUEUES}_ipgen)
	date | tee -a $TXT_LOG
	echo "Running test on $QUEUES" | tee -a $TXT_LOG
	$UDIR/set_num_queues.sh $GW_TX $QUEUES | tee -a $TXT_LOG
	echo "180 tx1 46 3000000" > $TMPSCRIPT
	$UDIR/ipgen.sh $GW_TX $GW_RX $FLOWS $TMPSCRIPT $IPGEN_LOG
done

