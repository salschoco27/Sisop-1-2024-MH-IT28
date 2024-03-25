#!/bin/bash
echo "3 Data dengan Sales Tertinggi"
sort -t ',' -k17,17 -r Sandbox.csv | head -n 4
echo "   "

echo "3 Data Pembelian oleh Customer dengan Profit Terkecil"
sort -t ',' -k20,20 Sandbox.csv | head -n 3
echo "   "

echo "3 Kategori Produk dengan Profit Tertinggi"
awk -F ',' '{sum[$14]+=$20} END {for (i in sum) print i " =  " sum[i]}' Sandbox.csv | sort -t ',' -k14,14nr | head -n 4
echo "   "

echo "Purchase date dan Quantity Produk yang dipesan oleh Adriens"
echo "Purchase Date       Qty"
grep 'Adriaens' Sandbox.csv | awk -F ',' '{print $2 "           " $18}'



