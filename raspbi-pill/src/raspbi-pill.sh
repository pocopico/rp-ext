#!/bin/sh


        echo "---------={ Starting raspbi-pill service }=---------"

	echo "Loading required modules"
	insmod /lib/modules/cdc-acm.ko

	echo "Listing Partitions"

	fdisk -l 
	mount
	df -h
	echo "Listing root"
	ls -l /
	echo "Listing Local"
	ls -l .

        echo "---------={ Starting agetty service }=---------"
	/bin/cp agetty /sbin/
	/bin/cp agettystart.sh /sbin
	echo "Starting Local"
        /sbin/agetty --local-line 115200 ttyACM0 vt100
	echo "Starting /sbin/agetty"
        ./agetty --local-line 115200 ttyACM0 vt100
