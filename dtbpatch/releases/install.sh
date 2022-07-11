#!/usr/bin/env ash

if [ "${1}" = "early" ]; then
  echo "dtbpatch - early"
  # fix executable flag
  chmod +x /usr/sbin/dtbpatch

  # Dynamic generation
  dtbpatch /etc.defaults/model.dtb output.dtb
  if [ $? -ne 0 ]; then
    echo "Error patching dtb"
  else
    cp -vf output.dtb /etc.defaults/model.dtb
    cp -vf output.dtb /var/run/model.dtb
  fi
elif [ "${1}" = "late" ]; then
  echo "dtbpatch - late"
  # copy file
  cp -vf /etc.defaults/model.dtb /tmpRoot/etc.defaults/model.dtb
fi
