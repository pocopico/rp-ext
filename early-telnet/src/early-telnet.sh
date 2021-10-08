#!/bin/sh

  echo ""
  if [ `netstat -an |grep "0.0.0.0:23" |wc -l` -gt 0 ] ;
  then
  echo "Telnet is already listening, no need to start"
  exit 0
  else

        echo "---------={ Starting early telnet service }=---------"
        /sbin/inetd
        if [ `netstat -an |grep "0.0.0.0:23" |wc -l` -gt 0 ] ;
        then
        echo "---------={ telnet service STARTED }=---------"
        else
        echo "---------={ telnet service Failed }=---------"
        fi
  fi

