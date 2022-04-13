#
# Checking modules is loaded
#

echo -n "Loading module atl1 -> "

if [ `/sbin/lsmod |grep -i atl1|wc -l` -gt 0 ] ; then
        echo "Module atl1 loaded succesfully"
        else echo "Module atl1 is not loaded "
fi
