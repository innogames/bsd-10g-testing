#!/bin/sh

. $(dirname "$0")/../lib/init.sh

. $WDIR/config

STEP=100

for QUEUES in `seq 1 6`; do
	TXT_LOG=$(logname ${QUEUES}_txt)
	IPGEN_LOG=$(logname ${QUEUES}_ipgen)
	$UDIR/set_num_queues.sh $GW_TX $QUEUES | tee -a $TXT_LOG
	$UDIR/gen_ipgen_script.sh $STEP 10000 > $TMPSCRIPT
	$UDIR/ipgen.sh $GW_TX $GW_RX 1000 $TMPSCRIPT $IPGEN_LOG
done

