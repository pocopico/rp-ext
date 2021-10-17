#
# Checking modules is loaded
#

echo -n "Loading module e1000 -> "

if [ `/sbin/lsmod |grep -i e1000|wc -l` -eq 1 ] ; then
        echo "Module e1000 loaded succesfully"
        else echo "Module e1000 is not loaded "
fi
