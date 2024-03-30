#!/bin/bash

### ADD THIS TO THE CRONTAB
# * * * * * /home/aca/Documents/SISOP/Modul1/soal_nomor_4/minute_log.sh

# extracting memory usage to a temporary text file
free -m > temp.txt

# extracting disk usage from the user home directory to THE temporary text file
user=whoami && du -sh /home/$user >> temp.txt

# print results using echo and awk
echo "mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" > /home/$user/log/"metrics_$(date +"%Y%m%d%H%M%S").log"
awk '/Mem/ {print $2","$3","$4","$5","$6","$7","};
     /Swa/ {print $2","$3","$4","};
     /home/ {print $2","$1}
     ' temp.txt | paste -s -d '' >> /home/$user/log/"metrics_$(date +"%Y%m%d%H%M%S").log"

# manage permissions
chmod go-rwx "/home/$user/log/""metrics_$(date +"%Y%m%d%H%M%S").log"    

# delete the temporary text file
rm temp.txt
