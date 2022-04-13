#
# Checking modules is loaded
#

echo -n "Loading module atl1e -> "

if [ `/sbin/lsmod |grep -i atl1e|wc -l` -gt 0 ] ; then
        echo "Module atl1e loaded succesfully"
        else echo "Module atl1e is not loaded "
fi
