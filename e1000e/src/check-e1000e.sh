#
# Checking modules is loaded
#

echo -n "Loading module e1000e -> "

if [ `/sbin/lsmod |grep -i e1000e|wc -l` -gt 0 ] ; then
        echo "Module e1000e loaded succesfully"
        else echo "Module e1000e is not loaded "
fi
