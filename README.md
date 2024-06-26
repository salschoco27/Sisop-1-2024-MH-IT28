#   SOAL SHIFT SISTEM OPERASI MODUL 1
Kelompok IT28:
- Salsabila Rahmah (5027231005)
- Fadlillah Cantika Sari H (5027231042)
- I Dewa Made Satya Raditya (5027231051)
## Soal 1
### Sandbox.sh
1. Download Sandbox.csv
`export fileid=1cC6MYBI3wRwDgqlFQE1OQUN83JAreId0 && export filename=Sandbox.csv && wget -O $filename 'https://docs.google.com/uc?export=download&id='$fileid`
3. Menampilkan nama pembeli dengan total sales paling tinggi. ```sort -t ',' -k17,17 -r Sandbox.csv | head -n 5```
Menggunakan sort descending "-r" dalam kolom ke 17 yaitu Sales.  Menampilkan 3 data customer teratas dengan sales paling tinggi.
4. Menampilkan customer yang memiliki profit paling kecil.   ```sort -t ',' -k20,20 Sandbox.csv | head -n 5```
Menggunakan sort ascending dalam kolom ke 20 yaitu profit. Dan mengambil 3 data teratas dengan profit terkecil.
5. Menampilkan 3 kategori produk dengan profit paling tinggi. ```awk -F ',' '{sum[$14]+=$20} END {for (i in sum) print i " = " sum[i]}' Sandbox.csv | sort -t ',' -k14,14nr | head -n 4```
6. Mencari purchase date dan amount (qty) dari nama Adriaens. ```grep 'Adriaens' Sandbox.csv | awk -F ',' '{print $2 "           " $18}'```
### Revisi & Catatan
- Soal 1a harusnya menampilkan nama customer dengan sales tertinggi saja.
Maka Code menjadi
```
sort -t ',' -k 17 -nr Sandbox.csv | head -n 3 | awk -F ',' '{print $6 "      "   $17}'
```
- Soal 1b harusnya menampilkan nama customer dengan profit tekecil saja.
Maka Code menjadi
```
sort -t ',' -k20,20 Sandbox.csv | head -n 3 |awk -F ',' '{print $6 "     " $20}'
```
- Soal 1c tampilkan 3 data (tanpa _Category = 0_)
Maka Code menjadi
```
awk -F ',' 'NR>1 {sum[$14]+=$20} END {for (i in sum) print i "=" sum[i]}' Sandbox.csv | sort -t ',' -k 14nr | head -4
```

