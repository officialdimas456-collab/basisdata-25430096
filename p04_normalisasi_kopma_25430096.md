# Modul Normalisasi dan Skema Relasional (Sistem Informasi Akademik)

**Nama:** Muhammad Fikri Misbahudin  
**Kelas:** D  
**NPM:** 25430096  

---

## D.1 Mengubah UNF menjadi 1NF

Relasi awal yang belum dinormalisasi (*Unnormalized Form* / UNF) pada sistem informasi akademik:

`$$\text{KRS\_UNF (no\_krs, tgl\_pengisian, nim, nama\_mhs, id\_dosen\_pa, nama\_dosen\_pa, \{kode\_mk, nama\_mk, sks\_mk, nilai\_huruf, nilai\_angka\}, total\_sks\_diambil)}$$`

Relasi tersebut masih memiliki kelompok mata kuliah berulang dalam satu Kartu Rencana Studi (KRS). Satu KRS dapat berisi beberapa mata kuliah sehingga kelompok mata kuliah perlu diuraikan menjadi satu baris untuk setiap mata kuliah pada setiap KRS.

Setelah diubah menjadi **Bentuk Normal Pertama (1NF)**, relasinya menjadi:

`$$\text{KRS\_1NF (no\_krs, kode\_mk, tgl\_pengisian, nim, nama\_mhs, id\_dosen\_pa, nama\_dosen\_pa, nama\_mk, sks\_mk, nilai\_huruf, nilai\_angka, total\_sks\_diambil)}$$`

* **Kunci primer komposit:** `(no_krs, kode_mk)`

### Hasil Normalisasi 1NF
Setiap atribut menyimpan satu nilai atomik pada setiap baris dan tidak ada lagi kelompok mata kuliah berulang. Namun, masih terdapat atribut yang bergantung pada sebagian kunci komposit (ketergantungan parsial) serta ketergantungan transitif. Oleh karena itu, normalisasi dilanjutkan ke 2NF dan 3NF.

---

## D.2 Menuliskan Dependensi Fungsional

Dependensi fungsional (DF) diturunkan dari aturan bisnis pengelolaan akademik kampus:

| Kode | Dependensi Fungsional | Keterangan |
| :--- | :--- | :--- |
| **DF1** | $\text{no\_krs} \rightarrow \text{tgl\_pengisian, nim, id\_dosen\_pa}$ | Satu nomor KRS menentukan tanggal pengisian, mahasiswa yang mengambil, dan dosen pembimbing akademik (PA). |
| **DF2** | $\text{nim} \rightarrow \text{nama\_mhs}$ | Nomor Induk Mahasiswa menentukan nama mahasiswa. |
| **DF3** | $\text{id\_dosen\_pa} \rightarrow \text{nama\_dosen\_pa}$ | ID/NIDN dosen PA menentukan nama dosen pembimbing. |
| **DF4** | $\text{kode\_mk} \rightarrow \text{nama\_mk, sks\_mk}$ | Kode mata kuliah menentukan nama mata kuliah dan bobot SKS-nya. |
| **DF5** | $(\text{no\_krs, kode\_mk}) \rightarrow \text{nilai\_huruf, nilai\_angka}$ | Kombinasi nomor KRS dan kode mata kuliah menentukan nilai akhir yang diperoleh mahasiswa. |
| **DF6** | $\text{nilai\_huruf} \rightarrow \text{nilai\_angka}$ | Nilai huruf (A, B, C, dst.) menentukan bobot nilai angka konversinya (4.0, 3.0, 2.0, dst.). |

---

## D.3 Menuju 2NF dan 3NF

### A. Tahap 2NF
Bentuk normal kedua (2NF) mensyaratkan bahwa relasi sudah memenuhi 1NF dan tidak memiliki atribut bukan kunci yang bergantung hanya pada sebagian kunci komposit (*partial dependency*).

Pada relasi `KRS_1NF`, kunci kompositnya adalah `(no_krs, kode_mk)`. Namun, tanggal pengisian hanya ditentukan oleh `no_krs`, sedangkan nama dan SKS mata kuliah hanya ditentukan oleh `kode_mk`.

Dengan demikian, informasi KRS dan informasi mata kuliah perlu dipisahkan dari detail pengambilan mata kuliah.

Relasi hasil pemisahan menuju 2NF adalah:

1. **KRS**  
   `$\text{KRS (no\_krs, tgl\_pengisian, nim, nama\_mhs, id\_dosen\_pa, nama\_dosen\_pa, total\_sks\_diambil)}$`
   * **Kunci primer:** `no_krs`

