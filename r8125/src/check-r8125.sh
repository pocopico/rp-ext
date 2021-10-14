#
# Checking modules is loaded
#

echo -n "Loading module r8125 -> "

if [ `lsmod |grep -i r8125|wc -l` -eq 1 ] ; then
        echo "Module r8125 loaded succesfully"
        else echo "Module r8125 is not loaded "
fi
