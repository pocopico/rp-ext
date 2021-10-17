#
# Checking modules is loaded
#

echo -n "Loading module tg3 -> "

if [ $(/sbin/lsmod |grep -i tg3|wc -l) -eq 1 ] ; then 
	echo "Module Tigon 3 loaded succesfully" 
	else echo "Module Tigon 3 is not loaded "
fi
