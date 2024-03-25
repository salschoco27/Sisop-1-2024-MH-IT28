#!/bin/bash

### ADD THIS TO THE CRONTAB
# 0 * * * * /home/aca/Documents/SISOP/Modul1/soal_nomor_4/aggregate_minutes_to_hourly_log.sh

# find all log files located in the log folder
user=whoami
range=date -d '-1 hour' +%Y%m%d%H
find /home/$user/log -name "$range" -not -name 'agg' -exec awk -F "," 'END{cmd=sprintf("numfmt --from=iec %s",$11); cmd | getline conv; close(cmd); print $0","  conv}' {} \; > temphour.txt 

# create the hourly log file
echo "type,mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" > /home/$user/log/"metrics_agg_$(date +"%Y%m%d%H").log"
    # minimum
awk -F "," '(NR==1){t = $1} {t = $1<t ? $1:t}  END{print "minimum,"t","}
            (NR==1){a = $2} {a = $2<a ? $2:a}  END{print a","}
            (NR==1){b = $3} {b = $3<b ? $3:b}  END{print b","}
            (NR==1){c = $4} {c = $4<c ? $4:c}  END{print c","}
            (NR==1){d = $5} {d = $5<d ? $5:d}  END{print d","}
            (NR==1){e = $6} {e = $6<e ? $6:e}  END{print e","}
            (NR==1){f = $7} {f = $7<f ? $7:f}  END{print f","}
            (NR==1){g = $8} {g = $8<g ? $8:g}  END{print g","}
            (NR==1){h = $9} {h = $9<h ? $9:h}  END{print h","$10","}
            (NR==1){m = $12}{m = $12<m ? $12:m}END{cmd=sprintf("numfmt --to=iec %d",m); cmd | getline conv; close(cmd); print conv}
            ' temphour.txt | paste -s -d '' >> /home/$user/log/"metrics_agg_$(date +"%Y%m%d%H").log"
    # maximum
awk -F "," '(NR==1){t = $1} {t = $1>t ? $1:t}  END{print "maximum,"t","}
            (NR==1){a = $2} {a = $2>a ? $2:a}  END{print a","}
            (NR==1){b = $3} {b = $3>b ? $3:b}  END{print b","}
            (NR==1){c = $4} {c = $4>c ? $4:c}  END{print c","}
            (NR==1){d = $5} {d = $5>d ? $5:d}  END{print d","}
            (NR==1){e = $6} {e = $6>e ? $6:e}  END{print e","}
            (NR==1){f = $7} {f = $7>f ? $7:f}  END{print f","}
            (NR==1){g = $8} {g = $8>g ? $8:g}  END{print g","}
            (NR==1){h = $9} {h = $9>h ? $9:h}  END{print h","$10","}
            (NR==1){m = $12}{m = $12>m ? $12:m}END{cmd=sprintf("numfmt --to=iec %d",m); cmd | getline conv; close(cmd); print conv}
            ' temphour.txt | paste -s -d '' >> /home/$user/log/"metrics_agg_$(date +"%Y%m%d%H").log"
    # average
awk -F "," '{t+=$1}  END{print "average,"t/NR","}
            {a+=$2}  END{print a/NR","}
            {b+=$3}  END{print b/NR","}
            {c+=$4}  END{print c/NR","}
            {d+=$5}  END{print d/NR","}
            {e+=$6}  END{print e/NR","}
            {f+=$7}  END{print f/NR","}
            {g+=$8}  END{print g/NR","}
            {h+=$9}  END{print h/NR","$10","}
            {m+=$12} END{cmd=sprintf("numfmt --to=iec %d",m/NR); cmd | getline conv; close(cmd); print conv}
            ' temphour.txt | paste -s -d '' >> /home/$user/log/"metrics_agg_$(date +"%Y%m%d%H").log"

# manage permissions
chmod go-rwx "/home/$user/log/"metrics_agg_$(date +"%Y%m%d%H").log""

# delete the temporary text file
rm temphour.txt
