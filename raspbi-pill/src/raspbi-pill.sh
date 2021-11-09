#!/bin/sh


function agettystart {

while true
do
if [ `who -u |grep -i ttyACM0| grep -v grep | wc -l ` -eq 1 ] ;
then
echo "User looged in from Serial Terminal waiting for exit"
else
        if [ `ps -ef |grep -ie ttyACM0 |grep -v grep | wc -l` -eq 1 ];
        then
        echo "agetty running"
        else
        echo "Starting agetty"
        /sbin/agetty --local-line 115200 ttyACM0 vt100
        fi
fi
sleep 5
echo "."
done

}

        echo "---------={ Starting raspbi-pill service }=---------"

	echo "Loading required modules"
	insmod /lib/modules/cdc-acm.ko

	nohup /bin/sh -c agettystart &

