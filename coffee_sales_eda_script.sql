-- ============================================================
-- Deskripsi Dataset
-- Tujuan: memberi gambaran umum tentang jumlah baris, rentang tanggal,
-- dan mengecek apakah ada nilai money yang NULL atau <= 0 (bad_money).
-- Output: rows_, days_, min_date, max_date, bad_money
-- ============================================================

/*SELECT
  COUNT(*)                             AS rows_,
  COUNT(DISTINCT date)                 AS days_,
  MIN(date)                            AS min_date,
  MAX(date)                            AS max_date,
  COALESCE(SUM(CASE WHEN money IS NULL OR money<=0 THEN 1 END),0) AS bad_money
FROM coffee_sales;*/


-- ============================================================
-- Jenis kopi yang paling sering diorder
-- Tujuan: hitung frekuensi pemesanan per menu (menu favorit).
-- Output: category (coffee_name), jumlah (count)
-- ============================================================

/*SELECT 
  coffee_name AS category,
  COUNT(*)    AS jumlah
FROM coffee_sales
GROUP BY coffee_name
ORDER BY jumlah DESC*/


-- ============================================================
-- Waktu favorit pembelian kopi (time of day)
-- Tujuan: identifikasi bagian hari (Morning/Afternoon/Night) dengan transaksi terbanyak.
-- Output: category (time_of_day), jumlah transaksi
-- ============================================================

/*SELECT 
  Time_of_Day  AS category,
  COUNT(*)    AS jumlah
FROM coffee_sales
GROUP BY Time_of_Day 
ORDER BY jumlah DESC*/


-- ============================================================
-- Bulan teramai (per bulan)
-- Tujuan: hitung jumlah transaksi per nama bulan untuk melihat bulan puncak.
-- Output: category (Month_name), jumlah
-- ============================================================

/*SELECT 
  Month_name  AS category,
  COUNT(*)    AS jumlah
FROM coffee_sales
GROUP BY Month_name 
ORDER BY jumlah DESC*/


-- ============================================================
-- Hari dalam minggu teramai (weekday)
-- Tujuan: lihat hari mana pelanggan paling sering membeli (Mon..Sun).
-- Output: category (Weekday), jumlah
-- ============================================================

/*SELECT 
  Weekday  AS category,
  COUNT(*)    AS jumlah
FROM coffee_sales
GROUP BY Weekday 
ORDER BY jumlah DESC*/


-- ============================================================
-- Jam transaksi teramai (hour_of_day)
-- Tujuan: identifikasi jam puncak per hari (rush hour).
-- Output: category (hour_of_day), jumlah
-- ============================================================

/*SELECT 
  hour_of_day  AS category,
  COUNT(*)    AS jumlah
FROM coffee_sales
GROUP BY hour_of_day 
ORDER BY jumlah DESC*/


-- ------------------------------------------------------------
-- Ringkasan makro (overall sales)
-- Tujuan: hitung sales_count, total revenue, dan rata-rata nilai transaksi (AOV)
-- ------------------------------------------------------------

/*SELECT 
  COUNT(*) AS sales_count,
  ROUND(SUM(money),2) AS revenue,
  ROUND(AVG(money),2) AS aov
FROM coffee_sales;*/


-- ============================================================
-- Tren harian
-- Tujuan: plotting/analisis time-series harian (date vs tx/revenue/aov)
-- Output: date, jumlah transaksi, revenue, aov
-- ============================================================

/*SELECT date, COUNT(*) jumlah, ROUND(SUM(money),2) revenue, ROUND(AVG(money),2) aov
FROM coffee_sales GROUP BY date ORDER BY date;*/


-- ============================================================
-- Tren bulanan (urut pakai monthsort)
-- Tujuan: jumlah transaksi, revenue, AOV per bulan; disusun sesuai monthsort agar trend tahunan jelas
-- Output: monthsort, month_name, tx, revenue, aov
-- ============================================================

/*SELECT 
  monthsort, month_name,
  COUNT(*) AS tx,
  ROUND(SUM(money),2) AS revenue,
  ROUND(AVG(money),2) AS aov
FROM coffee_sales
GROUP BY monthsort, month_name
ORDER BY monthsort;*/


