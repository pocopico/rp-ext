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
  tar xfz /exts/eudev/eudev.tgz -C /
  [ -e /proc/sys/kernel/hotplug ] && printf '\000\000\000\000' > /proc/sys/kernel/hotplug
  /sbin/udevd -d || { echo "FAIL"; exit 1; }
  echo "Triggering add events to udev"
  udevadm trigger --type=subsystems --action=add
  udevadm trigger --type=devices --action=add
  udevadm settle --timeout=10 || echo "udevadm settle failed"


  # Give more time
  sleep 10
  # Remove from memory to not conflict with RAID mount scripts
  /usr/bin/killall udevd
elif [ "$HASBOOTED" = "yes" ]; then
  echo "eudev - late"
  # Copy rules
  cp -vf /etc/udev/rules.d/* /tmpRoot/usr/lib/udev/rules.d/
  DEST="/tmpRoot/lib/systemd/system/udevrules.service"

  echo "[Unit]"                                                                  >${DEST}
  echo "Description=Reload udev rules"                                          >>${DEST}
  echo                                                                          >>${DEST}
  echo "[Service]"                                                              >>${DEST}
  echo "Type=oneshot"                                                           >>${DEST}
  echo "RemainAfterExit=true"                                                   >>${DEST}
  echo "ExecStart=/usr/bin/udevadm hwdb --update"                               >>${DEST}
  echo "ExecStart=/usr/bin/udevadm control --reload-rules"                      >>${DEST}
  echo                                                                          >>${DEST}
  echo "[Install]"                                                              >>${DEST}
  echo "WantedBy=multi-user.target"                                             >>${DEST}

  mkdir -p /tmpRoot/etc/systemd/system/multi-user.target.wants
  ln -sf /lib/systemd/system/udevrules.service /tmpRoot/lib/systemd/system/multi-user.target.wants/udevrules.service
fi


