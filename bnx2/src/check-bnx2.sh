#
# Checking modules is loaded
#

echo -n "Loading module bnx2 -> "

if [ `/sbin/lsmod |grep -i bnx2|wc -l` -gt 0 ] ; then
        echo "Module bnx2 loaded succesfully"
        else echo "Module bnx2 is not loaded "
fi
