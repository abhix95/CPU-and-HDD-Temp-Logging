
#### Use case
You  might  run  into  a  situation  where  your  old  laptop  or  your  new  work  machine  starts  running  hotter  even when  you  are  running  no  task  which  is  either CPU  or  I/O  intensive  in  particular.  Maybe  it's  time  to  do  a  clean install  of  your  favourite  linux  distro (the lazy way)  or  deep  dive  and  investigate  what  might be  causing  the overheating  (the time-consuming way).


Either  way  you  want  to  see  and  be  able  to  analyze  how  hot  your  CPU  cores  and  your  hard  disk  is  running  at. A  record  of  these  temperatures  persisting  over  usage  sessions  might  help  narrow  down  the  cause of  the  heating.


My old laptop which was acting as a media server started overheating. Thus I decided to write this script.  

#### Problem definition
Write  a  script  that  logs  CPU  core  temperature  and  Hard  Disk  Drive (HDD)  temperatures  every  30  seconds  in a  file.  The  script  must  start  automatically  on booting.

#### Solution
For demonstration purposes I am going to use Ubuntu throughout this guide.

First let us install some dependencies.

```shell
sudo apt-get install lm-sensors
sudo apt-get install hddtemp
sudo chmod u+s /usr/sbin/hddtemp
```
The third command lets us run hddtemp without using sudo.

Now let us try running these commands on the terminal.
```shell
abhishek@ThinkPad-P50:~$ sensors
acpitz-virtual-0
Adapter: Virtual device
temp1:        +43.0°C  (crit = +128.0°C)

thinkpad-isa-0000
Adapter: ISA adapter
fan1:           0 RPM

coretemp-isa-0000
Adapter: ISA adapter
Physical id 0:  +43.0°C  (high = +100.0°C, crit = +100.0°C)
Core 0:         +41.0°C  (high = +100.0°C, crit = +100.0°C)
Core 1:         +41.0°C  (high = +100.0°C, crit = +100.0°C)
Core 2:         +39.0°C  (high = +100.0°C, crit = +100.0°C)
Core 3:         +40.0°C  (high = +100.0°C, crit = +100.0°C)

abhishek@ThinkPad-P50:~$ hddtemp /dev/sda1
/dev/sda1: ST500LM021-1KJ152: 43°C

```

Now we will extract the CPU core temperatures from the ouput of **sensors** command using pipe 

```shell
sensors | awk  '/Core/{print $3}' ORS=' '
```
Output
```shell
abhishek@ThinkPad-P50:~$ sensors | awk  '/Core/{print $3}' ORS=' '
+40.0°C +41.0°C +39.0°C +40.0°C abhishek@ThinkPad-P50:~$ 

```
" | " is known as unnamed pipe and is used to pass output of command on the left as input to command on the right.

" awk "" is pattern scanning and processing language. Check [here](https://linux.die.net/man/1/awk) for understanding what each option does and [here](https://www.tutorialspoint.com/awk/awk_tutorial.pdf) for a complete tuorial.

Similarly we can extract HDD tempretures using
```shell
hddtemp /dev/sda | awk  '//{print $3}
``` 
Output
```shell
abhishek@ThinkPad-P50:~$ hddtemp /dev/sda | awk  '//{print $3}'
41°C
```
You can find temperatures for other hard disks by replacing /dev/sda in the command with other appropriate names. You can find list of devices using
```shell
lsblk
```

Now that we have extracted the values that we need, we now

```shell
echo -e "$(date) \n " >> ~/log
   while :
   do
		core_temp=`sensors | awk  '/Core/{print $3}' ORS=' '`
        hdd_temp=`hddtemp /dev/sda | awk  '//{print $4}'`
        echo $core_temp $hdd_temp >> ~/log
		echo  -e "\n"
        sleep 30
done
```

We save the date and time each time the script is started. After that we go in an infinite loop which gathers required data and appends to "~/log" ie. in a file named "log" in your home directory every 30 seconds.

The file should look like this
```
Fri Jul 21 15:23:23 IST 2017 
 
+40.0°C +41.0°C +38.0°C +40.0°C 42°C
+45.0°C +42.0°C +48.0°C +42.0°C 42°C
+42.0°C +43.0°C +40.0°C +41.0°C 42°C
```

Now we want this script to automatically start and stop as the systems starts and stops. So we add the header as specified in the Linux Standard Base(LSB)
 

 update-rc.d

```shell
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
        hdd_temp=`hddtemp /dev/sda | awk  '//{print $3}'`
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
```
This [page](https://wiki.debian.org/LSBInitScripts) helps understand the header.
We then move the script to /etc/init.d/, make it executable by adding the +x flag.

```shell
sudo cp <name> /etc/int.d/<name>
sudo chmod 755 /etc/init.d/<name>
sudo chown root:root /etc/init.d/<name>
sudo update-rc.d <name> defaults
sudo update-rc.d <name> enable
```

And voila!
Your script is ready and should start automatically when you boot into the system. 
