# Dokumen Kebutuhan Data - Sistem Informasi Akademik

**Nama:** Muhammad Fikri Misbahudin  
**NIM:** 25430096  
**Kelas:** D  
**Tanggal:** 11 Oktober 2026  

---

## 1. Latar Belakang dan Aktivitas Organisasi

Sistem Informasi Akademik_096 dirancang untuk mengelola data operasional perkuliahan, pendataan mahasiswa, pencatatan mata kuliah, serta pengolahan nilai dan KHS. Aktivitas utama organisasi mencakup pendaftaran mahasiswa baru, penyusunan rencana studi (KRS), pelaksanaan perkuliahan, penilaian oleh dosen, serta perekaman riwayat akademik mahasiswa secara terstruktur.

---

## 2. Aktor dan Proses Bisnis

| Kode PB | Aktor Utama | Deskripsi Proses Bisnis |
| :---: | :--- | :--- |
| **PB-01** | Mahasiswa | Mengajukan Rencana Studi (KRS) dan melihat Kartu Hasil Studi (KHS). |
| **PB-02** | Dosen | Mengampu mata kuliah, mengelola presensi, dan menginput nilai akhir. |
| **PB-03** | Admin Akademik | Mengelola data master (Mahasiswa, Dosen, Matakuliah) dan jadwal perkuliahan. |

---

## 3. Dokumen Sumber yang Dianalisis

1. **Formulir Rencana Studi (KRS):** Berisi data mahasiswa, daftar mata kuliah yang diambil, SKS, dan persetujuan dosen wali.
2. **Kartu Hasil Studi (KHS):** Berisi nilai mutu, bobot, nilai akhir per mata kuliah, serta Indeks Prestasi Semester (IPS).
3. **Transkrip Nilai Akademik:** Rekapitulasi seluruh nilai mata kuliah yang telah diselesaikan mahasiswa.

---

## 4. Entitas Kandidat dan Elemen Data

- **Mahasiswa:** `nim`, `nama`, `kelas`, `angkatan`, `email`
- **Dosen:** `nip`, `nama_dosen`, `email_dosen`
- **Matakuliah:** `kode_mk`, `nama_mk`, `sks`, `semester`
- **KRS / Nilai:** `id_krs`, `nim`, `kode_mk`, `nilai_angka`, `nilai_huruf`

---

## 5. Aturan Bisnis

| Kode AB | Entitas Terkait | Deskripsi Aturan Bisnis |
| :---: | :--- | :--- |
| **AB-01** | Mahasiswa | Setiap mahasiswa wajib memiliki identitas unik berupa **NIM** (*Primary Key*). |
| **AB-02** | KRS / Matakuliah | Satu mahasiswa dapat mengambil banyak mata kuliah dalam satu semester. |
| **AB-03** | Penilaian | Nilai huruf dikonversi secara otomatis dari **nilai_angka** berdasarkan standar kampus. |

---

## 6. Kebutuhan Informasi

| Kode KI | Kebutuhan Informasi | Target Pengguna | Output / Tampilan |
| :---: | :--- | :--- | :--- |
| **KI-01** | Transkrip dan KHS | Mahasiswa & Dosen Wali | Cetak Laporan KHS per Semester |
| **KI-02** | Rekapitulasi Nilai | Dosen Pengampu | Daftar Nilai Kelas & Distribution Grade |
| **KI-03** | Statistik Keaktifan | Admin Akademik | Laporan Jumlah Mahasiswa Aktif & SKS |

---

## 7. Matriks CRUD

> *Keterangan Akses: **C** = Create (Buat), **R** = Read (Baca), **U** = Update (Ubah), **D** = Delete (Hapus)*

| Proses | Anggota | Barang | Penjualan | Detail | Pemasok | Pembelian |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **PB-01 Daftar anggota** | C | | | | | |
| **PB-02 Catat penjualan** | R | R, U | C | C | | |
| **PB-03 Pesan ke pemasok** | | R | | | R | C |
| **PB-04 Terima barang** | | U | | | R | U |
| **PB-05 Laporan bulanan** | R | R | R | R | | R |

