#
# Checking modules is loaded
#

echo -n "Loading module bnx2x -> "

if [ `/sbin/lsmod |grep -i bnx2x|wc -l` -gt 0 ] ; then
        echo "Module bnx2x loaded succesfully"
        else echo "Module bnx2x is not loaded "
fi
