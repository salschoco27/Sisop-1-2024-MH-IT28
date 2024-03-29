#!/bin/bash
echo "3 Customer dengan Sales Tertinggi"
sort -t ',' -k 17 -nr Sandbox.csv | head -n 3 | awk -F ',' '{print $6 "      "   $17}'
echo "   "

echo "3 Data Pembelian oleh Customer dengan Profit Terkecil"
sort -t ',' -k20,20 Sandbox.csv | head -n 3 |awk -F ',' '{print $6 "     " $20}'
echo "   "

echo "3 Kategori Produk dengan Profit Tertinggi"
awk -F ',' 'NR>1 {sum[$14]+=$20} END {for (i in sum) print i "=" sum[i]}' Sandbox.csv | sort -t ',' -k 14nr | head -4
echo "   "

echo "Purchase date dan Quantity Produk yang dipesan oleh Adriens"
echo "Purchase Date       Qty"
grep 'Adriaens' Sandbox.csv | awk -F ',' '{print $2 "           " $18}'