---

## 8. Kamus Data Awal

| Nama Elemen | Tipe Data | Ukuran | Aturan / Keterangan | Penanggung Jawab |
| :--- | :---: | :---: | :--- | :--- |
| `nim` | VARCHAR | 8 | Unique, Primary Key Mahasiswa | Admin Akademik |
| `nama_mhs` | VARCHAR | 100 | Not Null, Nama Lengkap | Admin Akademik |
| `kode_mk` | VARCHAR | 10 | Unique, Primary Key Mata Kuliah | Admin Akademik |
| `nilai_angka` | DECIMAL | 5,2 | Rentang 0.00 - 100.00 | Dosen Pengampu |
| `nilai_huruf` | CHAR | 2 | Hasil Konversi (A, B+, B, C+, C, D, E) | Sistem / Dosen |

---

## 9. Kebutuhan Non-Fungsional Data

- **Volume Data:** Memuat data hingga 5.000 mahasiswa aktif dengan prediksi pertumbuhan 1.000 record/tahun.
- **Retensi Data:** Data riwayat nilai dan transkrip disimpan secara permanen.
- **Privasi & Keamanan:** Akses ubah nilai dibatasi khusus untuk Dosen Pengampu dan disahkan oleh Admin Akademik.

---

## 10. Isu Kualitas Data yang Diantisipasi

1. **Redundansi Data:** Dihindari dengan menerapkan teknik normalisasi pada entitas KRS dan Mata Kuliah.
2. **Inkonsistensi Nilai:** Menerapkan batasan (*CONSTRAINT*) rentang nilai angka 0.00 hingga 100.00 pada basis data.
3. **Data Yatim (*Orphan Record*):** Menambahkan *Foreign Key* dengan aturan `ON DELETE RESTRICT` agar data mahasiswa yang memiliki riwayat nilai tidak terhapus secara tidak sengaja.

---

## 11. Checklist Umum

| Butir | Yang Harus Ada | Status |
| :--- | :--- | :---: |
| Identitas | Nama, NIM, kelas, pertemuan ke-2, tanggal pelaksanaan | ✅ |
| Tujuan | Tujuan praktikum ditulis ulang dengan bahasa sendiri | ✅ |
| Ringkasan Teori | Pemahaman sendiri atas Dasar Teori | ✅ |
| Langkah | Tangkapan layar hasil langkah kunci + keterangan | ✅ |
| Titik Analisis | Semua Titik Analisis dijawab lengkap dengan alasan | ✅ |
| Latihan | Skrip/dokumen hasil latihan beserta bukti berjalan | ✅ |
| Tugas Mandiri | Milestone proyek pertemuan ini: berkas, bukti, dan penjelasan | ✅ |
| Pembahasan & Kendala | Galat yang ditemui, cara membaca, dan cara mengatasinya | ✅ |
| Kesimpulan | Dua sampai empat kalimat dengan bahasa sendiri | ✅ |
| Pernyataan Penggunaan AI | Alat yang dipakai, untuk apa, bagian mana | ✅ |
| Bukti Git | Tautan repositori dan kode commit (hash) | ✅ |
| Keaslian | Tangkapan layar menampilkan akun ber-NIM dan jam sistem | ✅ |

---

## 12. Checklist Khusus Laporan Pertemuan 2

| Jenis | Yang Harus Ada | Status |
| :--- | :--- | :---: |
| **Berkas wajib** | `p02_kebutuhan_data_25430096.md`, `README.md`, `.gitignore` | ✅ |
| **Dokumen Analisis** | Poin 1–10 Dokumen Kebutuhan Data terisi lengkap | ✅ |
| **Analisis wajib** | Matriks CRUD, aturan bisnis, dan kamus data awal terdefinisi jelas | ✅ |

---

> **Catatan: cara dosen memeriksa**  
> Dosen mencocokkan *checklist* di akhir laporan dengan isi repositori. Butir yang dicentang tetapi tidak ditemukan dianggap tidak ada, dan pencentangan palsu diperlakukan sebagai pelanggaran keaslian.