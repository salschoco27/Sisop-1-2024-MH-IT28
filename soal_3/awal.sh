#!/bin/bash

#ini teh buat download

curl -L "https://drive.usercontent.google.com/u/0/uc?id=1oGHdTf4_76_RacfmQIV4i7os4sGwa9vN&export=download" -o genshin.zip && unzip genshin.zip -d genshinstuff

cd genshinstuff 

unzip genshin_character.zip

#do wotever the numba told me, wait...yea, unencrypt or some shit


for file in genshin_character/*
do
    filename=$(printf '%b\n' "${file##*/}")
    newname=$(echo "$filename" | xxd -r -p)
    if [ "$newname" != "genshin_character" ]; then
        mv "$file" "genshin_character/$newname"
    fi
done

#sort region and shit
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


#rename file foto berdasarkan yang ada di list_character.csv
while IFS=',' read -r name region element weapon
do
    filename=$(find genshin_character -name "$name.*" | head -n 1)
    if [ -n "$filename" ]; then
        extension="${filename##*.}"
        nama_baru="$Region - $Nama - $Element - $Senjata.$extension"
        mkdir -p "$Region - $Name"
        mv "$filename" "$Region - $Nama/$nama_baru" #still figuring why this wont work????????
    fi
done < list_character.csv

# hitung jumlah user senjatanya dari .csv nya
for weapon in $(awk -F',' '{print $4}' list_character.csv | sort | uniq)
do
    count=$(find . -name "*$weapon*" | wc -l)
    echo "[$weapon] : $count"
done < list_character.csv
