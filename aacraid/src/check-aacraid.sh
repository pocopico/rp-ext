#
# Checking modules is loaded
#

echo -n "Loading module aacraid -> "

if [ `/sbin/lsmod |grep -i aacraid|wc -l` -eq 1 ] ; then
        echo "Module aacraid loaded succesfully"
        else echo "Module aacraid is not loaded "
fi
