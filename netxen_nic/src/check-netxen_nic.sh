#
# Checking modules is loaded
#

echo -n "Loading module netxen_nic -> "

if [ `/sbin/lsmod |grep -i netxen_nic|wc -l` -gt 0 ] ; then
        echo "Module netxen_nic loaded succesfully"
        else echo "Module netxen_nic is not loaded "
fi
