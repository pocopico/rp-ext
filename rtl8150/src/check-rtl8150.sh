#
# Checking modules is loaded
#

echo -n "Loading module rtl8150 -> "

if [ `/sbin/lsmod |grep -i rtl8150|wc -l` -gt 0 ] ; then
        echo "Module rtl8150 loaded succesfully"
        else echo "Module rtl8150 is not loaded "
fi
