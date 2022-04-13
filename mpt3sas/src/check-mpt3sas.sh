#
# Checking modules is loaded
#

echo -n "Loading module mpt3sas -> "

if [ `/sbin/lsmod |grep -i mpt3sas|wc -l` -gt 0 ] ; then
        echo "Module mpt3sas loaded succesfully"
        else echo "Module mpt3sas is not loaded "
fi
