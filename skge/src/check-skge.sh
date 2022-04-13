#
# Checking modules is loaded
#

echo -n "Loading module skge -> "

if [ `/sbin/lsmod |grep -i skge|wc -l` -eq 1 ] ; then
        echo "Module skge loaded succesfully"
        else echo "Module skge is not loaded "
fi
