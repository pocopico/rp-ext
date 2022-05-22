#
# Checking modules is loaded
#

echo -n "Loading module nct6775 -> "

if [ `/sbin/lsmod |grep -i nct6775|wc -l` -gt 0 ] ; then
        echo "Module nct6775 loaded succesfully"
        else echo "Module nct6775 is not loaded "
fi
