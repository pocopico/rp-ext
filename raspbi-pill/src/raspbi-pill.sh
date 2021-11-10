#!/bin/sh


        echo "---------={ Starting raspbi-pill service }=---------"

	echo "Loading required modules"
	insmod /lib/modules/cdc-acm.ko

        echo "---------={ Starting agetty service }=---------"
	/bin/cp agetty /sbin/
	/bin/cp J01agetty.sh /usr/syno/etc/rc.d/
	/bin/cp agettystart.sh /sbin/
	chmod 777 /sbin/agetty 
	chmod 777 /usr/syno/etc/rc.d/J01agetty.sh
	chmod 777 /sbin/agettystart.sh
