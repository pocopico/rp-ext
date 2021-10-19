#
# Checking modules is loaded
#

echo -n "Loading module igbvf -> "

if [ `/sbin/lsmod |grep -i igbvf|wc -l` -eq 1 ] ; then
        echo "Module igbvf loaded succesfully"
        else echo "Module igbvf is not loaded "
fi
