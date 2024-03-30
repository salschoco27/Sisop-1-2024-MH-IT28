#!/bin/bash

### TAMBAHKAN INI KE CRONTAB
# 0 * * * * /home/aca/Dokumen/SISOP/Modul1/soal_nomor_4/aggregate_minutes_to_hourly_log.sh

# Mengidentifikasi file log dalam direktori yang ditentukan
pengguna=$(whoami)
rentang_waktu=$(date -d '-1 jam' +%Y%m%d%H)
cari /home/$pengguna/log -name "$rentang_waktu" -not -name 'agg' -exec awk -F "," 'END{perintah=sprintf("numfmt --from=iec %s",$11); perintah | getline conv; close(perintah); print $0","  conv}' {} \; > temphour.txt 

# Membuat file log per jam
echo "jenis,total_memori,memori_terpakai,memori_kosong,memori_dibagi,memori_buffer,memori_tersedia,total_swap,swap_terpakai,swap_kosong,path,ukuran_path" > /home/$pengguna/log/"metrics_agg_$(date +"%Y%m%d%H").log"
    # Minimum
awk -F "," '(NR==1){min = $1} {min = $1<min ? $1:min}  END{print "minimum,"min","}
            (NR==1){a = $2} {a = $2<a ? $2:a}  END{print a","}
            (NR==1){b = $3} {b = $3<b ? $3:b}  END{print b","}
            (NR==1){c = $4} {c = $4<c ? $4:c}  END{print c","}
            (NR==1){d = $5} {d = $5<d ? $5:d}  END{print d","}
            (NR==1){e = $6} {e = $6<e ? $6:e}  END{print e","}
            (NR==1){f = $7} {f = $7<f ? $7:f}  END{print f","}
            (NR==1){g = $8} {g = $8<g ? $8:g}  END{print g","}
            (NR==1){h = $9} {h = $9<h ? $9:h}  END{print h","$10","}
            (NR==1){m = $12}{m = $12<m ? $12:m}END{perintah=sprintf("numfmt --to=iec %d",m); perintah | getline conv; close(perintah); print conv}
            ' temphour.txt | paste -s -d '' >> /home/$pengguna/log/"metrics_agg_$(date +"%Y%m%d%H").log"
    # Maksimum
awk -F "," '(NR==1){max = $1} {max = $1>max ? $1:max}  END{print "maksimum,"max","}
            (NR==1){a = $2} {a = $2>a ? $2:a}  END{print a","}
            (NR==1){b = $3} {b = $3>b ? $3:b}  END{print b","}
            (NR==1){c = $4} {c = $4>c ? $4:c}  END{print c","}
            (NR==1){d = $5} {d = $5>d ? $5:d}  END{print d","}
            (NR==1){e = $6} {e = $6>e ? $6:e}  END{print e","}
            (NR==1){f = $7} {f = $7>f ? $7:f}  END{print f","}
            (NR==1){g = $8} {g = $8>g ? $8:g}  END{print g","}
            (NR==1){h = $9} {h = $9>h ? $9:h}  END{print h","$10","}
            (NR==1){m = $12}{m = $12>m ? $12:m}END{perintah=sprintf("numfmt --to=iec %d",m); perintah | getline conv; close(perintah); print conv}
            ' temphour.txt | paste -s -d '' >> /home/$pengguna/log/"metrics_agg_$(date +"%Y%m%d%H").log"
    # Rata-rata
awk -F "," '{jumlah+=$1}  END{print "rata-rata,"jumlah/NR","}
            {a+=$2}  END{print a/NR","}
            {b+=$3}  END{print b/NR","}
            {c+=$4}  END{print c/NR","}
            {d+=$5}  END{print d/NR","}
            {e+=$6}  END{print e/NR","}
            {f+=$7}  END{print f/NR","}
            {g+=$8}  END{print g/NR","}
            {h+=$9}  END{print h/NR","$10","}
            {m+=$12} END{perintah=sprintf("numfmt --to=iec %d",m/NR); perintah | getline conv; close(perintah); print conv}
            ' temphour.txt | paste -s -d '' >> /home/$pengguna/log/"metrics_agg_$(date +"%Y%m%d%H").log"

# Mengelola izin file
chmod go-rwx "/home/$pengguna/log/"metrics_agg_$(date +"%Y%m%d%H").log""

# Menghapus file teks sementara
rm temphour.txt

