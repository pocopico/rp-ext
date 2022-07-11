#!/usr/bin/env ash


### USUALLY SCEMD is the last process run in init, so when scemd is running we are most
# probably certain that system has finish init process
#


if [ `ps -ef |grep -i scemd |grep -v grep | wc -l` -gt 0 ] ; then
HASBOOTED="yes"
echo "System has completed init process"
else
echo "System is booting"
HASBOOTED="no"
fi


if [ "$HASBOOTED" = "no" ]; then
  echo "dtbpatch - early"
  # fix executable flag
  cp dtbpatch /usr/sbin/
  chmod +x /usr/sbin/dtbpatch

  # Dynamic generation
  /usr/sbin/dtbpatch /etc.defaults/model.dtb output.dtb
  if [ $? -ne 0 ]; then
    echo "Error patching dtb"
  else
    cp -vf output.dtb /etc.defaults/model.dtb
    cp -vf output.dtb /var/run/model.dtb
    cp -vf /etc.defaults/model.dtb /tmpRoot/etc.defaults/model.dtb
  fi
elif [ "$HASBOOTED" = "yes" ]; then
  echo "dtbpatch - late"
  # copy file
  cp -vf /etc.defaults/model.dtb /tmpRoot/etc.defaults/model.dtb
  cp -vf /etc.defaults/model.dtb /var/run/model.dtb
fi
