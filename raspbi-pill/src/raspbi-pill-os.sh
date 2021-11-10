#!/bin/sh


        echo "---------={ Starting raspbi-pill service }=---------"
	echo "Waiting for root device"

	echo "Loading required modules"
	insmod /lib/modules/cdc-acm.ko
	insmod /lib/modules/cdc_ether.ko

        echo "---------={ Starting agetty service }=---------"
	/bin/cp agetty /sbin/
	/bin/cp agettystart.sh /sbin/
	chmod 777 /sbin/agetty
	chmod 777 /sbin/agettystart.sh
	/sbin/agettystart.sh &
