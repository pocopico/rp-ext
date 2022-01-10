#
# Checking modules is loaded
#

echo -n "Loading module ata_piix -> "

if [ `/sbin/lsmod |grep -i ata_piix|wc -l` -eq 1 ] ; then
        echo "Module ata_piix loaded succesfully"
        else echo "Module ata_piix is not loaded "
fi
