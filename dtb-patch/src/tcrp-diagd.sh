#!/bin/sh

# You can force junior by adding force_junior in the linux cmdline 

function preparediag(){

echo "Copying tcrp auxiliary files to /sbin/"

/bin/cp -v lsscsi /usr/sbin/ ; chmod 700 /usr/sbin/lsscsi
/bin/cp -v lspci  /usr/sbin/  ; chmod 700 /usr/sbin/lspci
/bin/cp -v lsusb  /usr/sbin/  ; chmod 700 /usr/sbin/lsusb
/bin/cp -v dmidecode /usr/sbin/  ; chmod 700 /usr/sbin/dmidecode
/bin/cp -v dtc /usr/sbin/  ; chmod 700 /usr/sbin/dtc
/bin/cp -v ethtool /usr/sbin/  ; chmod 700 /usr/sbin/ethtool
/bin/cp -v tcrp-diag.sh /usr/sbin/  ; chmod 700 /usr/sbin/tcrp-diag.sh

echo "Copying tcrp libraries to /lib/"
/bin/cp -v libpci.so.3 /lib ; chmod 644 /lib/libpci.so.3
/bin/cp -v libusb-1.0.so.0 /lib  ; chmod 644 /lib/libusb-1.0.so.0
/bin/cp -v libz.so.1      /lib  ; chmod 644 /lib/libz.so.1     
/bin/cp -v libudev.so.1   /lib  ; chmod 644 /lib/libudev.so.1  
/bin/cp -v libkmod.so.2   /lib  ; chmod 644 /lib/libkmod.so.2  
/bin/cp -v libresolv.so.2 /lib  ; chmod 644 /lib/libresolv.so.2
/bin/mkdir /var/lib/usbutils ; /bin/cp usb.ids /var/lib/usbutils/usb.ids ;  chmod 644 /var/lib/usbutils/usb.ids

}


function getvars(){


let HEAD=1

if [ -n "$(grep tcrpdiag /proc/cmdline)" ]; then
TCRPDIAG="enabled"
else 
TCRPDIAG=""
fi

### USUALLY SCEMD is the last process run in init, so when scemd is running we are most 
# probably certain that system has finish init process 
#


if [ `ps -ef |grep -i scemd |grep -v grep | wc -l` -gt 0 ] ; then 
HASBOOTED="yes"
echo "System has completed init process"
else 
echo "System is booting"
HASBOOTED="no"
fi

}


############ START RUN ############

getvars


if [ "$TCRPDIAG" = "enabled" ] ; then 

       if  [ "$HASBOOTED" = "no" ] ; then
       preparediag
       sleep 120 && /usr/sbin/tcrp-diag.sh &
       elif [ "$HASBOOTED" = "yes" ] ; then
	   sleep 120 && /usr/sbin/tcrp-diag.sh &
       startcollection
       fi

elif [ ! "$TCRPDIAG" = "enabled" ] ; then 

 	  if  [ "$HASBOOTED" = "no" ] ; then
      preparediag
	  echo "TCRP not enabled on linux command line" 	
       	
      elif [ "$HASBOOTED" = "yes" ] ; then
      sleep 120 && /usr/sbin/tcrp-diag.sh &
      fi

fi


exit 0
