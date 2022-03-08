#
# Checking modules is loaded
#

echo -n "Loading module cxgb -> "

if [ `/sbin/lsmod |grep -i cxgb|wc -l` -eq 1 ] ; then
        echo "Module cxgb loaded succesfully"
        else echo "Module cxgb is not loaded "
fi
