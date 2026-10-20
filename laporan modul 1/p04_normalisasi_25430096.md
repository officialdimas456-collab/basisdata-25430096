# F. Tugas Mandiri — Milestone Proyek Akademik

**Nama:** Muhammad Fikri Misbahudin  
**Kelas:** D  
**NPM:** 25430096  

---

### F.1 Bentuk Tidak Ternormalisasi (UNF)
Dokumen sumber yang digunakan sebagai titik awal adalah lembar Kartu Rencana Studi (KRS) pada proyek Sistem Informasi Akademik Kampus.  
Berdasarkan elemen data pada dokumen kebutuhan, relasi awal dapat dituliskan sebagai berikut:  
`KRS_UNF (no_krs, tanggal_pengisian, semester_akademik, nim, nama_mhs, id_dosen_pa, nama_dosen_pa, {kode_mk, nama_mk, sks_mk, nilai_huruf, nilai_angka}, total_sks_diambil)`  

**Keterangan:**  
* Data KRS memuat identitas mahasiswa, dosen pembimbing akademik (PA), tanggal pengisian, serta semester akademik.
* Satu transaksi pengisian KRS dapat memuat beberapa mata kuliah. Kelompok `{kode_mk, nama_mk, sks_mk, nilai_huruf, nilai_angka}` merupakan kelompok data berulang.
* Data pembayaran Uang Kuliah Tunggal (UKT) dan status verifikasi dicatat pada dokumen sumber tersendiri, sehingga tidak langsung dimasukkan ke dalam hubungan awal ini.

Relasi tersebut merupakan bentuk awal hasil penyusunan dari elemen data proyek, bukan salinan tetap dari formulir yang sudah terisi.

---

### F.2 Dependensi Fungsional
Dependensi fungsional (DF) berikut disusun berdasarkan data identitas pada entitas kandidat. Kode aturan bisnis (AB) yang dicantumkan menunjukkan aturan terkait, tetapi tidak semua aturan bisnis secara langsung membuktikan suatu ketergantungan fungsional.

| Dependensi Fungsional | Dasar / Keterangan |
| :--- | :--- |
| **DF-01:** `nim → nama_mhs, prodi, alamat, hp, email, status_mhs` | AB-01; data Mahasiswa |
| **DF-02:** `kode_mk → nama_mk, sks_mk, semester_penawaran` | Data Mata Kuliah |
| **DF-03:** `id_dosen → nama_dosen, email_dosen, prodi_dosen` | Data Dosen / Pembimbing Akademik |
| **DF-04:** `no_krs → nim, id_dosen, tanggal_pengisian, semester_akademik` | AB-02; data KRS |
| **DF-05:** `(no_krs, kode_mk) → nilai_huruf, nilai_angka` | Detail Data KRS / Transkrip |
| **DF-06:** `nilai_huruf → nilai_angka` | Aturan Konversi Nilai Mutu |

*Catatan:* DF-01 sampai DF-05 mengandung kode atau nomor pada masing-masing entitas untuk mengidentifikasi satu data secara unik. Keunikan NIM mahasiswa secara eksplisit ditetapkan pada aturan akademik kampus.

---

### F.3 Bentuk Normal Pertama (1NF)
Syarat 1NF adalah setiap atribut berisi satu nilai dan tidak terdapat kelompok atribut berulang dalam satu baris.  
Kelompok mata kuliah yang berulang-ulang dipisahkan menjadi baris-baris detail KRS.  

**Relasi setelah 1NF:**  
1. `KRS (no_krs, tanggal_pengisian, semester_akademik, nim, nama_mhs, id_dosen_pa, nama_dosen_pa)`  
2. `DETAIL_KRS (no_krs, kode_mk, nama_mk, sks_mk, nilai_huruf, nilai_angka)`  

Setiap baris `DETAIL_KRS` mewakili satu mata kuliah yang diambil dalam satu lembar pengisian KRS.

---

### F.4 Bentuk Normal Kedua (2NF)
Syarat 2NF adalah relasi sudah memenuhi 1NF dan setiap atribut nonkunci harus bergantung penuh pada kunci kandidat, bukan hanya sebagian dari kunci gabungan.  

Pada `DETAIL_KRS`, kunci gabungan yang digunakan adalah `(no_krs, kode_mk)`. Informasi mata kuliah (seperti nama dan SKS) bergantung pada kode mata kuliah, bukan pada keseluruhan kunci gabungan detail KRS.

**Pemisahan yang dilakukan:**  
1. `KRS (no_krs, tanggal_pengisian, semester_akademik, nim, nama_mhs, id_dosen_pa, nama_dosen_pa)`  
2. `DETAIL_KRS (no_krs, kode_mk, nilai_huruf, nilai_angka)`  
3. `MATA_KULIAH (kode_mk, nama_mk, sks_mk, semester_penawaran)`  

Dengan uraian ini, atribut mata kuliah disimpan pada entitas `MATA_KULIAH` dan informasi rincian nilai disimpan pada entitas `DETAIL_KRS`.

