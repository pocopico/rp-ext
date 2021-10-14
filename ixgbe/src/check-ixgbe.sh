#
# Checking modules is loaded
#

echo -n "Loading module ixgbe -> "

if [ `lsmod |grep -i ixgbe | wc -l` -eq 1 ] ; then
        echo "Module ixgbe loaded succesfully"
        else echo "Module ixgbe is not loaded "
fi
