#
# Checking modules is loaded
#

echo -n "Loading module hv_netvsc -> "

if [ `/sbin/lsmod |grep -i hv_netvsc|wc -l` -gt 0 ] ; then
        echo "Module hv_netvsc loaded succesfully"
        else echo "Module hv_netvsc is not loaded "
fi
