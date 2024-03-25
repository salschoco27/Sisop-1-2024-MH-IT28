# Mencari file gambar di direktori
files=(*.jpg *.png *.bmp)

while true; do
  for file in "${files[@]}"; do
    # Mengekstrak file teks tersembunyi dari gambar menggunakan steghide
    extracted=$(steghide extract -sf "$file" -p "password")
    
    # Mengecek teks yang bisa diekstrak
    if [[ -n "$extracted" ]]; then
      # Mendekripsi file teks menggunakan hex
      decrypted=$(echo "$extracted" | xxd -r -p)
      
      # cek string merupakan URL/enggak
      if [[ "$decrypted" =~ ^https?://.*$ ]]; then
        url="$decrypted"
        echo "URL ditemukan: $url"
        
        # Mendownload dari
        wget "$url"
        
        # stop program setelah URL ketemu
        exit 0
      fi
    fi
  done
  
  # tunggu 1 detik sebelum cek lagi
  sleep 1
done
