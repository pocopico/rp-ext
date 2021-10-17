#
# Checking modules is loaded
#

echo -n "Loading module asix -> "

if [ `/sbin/lsmod |grep -i asix|wc -l` -eq 1 ] ; then
        echo "Module asix loaded succesfully"
        else echo "Module asix is not loaded "
fi
