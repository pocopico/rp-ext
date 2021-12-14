#
# Checking modules is loaded
#

echo -n "Checking if module is loaded mlx4_core -> "

if [ `/sbin/lsmod |grep -i mlx4_core|wc -l` -gt 0 ] ; then
        echo "Module mlx4_core loaded succesfully"
        else echo "Module mlx4_core is not loaded "
	exit 
fi


ls -l /sys/class/net/*/device/driver/module | cut -d/ -f5,13 |sed 's?/? ?' | while read line
do

read ethint module <<< $line

#echo "ethint=$ethint, module=$module"
	
	if [ "$module" = "mlx4_core" ] || [ "$module" = "mlx4_en" ] ; then

		if [ `ip link  | grep $ethint  | grep "state UP" | wc -l` -gt 0 ] ; then
		echo "Interface is already up"
		else
		echo  "Bringing up mlx4 interfaces"
		ifconfig $ethint up
		fi
	else 
	echo "Skipping $ethint as its $module"
	fi

done


