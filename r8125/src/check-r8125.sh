#
# Checking modules is loaded
#

echo -n "Loading module r8125 -> "

if [ `/sbin/lsmod |grep -i r8125|wc -l` -gt 0 ] ; then
        echo "Module r8125 loaded succesfully"
        else echo "Module r8125 is not loaded "
fi
