#
# Checking modules is loaded
#

echo -n "Loading module cxgb4 -> "

if [ `/sbin/lsmod |grep -i cxgb4|wc -l` -eq 1 ] ; then
        echo "Module cxgb4 loaded succesfully"
        else echo "Module cxgb4 is not loaded "
fi
