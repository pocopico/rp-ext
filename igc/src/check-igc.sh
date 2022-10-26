#
# Checking modules is loaded
#

echo -n "Loading module igc -> "

if [ `/sbin/lsmod |grep -i igc|wc -l` -gt 0 ] ; then
        echo "Module igc loaded succesfully"
        else echo "Module igc is not loaded "
fi
