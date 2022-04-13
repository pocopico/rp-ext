#
# Checking modules is loaded
#

echo -n "Loading module ixgbe -> "

if [ `/sbin/lsmod |grep -i ixgbe|wc -l` -gt 0 ] ; then
        echo "Module ixgbe loaded succesfully"
        else echo "Module ixgbe is not loaded "
fi
