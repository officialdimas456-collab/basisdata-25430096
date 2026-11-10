-- ============================================================
-- PROYEK BASIS DATA: SISTEM INFORMASI AKADEMIK
-- Nama : Muhamad Fikri Misbahudin
-- NPM  : 25430096
-- File : p07_kueri_25430096.sql
-- Modul: Pertemuan 7 - SELECT dan Fungsi Skalar
-- ============================================================

USE akad_096;

-- ============================================================
-- KI-01: DAFTAR MAHASISWA AKTIF
-- Pertanyaan:
-- Siapa saja mahasiswa yang statusnya masih aktif?
-- Hasil yang diharapkan: 
-- Menampilkan ID, NIM, Nama Mahasiswa, Program Studi, dan Status keaktifannya.
-- ============================================================
SELECT
    id_mahasiswa,
    nim,
    nama_mahasiswa,
    prodi,
    status_mahasiswa
FROM mahasiswa
WHERE status_mahasiswa = 'aktif';


-- ============================================================
-- KI-01: PENCARIAN MAHASISWA BERDASARKAN NAMA
-- Pertanyaan:
-- Siapa saja mahasiswa yang namanya mengandung kata atau huruf 'Fikri'?
-- Hasil yang diharapkan: 
-- Menampilkan nomor NIM dan Nama Mahasiswa yang sesuai dengan kriteria pencarian.
-- ============================================================
SELECT
    id_mahasiswa,
    nim,
    nama_mahasiswa,
    prodi
FROM mahasiswa
WHERE nama_mahasiswa LIKE '%Fikri%';


-- ============================================================
-- KI-01: MAHASISWA TANPA NOMOR HANDPHONE / EMAIL
-- Pertanyaan:
-- Siapa saja mahasiswa yang belum melengkapi data kontak (Nomor HP/Email)?
-- Hasil yang diharapkan: 
-- Menampilkan data mahasiswa yang kontak nomor HP atau Email-nya bernilai NULL.
-- ============================================================
SELECT
    id_mahasiswa,
    nim,
    nama_mahasiswa,
    no_hp
FROM mahasiswa
WHERE no_hp IS NULL;


-- ============================================================
-- KI-01: KETERANGAN STATUS KEAKTIFAN MAHASISWA
-- Pertanyaan:
-- Bagaimana keterangan status keaktifan setiap mahasiswa?
-- Hasil yang diharapkan:
-- Mahasiswa dengan status 'aktif' diberi keterangan 'Mahasiswa Aktif', 
-- sedangkan selain itu diberi keterangan 'Mahasiswa Nonaktif / Cuti'.
-- ============================================================
SELECT
    nim,
    nama_mahasiswa,
    status_mahasiswa,
    CASE
        WHEN status_mahasiswa = 'aktif' THEN 'Mahasiswa Aktif'
        ELSE 'Mahasiswa Nonaktif / Cuti'
    END AS keterangan_status
FROM mahasiswa;


-- ============================================================
-- KI-02: DAFTAR MATA KULIAH BERDASARKAN NAMA
-- Pertanyaan:
-- Mata kuliah apa saja yang nama makulnya mengandung kata 'Basis' atau 'Web'?
-- Hasil yang diharapkan:
-- Menampilkan Kode MK, Nama MK dalam huruf KAPITAL, SKS, dan Semester Kurikulum.
-- ============================================================
SELECT
    kode_mk,
    UPPER(nama_mk) AS nama_mk_kapital,
    sks,
    semester_kurikulum
FROM mata_kuliah
WHERE nama_mk LIKE '%Basis%' OR nama_mk LIKE '%Web%';


-- ============================================================
-- KI-02: DAFTAR JADWAL KULIAH BERDASARKAN HARI
-- Pertanyaan:
-- Jadwal perkuliahan apa saja yang dilaksanakan pada hari Senin atau Rabu?
-- Hasil yang diharapkan:
-- Menampilkan ID Jadwal, Kode MK, Hari, Jam Mulai, dan Ruang Kelas.
-- ============================================================
SELECT
    id_jadwal,
    kode_mk,
    hari,
    jam_mulai,
    ruang
