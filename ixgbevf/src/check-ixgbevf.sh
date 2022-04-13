#
# Checking modules is loaded
#

echo -n "Loading module ixgbevf -> "

if [ `/sbin/lsmod |grep -i ixgbevf|wc -l` -gt 0 ] ; then
        echo "Module ixgbevf loaded succesfully"
        else echo "Module ixgbevf is not loaded "
fi
