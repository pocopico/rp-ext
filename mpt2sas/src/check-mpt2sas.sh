#
# Checking modules is loaded
#

echo -n "Loading module mpt2sas -> "

if [ `/sbin/lsmod |grep -i mpt2sas|wc -l` -gt 0 ] ; then
        echo "Module mpt2sas loaded succesfully"
        else echo "Module mpt2sas is not loaded "
fi