-- ============================================================
-- Growth MoM (jumlah & revenue)
-- Tujuan: hitung perubahan month-over-month (MoM) untuk jumlah transaksi & revenue
-- Metode: gunakan LAG() untuk mengambil nilai bulan sebelumnya lalu hitung persentase perubahan
-- ============================================================

/*WITH m AS (
  SELECT monthsort, month_name, COUNT(*) jumlah, SUM(money) revenue
  FROM coffee_sales GROUP BY monthsort, month_name
)
SELECT monthsort, month_name, jumlah, revenue,
       LAG(jumlah) OVER(ORDER BY monthsort) AS jumlah_prev,
       ROUND(100.0*(jumlah - LAG(jumlah) OVER(ORDER BY monthsort))
             / NULLIF(LAG(jumlah) OVER(ORDER BY monthsort),0), 2) AS jumlah_mom_pct,
       LAG(revenue) OVER(ORDER BY monthsort) AS rev_prev,
       ROUND(100.0*(revenue - LAG(revenue) OVER(ORDER BY monthsort))
             / NULLIF(LAG(revenue) OVER(ORDER BY monthsort),0), 2) AS rev_mom_pct
FROM m ORDER BY monthsort;*/


-- ============================================================
-- Weekday vs Weekend
-- Tujuan: bandingkan volume, revenue, dan AOV antara hari kerja dan akhir pekan
-- Metode: ubah weekdaysort menjadi dua kategori ('Weekend' jika 6/7, else 'Weekday')
-- ============================================================

/*SELECT CASE WHEN weekdaysort IN (6,7) THEN 'Weekend' ELSE 'Weekday' END day_type,
       COUNT(*) jumlah, ROUND(SUM(money),2) revenue, ROUND(AVG(money),2) aov
FROM coffee_sales GROUP BY 1;*/


-- ============================================================
-- Peak hour (per jam)
-- Tujuan: identifikasi jam-jam kritikal/ramai dalam 24 jam
-- Output: hour_of_day, jumlah, revenue, aov
-- ============================================================

/*SELECT hour_of_day, COUNT(*) jumlah, ROUND(SUM(money),2) revenue, ROUND(AVG(money),2) aov
FROM coffee_sales GROUP BY hour_of_day ORDER BY hour_of_day;*/


-- ============================================================
-- Daypart (Morning/Afternoon/Night)
-- Tujuan: bandingkan jumlah, revenue, AOV antar kategori bagian hari
-- ============================================================

/*SELECT time_of_day, COUNT(*) jumlah, ROUND(SUM(money),2) revenue, ROUND(AVG(money),2) aov
FROM coffee_sales GROUP BY time_of_day ORDER BY time_of_day;*/


-- ============================================================
-- Heatmap data (stacked bar proxy: X=hour_of_day, series=weekday)
-- Tujuan: sediakan tabel agregasi untuk membuat heatmap atau stacked bar
-- Output: weekdaysort, weekday, hour_of_day, jumlah, revenue
-- ============================================================

/*SELECT weekdaysort, weekday, hour_of_day,
       COUNT(*) jumlah, ROUND(SUM(money),2) revenue
FROM coffee_sales
GROUP BY weekdaysort, weekday, hour_of_day
ORDER BY weekdaysort, hour_of_day;*/


-- ============================================================
-- Top 5 menu by revenue
-- Tujuan: temukan menu yang memberikan kontribusi revenue terbesar
-- Output: coffee_name, jumlah transaksi, revenue, avg_price
-- ============================================================

/*SELECT coffee_name, COUNT(*) jumlah,
       ROUND(SUM(money),2) revenue, ROUND(AVG(money),2) avg_price
FROM coffee_sales
GROUP BY coffee_name
ORDER BY revenue DESC
LIMIT 5;*/


-- ============================================================
-- Dispersi harga per menu (aproks SD)
-- Tujuan: ukur variasi harga tiap menu (SD aproks): sqrt(E[x^2] - E[x]^2)
-- Output: avg_price, sd_price, n (jumlah transaksi sebagai konteks)
-- ============================================================

