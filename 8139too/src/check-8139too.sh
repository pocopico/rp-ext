#
# Checking modules is loaded
#

echo -n "Loading module 8139too -> "

if [ `/sbin/lsmod |grep -i 8139too|wc -l` -gt 0 ] ; then
        echo "Module 8139too loaded succesfully"
        else echo "Module 8139too is not loaded "
fi
