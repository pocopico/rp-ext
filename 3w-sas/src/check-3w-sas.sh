#
# Checking modules is loaded
#

echo -n "Loading module 3w-sas -> "

if [ `/sbin/lsmod |grep -i 3w-sas|wc -l` -gt 0 ] ; then
        echo "Module 3w-sas loaded succesfully"
        else echo "Module 3w-sas is not loaded "
fi
