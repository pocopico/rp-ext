#
# Checking modules is loaded
#

echo -n "Loading module rtc-cmos -> "

if [ `/sbin/lsmod |grep -i rtc-cmos|wc -l` -gt 0 ] ; then
        echo "Module rtc-cmos loaded succesfully"
        else echo "Module rtc-cmos is not loaded "
fi
