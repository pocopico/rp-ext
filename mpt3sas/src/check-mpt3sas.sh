#
# Checking modules is loaded
#

echo -n "Loading module mpt3sas -> "

if [ `/sbin/lsmod |grep -i mpt3sas|wc -l` -eq 1 ] ; then
        echo "Module mpt3sas loaded succesfully"
        else echo "Module mpt3sas is not loaded "
fi
