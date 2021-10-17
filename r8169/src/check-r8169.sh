#
# Checking modules is loaded
#

echo -n "Loading module r8169 -> "

if [ `/sbin/lsmod |grep -i r8169|wc -l` -eq 1 ] ; then
        echo "Module r8169 loaded succesfully"
        else echo "Module r8169 is not loaded "
fi