FROM jadwal_kuliah
WHERE hari IN ('Senin', 'Rabu');


-- ============================================================
-- KI-03: DAFTAR DETAIL PENGAMBILAN KRS
-- Pertanyaan:
-- Mata kuliah apa saja yang tercatat dalam detail KRS mahasiswa?
-- Hasil yang diharapkan:
-- Menampilkan Nomor KRS, Kode MK, dan Status Pengambilan (misal: 'baru' atau 'mengulang').
--
-- CATATAN:
-- Belum dapat menampilkan nama lengkap mahasiswa dan nama mata kuliah 
-- karena memerlukan teknik JOIN antartabel.
-- ============================================================
SELECT
    no_krs,
    kode_mk,
    status_ambil
FROM detail_krs;


-- ============================================================
-- KI-04: TRANSAKSI KRS DALAM RENTANG TANGGAL
-- Pertanyaan:
-- Pengisian KRS apa saja yang dilakukan selama bulan September 2026?
-- Hasil yang diharapkan:
-- Menampilkan Nomor KRS, ID Mahasiswa, Tanggal KRS, dan Total SKS.
-- ============================================================
SELECT
    no_krs,
    id_mahasiswa,
    tanggal_krs,
    total_sks_krs
FROM pemilih_krs
WHERE tanggal_krs BETWEEN '2026-09-01' AND '2026-09-30';


-- ============================================================
-- KI-04: MAHASISWA DENGAN BEBAN SKS TINGGI (SKS > 20)
-- Pertanyaan:
-- KRS mana saja yang mengambil beban SKS lebih dari 20 SKS?
-- Hasil yang diharapkan:
-- Menampilkan pengisian KRS yang total SKS-nya di atas 20.
-- ============================================================
SELECT
    no_krs,
    id_mahasiswa,
    semester_krs,
    total_sks_krs
FROM pemilih_krs
WHERE total_sks_krs > 20;


-- ============================================================
-- KI-05: DAFTAR EVALUASI NILAI KHS
-- Pertanyaan:
-- Bagaimana evaluasi predikat nilai KHS mahasiswa?
-- Hasil yang diharapkan:
-- Menampilkan Nomor KRS, Kode MK, Nilai Angka, Nilai Huruf, dan Keterangan
-- kelulusan ('LULUS' jika Nilai Huruf A, B, atau C).
-- ============================================================
SELECT
    no_krs,
    kode_mk,
    nilai_angka,
    nilai_huruf,
    CASE
        WHEN nilai_huruf IN ('A', 'B', 'C') THEN 'LULUS'
        ELSE 'TIDAK LULUS / REKAP'
    END AS status_kelulusan
FROM nilai_khs;


-- ============================================================
-- CATATAN KETERBATASAN KEBUTUHAN INFORMASI (KI)
--
-- KI-01:
-- Dapat dijawab dengan baik hanya menggunakan satu tabel master `mahasiswa`.
--
-- KI-02:
-- Informasi ketersediaan jadwal perkuliahan belum dapat menampilkan 
-- nama dosen pengampu secara langsung karena memerlukan relasi (JOIN) ke tabel `dosen`.
--
-- KI-03:
-- Detail KRS belum dapat menampilkan Judul Mata Kuliah dan Nama Mahasiswa 
-- karena perlu menghubungkan `detail_krs` dengan `pemilih_krs`, `mahasiswa`, dan `mata_kuliah`.
--
-- KI-04:
-- Informasi mahasiswa yang melampaui batas Maksimal SKS belum dapat memvalidasi 
-- Indeks Prestasi (IPK) semester sebelumnya karena membutuhkan penghitungan agregat.
--
-- KI-05:
-- Penghitungan Indeks Prestasi Semester (IPS) membutuhkan fungsi agregat 
-- (SUM, AVG) serta pengelompokan GROUP BY yang akan dipelajari pada Modul 8.
-- ============================================================