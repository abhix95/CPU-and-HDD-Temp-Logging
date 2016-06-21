#!/bin/bash
### BEGIN INIT INFO
# Provides:          temperature_recording_daemon
# Required-Start:
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Record CPU and HDD temperatures
# Description:       This script stores CPU and HDD temperatures every 30 seconds in the format
#                    CORE1_temp CORE2_temp HDD_temp
#
### END INIT INFO

case "$1" in
 start)
   echo -e "$(date) \n " >> /home/log
   while :
   do
	core_temp=`sensors | awk  '/Core/{print $3}' ORS=' '`
        hdd_temp=`hddtemp /dev/sda | awk  '//{print $4}'`
        echo $core_temp $hdd_temp >> /home/log
	echo  -e "\n"
        sleep 30
   done
   ;;
 stop)

   ;;
 restart)

   ;;
 *)
   ;;
esac

