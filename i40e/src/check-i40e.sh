#
# Checking modules is loaded
#

echo -n "Loading module i40e -> "

if [ `/sbin/lsmod |grep -i i40e|wc -l` -gt 0 ] ; then
        echo "Module i40e loaded succesfully"
        else echo "Module i40e is not loaded "
fi
