#
# Checking modules is loaded
#

echo -n "Loading module ax88179_178a -> "

if [ `/sbin/lsmod |grep -i ax88179_178a|wc -l` -gt 0 ] ; then
        echo "Module ax88179_178a loaded succesfully"
        else echo "Module ax88179_178a is not loaded "
fi