/*SELECT coffee_name,
       ROUND(AVG(money),2) AS avg_price,
       ROUND(SQRT(AVG(money*money) - AVG(money)*AVG(money)),2) AS sd_price,
       COUNT(*) n
FROM coffee_sales
GROUP BY coffee_name
ORDER BY sd_price DESC;*/


-- ============================================================
-- Payday window (tanggal 25–31 & 1)
-- Tujuan: bedakan transaksi pada periode gajian (payday) vs non-payday
-- Output: period, jumlah, revenue, aov
-- ============================================================

/*SELECT CASE
         WHEN CAST(strftime('%d', date) AS INT) BETWEEN 25 AND 31 THEN 'Payday'
         WHEN CAST(strftime('%d', date) AS INT) = 1 THEN 'Payday'
         ELSE 'Non_payday'
       END period,
       COUNT(*) jumlah, ROUND(SUM(money),2) revenue, ROUND(AVG(money),2) aov
FROM coffee_sales
GROUP BY 1 ORDER BY 1;*/


-- ============================================================
-- Happy Hour contoh (14:00–16:59)
-- Tujuan: bandingkan performa pada jam promosi HappyHour vs non-Happy
-- ============================================================

/*SELECT CASE WHEN hour_of_day BETWEEN 14 AND 16 THEN 'HappyHour' ELSE 'NonHappy' END period,
       COUNT(*) jumlah, ROUND(SUM(money),2) revenue, ROUND(AVG(money),2) aov
FROM coffee_sales
GROUP BY 1 ORDER BY 1;*/


-- ============================================================
-- Jam penggerak (kontribusi kumulatif revenue)
-- Tujuan: cari jam-jam yang menyumbang proporsi terbesar revenue (cum_share_pct)
-- Metode: rangking berdasarkan revenue per jam lalu hitung cumulative share
-- ============================================================

/*WITH byh AS (
  SELECT hour_of_day, SUM(money) revenue FROM coffee_sales GROUP BY hour_of_day
),
ranked AS (
  SELECT hour_of_day, revenue,
         SUM(revenue) OVER() total_rev,
         SUM(revenue) OVER(ORDER BY revenue DESC) cum_rev
  FROM byh
)
SELECT hour_of_day, ROUND(revenue,2) revenue,
       ROUND(100.0*cum_rev/total_rev,2) cum_share_pct
FROM ranked
ORDER BY revenue DESC;*/


-- ============================================================
-- Anomali (deviasi besar vs baseline jam×hari)
-- Tujuan: deteksi kombinasi date×hour yang menyimpang signifikan dari baseline rata-rata
-- Metode:
--  1) base: hitung rata-rata transaksi per kombinasi weekdaysort, weekday, hour_of_day (avg_tx)
--  2) actual: hitung jumlah transaksi aktual per date×weekdaysort×weekday×hour_of_day
--  3) bandingkan: pilih yang selisih absolutnya >= 80% dari baseline (threshold bisa disesuaikan)
-- Output: tanggal, weekday, hour_of_day, actual jumlah, avg_tx (baseline), delta
-- ============================================================

/*WITH base AS (
  SELECT weekdaysort, weekday, hour_of_day, AVG(cnt) avg_tx
  FROM (
    SELECT date, weekdaysort, weekday, hour_of_day, COUNT(*) cnt
    FROM coffee_sales GROUP BY date, weekdaysort, weekday, hour_of_day
  ) d
  GROUP BY weekdaysort, weekday, hour_of_day
),
actual AS (
  SELECT date, weekdaysort, weekday, hour_of_day, COUNT(*) jumlah
  FROM coffee_sales GROUP BY date, weekdaysort, weekday, hour_of_day
)
SELECT a.date, a.weekday, a.hour_of_day,
       a.jumlah, ROUND(b.avg_tx,2) avg_tx, (a.jumlah - b.avg_tx) delta
FROM actual a JOIN base b USING(weekdaysort, weekday, hour_of_day)
WHERE ABS(a.jumlah - b.avg_tx) >= (b.avg_tx * 0.8)   -- ubah threshold sesuai kebutuhan
ORDER BY ABS(delta) DESC LIMIT 10;*/
