#
# Checking modules is loaded
#

echo -n "Loading module via-velocity -> "

if [ `/sbin/lsmod |grep -i via-velocity|wc -l` -eq 1 ] ; then
        echo "Module via-velocity loaded succesfully"
        else echo "Module via-velocity is not loaded "
fi
