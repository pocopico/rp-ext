#
# Checking modules is loaded
#

echo -n "Loading module VMware VM modules  -> "

if [ `lsmod | grep -i vmxnet3` -eq 1 ] ; then
        echo "Modules for VMware VM loaded succesfully"
        else echo "Modules for VMware VM is not loaded "
fi