2. **MATA_KULIAH**  
   `$\text{MATA\_KULIAH (kode\_mk, nama\_mk, sks\_mk)}$`
   * **Kunci primer:** `kode_mk`

3. **DETAIL_KRS**  
   `$\text{DETAIL\_KRS (no\_krs, kode\_mk, nilai\_huruf, nilai\_angka)}$`
   * **Kunci primer komposit:** `(no_krs, kode_mk)`

Pada tahap ini, ketergantungan pada sebagian kunci komposit telah dihilangkan. Akan tetapi, tabel `KRS` masih memiliki ketergantungan transitif karena `nama_mhs` ditentukan oleh `nim`, dan `nama_dosen_pa` ditentukan oleh `id_dosen_pa`. Nilai turunan juga masih perlu dievaluasi.

---

### B. Tahap 3NF
Bentuk normal ketiga (3NF) mensyaratkan bahwa relasi sudah memenuhi 2NF dan tidak memiliki ketergantungan transitif (*transitive dependency*) di antara atribut bukan kunci.

Pada tabel KRS terdapat rantai dependensi:
* `$\text{no\_krs} \rightarrow \text{nim} \rightarrow \text{nama\_mhs}$`
* `$\text{no\_krs} \rightarrow \text{id\_dosen\_pa} \rightarrow \text{nama\_dosen\_pa}$`

Kedua rantai tersebut menunjukkan bahwa nama mahasiswa dan nama dosen PA tidak perlu disimpan berulang dalam tabel KRS. Informasi tersebut dipisahkan ke tabel masing-masing.

Relasi hasil normalisasi 3NF:

1. **KRS**  
   `$\text{KRS (no\_krs, tgl\_pengisian, nim*, id\_dosen\_pa*, semester\_akademik)}$`

2. **DETAIL_KRS**  
   `$\text{DETAIL\_KRS (no\_krs*, kode\_mk*, nilai\_huruf, nilai\_angka)}$`

3. **MATA_KULIAH**  
   `$\text{MATA\_KULIAH (kode\_mk, nama\_mk, sks\_mk, semester\_penawaran)}$`

4. **MAHASISWA**  
   `$\text{MAHASISWA (nim, nama\_mhs, prodi, id\_dosen\_pa*)}$`

5. **DOSEN**  
   `$\text{DOSEN (id\_dosen, nidn, nama\_dosen, email\_dosen)}$`

> **Keterangan:**
> * Atribut yang diisi garis bawah atau ditetapkan sebagai kunci primer mengidentifikasi setiap baris.
> * Tanda `*` menunjukkan kunci tamu (*foreign key*) yang mereferensikan relasi lain.

---

### C. Keputusan Penyimpanan Nilai Turunan
Nilai turunan yang dibahas dalam konteks akademik meliputi:
* `total_sks_diambil` (Jumlah akumulasi SKS mata kuliah yang diambil dalam satu KRS)
* `ipk` / `ips` (Indeks Prestasi Semester/Kumulatif)

Perhitungan SKS dilakukan dengan rumus:

`$$\text{total\_sks\_diambil} = \sum \text{sks\_mk}$$`

Berdasarkan keputusan pemodelan, `total_sks_diambil` dan `ips` **tidak disimpan** sebagai atribut tersendiri dalam tabel operasional `KRS` karena nilainya dapat dihitung secara dinamis dari tabel `DETAIL_KRS` dan `MATA_KULIAH`. Hal ini mengurangi risiko redundansi dan ketidaksesuaian nilai saat ada penambahan/penghapusan mata kuliah (mencegah anomali ubah).

---

## D.4 Mencocokkan dengan Skema Kanonik

Skema kanonik Sistem Informasi Akademik menggunakan kunci pengganti (*surrogate key*) berupa atribut `id_*` sebagai kunci primer. Nomor atau kode alami (seperti NIM, NIDN, Kode MK, No KRS) tetap dipertahankan sebagai kunci unik.

### Tabel Skema Kanonik Akademik

| Tabel | Kunci Primer (PK) | Kunci Unik (UQ) | Kunci Tamu (FK) |
| :--- | :--- | :--- | :--- |
| **dosen** | `id_dosen` | `nidn` | — |
| **mahasiswa** | `id_mahasiswa` | `nim` | `id_dosen_pa` (boleh NULL) |
| **mata_kuliah**| `id_mk` | `kode_mk` | — |
| **dosen_pengampu**| `id_pengampu` | — | `id_dosen`, `id_mk` |
| **krs** | `id_krs` | `no_krs` | `id_mahasiswa` |
| **detail_krs** | `(id_krs, id_mk)` | — | `id_krs`, `id_mk` |

