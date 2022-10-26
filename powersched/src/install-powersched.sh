  echo "Installing powersched tools"
  cp -vf powersched /tmpRoot/usr/sbin/powersched
  chmod 755 /tmpRoot/usr/sbin/powersched
  cat > /tmpRoot/etc/systemd/system/powersched.timer <<'EOF'
[Unit]
Description=Configure RTC to DSM power schedule
[Timer]
OnCalendar=*-*-* *:*:00
Persistent=true
[Install]
WantedBy=timers.target
EOF
  mkdir -p /tmpRoot/etc/systemd/system/timers.target.wants
  ln -sf /etc/systemd/system/powersched.timer /tmpRoot/etc/systemd/system/timers.target.wants/powersched.timer
  cat > /tmpRoot/etc/systemd/system/powersched.service <<'EOF'
[Unit]
Description=Configure RTC to DSM power schedule
[Service]
Type=oneshot
ExecStart=/usr/sbin/powersched
[Install]
WantedBy=multi-user.target
EOF
  mkdir -p /tmpRoot/etc/systemd/system/multi-user.target.wants
  ln -sf /etc/systemd/system/powersched.service /tmpRoot/etc/systemd/system/multi-user.target.wants/powersched.service