---

### F.5 Bentuk Normal Ketiga (3NF)
Syarat 3NF adalah relasi sudah memenuhi 2NF dan tidak memiliki ketergantungan transitif atribut nonkunci terhadap kunci.  

Atribut nama mahasiswa tidak perlu disimpan berulang kali di setiap transaksi KRS. Demikian pula nama dosen PA tidak perlu disimpan berulang kali dalam tabel `KRS`.

**Hasil relasi 3NF:**

| Tabel | Atribut | Keterangan Kunci |
| :--- | :--- | :--- |
| **MAHASISWA** | `nim, nama_mhs, prodi, alamat, hp, email, status_mhs` | PK: `nim` |
| **DOSEN** | `id_dosen, nama_dosen, email_dosen, prodi_dosen` | PK: `id_dosen` |
| **MATA_KULIAH** | `kode_mk, nama_mk, sks_mk, semester_penawaran` | PK: `kode_mk` |
| **KRS** | `no_krs, nim, id_dosen, tanggal_pengisian, semester_akademik` | PK: `no_krs`; FK: `nim`, `id_dosen` |
| **DETAIL_KRS** | `no_krs, kode_mk, nilai_huruf, nilai_angka` | PK gabungan dan FK ke `KRS` serta `MATA_KULIAH` |

Struktur ini mempertahankan entitas dan atribut yang sudah digunakan dalam proyek akademik. Hubungan KRS mengacu pada mahasiswa dan dosen PA sesuai aturan bisnis sistem kampus.

---

### F.6 Pemeriksaan Bentuk Normal Boyce–Codd (BCNF)
BCNF mengharuskan setiap penentu pada ketergantungan fungsional nontrivial merupakan kunci kandidat.

* **MAHASISWA:** Memenuhi BCNF jika `nim` merupakan kunci kandidat dan dependensi atribut mahasiswa sesuai DF-01.
* **DOSEN:** Memenuhi BCNF jika `id_dosen` merupakan kunci kandidat dan tidak ada penentu lain yang bukan kunci.
* **MATA_KULIAH:** Memenuhi BCNF jika `kode_mk` merupakan kunci kandidat dan dependensi sesuai DF-02.
* **KRS:** Memenuhi BCNF jika `no_krs` merupakan kunci kandidat dan dependensi sesuai DF-04.
* **DETAIL_KRS:** Memenuhi BCNF jika pasangan `(no_krs, kode_mk)` merupakan kunci kandidat dan tidak terdapat penentu nonkunci.

**Kesimpulan:** Pemeriksaan awal menunjukkan bahwa rencana dapat memenuhi BCNF apabila asumsi kunci dan dependensi di atas benar. Kepastian akhir memerlukan konfirmasi seluruh kunci kandidat serta aturan keunikan yang berlaku.

---

### F.7 Keputusan Penyimpanan Nilai Turunan

| Nilai Turunan | Keputusan | Alasan |
| :--- | :--- | :--- |
| **nilai_angka** | Dapat dihitung / disimpan | Dapat dikonversi langsung dari `nilai_huruf` (misal A = 4.0), namun sering disimpan untuk mempercepat perhitungan IPK. |
| **total_sks_diambil** | Dihitung dari data transaksi | Merupakan rekapitulasi/laporan dari jumlah SKS mata kuliah dalam KRS, bukan data pokok wajib yang disimpan. |
| **IPK / IPS** | Dihitung dari data transkrip | Merupakan nilai akumulasi berkala, bukan atribut transaksi dasar yang disimpan permanen di tabel KRS. |
| **status_mhs** | Disimpan pada data Mahasiswa | Status keaktifan diperlukan untuk memvalidasi kelayakan pengambilan KRS setiap awal semester. |

---

### F.8 Penyesuaian ERD
Normalisasi menghasilkan konsep struktur yang menggunakan lima entitas utama: Mahasiswa, Dosen, Mata Kuliah, KRS, dan Detail KRS.  

ERD tidak diubah pada pengerjaan ini. Struktur dan aturan akademik yang belum ditentukan tetap dibiarkan sesuai dokumen proyek saat ini. Jika ada perbedaan penulisan atribut dalam tabel hasil normalisasi dengan ERD, samakan nama atribut ketika menyiapkan DDL pada pertemuan berikutnya.

---

### Ringkasan Hasil
1. Kelompok mata kuliah berulang pada bentuk UNF dipisahkan menjadi detail KRS.
2. Data Mata Kuliah dipisahkan untuk menghindari pengulangan informasi SKS dan nama mata kuliah.
3. Data Mahasiswa dan Dosen dipisahkan dari transaksi pengisian KRS.
4. Relasi 3NF terdiri atas lima tabel utama sesuai entitas sistem akademik.
5. BCNF diperiksa berdasarkan asumsi kunci kandidat dan ketergantungan fungsional yang telah ditentukan.
6. Nilai turunan ditinjau untuk menentukan apakah dihitung atau disimpan.
7. ERD yang sudah ada tidak diubah.