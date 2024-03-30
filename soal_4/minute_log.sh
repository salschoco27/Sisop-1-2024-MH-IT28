#!/bin/bash

### TAMBAHKAN INI KE CRONTAB
# * * * * * /home/aca/Dokumen/SISOP/Modul1/soal_nomor_4/minute_log.sh

# mengekstraksi penggunaan memori ke file teks sementara
free -m > temp.txt

# mengekstraksi penggunaan disk dari direktori home pengguna ke file teks sementara
pengguna=whoami && du -sh /home/$pengguna >> temp.txt

# mencetak hasil menggunakan echo dan awk
echo "mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" > /home/$pengguna/log/"metrics_$(date +"%Y%m%d%H%M%S").log"
awk '/Mem/ {print $2","$3","$4","$5","$6","$7","};
     /Swa/ {print $2","$3","$4","};
     /home/ {print $2","$1}
     ' temp.txt | paste -s -d '' >> /home/$pengguna/log/"metrics_$(date +"%Y%m%d%H%M%S").log"

# mengelola izin
chmod go-rwx "/home/$pengguna/log/""metrics_$(date +"%Y%m%d%H%M%S").log"    

# menghapus file teks sementara
rm temp.txt

