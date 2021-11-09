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
	/sbin/agettystart.sh &

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



