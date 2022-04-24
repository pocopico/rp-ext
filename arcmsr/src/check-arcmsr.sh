#
# Checking modules is loaded
#

echo -n "Loading module arcmsr -> "

if [ `/sbin/lsmod |grep -i arcmsr|wc -l` -gt 0 ] ; then
        echo "Module arcmsr loaded succesfully"
        else echo "Module arcmsr is not loaded "
fi
