#
# Checking modules is loaded
#

echo -n "Loading module asix -> "

if [ `/sbin/lsmod |grep -i asix|wc -l` -gt 0 ] ; then
        echo "Module asix loaded succesfully"
        else echo "Module asix is not loaded "
fi
