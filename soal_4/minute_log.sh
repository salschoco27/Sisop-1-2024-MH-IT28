#!/bin/bash

### TAMBAHKAN INI KE CRONTAB
# * * * * * /home/aca/Documents/SISOP/Modul1/soal_nomor_4/minute_log.sh

# Mengekstrak penggunaan memori ke file teks sementara
free -m > temp.txt

# Mengekstrak penggunaan disk dari direktori home pengguna ke file teks sementara
user=whoami && du -sh /home/$user >> temp.txt

# Hasil cetak menggunakan Echo dan AWK
echo "mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" > /home/$user/log/"metrics_$(date +"%Y%m%d%H%M%S").log"
awk '/Mem/ {print $2","$3","$4","$5","$6","$7","};
     /Swa/ {print $2","$3","$4","};
     /home/ {print $2","$1}
     ' temp.txt | paste -s -d '' >> /home/$user/log/"metrics_$(date +"%Y%m%d%H%M%S").log"

# Mengelola izin
chmod +x minute_log.sh

# Menghapus file teks sementara
rm temp.txt
