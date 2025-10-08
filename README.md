# ☕ Coffee Shop Data Analytics — Brewing Insights with SQL

Analisis ini bertujuan untuk memahami **pola perilaku pelanggan** di sebuah coffee shop selama satu tahun penuh, dengan menggunakan **SQL** untuk menelusuri kapan pelanggan paling sering membeli kopi, menu apa yang paling laris, serta bagaimana faktor waktu (jam, hari, bulan) dan periode khusus (weekend, payday, happy hour) memengaruhi performa penjualan.

---

## 📊 Tujuan Analisis

1. **Memahami pola konsumsi kopi**
   - Mengidentifikasi kapan pelanggan paling sering membeli kopi (jam, hari, bulan).
   - Melihat bagaimana pola pembelian berubah antara *weekday* dan *weekend*.

2. **Mengetahui menu favorit dan perilaku harga**
   - Menemukan menu yang paling populer dan kontribusi pendapatannya.
   - Menganalisis variasi harga tiap menu (dispersion/standard deviation).

3. **Menelusuri efek waktu khusus**
   - Mengevaluasi pengaruh periode seperti *Payday* (tanggal 25–1) dan *Happy Hour* (14.00–16.00).
   - Menemukan apakah terdapat perbedaan signifikan dibandingkan periode biasa.

4. **Mendeteksi anomali dan jam emas**
   - Menemukan jam atau hari dengan transaksi tidak wajar (lebih tinggi/rendah dari rata-rata).
   - Mengidentifikasi “jam penggerak” revenue tertinggi.
   
---

## 🧩 Dataset Overview

Dataset terdiri dari **3.547 transaksi** selama **381 hari**, mencakup:
- `date` → tanggal transaksi  
- `coffee_name` → nama menu kopi  
- `money` → total pembelian (dalam satuan mata uang lokal)  
- `time_of_day`, `hour_of_day`, `weekday`, `month_name` → kategori waktu turunan  
- `weekdaysort`, `monthsort` → urutan numerik untuk sortasi kronologis

Periode data: **Maret 2024 – Maret 2025**  
Semua nilai transaksi valid (`bad_money = 0`).

## 🧩 Hasil Analisis
🔗 Lihat versi interaktif di Notion: [Eksplorasi Data Coffee Shop]([https://living-mosquito-dca.notion.site/Eksplorasi-Data-Coffee-Shop-dengan-SQL-27f6c12bc6518078bd39e951b491eed2?source=copy_link](https://lista-kurniawati.notion.site/Coffee-Shop-Data-Analytics-Brewing-Insights-with-SQL-27f6c12bc6518078bd39e951b491eed2?source=copy_link))
