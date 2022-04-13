#
# Checking modules is loaded
#

echo -n "Loading module iavf -> "

if [ `/sbin/lsmod |grep -i iavf|wc -l` -eq 1 ] ; then
        echo "Module iavf loaded succesfully"
        else echo "Module iavf is not loaded "
fi
