#!/bin/bash

function getvalues() {

	days=(Sat Mon Tue Wed Thu Fri Sun)

	let day=0

	echo "$dayset" | while IFS= read -r -n1 char; do
		# display one character at a time
		#	echo  "$char"
		if [ -n $char ] && [ "$char" = "1" ]; then
			if [ "$(date +%s -d "today ${days[$day]} $hour:$minutes")" -gt "$(date +%s)" ]; then
				echo "$(date +%s -d "this ${days[$day]} $hour:$minutes")"
			else
				echo "$(date +%s -d "next ${days[$day]} $hour:$minutes")"
			fi
		fi
		let day=$day+1
	done | sort -n | head -1

}

function setpowerup() {

	if [ -f /etc/power_sched.conf ]; then

		setting="$(sed -n '/Power On/,/Power Off/ p' /etc/power_sched.conf | grep -v Power | sort -n | head -1 | /bin/dec2bin)"

		if [ -n $setting ] && [ $(printf $setting | wc -c) -eq 32 ]; then
			dayset="$(echo $setting | cut -c 10-16)"
			hr="$(echo "$setting" | cut -c 17-24)"
			min="$(echo "$setting" | cut -c 25-32)"

			hour="$((2#$hr))"
			minutes="$((2#$min))"

		else
			echo "No setting yet" && exit 0
		fi

	else
		echo "No power schedule yet" && exit 0
	fi

	if [ "$dayset" != "0000000" ]; then
		startupdate="$(getvalues)"
		#echo "Dayset : $dayset hour: $hour minutes: minutes"
		echo "System will be set to startup at : $(date -d @$startupdate) , epoch startdate : $startupdate"
		logger -p err "System will be set to startup at : $(date -d @$startupdate) , epoch startdate : $startupdate"
		sudo sh -c "echo 0 > /sys/class/rtc/rtc0/wakealarm"
		sudo sh -c "echo $(date '+%s' -d @$startupdate) > /sys/class/rtc/rtc0/wakealarm"
	fi
}

case $1 in

start)
	touch /etc/power_sched.conf
	/etc/rtcwake/adhocify -d -m IN_MODIFY -w /etc/power_sched.conf /etc/rtcwake/setpowerup.sh -o /etc/rtcwake/adhocify.log
	setpowerup
	;;

stop)
	killall adhocify
	setpowerup
	;;

*)
	setpowerup
	;;

esac

for line in $(sed -n '/Power On/,/Power Off/ p' /etc/power_sched.conf | grep -v Power | sort -n); do
	hr="$((2#$(echo $line | dec2bin | cut -c 17-24)))"
	min="$((2#$(echo $line | dec2bin | cut -c 25-32)))"
	echo $line $hr $min
done
