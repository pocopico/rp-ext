#!/bin/sh


echo "---------={ Starting agetty daemon }=---------"

while true
do
        if [ `ps -ef |grep -ie ttyACM0 |grep -v grep | wc -l` -gt 0 ];
        then
        echo "agetty running"  >> /var/log/agetty.log
        else
	echo "starting agetty" >> /var/log/agetty.log
        /sbin/agetty --local-line 115200 ttyACM0 vt100
        fi
sleep 5
done
