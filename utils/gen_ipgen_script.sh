#!/bin/sh

usage () {
	echo "Please give me the following parameters in kpps"
	echo " - step"
	echo " - end value"
	exit 1
}

[ -z "$1" ] || [ -z "$2" ] && usage

echo "#sec    cmd     pktsize pps or Mbps"
echo "#------ ------- ------- -------------"

for i in `seq $1 $1 $2`; do
	printf '10	tx1	46	%8d\n' $(( $i * 1000 ))
done

