#
# Checking modules is loaded
#

echo -n "Loading module r8168 -> "

if [ `/sbin/lsmod |grep -i r8168|wc -l` -eq 1 ] ; then
        echo "Module r8168 loaded succesfully"
        else echo "Module r8168 is not loaded "
fi
