#
# Checking modules is loaded
#

echo -n "Loading module 8139cp -> "

if [ `/sbin/lsmod |grep -i 8139cp|wc -l` -eq 1 ] ; then
        echo "Module 8139cp loaded succesfully"
        else echo "Module 8139cp is not loaded "
fi
