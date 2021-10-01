#
# Checking modules is loaded
#

echo -n "Loading module MPT SAS -> "

if [ $(/sbin/lsmod |grep -i mptsas|wc -l) -gt 0 ] ; then 
	echo "Module MPT SAS loaded succesfully" 
	else echo "Module MPTSAS is not loaded "
fi
