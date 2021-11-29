#
# Checking modules is loaded
#

echo -n "Loading module redpill -> "

if [ `/sbin/lsmod |grep -i redpill|wc -l` -eq 1 ] ; then
        echo "Module redpill loaded succesfully"
        else echo "Module redpill is not loaded "
fi
