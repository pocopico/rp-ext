#
# Checking modules is loaded
#

echo -n "Loading module qlcnic -> "

if [ `/sbin/lsmod |grep -i qlcnic|wc -l` -eq 1 ] ; then
        echo "Module qlcnic loaded succesfully"
        else echo "Module qlcnic is not loaded "
fi
