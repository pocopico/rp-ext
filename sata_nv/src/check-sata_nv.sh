#
# Checking modules is loaded
#

echo -n "Loading module sata_nv -> "

if [ `/sbin/lsmod |grep -i sata_nv|wc -l` -gt 0 ] ; then
        echo "Module sata_nv loaded succesfully"
        else echo "Module sata_nv is not loaded "
fi
