#
# Checking modules is loaded
#

echo -n "Loading module cxgb3 -> "

if [ `/sbin/lsmod |grep -i cxgb3|wc -l` -gt 0 ] ; then
        echo "Module cxgb3 loaded succesfully"
        else echo "Module cxgb3 is not loaded "
fi
