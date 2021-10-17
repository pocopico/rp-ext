#
# Checking modules is loaded
#

echo -n "Loading module atl2 -> "

if [ `/sbin/lsmod |grep -i atl2|wc -l` -eq 1 ] ; then
        echo "Module atl2 loaded succesfully"
        else echo "Module atl2 is not loaded "
fi
