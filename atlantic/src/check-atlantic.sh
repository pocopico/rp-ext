#
# Checking modules is loaded
#

echo -n "Loading module atlantic -> "

if [ `/sbin/lsmod |grep -i atlantic|wc -l` -gt 0 ] ; then
        echo "Module atlantic loaded succesfully"
        else echo "Module atlantic is not loaded "
fi
