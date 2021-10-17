#
# Checking modules is loaded
#

echo -n "Loading module r8101 -> "

if [ `/sbin/lsmod |grep -i r8101|wc -l` -eq 1 ] ; then
        echo "Module r8101 loaded succesfully"
        else echo "Module r8101 is not loaded "
fi
