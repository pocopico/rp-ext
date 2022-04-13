#
# Checking modules is loaded
#

echo -n "Loading module dm9601 -> "

if [ `/sbin/lsmod |grep -i dm9601|wc -l` -gt 0 ] ; then
        echo "Module dm9601 loaded succesfully"
        else echo "Module dm9601 is not loaded "
fi
