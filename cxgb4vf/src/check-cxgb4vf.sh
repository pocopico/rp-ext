#
# Checking modules is loaded
#

echo -n "Loading module cxgb4vf -> "

if [ `/sbin/lsmod |grep -i cxgb4vf|wc -l` -eq 1 ] ; then
        echo "Module cxgb4vf loaded succesfully"
        else echo "Module cxgb4vf is not loaded "
fi
