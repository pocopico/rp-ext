#
# Checking modules is loaded
#

echo -n "Loading module mptsas -> "

if [ `/sbin/lsmod |grep -i mptsas|wc -l` -eq 1 ] ; then
        echo "Module mptsas loaded succesfully"
        else echo "Module mptsas is not loaded "
fi
