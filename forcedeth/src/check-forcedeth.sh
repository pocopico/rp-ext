#
# Checking modules is loaded
#

echo -n "Loading module forcedeth -> "

if [ `/sbin/lsmod |grep -i forcedeth|wc -l` -gt 0 ] ; then
        echo "Module forcedeth loaded succesfully"
        else echo "Module forcedeth is not loaded "
fi
