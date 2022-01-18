#
# Checking modules is loaded
#

echo -n "Loading module mptspi -> "

if [ `/sbin/lsmod |grep -i mptspi|wc -l` -eq 1 ] ; then
        echo "Module mptspi loaded succesfully"
        else echo "Module mptspi is not loaded "
fi
