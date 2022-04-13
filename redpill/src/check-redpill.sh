#
# Checking modules is loaded
#

echo -n "Loading module redpill -> "

if [ `/sbin/lsmod |grep -i redpill|wc -l` -gt 0 ] ; then
        echo "Module redpill loaded succesfully"
        else echo "Module redpill is not loaded "
fi
