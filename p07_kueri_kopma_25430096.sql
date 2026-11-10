-- ============================================================
-- PROYEK BASIS DATA: SISTEM INFORMASI AKADEMIK
-- Nama : Muhamad Fikri Misbahudin
-- NPM  : 25430096
-- File : p07_fungsi_skalar_akad_25430096.sql
-- ============================================================

USE akad_096;

-- 1. KI-03: Mata kuliah dengan kapasitas / SKS tinggi yang perlu perhatian
SELECT kode_mk, nama_mk, sks, semester_kurikulum,
       sks + 1 AS simulasi_beban -- Contoh fungsi aritmatika
FROM mata_kuliah
WHERE sks >= 3
ORDER BY sks DESC;

-- 2. Menampilkan mata kuliah kategori tertentu (Semester 2 atau 3)
SELECT kode_mk, nama_mk, semester_kurikulum
FROM mata_kuliah
WHERE semester_kurikulum IN ('Semester 2', 'Semester 3');

-- 3. Menampilkan pengisian KRS pada rentang tanggal tertentu
SELECT no_krs, id_mahasiswa, tanggal_krs
FROM pemilih_krs
WHERE tanggal_krs
BETWEEN '2026-09-01 00:00:00' AND '2026-11-03 23:59:59';

-- 4. Menampilkan mahasiswa tanpa nomor HP
SELECT nim, nama_mahasiswa, no_hp
FROM mahasiswa
WHERE no_hp IS NULL;

-- 5. Mencari mahasiswa yang namanya mengandung huruf 'a' atau 'f'
SELECT
    CONCAT(
        nama_mahasiswa,
        ' (',
        nim,
        ')'
    ) AS mahasiswa_info,

    DATE_FORMAT(
        NOW(),
        '%d-%m-%Y'
    ) AS tanggal_akses,

    IFNULL(no_hp, 'Tidak Ada Kontak') AS kontak_hp,

    CASE status_mahasiswa
        WHEN 'aktif' THEN 'Status: Aktif Studi'
        ELSE 'Status: Nonaktif / Cuti'
    END AS keterangan_status

FROM mahasiswa
WHERE nama_mahasiswa LIKE '%a%'
ORDER BY nama_mahasiswa ASC
LIMIT 5;

-- CONCAT         Menggabungkan nama dan NIM mahasiswa
-- DATE_FORMAT    Mengubah format tanggal saat ini
-- IFNULL         Mengganti nomor HP yang NULL menjadi teks pengganti
-- CASE           Menampilkan keterangan berdasarkan keaktifan mahasiswa
-- LIKE '%a%'     Mencari nama yang mengandung huruf a
-- ORDER BY ASC   Mengurutkan berdasarkan abjad nama
-- LIMIT 5        Membatasi hasil maksimal 5 baris

-- 6. Menghitung estimasi masa studi atau keaktifan berdasarkan angkatan (menggunakan tahun)
SELECT
    nama_mahasiswa,
    angkatan,
    YEAR(CURDATE()) - angkatan AS tahun_selisih_akademik,
    CASE
        WHEN (YEAR(CURDATE()) - angkatan) <= 2 THEN 'Mahasiswa Tingkat Awal'
        ELSE 'Mahasiswa Tingkat Lanjut'
    END AS kategori_tingkat
FROM mahasiswa;

-- 7. Menghitung subtotal bobot / nilai pada KHS (Contoh perkalian numerik)
SELECT no_krs,
       kode_mk,
       nilai_angka,
       bobot_nilai,
       nilai_angka * bobot_nilai AS skor_perkalian
FROM nilai_khs
WHERE no_krs = 'KRS-2026-01';

-- 8. E.1: Menampilkan nama mata kuliah kapital dan format teks informasi SKS
SELECT
    UPPER(nama_mk) AS nama_mk_kapital,
    CONCAT(sks, ' SKS (Semester ', semester_kurikulum, ')') AS info_sks
FROM mata_kuliah;

-- 9. E.2: Kueri logika majemuk (Operator AND / OR dengan tanda kurung)
SELECT *
FROM mata_kuliah
WHERE semester_kurikulum = 'Semester 3'
  AND (
      sks >= 3
      OR nama_mk LIKE '%Basis%'
  );