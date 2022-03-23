#!/bin/sh
#
# This scripts will collect diagnostic data and produce an HTML report 
# 
#
# VERSION 00.01
#
#

#### USER Variables 

htmlfilename="tcrp-diag.html"


##### END OF USER Variables


function tcrpbanner()
{

cat <<EOF
<pre>
::::::::::: ::::::::  :::::::::  :::::::::       ::::::::: :::::::::::     :::      ::::::::  
    :+:    :+:    :+: :+:    :+: :+:    :+:      :+:    :+:    :+:       :+: :+:   :+:    :+: 
    +:+    +:+        +:+    +:+ +:+    +:+      +:+    +:+    +:+      +:+   +:+  +:+        
    +#+    +#+        +#++:++#:  +#++:++#+       +#+    +:+    +#+     +#++:++#++: :#:        
    +#+    +#+        +#+    +#+ +#+             +#+    +#+    +#+     +#+     +#+ +#+   +#+# 
    #+#    #+#    #+# #+#    #+# #+#             #+#    #+#    #+#     #+#     #+# #+#    #+# 
    ###     ########  ###    ### ###             ######### ########### ###     ###  ########  
--------------------------------------------------------------------------------------------
Started diagnostic collection at :   
EOF
date
echo "--------------------------------------------------------------------------------------------"
echo "</pre>"

}


function mounttcrp() {

echo "Mounting TCRP"

mkdir /tcrp
cd /dev/ ; mount synoboot3 /tcrp

     if [ `mount |grep -i tcrp| wc -l` -gt 0 ] ; then
     echo "TCRP Partition Mounted succesfully"
	 echo "Creating tcrp diag directory"
	 mkdir /tcrp/diag/
     else 
     echo "TCRP Failed to mount"
	 fi

}


function getrootdevice(){

add_head "Root device"

. /usr/syno/share/rootdevice.sh

cmdcontent "echo Found $RootDevice"


}


function htmlheader(){

cat << EOF
<!DOCTYPE html>
<html>

   <head>
      <title>TCRP Diagnostic report</title>
	  
	  
	  <style type="text/css">

           Pre		{Font-Family: Courier-New, Courier;Font-Size: 10pt}
           BODY		{FONT-FAMILY: Arial, Verdana, Helvetica, Sans-serif; FONT-SIZE: 12pt;}
           A		{FONT-FAMILY: Arial, Verdana, Helvetica, Sans-serif}
           A:link 		{text-decoration: none}
           A:visited 	{text-decoration: none}
           A:hover 	{text-decoration: underline}
           A:active 	{color: red; text-decoration: none}
           
           H1		{FONT-FAMILY: Arial, Verdana, Helvetica, Sans-serif;FONT-SIZE: 20pt}
           H2		{FONT-FAMILY: Arial, Verdana, Helvetica, Sans-serif;FONT-SIZE: 14pt}
           H3		{FONT-FAMILY: Arial, Verdana, Helvetica, Sans-serif;FONT-SIZE: 12pt}
           DIV, P, OL, UL, SPAN, TD
           		{FONT-FAMILY: Arial, Verdana, Helvetica, Sans-serif;FONT-SIZE: 11pt}
       </style>

   
   </head>

   <body>

EOF


}



function htmlfooter(){

cat << EOF

<br>

   </body>
   </html>

EOF


}



function add_head(){ 
#<p id="opening">Hyperlinks are </p>
#<a href="#opening">$1</a>
echo "<h${HEAD}> $1 </h${HEAD}>" 
}
function inc_head(){ 
let HEAD=$HEAD+1 
}
function dec_head(){
let HEAD=$HEAD-1 
}

function filecontent(){

echo "<pre>"
cat $1
echo "</pre>"

}

function cmdcontent() {

echo "<pre>"
echo add_head "$1"
$1
echo "</pre>"

}


function sysoverview(){

add_head "System Overview"

echo "<pre>"
echo "Hostname          = `/bin/hostname`"
echo "HW Model          = `/bin/cat /proc/syno_platform`"
echo "Syno Platform     = ${synoplatform}"
echo "Syno Model        = ${synomodel}"
echo "uname -a          = `uname -a`"
echo "# CPUs (Cores)    = `/bin/cat /proc/cpuinfo |grep processor | wc -l`"
echo "# Disks           = `/bin/ls /dev/sd[a-z] |wc -l`"
echo "Memory            = `cat /proc/meminfo |grep MemTotal`"
echo "Deviceswap        = `cat /proc/swaps | grep -i part`"
echo "Linux cmdline     = `cat /proc/cmdline`"

echo "</pre>"



}


function serialtofile(){

(cat > serial0.log) < /dev/ttyS0 &
(cat > serial1.log) < /dev/ttyS1 &


}


function getlogs(){


add_head "Upgrade Log"
filecontent /var/log/upgrade_sh.log
add_head "Junior Reason Log"
filecontent /var/log/junior_reason
add_head "Linux RC Syno Log"
filecontent /var/log/linuxrc.syno.log
add_head "Syno Messages Log"
filecontent /var/log/messages

}


function getnetwork(){

add_head "Networking Information"
inc_head 

add_head "IFCONFIG : "
cmdcontent "ifconfig"
add_head "NETSTAT -an : "
cmdcontent "netstat -an "
dec_head



}

