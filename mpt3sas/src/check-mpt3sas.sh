#
# Checking modules is loaded
#

echo -n "Loading module MPT 3 SAS -> "

if [ $(/sbin/lsmod |grep -i mpt3sas|wc -l) -gt 0 ] ; then 
	echo "Module MPT 3 SAS loaded succesfully" 
	else echo "Module MPT 3 SAS is not loaded "
fi
