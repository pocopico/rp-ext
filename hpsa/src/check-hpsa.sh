#
# Checking modules is loaded
#

echo -n "Loading module HP Smart array -> "

if [ $(/sbin/lsmod |grep -i hpsa|wc -l) -gt 0 ] ; then 
	echo "Module HP Smart array loaded succesfully" 
	else echo "Module HP Smart array not loaded "
fi
