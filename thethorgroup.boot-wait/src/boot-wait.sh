#!/bin/sh

wait_time=30 # maximum wait time in seconds

dump_all_partitions()
{
  echo ""
  echo "========== BEGIN DUMP OF ALL PARTITIONS DETECTED ==========="
  /usr/sbin/sfdisk -l
  echo "========== END OF DUMP OF ALL PARTITIONS DETECTED =========="
}

time_counter=0
while [ ! -b /dev/synoboot ] && [ $time_counter -lt $wait_time ]; do
  sleep 1
  echo "Still waiting for boot device (waited $((time_counter=time_counter+1)) of ${wait_time} seconds)"
done

if [ ! -b /dev/synoboot ]; then
  touch /.no_synoboot
  echo "ERROR: Timeout waiting for /dev/synoboot device to appear."
  echo "Most likely your vid/pid configuration is not correct, or you don't have drivers needed for your USB/SATA controller"
  dump_all_partitions
  exit 1
fi

[ -b /dev/synoboot3 ] || sleep 1 # sometimes we can hit synoboot but before partscan
if [ ! -b /dev/synoboot1 ] || [ ! -b /dev/synoboot2 ] || [ ! -b /dev/synoboot3 ]; then
  echo "The /dev/synoboot device exists but it does not contain expected partitions (>=3 partitions)"
  dump_all_partitions
  exit 1
fi

echo "Confirmed a valid-looking /dev/synoboot device"
