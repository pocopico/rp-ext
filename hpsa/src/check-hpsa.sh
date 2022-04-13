#
# Checking modules is loaded
#

echo -n "Loading module hpsa -> "

if [ `/sbin/lsmod |grep -i hpsa|wc -l` -gt 0 ] ; then
        echo "Module hpsa loaded succesfully"
        else echo "Module hpsa is not loaded "
fi
