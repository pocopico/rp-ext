#
# Checking modules is loaded
#

echo -n "Loading module via-rhine -> "

if [ `/sbin/lsmod |grep -i via-rhine|wc -l` -gt 0 ] ; then
        echo "Module via-rhine loaded succesfully"
        else echo "Module via-rhine is not loaded "
fi
