#
# Checking modules is loaded
#

echo -n "Loading module bna -> "

if [ `/sbin/lsmod |grep -i bna|wc -l` -gt 0 ] ; then
        echo "Module bna loaded succesfully"
        else echo "Module bna is not loaded "
fi
