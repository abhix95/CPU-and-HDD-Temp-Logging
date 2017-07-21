# CPU and HDD temperature monitoring system

#### Use case
You  might  run  into  a  situation  where  your  old  laptop  or  your  new  work  machine  starts  running  hotter  even when  you  are  running  no  task  which  is  either CPU  or  I/O  intensive  in  particular.  Maybe  it's  time  to  do  a  clean install  of  your  favourite  linux  distro (the lazy way)  or  deep  dive  and  investigate  what  might be  causing  the overheating  (the time-consuming way). 
Either  way  you  want  to  see  and  be  able  to  analyze  how  hot  your  CPU  cores  and  your  hard  disk  is  running  at. A  record  of  these  temperatures  persisting  over  usage  sessions  might  help  narrow  down  the  cause of  the  heating.
My old laptop which was acting as a media server started overheating. Thus I decided to write this script.  

#### Problem definition
Write  a  script  that  logs  CPU  core  temperature  and  Hard  Disk  Drive (HDD)  temperatures  every  30  seconds  in a  file.  The  script  must  start  automatically  on booting.
