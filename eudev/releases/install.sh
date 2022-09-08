#!/usr/bin/env ash



### USUALLY SCEMD is the last process run in init, so when scemd is running we are most
# probably certain that system has finish init process
#


if [ `mount | grep tmpRoot | wc -l` -gt 0 ] ; then
HASBOOTED="yes"
echo -n "System passed junior"
else
echo -n "System is booting"
HASBOOTED="no"
fi

if [ "$HASBOOTED" = "no" ]; then

  echo "Starting eudev daemon"
  [ -e /proc/sys/kernel/hotplug ] && printf '\000\000\000\000' > /proc/sys/kernel/hotplug
  /sbin/udevd -d || { echo "FAIL"; exit 1; }
  echo "Triggering add events to udev"
  udevadm trigger --type=subsystems --action=add
  udevadm trigger --type=devices --action=add
  udevadm settle --timeout=10 || echo "udevadm settle failed"

elif [ "$HASBOOTED" = "yes" ]; then
  echo "eudev - late"
fi

