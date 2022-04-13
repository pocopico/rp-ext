#
# Checking modules is loaded
#

echo -n "Loading module tg3 -> "

if [ `/sbin/lsmod |grep -i tg3|wc -l` -gt 0 ] ; then
        echo "Module tg3 loaded succesfully"
        else echo "Module tg3 is not loaded "
fi
