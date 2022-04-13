#
# Checking modules is loaded
#

echo -n "Loading module cxgb -> "

if [ `/sbin/lsmod |grep -i cxgb|wc -l` -gt 0 ] ; then
        echo "Module cxgb loaded succesfully"
        else echo "Module cxgb is not loaded "
fi
