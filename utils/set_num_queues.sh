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
	if grep -qE '^hw.ix.num_queues=' /boot/loader.conf; then
		sed -i '' -E 's/^(hw.ix.num_queues=).*/\1'"$2"'/' /boot/loader.conf
	else 
		echo "hw.ix.num_queues=$2" >> /boot/loader.conf
	fi

#	/sbin/reboot

else
	scp $UDIR/{pincpus.sh,set_num_queues.sh} root@$1:/tmp
	ssh root@$1 /tmp/set_num_queues.sh local $2
	echo "Waiting 30s for reboot"
	sleep 30
	printf 'Waiting for %s to come back' "$1"
	while !	ssh -o ConnectTimeout=5 root@$1 /tmp/pincpus.sh 2>/dev/null; do
		printf '.'
	done
	echo
fi

