#!/bin/bash

#for extension in `ls /mnt/hgfs/Downloads/rp-ext`
for extension in `cat exts`
do

	echo "Creating extension $extension"
#./create-ext-3622.sh $extension
	#cp $extension/releases/$extension-4.4.180plus-broadwellnk.tgz /mnt/hgfs/Downloads/rp-ext/$extension/releases
	cp $extension/releases/ds3615xs_42218.json /mnt/hgfs/Downloads/rp-ext/$extension/releases/ds3615xs_42621.json
	newline=`cat $extension/rp* |grep 3615xs_42218 | sed -e 's/42218/42621/g' `
	echo "Removing extension from file"
	#sed -i "s/\"ds3615xs_42621\": \"https:\/\/raw.githubusercontent.com\/pocopico\/rp-ext\/master\/$extension\/releases\/ds3615xs_42621.json\",//g" /mnt/hgfs/Downloads/rp-ext/$extension/rpext-index.json
	#sed -i "/ds3615xs_42218.json\",/a $newline" /mnt/hgfs/Downloads/rp-ext/$extension/rpext-index.json

# REMOVE EMPTY LINES : sed -r '/^\s*$/d'
       sed -i '/^\s*$/d' /mnt/hgfs/Downloads/rp-ext/$extension/rpext-index.json



	#sed -i '/$newline/d' /mnt/hgfs/Downloads/rp-ext/$extension/rpext-index.json
done


