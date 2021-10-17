#
# Checking modules is loaded
#

echo -n "Loading module r8152 -> "

if [ `/sbin/lsmod |grep -i r8152|wc -l` -eq 1 ] ; then
        echo "Module r8152 loaded succesfully"
        else echo "Module r8152 is not loaded "
fi
