#
# Checking modules is loaded
#

echo -n "Loading module alx -> "

if [ `/sbin/lsmod |grep -i alx|wc -l` -gt 0 ] ; then
        echo "Module alx loaded succesfully"
        else echo "Module alx is not loaded "
fi
