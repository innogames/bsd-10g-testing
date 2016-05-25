#!/bin/sh

pair1_mac1="68:05:ca:0b:dd:02" # t4 ix0
pair1_mac2="68:05:ca:0b:cd:94" # t3 ix2

pair2_mac1="68:05:ca:0b:dd:03" # i4 ix1
pair2_mac2="68:05:ca:0b:cd:95" # t3 ix3

cores=$(sysctl hw.ix.num_queues | cut -d: -f2)

usage() {
	echo "Give me parameters:"
	echo " - direction: tx|rx"
	echo " - source port range"
	exit
}

#getmac() {
#	ifconfig $1 | awk '/ether / {print $2}'
#}

[ -z "$1" ] && usage

case $(hostname) in
	kajetan-test10g-3.ig.local)
		pair1_if="ix2"
		pair2_if="ix3"
		;;
	kajetan-test10g-4.ig.local)
		pair1_if="ix0"
		pair2_if="ix1"
		;;
	*)
		echo "Unknown host"
		exit 1
		;;
esac

case "$1" in
	tx)
		[ -z "$2" ] && usage
		dir_mac_loc="-S"
		dir_mac_rem="-D"
		dir_ip_loc="-s"
		dir_ip_rem="-d"
		func="tx"
		pps="-R "$(($2 / $cores))
		;;
	rx)
		dir_mac_rem="-S"
		dir_mac_loc="-D"
		dir_ip_rem="-s"
		dir_ip_loc="-d"
		func="rx"
		;;
	*)
		echo "Wrong direction specified"
		exit 1
	;;
esac

cpuset -l 0-$(($cores-1)) \
pkt-gen \
	-i $pair1_if \
	$dir_mac_loc $pair1_mac1 \
	$dir_mac_rem $pair1_mac2 \
	$dir_ip_loc 192.168.42.0:0-192.168.42.0:65535 \
	$dir_ip_rem 192.168.42.0:0-192.168.42.0:65535 \
	-f $func \
	-p$cores \
	-c$cores \
	$pps
	

