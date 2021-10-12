#
# Checking modules is loaded
#

echo -n "Loading module vmw_pvscsi -> "

if [ 0 -eq 1 ] ; then
        echo "Module vmw_pvscsi loaded succesfully"
        else echo "Module vmw_pvscsi is not loaded "
fi