---

### Pemeriksaan BCNF

BCNF (*Boyce–Codd Normal Form*) mensyaratkan bahwa setiap penentu (*determinant*) pada dependensi fungsional nontrivial merupakan kunci kandidat (*candidate key*).

| Tabel | Penentu yang diperiksa | Hasil pemeriksaan |
| :--- | :--- | :--- |
| **dosen** | `id_dosen`, `nidn` | Kedua atribut merupakan kunci kandidat. Dependensi `nidn → nama_dosen` tidak melanggar BCNF. |
| **mahasiswa** | `id_mahasiswa`, `nim` | Kedua atribut merupakan kunci kandidat. Dependensi `nim → nama_mhs` tidak melanggar BCNF. |
| **mata_kuliah**| `id_mk`, `kode_mk` | Kedua atribut merupakan kunci kandidat. Dependensi `kode_mk → nama_mk` tidak melanggar BCNF. |
| **krs** | `id_krs`, `no_krs` | Kedua atribut merupakan kunci kandidat. Dependensi `no_krs → tgl_pengisian` tidak melanggar BCNF. |
| **detail_krs** | `(id_krs, id_mk)` | Gabungan atribut merupakan kunci primer komposit. BCNF terpenuhi selama tidak terdapat atribut penentu lain yang bukan merupakan kunci kandidat. |

---

## Kesimpulan

Normalisasi sistem akademik dilakukan untuk meminimalkan pengulangan data mahasiswa, dosen, dan mata kuliah, mencegah anomali ubah/sisip/hapus, serta menjaga integritas data akademik. 

Tahap **1NF** menghilangkan kelompok mata kuliah berulang pada KRS, **2NF** memisahkan atribut yang hanya bergantung pada sebagian kunci komposit (seperti informasi mata kuliah), dan **3NF** memisahkan relasi yang memiliki ketergantungan transitif (seperti data biodata mahasiswa dan dosen PA). Nilai turunan seperti total SKS dan IPS dihitung melalui kueri dinamis untuk menjamin konsistensi data.

---

## E. Latihan dan Modifikasi (Tema Akademik)

### 1. Normalisasi Nomor Kontak/Nomor HP Mahasiswa

Sistem akademik membutuhkan penyimpanan lebih dari satu nomor telepon/WhatsApp untuk setiap mahasiswa (misalnya nomor HP pribadi dan nomor HP orang tua/wali). Jika beberapa nomor telepon disimpan dalam satu kolom pada tabel `mahasiswa`, data menjadi tidak atomik dan melanggar Bentuk Normal Pertama (1NF).

Untuk mengatasinya, data nomor telepon dipisahkan ke dalam relasi tersendiri bernama `kontak_mahasiswa`.

**Relasi Utama Mahasiswa:**
$$\text{MAHASISWA (id\_mahasiswa, nim, nama\_mhs, prodi)}$$
* **PK:** `id_mahasiswa`
* **UQ:** `nim`

**Relasi Kontak Mahasiswa:**
$$\text{KONTAK\_MAHASISWA (id\_mahasiswa, no\_hp, jenis\_kontak)}$$
* **PK:** `(id_mahasiswa, no_hp)`
* **FK:** `id_mahasiswa` mengacu pada $\text{MAHASISWA(id\_mahasiswa)}$

---

### 2. Pelanggaran 3NF dan Anomali Ubah

Jika atribut `nama_dosen_pa` disimpan langsung di tabel `krs`, maka nama dosen PA akan tercatat berulang pada setiap KRS yang dibuat oleh mahasiswa bimbingannya dari semester ke semester.

Contoh data:

| no_krs | nim | id_dosen_pa | nama_dosen_pa |
| :--- | :--- | :--- | :--- |
| KRS-20241-01 | M2024001 | D088 | Prof. Dr. Budi |
| KRS-20242-01 | M2024001 | D088 | Prof. Dr. Budi |

Pada data tersebut, terdapat rantai dependensi transitif:

$$\text{no\_krs} \rightarrow \text{id\_dosen\_pa} \rightarrow \text{nama\_dosen\_pa}$$

Hal ini melanggar 3NF karena atribut `nama_dosen_pa` bergantung secara transitif pada kunci primer `no_krs`, bukan secara langsung.

#### Contoh Kueri SQL yang Menunjukkan Anomali Ubah:

```sql
UPDATE krs
SET nama_dosen_pa = 'Prof. Dr. Budi Santoso, M.Kom.'
WHERE no_krs = 'KRS-20241-01';