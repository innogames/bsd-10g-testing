#!/bin/sh

for iface in $(ifconfig -l); do
	case "$iface" in
		ix*)
			echo "Interface $iface:"
			cpu=0
			for irq in $(vmstat -i | grep -E "$iface"':q[0-9]' | sed -E 's/irq([0-9]+).*/\1/'); do
			[ -z "$1" ] && cpu=$(($cpu+1)) || cpu=$1
		        echo "irq $irq to cpu $cpu";
		        cpuset -x $irq -l $cpu;
		done
		;;
	esac
done

