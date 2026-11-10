USE ddl_kopma_096;

-- Hapus tabel secara berurutan dari tabel anak (detail/transaksi) ke tabel induk
DROP TABLE IF EXISTS detail_krs;
DROP TABLE IF EXISTS krs;
DROP TABLE IF EXISTS mata_kuliah;
DROP TABLE IF EXISTS mahasiswa;
DROP TABLE IF EXISTS dosen;

-- 1. TABEL DOSEN (Induk)
CREATE TABLE dosen (
    id_dosen INT AUTO_INCREMENT NOT NULL,
    kode_dosen CHAR(5) NOT NULL,
    nidn VARCHAR(20) NOT NULL,
    nama_dosen VARCHAR(100) NOT NULL,
    email_dosen VARCHAR(100) NULL,
    prodi_dosen VARCHAR(60) NOT NULL,
    PRIMARY KEY (id_dosen),
    UNIQUE KEY uq_dosen_kode (kode_dosen),
    UNIQUE KEY uq_dosen_nidn (nidn)
) ENGINE=InnoDB;

-- 2. TABEL MAHASISWA (Induk, Memiliki FK ke Dosen Wali/PA)
CREATE TABLE mahasiswa (
    id_mahasiswa INT AUTO_INCREMENT NOT NULL,
    nim CHAR(10) NOT NULL,
    nama_mhs VARCHAR(100) NOT NULL,
    prodi_mhs VARCHAR(60) NOT NULL,
    no_hp_mhs VARCHAR(15) NULL,
    email_mhs VARCHAR(100) NULL,
    status_mhs ENUM('aktif', 'cuti', 'nonaktif', 'lulus') NOT NULL DEFAULT 'aktif',
    tgl_daftar_mhs DATE NOT NULL,
    id_dosen_pa INT NULL,
    PRIMARY KEY (id_mahasiswa),
    UNIQUE KEY uq_mhs_nim (nim),
    CONSTRAINT fk_mhs_dosen_pa FOREIGN KEY (id_dosen_pa) REFERENCES dosen (id_dosen) 
        ON UPDATE CASCADE 
        ON DELETE SET NULL
) ENGINE=InnoDB;

-- 3. TABEL MATA KULIAH (Induk)
CREATE TABLE mata_kuliah (
    id_mk INT AUTO_INCREMENT NOT NULL,
    kode_mk VARCHAR(10) NOT NULL,
    nama_mk VARCHAR(100) NOT NULL,
    sks_mk TINYINT NOT NULL,
    semester_penawaran TINYINT NOT NULL,
    kategori_mk ENUM('wajib', 'pilihan') NOT NULL DEFAULT 'wajib',
    PRIMARY KEY (id_mk),
    UNIQUE KEY uq_mk_kode (kode_mk),
    CONSTRAINT ck_mk_sks CHECK (sks_mk > 0 AND sks_mk <= 6),
    CONSTRAINT ck_mk_smt CHECK (semester_penawaran >= 1 AND semester_penawaran <= 8)
) ENGINE=InnoDB;

-- 4. TABEL KRS (Transaksi Utama Peminatan Mata Kuliah)
CREATE TABLE krs (
    id_krs INT AUTO_INCREMENT NOT NULL,
    no_krs CHAR(12) NOT NULL,
    tgl_krs DATETIME NOT NULL,
    semester_akademik VARCHAR(10) NOT NULL, -- Contoh: '2025/2026-1'
    id_mahasiswa INT NOT NULL,
    status_persetujuan ENUM('draft', 'diajukan', 'disetujui', 'ditolak') NOT NULL DEFAULT 'draft',
    PRIMARY KEY (id_krs),
    UNIQUE KEY uq_krs_no (no_krs),
    CONSTRAINT fk_krs_mahasiswa FOREIGN KEY (id_mahasiswa) REFERENCES mahasiswa (id_mahasiswa) 
        ON UPDATE CASCADE 
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- 5. TABEL DETAIL KRS (Tabel Pivot/Relasi N-to-M Antara KRS dan Mata Kuliah)
CREATE TABLE detail_krs (
    id_krs INT NOT NULL,
    id_mk INT NOT NULL,
    nilai_huruf ENUM('A', 'B+', 'B', 'C+', 'C', 'D', 'E') NULL,
    nilai_angka DECIMAL(3,2) NULL,
    PRIMARY KEY (id_krs, id_mk),
    CONSTRAINT fk_detail_krs FOREIGN KEY (id_krs) REFERENCES krs (id_krs) 
        ON DELETE CASCADE,
    CONSTRAINT fk_detail_mk FOREIGN KEY (id_mk) REFERENCES mata_kuliah (id_mk),
    CONSTRAINT ck_detail_nilai_angka CHECK (nilai_angka IS NULL OR (nilai_angka >= 0.00 AND nilai_angka <= 4.00))
) ENGINE=InnoDB;