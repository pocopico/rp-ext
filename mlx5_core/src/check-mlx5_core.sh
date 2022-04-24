#
# Checking modules is loaded
#

echo -n "Loading module mlx5_core -> "

if [ `/sbin/lsmod |grep -i mlx5_core|wc -l` -gt 0 ] ; then
        echo "Module mlx5_core loaded succesfully"
        else echo "Module mlx5_core is not loaded "
fi
