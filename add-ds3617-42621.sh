#!/bin/bash

#for extension in `ls /mnt/hgfs/Downloads/rp-ext`
for extension in `cat exts`
do

	sed -i '/$newline/d' /mnt/hgfs/Downloads/rp-ext/$extension/rpext-index.json
done


