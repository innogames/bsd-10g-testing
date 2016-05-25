#!/bin/sh

base_ip="42.0.0.0"
max_flow=1000

usage() {
	echo "I expect the following parameters:"
	echo " - tx gw address"
	echo " - rx gw address"
	echo " - number of flows"
	echo " - script file"
	echo " - log file"
	exit 1
}

itoa() {
	echo $(($1/256/256/256%256)).$(($1/256/256%256)).$(($1/256%256)).$(($1%256))
}

atoi() {
	IP=$1
	for pos in 3 2 1 0; do
		octet=${IP%%.*}
		IP=${IP#*.}
		val=$( echo $octet'*'256'^'$pos | bc )
		out=$(($out + $val))
	done
	echo $out
}

[ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] ||[ -z "$4" ] || [ -z "$5" ] && usage

GW_TX=$1
GW_RX=$2
FLOWS=$3
SCRIPT=$4
LOG=$5

! [ "$FLOWS" -eq "$FLOWS" ] 2>/dev/null || [ "$FLOWS" -le 0 ] || [ "$FLOWS" -gt $max_flow ] && { echo "Number of flows must be between 1 and $max_flow"; usage; }

if [ -n "$SCRIPT" ]; then
	[ ! -f "$SCRIPT" ] && { echo "Unable to find script file $SCRIPT" ; usage ; }
fi

max_ip=$(atoi "$base_ip")
max_ip=$(($max_ip + $FLOWS -1 ))
max_ip=$(itoa $max_ip)

ipgen -T ix0,$GW_TX -R ix1,$GW_RX -s 64 --saddr $base_ip-$max_ip --dport 42 $SCRIPT -S $SCRIPT -L $LOG

