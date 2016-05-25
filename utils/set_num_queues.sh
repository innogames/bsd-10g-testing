#!/bin/sh

usage () {
	echo "I expect the following parameters:"
	echo " - host to connect to (or 'local' for remote operation)"
	echo " - number of queues on IX interfaces"
	exit 1
}

UDIR=$(dirname "$0")

[ -z "$1" ] || [ -z "$2" ] && usage

if [ "$1" = "local" ]; then
	echo "Configuring local system to use $2 queues"
	if grep -qE '^hw.ix.num_queues=' /boot/loader.conf; then
		sed -i '' -E 's/^(hw.ix.num_queues=).*/\1'"$2"'/' /boot/loader.conf
	else 
		echo "hw.ix.num_queues=$2" >> /boot/loader.conf
	fi
	/sbin/reboot
else
	echo "Configuring remote system to use $2 queues"
	scp $UDIR/pincpus.sh $UDIR/set_num_queues.sh root@$1:/tmp
	ssh root@$1 /tmp/set_num_queues.sh local $2
	echo "Waiting 30s for reboot"
	sleep 30
	echo  "Waiting for $1 to come back"
	while !	ssh -o ConnectTimeout=5 root@$1 /bin/echo 2>/dev/null; do
		sleep 5
	done
	# Unfortunately IRQs are not visible until some traffic is sent through.
	# So sent a bit of traffic and only then pin CPUs.
	echo "Unfreezing IRQs"
	$UDIR/ipgen.sh $GW_TX $GW_RX 1000 $UDIR/enable_irqs /dev/null > /dev/null
	ssh root@$1 /tmp/pincpus.sh
fi