function getmodules(){

add_head "Modules Information"
inc_head 

cmdcontent "lsmod"

dec_head

}

function diskinfo(){

add_head "Disk Information"
inc_head 


cmdcontent "fdisk -l"


cmdcontent "cat /proc/scsi/scsi"


for disk in `ls -d /sys/block/sd[a-z]`
do
cmdcontent "echo Disk : ${disk} Model    : `cat ${disk}/device/model`"
cmdcontent "echo Disk : ${disk} Serial Number : `cat ${disk}/device/syno_disk_serial`"
done


for disk in `ls -d /sys/block/nvme*`
do
cmdcontent "echo NVME : ${disk} Model    : `cat ${disk}/device/model`"
cmdcontent "echo NVME : ${disk} Serial Number : `cat ${disk}/device/serial`"
cmdcontent "echo NVME : ${disk} Firmware : `cat ${disk}/device/firmware_rev`"
done

dec_head

}

function cpuinfo(){

add_head "CPU Info"
inc_head 

cmdcontent "cat /proc/cpuinfo"
cmdcontent "cat /proc/syno_cpu_arch"

dec_head

}


function synoinfo(){

/bin/get_key_value /etc.defaults/synoinfo.conf $1

}

function getrestinfo(){

#### This functions should include binary found in TCRP DEVICE: /diag/ folder #####

add_head "Collecting auxiliary information"

cmdcontent "dmidecode"
cmdcontent "lsscsi -v"
cmdcontent "lsscsi -H"
cmdcontent "lspci -nnq"
cmdcontent "lsusb"

}


function getprocesses(){

add_head "Running Processes"

cmdcontent "ps -ef"


}


function getsynoinfo(){

add_head "Syno Info Known Variables : "

echo "<pre>"
echo "support_disk_compatibility     = `synoinfo support_disk_compatibility`"
echo "support_disk_hibernation       = `synoinfo support_disk_hibernation`"
echo "support_memory_compatibility   = `synoinfo support_memory_compatibility`"
echo "support_ssd_cache              = `synoinfo support_ssd_cache`"
echo "support_ssd_related_ui         = `synoinfo support_ssd_related_ui`"
echo "support_ssd_trim               = `synoinfo support_ssd_trim`"
echo "support_wol                    = `synoinfo support_wol`"
echo "supportsmart                   = `synoinfo supportsmart`"
echo "supportsnapshot                = `synoinfo supportsnapshot`"
echo "supportsystemperature          = `synoinfo supportsystemperature`"
echo "support_syno_hybrid_raid       = `synoinfo support_syno_hybrid_raid`"

echo "</pre>"

}


function getvars(){

synoplatform=$(synoinfo unique | cut -d"_" -f2)
synomodel=$(synoinfo unique | cut -d"_" -f3)

let HEAD=1

if [ -n "$(grep tcrpdiag /proc/cmdline)" ]; then
TCRPDIAG="enabled"
else 
TCRPDIAG=""
fi

}

function getsynoboot(){

add_head "Synoboot Information"

echo "<pre>"
if [ `ls -ltr /dev/synoboot | wc -l` -gt 0 ]; then
echo "Synoboot Found"
cmdcontent "fdisk -l /dev/synoboot"
else "Echo no synoboot found"
fi
echo "</pre>"

}

function preparediag(){

echo "Copying tcrp auxiliary files to /sbin/"

/bin/cp lsscsi /sbin/ ; chmod 700 /sbin/lsscsi
/bin/cp lspci /sbin/  ; chmod 700 /sbin/lspci
/bin/cp lsusb /sbin/  ; chmod 700 /sbin/lsusb
/bin/cp dmidecode /sbin/  ; chmod 700 /sbin/dmidecode
/bin/cp tcrp-diag.sh /sbin/  ; chmod 700 /sbin/tcrp-diag.sh

/bin/cp libpci.so.3 /lib ; chmod 644 /lib/libpci.so.3
/bin/cp libusb-1.0.so.0 /lib  ; chmod 644 /lib/libusb-1.0.so.0


}

function startcollection(){
################## MAIN ################

#### Preparation 

preparediag
mounttcrp
getvars         

#### Start collection

if [ -d /tcrp/diag/ ] ; then 
folder="/tcrp/diag"
else
folder="/tmp"
fi

echo "Exporting report to ${folder}/$htmlfilename ..."

htmlheader      >  ${folder}/$htmlfilename
tcrpbanner      >> ${folder}/$htmlfilename
sysoverview     >> ${folder}/$htmlfilename
getsynoboot     >> ${folder}/$htmlfilename
getrootdevice   >> ${folder}/$htmlfilename
getnetwork      >> ${folder}/$htmlfilename
cpuinfo         >> ${folder}/$htmlfilename
diskinfo        >> ${folder}/$htmlfilename
getrestinfo     >> ${folder}/$htmlfilename
getsynoinfo     >> ${folder}/$htmlfilename
getmodules      >> ${folder}/$htmlfilename
getlogs         >> ${folder}/$htmlfilename
htmlfooter      >> ${folder}/$htmlfilename
}


if [ "$TCRPDIAG" = "enabled" ] ; then 
startcollection
else
echo "TCRP not enabled on linux command line. Bye !"
preparediag
fi

#### Always exit with return code 0 
exit 0


