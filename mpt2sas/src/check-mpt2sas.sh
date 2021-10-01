#
# Checking modules is loaded
#

echo -n "Loading module MPT 2 SAS -> "

if [ $(/sbin/lsmod |grep -i mpt |grep -i sas|wc -l) -gt 0 ] ; then 
	echo "Module MPT 2 SAS loaded succesfully" 
	else echo "Module MPT 2 SAS is not loaded "
fi
