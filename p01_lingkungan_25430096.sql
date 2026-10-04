-- p01_lingkungan_2301010123.sql
-- Password sengaja diganti penanda. JANGAN commit password asli.
CREATE DATABASE IF NOT EXISTS Modul_01
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'Fikri_096'@'localhost' IDENTIFIED BY '<password_kerja>';
GRANT ALL PRIVILEGES ON Modul_01.* TO 'Fikri_096'@'localhost';