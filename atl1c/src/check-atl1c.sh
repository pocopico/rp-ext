#
# Checking modules is loaded
#

echo -n "Loading module atl1c -> "

if [ `/sbin/lsmod |grep -i atl1c|wc -l` -gt 0 ] ; then
        echo "Module atl1c loaded succesfully"
        else echo "Module atl1c is not loaded "
fi
