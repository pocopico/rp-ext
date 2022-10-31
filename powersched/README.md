The DSM GUI Power on/off settings are written on file #/etc/power_sched.conf

The contents are : 

[Power On schedule]
25104128
[Power Off schedule]

Its a decimal value that if you convert it to binary it results in :

startup

day        hex     bin
monday     1020D00 1000000100000110100000000
monday+tue 1060D00 1000001100000110100000000
alldays    17F0D00 1011111110000110100000000
weekdays   13E0D00 1001111100000110100000000
weekend    1410D00 1010000010000110100000000
disabled 410D00      10000010000110100000000

shutdown
           17F0500 1011111110000010100000000

So as you might guess a portion if for the weekdays sunday to saturday and the rest is the hour and seconds in hexadecimal format.

e.g.         10|1111111|00001101|00000000| = 0d00 which is 1300 
             FN|  DAYS |  HOURS | MINUTES 

The last binary digits are related to whether its enabled or disabled and if its shutdown or poweron 

Once you have these settings to enable rtc-cmos wakealarm you should execute :

$ sudo sh -c "echo 0 > /sys/class/rtc/rtc0/wakealarm"

$ sudo sh -c "echo `date '+%s' -d '+ 3 minutes'` > /sys/class/rtc/rtc0/wakealarm"

Date format is epoch and you should always zero the wakealarm first before reseting.
