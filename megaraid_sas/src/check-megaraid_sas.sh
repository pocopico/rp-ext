#
# Checking modules is loaded
#

echo -n "Loading module megaraid_sas -> "

if [ `/sbin/lsmod |grep -i megaraid_sas|wc -l` -gt 0 ] ; then
        echo "Module megaraid_sas loaded succesfully"
        else echo "Module megaraid_sas is not loaded "
fi
