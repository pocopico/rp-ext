#
# Checking modules is loaded
#

echo -n "Loading module 9pnet -> "

if [ `/sbin/lsmod |grep -i 9pnet|wc -l` -eq 1 ] ; then
        echo "Module 9pnet loaded succesfully"
        else echo "Module 9pnet is not loaded "
fi
