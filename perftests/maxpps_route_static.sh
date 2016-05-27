#!/bin/sh

. $(dirname "$0")/../lib/init.sh

. $WDIR/config

STEP=100
MAX=5000

for QUEUES in `seq 1 12`; do
	TXT_LOG=$(logname ${QUEUES}_txt)
	IPGEN_LOG=$(logname ${QUEUES}_ipgen)
	$UDIR/set_num_queues.sh $GW_TX $QUEUES | tee -a $TXT_LOG
	echo "100 tx1 46 3000000" > $TMPSCRIPT
	$UDIR/ipgen.sh $GW_TX $GW_RX 1000 $TMPSCRIPT $IPGEN_LOG
done

