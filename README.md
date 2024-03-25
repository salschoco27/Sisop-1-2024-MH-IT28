#   SOAL SHIFT SISTEM OPERASI MODUL 1
Kelompok IT28:
- Salsabila Rahmah (5027231005)
- Fadlillah Cantika Sari H (5027231042)
- I Dewa Made Satya Raditya (5027231051)
> Soal 1
1. Download Sandbox.csv
**export fileid=1cC6MYBI3wRwDgqlFQE1OQUN83JAreId0 && export filename=Sandbox.csv && wget -O $filename 'https://docs.google.com/uc?export=download&id='$fileid**
2. Menampilkan pembeli dengan total sales paling tinggi. **sort -t ',' -k17,17 -r Sandbox.csv | head -n 4**
   menggunakan sort descending "-r" dalam kolom ke 17 yaitu Sales.  Menampilkan 3 data customer teratas dengan sales paling tinggi.
3. Menampilkan customer yang memiliki profit paling kecil.   **sort -t ',' -k20,20 Sandbox.csv | head -n 3**
   menggunakan sort ascending dalam kolom ke 20 yaitu profit. Dan mengambil 3 data teratas dengan profit terkecil.
4. Menampilkan 3 kategori produk dengan profit paling tinggi. **awk -F ',' '{sum[$14]+=$20} END {for (i in sum) print i " = " sum[i]}' Sandbox.csv | sort -t ',' -k14,14nr | head -n 4**
5. Mencari purchase date dan amount (qty) dari nama Adriaens. **grep 'Adriaens' Sandbox.csv | awk -F ',' '{print $2 "           " $18}'**
