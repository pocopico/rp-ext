#
# Checking modules is loaded
#

echo -n "Loading module mvsas -> "

if [ `/sbin/lsmod |grep -i mvsas|wc -l` -gt 0 ] ; then
        echo "Module mvsas loaded succesfully"
        else echo "Module mvsas is not loaded "
fi
