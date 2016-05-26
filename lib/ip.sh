#!/bin/sh

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

