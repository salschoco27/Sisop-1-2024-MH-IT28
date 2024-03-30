#!/bin/bash

#ini teh buat download

curl -L "https://drive.usercontent.google.com/u/0/uc?id=1oGHdTf4_76_RacfmQIV4i7os4sGwa9vN&export=download" -o genshin.zip && unzip genshin.zip -d genshinstuff

cd genshinstuff 

unzip genshin_character.zip

#unencrypt yang udah di unzip

##LAMA##
for file in genshin_character/*
do
    filename=$(printf '%b\n' "${file##*/}")
    newname=$(echo "$filename" | xxd -r -p)
    if [ "$newname" != "genshin_character" ]; then
        mv "$file" "genshin_character/$newname"
    fi
done 

##BARU##
for file in *.jpg; do
    filename=$(printf '%b\n' "${file##*/}")
    rename=$(echo "$filename" | xxd -r -p)
    if [ "$rename" != "genshin_character" ]; then
        mv "$file" "$rename"
        
        updated=$(awk -F, "/$rename/"'{OFS=0;print $2 "-" $1 "-" $3 "-" $4}' ../list_character.csv)
        mv "$rename" "$updated.jpg" ##ganti nama lagi tapi disesuaikan dengan list_character.csv nya
    fi
done

#sort region & name berdasarkan data di .csv

##LAMA##
while IFS=',' read -r name region element weapon
do
    filename=$(find genshin_character -name "$name.*" | head -n 1)
    if [ -n "$filename" ]; then
        extension="${filename##*.}"
        newname="$Region - $Nama - $Element - $Senjata.$extension"
        mkdir -p "$Region - $Nama"
        mv "$filename" "$Region - $nama/$nama_baru"
fi
done < list_character.csv

##BARU##
##mengecek yang updated sudah sesuai dengan .csv lalu dimasukkan ke directory/folder baru berdasarkan data .csv
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

# hitung jumlah user senjatanya dari .csv nya
for weapon in $(awk -F',' '{print $4}' ../list_character.csv | sort | uniq)
do
    count=$(find . -name "*$weapon*" | wc -l)
    echo "[$weapon] : $count"
done < ../list_character.csv
