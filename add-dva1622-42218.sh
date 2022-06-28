#!/bin/bash

#for extension in `ls /mnt/hgfs/Downloads/rp-ext`
for extension in $(cat exts); do

	echo "Creating extension $extension"
	#./create-ext-3622.sh $extension
	#cp $extension/releases/$extension-4.4.180plus-broadwellnk.tgz /mnt/hgfs/Downloads/rp-ext/$extension/releases

	cp $extension/releases/ds920p_42218.json /mnt/hgfs/Downloads/rp-ext/$extension/releases/dva1622_42218.json
	echo -n "Adding extension $extension from file"
	newline=$(cat $extension/rp* | grep 920p_42661 | sort -n | head -1 | sed -e 's/ds920p/dva1622/g')
	echo "$newline"
	sed -i "/\"dva3221_42661\": \"/a $newline" /mnt/hgfs/Downloads/rp-ext/${extension}/rpext-index.json

	#cat /mnt/hgfs/Downloads/rp-ext/${extension}/rpext-index.json | jq . >/mnt/hgfs/Downloads/rp-ext/${extension}/temp
	#mv /mnt/hgfs/Downloads/rp-ext/${extension}/temp /mnt/hgfs/Downloads/rp-ext/${extension}/rpext-index.json

done
