#
# Checking modules is loaded
#

echo -n "Loading module sfc -> "

if [ `/sbin/lsmod |grep -i sfc|wc -l` -gt 0 ] ; then
        echo "Module sfc loaded succesfully"
        else echo "Module sfc is not loaded "
fi
