# Dokumen Kebutuhan Data - Koperasi Mahasiswa (Kopma_096)

## 1. Latar Belakang dan Aktivitas Organisasi

Koperasi Mahasiswa (Kopma_096) adalah unit kegiatan mahasiswa yang bergerak di bidang usaha ritel dan pelayanan kebutuhan mahasiswa di lingkungan kampus. Aktivitas bisnis utama Kopma mencakup pendaftaran anggota baru, pengelolaan stok barang dagangan, transaksi penjualan harian kepada anggota maupun non-anggota, pemesanan dan penerimaan barang dari pemasok (*supplier*), serta penyusunan laporan keuangan dan rekapitulasi penjualan bulanan.

---

## 2. Aktor dan Proses Bisnis

| Kode PB | Nama Proses Bisnis | Deskripsi Singkat Proses Bisnis |
| :---: | :--- | :--- |
| **PB-01** | Daftar anggota | Pendaftaran mahasiswa menjadi anggota Kopma dan penerbitan kartu anggota. |
| **PB-02** | Catat penjualan | Pencatatan transaksi penjualan barang kasir kepada pembeli/anggota. |
| **PB-03** | Pesan ke pemasok | Pembuatan dokumen pemesanan barang (*Purchase Order*) kepada pemasok. |
| **PB-04** | Terima barang | Penerimaan pasokan barang dari pemasok dan pembaharuan stok barang. |
| **PB-05** | Laporan bulanan | Rekapitulasi transaksi penjualan, pembelian, dan laporan laba/rugi bulanan. |

---

## 3. Dokumen Sumber yang Dianalisis

1. **Formulir Pendaftaran Anggota:** Berisi identitas mahasiswa, foto, dan bukti pembayaran simpanan pokok/wajib.
2. **Nota / Struk Penjualan:** Berisi tanggal transaksi, kode barang, nama barang, jumlah beli, harga satuan, dan total bayar.
3. **Surat Jalan & Faktur Pemasok:** Berisi daftar barang yang dikirim oleh *supplier*, jumlah pasokan, dan harga beli.

---

## 4. Entitas Kandidat dan Elemen Data

- **Anggota:** `id_anggota`, `nim`, `nama_anggota`, `no_hp`, `status_aktif`
- **Barang:** `kode_barang`, `nama_barang`, `harga_beli`, `harga_jual`, `stok`
- **Penjualan:** `no_nota`, `tgl_transaksi`, `id_anggota`, `total_bayar`
- **Detail Penjualan:** `no_nota`, `kode_barang`, `jumlah`, `subtotal`
- **Pemasok:** `id_pemasok`, `nama_pemasok`, `alamat`, `no_telp`
- **Pembelian:** `no_faktur`, `tgl_pembelian`, `id_pemasok`, `total_pembelian`

---

## 5. Aturan Bisnis

| Kode AB | Entitas Terkait | Deskripsi Aturan Bisnis |
| :---: | :--- | :--- |
| **AB-01** | Anggota | Setiap anggota wajib memiliki **id_anggota** unik dan NIM terdaftar aktif. |
| **AB-02** | Penjualan | Transaksi penjualan dapat dilakukan oleh anggota maupun non-anggota. |
| **AB-03** | Stok Barang | Stok barang otomatis berkurang saat transaksi penjualan dan bertambah saat penerimaan barang dari pemasok. |

---

## 6. Kebutuhan Informasi

| Kode KI | Kebutuhan Informasi | Target Pengguna | Output / Tampilan |
| :---: | :--- | :--- | :--- |
| **KI-01** | Struk Penjualan Harian | Kasir & Pembeli | Struk Belanja / Nota Kasir |
| **KI-02** | Laporan Stok & Barang Kritis | Pengelola Gudang | Daftar Barang yang Harus Di-order |
| **KI-03** | Laporan Penjualan Bulanan | Pengurus Kopma | Rekapitulasi Pendapatan & Laba Ritel |

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
| `id_anggota` | VARCHAR | 10 | Unique, Primary Key Anggota | Divisi Keanggotaan |
| `kode_barang` | VARCHAR | 10 | Unique, Primary Key Barang | Pengelola Gudang |
| `nama_barang` | VARCHAR | 100 | Not Null, Nama Produk Dagangan | Pengelola Gudang |
| `harga_jual` | INT | 11 | Not Null, Nilai Rupiah ($\ge 0$) | Divisi Usaha |
| `stok` | INT | 6 | Jumlah Barang Tersedia ($\ge 0$) | Pengelola Gudang |

---

## 9. Kebutuhan Non-Fungsional Data

- **Volume Data:** Diperkirakan menampung hingga 1.000 transaksi penjualan per hari pada jam operasional puncak.
- **Retensi Data:** Data transaksi penjualan dan pembelian disimpan sekurang-kurangnya selama 5 tahun untuk audit keuangan.
- **Privasi & Keamanan:** Hak akses pengubahan harga barang dan rekapitulasi laporan bulanan dibatasi hanya untuk Pengurus/Admin Kopma.

---

## 10. Isu Kualitas Data yang Diantisipasi

1. **Redundansi Data:** Dipisahkan antara entitas Penjualan dan Detail Penjualan agar data nota tidak berulang.
2. **Inkonsistensi Stok:** Penggunaan transaksi database (*ACID*) saat pencatatan penjualan agar jumlah stok barang riil dan sistem selalu sinkron.
3. **Integritas Referensial:** Menambahkan *Foreign Key* dengan aturan `ON DELETE RESTRICT` pada transaksi agar data barang/pemasok tidak terhapus jika masih memiliki riwayat riil.

---
