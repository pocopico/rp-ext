#!/usr/bin/env ash


### USUALLY SCEMD is the last process run in init, so when scemd is running we are most
# probably certain that system has finish init process
#


if [ `mount | grep tmpRoot | wc -l` -gt 0 ] ; then
HASBOOTED="yes"
echo "System passed junior"
else
echo "System is booting"
HASBOOTED="no"
fi


if [ "$HASBOOTED" = "no" ]; then
  echo "dtbpatch - early"
  # fix executable flag
  cp dtbpatch /usr/sbin/
  cp dtc /usr/sbin/
  chmod +x /usr/sbin/dtbpatch
  chmod +x /usr/sbin/dtc

  # Dynamic generation
  /usr/sbin/dtbpatch /etc.defaults/model.dtb output.dtb
  if [ $? -ne 0 ]; then
    echo "Error patching dtb"
  else
    cp -vf output.dtb /etc.defaults/model.dtb
    cp -vf output.dtb /var/run/model.dtb
    /usr/sbin/dtc -I dtb -O dts /etc.defaults/model.dtb > /etc.defaults/model.dts
  fi
elif [ "$HASBOOTED" = "yes" ]; then
  echo "dtbpatch - late"
  # copy utilities 
  cp /usr/sbin/dtbpatch /tmpRoot/usr/sbin
  cp /usr/sbin/dtc /tmpRoot/usr/sbin
  # copy file
  cp -vf /etc.defaults/model.dtb /tmpRoot/etc.defaults/model.dtb
  cp -vf /etc.defaults/model.dtb /var/run/model.dtb
fi
