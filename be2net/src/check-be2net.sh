#
# Checking modules is loaded
#

echo -n "Loading module be2net -> "

if [ `/sbin/lsmod |grep -i be2net|wc -l` -gt 0 ] ; then
        echo "Module be2net loaded succesfully"
        else echo "Module be2net is not loaded "
fi
