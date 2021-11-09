#!/bin/sh

PATH="$PATH:/bin/"               # cat
PATH="$PATH:/sbin/"              # agetty
PATH="$PATH:/usr/bin"            # basename
HTTPD="/usr/sbin/httpd"


usage() {
        cat <<EOF
Usage: $(basename $0) [start|stop|restart]
EOF
}

start() {

        echo "---------={ Starting agetty service }=---------"

if [ `who -u |grep -i ttyACM0| grep -v grep | wc -l ` -eq 1 ] ;
then
echo "User looged in from Serial Terminal waiting for exit"
else
        if [ `ps -ef |grep -ie ttyACM0 |grep -v grep | wc -l` -eq 1 ];
        then
        echo "agetty running"
        else
        echo "Starting agetty"
        /sbin/agetty --local-line 115200 ttyACM0 vt100
        fi
fi


}
stop() {

        echo "---------={ Stopping agetty service }=---------"

}

case "$1" in
        start)   start ;;
        stop)    stop ;;
        restart) stop && start ;;
        *)       usage >&2 ; exit 1 ;;
esac



