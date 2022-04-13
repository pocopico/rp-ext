#
# Checking modules is loaded
#

echo -n "Loading module ax88179_178a -> "

if [ `/sbin/lsmod |grep -i ax88179_178a|wc -l` -eq 1 ] ; then
        echo "Module ax88179_178a loaded succesfully"
        else echo "Module ax88179_178a is not loaded "
fi
