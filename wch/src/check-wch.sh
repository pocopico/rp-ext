#
# Checking modules is loaded
#

echo -n "Loading module wch -> "

if [ `/sbin/lsmod |grep -i wch|wc -l` -eq 1 ] ; then
        echo "Module wch loaded succesfully"
        else echo "Module wch is not loaded "
fi
