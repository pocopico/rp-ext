#
# Checking modules is loaded
#

echo -n "Loading module igb -> "

if [ `/sbin/lsmod |grep -i igb|wc -l` -gt 0 ] ; then
        echo "Module igb loaded succesfully"
        else echo "Module igb is not loaded "
fi