### Dokumentasi
**Keterangan:** yang bertanda pagar (#) adalah code setelah direvisi.

<img width="478" alt="image" src="https://github.com/salschoco27/Sisop-1-2024-MH-IT28/assets/151063684/49139438-55cf-477f-8938-87bddc177d75">

**Sebelum direvisi**

<img width="668" alt="image" src="https://github.com/salschoco27/Sisop-1-2024-MH-IT28/assets/151063684/182841bf-c336-4073-b8a7-1d1d499a5f17">

**Setelah direvisi**

<img width="366" alt="image" src="https://github.com/salschoco27/Sisop-1-2024-MH-IT28/assets/151063684/b392c427-4306-4791-97cc-128f6490763a">


## Soal 2
### register.sh

* Function untuk password encryption
```
encryption() {
    echo -n "$1" | base64
}
encrypted_password=$(encryption "$password")
```

* Function untuk check apakah email sudah terdaftar/belum dan check apakah email tersebut admin atau bukan
```
check_duplicate_email() {
    local email=$1
    grep -q "^$email:" user.txt
    return $?
}
    if [[ "$email" == admin ]]; then
        user_type="admin"
    fi
```
* Declare data
```
register_user() {
    local email=$1
    local username=$2
    local sec_quest=$3
    local answer=$4
    local password=$5
    local user_type="user"
```
  
* Menjalankan function duplicate email dengan email yang sudah dimasukkan ketika registrasi GAGAL
```
      check_duplicate_email "$email"
    if [ $? -eq 0 ]; then
        echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [REGISTER FAILED] Failed registration with email $email because it’s already registered. " >> auth.log
        echo "Failed registration with email $email because it’s already registered. "
        exit 1
    fi
```

* Menjalankan function duplicate email dengan email yang sudah dimasukkan ketika registrasi BERHASIL
```
    #Write user data to user.txt with admin flag
    echo "$email:$username:$sec_quest:$answer:$encrypted_password:$user_type" >> user.txt

    if [[ $user_type == "admin" ]]; then
        echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [REGISTER SUCCESS] Admin $username registered successfully." >> auth.log
        echo "Admin $username registered successfully."
    else
        echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [REGISTER SUCCESS] user $username registered successfully." >> auth.log
        echo "User $username registered successfully."
    fi
}
```

* Main Function
```
touch user.txt
echo "Welcome to Registration System"
echo "Enter your email: "; read email
echo "Enter your username: " ; read username
echo "Enter a security question: "  ; read sec_quest
echo "Enter the answer to yout security question: "; read answer
read -sp "Enter a password(minimum 8 characters, at least 1 UPPERCASE letter, 1 lowercase letter, 1 digit, 1 symbol, and not the same as username, birthdate, or name): " password
echo

#verify pw
while true; do
    if [[ ${#password} -lt 8 || !("$password" =~ [[:lower:]]) || !("$password" =~ [[:upper:]]) || !("$password" =~ [0-9]) ]]; then
        #echo "Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one digit."
        read -sp "Password: " password
        echo
    else
        break
    fi
done
register_user "$email" "$username" "$sec_quest" "$answer" "$password"
```

### login.sh
* Code untuk melakukan decryption password dan menyimpannya.
```
decryption() {
    echo "$1" | base64 -d
}
save_pw_decrypted=$(decryption "$save_pw")
```

* Function untuk check apakah password yang dimasukkan user sudah benar.
```
check_pw() {
    local email=$1
    local password=$2
    local save_pw=$(grep "^$email:" user.txt | cut -d: -f5)
    local admincheck=$(grep "^$email:" user.txt | cut -d: -f6)

    if [ "$password" == "$save_pw_decrypted" ]; then
        return 0
    else
        return 1
    fi
}
```

* Function dibawah ini akan dijalankan ketika user memilih menu lupa password, dan akan menampilkan password dari user setelah user menjawab security question dengan benar.

**_Keterangan: Code error, tidak dapat menampilkan password._**
```
pw_forgot() {
    local email=$1
    local sec_quest=$(grep "^$email:" user.txt | cut -d: -f3)
    local correct_answer=$(grep "^$email:" user.txt | cut -d: -f4)
    read -p "Security Question: $sec_quest " user_answer

    if [ "$user_answer" == "$correct_answer" ]; then
        local save_pw=$(grep "^$email:" user.txt | cut -d: -f5)
        save_pw_decrypted=$(decryption "$save_pw")
        echo "Your password is: $save_pw_decrypted"
    else
        echo "Your answer is incorrect."
    fi
}
```
* Main Function untuk email type Admin.
```
admin_menu() {
    echo "Admin Menu:"
    echo "1. Add User"
    echo "2. Edit User"
    echo "3. Delete User"
    read action
    case $action in
        1)
            ./register.sh
            ;;
        2)
            ./edit_user.sh
            ;;
        3)
            ./delete_user.sh
            ;;
        *)
            echo "Choose 1, 2, or 3!"
            ;;
    esac
}
```

* Main Function untuk user biasa
```
echo "Welcome  to Login System"
echo "1. Login"
echo "2. Forgot Password"
read option
case $option in
    1)
        read -p "Enter your email: " email
        read -sp "Enter your password: " password
        echo
        grep -q "^$email:" user.txt
        if [ $? -ne 0 ]; then
            echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [LOGIN FAILED] ERROR Failed login attempt on user with email $email" >> auth.log
            echo "ERROR Failed login attempt on user with email $email"
            exit 1
        fi

#verif pw
        check_pw "$email" "$password"
        if [ $? -eq 0 ]; then
            echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [LOGIN SUCCESS] Login succeeded." >> auth.log

            admincheck=$(grep "^$email:" user.txt | cut -d: -f6)
            if [ "$admincheck" == "admin" ]; then
                admin_actions
            else
                echo "You do not have admin privileges. Welcome!"
            fi
        else
            echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [LOGIN FAILED] ERROR Password Incorrect" >> auth.log
            echo "ERROR Password Incorrect"
            read -p "Forgot Password? (Y/N): " choice
            if [ "$choice" == "Y" ]; then
                pw_forgot "$email"
            fi
        fi
        ;;
    2)
        read -p "Enter your email: " email
        pw_forgot "$email"
        ;;
    *)
        echo "Choose 1 or 2!"
        ;;
esac
```
### Catatan
- Password harusnya di decrypt juga.
### Dokumentasi
<img width="722" alt="image" src="https://github.com/salschoco27/Sisop-1-2024-MH-IT28/assets/151063684/14bcefba-2ca5-416d-a932-f0eee2e8cd91">

### ERROR
- Tidak bisa menampilkan password.
- Ketika ada email yang menggunakan kata _admin_, user type nya tidak terganti (tetap menjadi user).

## Soal 3

### Deskripsi soal

Alyss ingin mengoleksi foto-foto karakter game Genshin Impact yang diberikan oleh Yanuar dalam bentuk file yang namanya terenkripsi dengan heksadesimal. Untuk itu, dia harus:
A. Membuat script awal.sh yang dapat:

    1. Mendownload file dari link yang diberikan Yanuar
    2. Unzip file tersebut
    3. Mendekode nama file yang terenkripsi dengan heksadesimal
    4. Merename file sesuai format "Region - Nama - Elemen - Senjata.jpg" berdasarkan data pada file list_character.csv
    5. Mengumpulkan file ke dalam folder berdasarkan region karakter
    6. Menghitung dan menampilkan jumlah pengguna setiap senjata
    7. Menghapus file-file yang tidak digunakan
    
B. Membuat script search.sh yang dapat:

    1. Melakukan pengecekan setiap 1 detik pada setiap file gambar
    2. Mengekstrak value dari setiap gambar menggunakan steghide
    3. Mendekripsi file teks yang diekstrak dari gambar untuk mendapatkan URL
    4. Menghentikan program dan mendownload file berdasarkan URL yang diperoleh
    5. Menghapus file teks jika bukan yang dicari, atau menyimpan hasil dekripsinya jika itu yang dicari
    6. Mencatat log setiap pengecekan gambar dalam format tertentu
    
Tujuan akhirnya pada soal adalah agar Alyss dapat mengoleksi foto-foto karakter Genshin Impact dengan rapi, mengetahui jumlah pengguna setiap senjata, dan menemukan gambar rahasia yang disinggung oleh Yanuar.

### awal.sh
### langkah pengerjaan
1. salin kode skrip ke dalam file yang bernama awal.sh

a. endownload file dari link yang diberikan Yanuar & unzip file yang di download tadi
```
curl -L "https://drive.usercontent.google.com/u/0/uc?id=1oGHdTf4_76_RacfmQIV4i7os4sGwa9vN&export=download" -o genshin.zip && unzip genshin.zip -d genshinstuff

cd genshinstuff 

unzip genshin_character.zip
```
b. de-encrypt nama file yang terenkripsi dengan heksadesimal 
```
cd genshin_character
for file in *.jpg; do
    filename=$(printf '%b\n' "${file##*/}")
    rename=$(echo "$filename" | xxd -r -p)
    if [ "$rename" != "genshin_character" ]; then
        mv "$file" "$rename"

```
c.rename nama file berdasarkan data yang berada di dalam list_character.csv
```
updated=$(awk -F, "/$rename/"'{OFS=0;print $2 "-" $1 "-" $3 "-" $4}' ../list_character.csv)
        mv "$rename" "$updated.jpg" ##ganti nama lagi tapi disesuaikan dengan list_character.csv nya
    fi
done
```
d.membaca file list_character.csv dan sortir file {nama karakter yang sudah di de-encrypt}.jpg ke folder region asal masing-masing karakter

```
while IFS=',' read -r nama region element senjata; do
    # cek data di file .csv
    filename="${region} - ${nama} - ${element} - ${senjata}.jpg"
    namaori="$updated.jpg"

    # buat direct region utk char
    mkdir -p "$region"

    # Cek file JPG dengan nama asli ada/tidak
    if [ -f "$namaori" ]; then
        # Mengubah nama file JPG sesuai dengan format baru
        mv "$namaori" "$region/$filename"
    else
        echo "File $namaori tidak ditemukan."
    fi
done < ../list_character.csv
```
e. menghitung jumlah user senjata di dalam file .csv 

```
for weapon in $(awk -F',' '{print $4}' ../list_character.csv | sort | uniq)
do
    count=$(find . -name "*$weapon*" | wc -l)
    echo "[$weapon] : $count"
done < ../list_character.csv
```


### Dokumentasi:
-perubahan nama pada file .jpg karakter menjadi sesuai format (region-nama-element-senjata) dari yang sebelumnya hanya muncul nama saja

* Sebelum Revisi
 -yang terlihat di console
  ![Screenshot from 2024-03-30 22-51-27](https://github.com/salschoco27/Sisop-1-2024-MH-IT28/assets/163504787/4e307493-0ead-4446-aa6e-b331b303e8be)
 
 -yang terlihat di files
  ![image](https://github.com/salschoco27/Sisop-1-2024-MH-IT28/assets/163504787/1cbf9da8-dbf1-408f-932e-4c85ada4a840)

* Sesudah Revisi
-yang terlihat di console
 ![Screenshot from 2024-03-30 22-52-26](https://github.com/salschoco27/Sisop-1-2024-MH-IT28/assets/163504787/44b8c323-0e5d-4682-a5e0-f2921ce6d515)

-yang terlihat di files
 ![image](https://github.com/salschoco27/Sisop-1-2024-MH-IT28/assets/163504787/bcbf297d-c281-4fd5-8e5e-326b34df86a0)

* Kendala yang masih dialami:
  -masih tidak dapat menghitung jumlah senjata
 ![Screenshot from 2024-03-30 22-49-56](https://github.com/salschoco27/Sisop-1-2024-MH-IT28/assets/163504787/8ad53d5d-e117-429c-86e3-8390e4342994)

   
  


### Change log & KENDALA: 
* Sebelum Revisi:
  -tidak dapat membuat folder berdasarkan region yang ada di dalam file .csv
  
  -hasil de-encrypt hanya berupa nama karakter dan tidak seperti format yang diminta pada soal
  
  -tidak dapat menghitung jumlah senjata
  
* Sesudah Revisi:
  -berhasil mengubah nama karakter menjadi lebih spesifik dan sesuai dengan format yang diminta oleh soal
  
  -folder region berhasil dibuat namum tidak dapat melakukan sortir terhadap karakter dimana foto karakter dimasukkan dalam folder berdasarkan region nya masing-masing sehingga tidak dapat melanjutkan ke dalam script search.sh
  
  -masih tidak dapat menghitung jumlah senjata






## Soal 4
Deskripsi soal
Soal nomor 4 ini berisikan program yang bertujuan untuk memantau penggunaan RAM dan ukuran suatu direktori pada komputer. Terdapat dua script yang digunakan yaitu minute_log.sh dan aggregate_minutes_to_hourly_log.sh. Script minute_log.sh digunakan untuk mengumpulkan informasi dalam setiap menit sedangkan aggregate_minutes_to_hourly_log.sh digunakan untuk mengumpulkan dan mengagregasi data dari file-file log yang dihasilkan oleh minute_log.sh setiap jam.
## Langkah langkah
1. Salin kode skrip berikut ke dalam file bernama minute_log.sh
   ```
   #!/bin/bash
   ### TAMBAHKAN INI KE CRONTAB
   # * * * * * /home/aca/Documents/SISOP/Modul1/soal_nomor_4/minute_log.sh
   # Mengekstrak penggunaan memori ke file teks sementara
   free -m > temp.txt
   # Mengekstrak penggunaan disk dari direktori home pengguna ke file teks sementara
   user=whoami && du -sh /home/$user >> temp.txt
   # Hasil cetak menggunakan Echo dan AWK
   echo
   "mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" > /home/$user/log/"metrics_$(date +"%Y%m%d%H%M%S").log"
   awk '/Mem/ {print $2","$3","$4","$5","$6","$7","};
     /Swa/ {print $2","$3","$4","};
     /home/ {print $2","$1}
     ' temp.txt | paste -s -d '' >> /home/$user/log/"metrics_$(date +"%Y%m%d%H%M%S").log"
   # Mengelola izin
   chmod +x minute_log.sh
   # Menghapus file teks sementara
   rm temp.txt
2. Berikan izin eksekusi pada skrip dengan menjalankan perintah
   ```
   chmod +x minute_log.sh
3. Buka crontab untuk pengguna dengan perintah :
   ```
   crontab -e
4. Tambahkan baris berikut pada file crontab 
   ```
   * * * * * /home/aca/Documents/SISOP/Modul1/soal_nomor_4/minute_log.sh
5. Gantilah /path/to/minute_log.sh dengan jalur lengkap ke skrip minute_log.sh yang telah Anda simpan.
6. Simpan dan keluar dari editor crontab ( Cntrl + x ) lalu save tekan Y
7. Buat satu script lagi untuk membuat agregasi file log ke satuan jam. Salin kode berikut ke dalam file bernama aggregate_minutes_to_hourly_log.sh
    ```
    #!/bin/bash
    ### TAMBAHKAN INI KE CRONTAB
    # 0 * * * * /home/aca/Documents/SISOP/Modul1/soal_nomor_4/aggregate_minutes_to_hourly_log.sh
    # Mengidentifikasi file log dalam direktori yang ditentukan
    user=$(whoami)
    time_range=$(date -d '-1 hour' +%Y%m%d%H)
    find /home/$user/log -name "$time_range" -not -name 'agg' -exec awk -F "," 'END{command=sprintf("numfmt --from=iec %s",$11); command | getline conv; close(command); print $0","  conv}' {} \; > temphour.txt
    # Membuat file log per jam
    echo "type,mem_total,mem_used,mem_free,mem_shared,mem_buff,mem_available,swap_total,swap_used,swap_free,path,path_size" > /home/$user/log/"metrics_agg_$(date +"%Y%m%d%H").log"
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
            (NR==1){m = $12}{m = $12<m ? $12:m}END{command=sprintf("numfmt --to=iec %d",m); command | getline conv; close(command); print conv}
            ' temphour.txt | paste -s -d '' >> /home/$user/log/"metrics_agg_$(date +"%Y%m%d%H").log"
    # Maksimum
    awk -F "," '(NR==1){max = $1} {max = $1>max ? $1:max}  END{print "maximum,"max","}
            (NR==1){a = $2} {a = $2>a ? $2:a}  END{print a","}
            (NR==1){b = $3} {b = $3>b ? $3:b}  END{print b","}
            (NR==1){c = $4} {c = $4>c ? $4:c}  END{print c","}
            (NR==1){d = $5} {d = $5>d ? $5:d}  END{print d","}
            (NR==1){e = $6} {e = $6>e ? $6:e}  END{print e","}
            (NR==1){f = $7} {f = $7>f ? $7:f}  END{print f","}
            (NR==1){g = $8} {g = $8>g ? $8:g}  END{print g","}
            (NR==1){h = $9} {h = $9>h ? $9:h}  END{print h","$10","}
            (NR==1){m = $12}{m = $12>m ? $12:m}END{command=sprintf("numfmt --to=iec %d",m); command | getline conv; close(command); print conv}
            ' temphour.txt | paste -s -d '' >> /home/$user/log/"metrics_agg_$(date +"%Y%m%d%H").log"
    # Average
    awk -F "," '{sum+=$1}  END{print "average,"sum/NR","}
            {a+=$2}  END{print a/NR","}
            {b+=$3}  END{print b/NR","}
            {c+=$4}  END{print c/NR","}
            {d+=$5}  END{print d/NR","}
            {e+=$6}  END{print e/NR","}
            {f+=$7}  END{print f/NR","}
            {g+=$8}  END{print g/NR","}
            {h+=$9}  END{print h/NR","$10","}
            {m+=$12} END{command=sprintf("numfmt --to=iec %d",m/NR); command | getline conv; close(command); print conv}
            ' temphour.txt | paste -s -d '' >> /home/$user/log/"metrics_agg_$(date +"%Y%m%d%H").log"
            # Mengelola izin file
    chmod +x aggregate_minutes_to_hourly_log.sh
    #  Hapus file teks sementara
    rm temphour.txt
8. Berikan izin eksekusi pada skrip dengan menjalankan perintah
   ```
    chmod +x aggregate_minutes_to_hourly_log.sh
9. Agar dieksekusi setiap jam, buka crontab untuk pengguna dengan perintah :
   ```
   crontab -e
10. Tambahkan baris berikut pada file crontab :
     ```
     0 * * * * /home/aca/Documents/SISOP/Modul1/soal_nomor_4/aggregate_minutes_to_hourly_log.sh
11. Gantilah /path/to/aggregate_minutes_to_hourly_log.sh dengan jalur lengkap ke skrip aggregate_minutes_to_hourly_log.sh yang telah disimpan.
12. Simpan dan keluar dari editor crontab.
13. Dengan langkah-langkah di atas program akan secara otomatis memantau penggunaan RAM dan ukuran direktori setiap menit serta membuat agregasi data tersebut ke dalam file log per jam.
![WhatsApp Image 2024-03-30 at 23 42 35_39e138e7](https://github.com/salschoco27/Sisop-1-2024-MH-IT28/assets/150428950/cd78f617-62b3-45c0-95dd-e1d471005b13)
