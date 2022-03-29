#!/bin/bash

#for extension in `ls /mnt/hgfs/Downloads/rp-ext`
for extension in `cat exts`
do
	echo "Creating extension $extension"
#./create-ext-3622.sh $extension
	#cp $extension/releases/$extension-4.4.180plus-broadwellnk.tgz /mnt/hgfs/Downloads/rp-ext/$extension/releases
	cp $extension/releases/dva3221_42218.json /mnt/hgfs/Downloads/rp-ext/$extension/releases/dva3221_42621.json
	newline=`cat $extension/rp* |grep 3221 | sed -e 's/42218/42621/g' `

	sed -i "/dva3221_42218.json\",/a $newline" /mnt/hgfs/Downloads/rp-ext/$extension/rpext-index.json
	#sed -i '/$newline/d' /mnt/hgfs/Downloads/rp-ext/$extension/rpext-index.json
done


