#
# Checking modules is loaded
#

echo -n "Loading module aic94xx -> "

if [ `/sbin/lsmod |grep -i aic94xx|wc -l` -eq 1 ] ; then
        echo "Module aic94xx loaded succesfully"
        else echo "Module aic94xx is not loaded "
fi
