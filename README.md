#   SOAL SHIFT SISTEM OPERASI MODUL 1
Kelompok IT28:
- Salsabila Rahmah (5027231005)
- Fadlillah Cantika Sari H (5027231042)
- I Dewa Made Satya Raditya (5027231051)
## Soal 1
>Sandbox.sh
1. Download Sandbox.csv
`export fileid=1cC6MYBI3wRwDgqlFQE1OQUN83JAreId0 && export filename=Sandbox.csv && wget -O $filename 'https://docs.google.com/uc?export=download&id='$fileid`
3. Menampilkan nama pembeli dengan total sales paling tinggi. ```sort -t ',' -k 17 -nr Sandbox.csv | head -n 3 | awk -F ',' '{print $6 "      "   $17}'```
   menggunakan sort descending "-r" dalam kolom ke 17 yaitu Sales.  Menampilkan 3 data customer teratas dengan sales paling tinggi.
4. Menampilkan customer yang memiliki profit paling kecil.   ```awk -F ',' 'NR>1 {sum[$14]+=$20} END {for (i in sum) print i "=" sum[i]}' Sandbox.csv | sort -t ',' -k 14nr | head -4```
   menggunakan sort ascending dalam kolom ke 20 yaitu profit. Dan mengambil 3 data teratas dengan profit terkecil.
5. Menampilkan 3 kategori produk dengan profit paling tinggi. ```awk -F ',' '{sum[$14]+=$20} END {for (i in sum) print i " = " sum[i]}' Sandbox.csv | sort -t ',' -k14,14nr | head -n 4```
6. Mencari purchase date dan amount (qty) dari nama Adriaens. ```grep 'Adriaens' Sandbox.csv | awk -F ',' '{print $2 "           " $18}'```
## Soal 2
>register.sh

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
* ```
    #Write user data to user.txt with admin flag
    echo "$email:$username:$sec_quest:$answer:$encrypted_password:$user_type" >> user.txt

    if [[ $user_type == "admin" ]]; then
        echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [REGISTER SUCCESS] Admin $username registered successfully." >> auth.log
        echo "Admin $username registered successfully."
    else
        echo "[ $(date +'%d/%m/%Y %H:%M:%S') ] [REGISTER SUCCESS] user $username registered successfully." >> auth.log
        echo "User $username registered successfully."
    fi
}  ```

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

>login.sh
- Tidak bisa menampilkan password
   ```if [ "$user_answer" == "$correct_answer" ]; then
        local save_pw=$(grep "^$email:" user.txt | cut -d: -f5)
        save_pw_decrypted=$(decryption "$save_pw")
        echo "Your password is: $save_pw_decrypted"
    else
        echo "Your answer is incorrect."
    fi
## Soal 4
Deskripsi soal
Soal nomor 4 ini berisikan program yang bertujuan untuk memantau penggunaan RAM dan ukuran suatu direktori pada komputer. Penggunaan RAM akan dimonitor menggunakan perintah free -m, sedangkan ukuran direktori akan dimonitor menggunakan perintah du -sh <target_path>. Semua metrik yang diperoleh akan dicatat dalam file log dengan format metrics_{YmdHms}.log, di mana {YmdHms} adalah waktu saat skrip dijalankan. Terdapat dua script yang digunakan yaitu minute_log.sh dan aggregate_minutes_to_hourly_log.sh. Script minute_log.sh digunakan untuk mengumpulkan informasi dalam setiap menit sedangkan aggregate_minutes_to_hourly_log.sh digunakan untuk mengumpulkan dan mengagregasi data dari file-file log yang dihasilkan oleh minute_log.sh setiap jam.
## langkah langkah
