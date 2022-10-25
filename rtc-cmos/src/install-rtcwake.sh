#!/bin/sh

tar -zxvf rtcwake.tar.gz -C /tmpRoot/

# enable
#systemctl enable rtcwake.service
#ln -s /usr/lib/systemd/system/rtcwake.service /tmpRoot/etc/systemd/system/multi-user.target.wants/rtcwake.service
mkdir -p /tmpRoot/etc/systemd/system/syno-bootup-done.target.wants
ln -s /usr/lib/systemd/system/rtcwake.service /tmpRoot/etc/systemd/system/syno-bootup-done.target.wants/rtcwake.service

# start
#systemctl start rtcwake.service

