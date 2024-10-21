-- Membuat skema SALAM
CREATE SCHEMA SALAM;

-- Membuat tabel mahasiswas di dalam skema SALAM
CREATE TABLE SALAM.mahasiswas (
    id SERIAL PRIMARY KEY,             -- Primary key
    nim VARCHAR(10) UNIQUE,            -- Unique constraint pada kolom nim
    nama VARCHAR(100) NOT NULL,
    tanggal_lahir DATE,
    ipk NUMERIC(3, 2),
    status VARCHAR(10) CHECK (status IN ('Aktif', 'Cuti', 'Lulus')) -- Check constraint pada kolom status
);

-- Pengujian Constraint:
-- 1. Insert data yang valid
INSERT INTO SALAM.mahasiswas (nim, nama, tanggal_lahir, ipk, status)
VALUES ('1234567890', 'Budi', '2000-05-20', 3.50, 'Aktif');

-- 2. Pengujian Unique Constraint (Ini akan gagal karena NIM sudah ada)
INSERT INTO SALAM.mahasiswas (nim, nama, tanggal_lahir, ipk, status)
VALUES ('1234567890', 'Siti', '2001-07-11', 3.20, 'Aktif');

-- 3. Pengujian Check Constraint (Ini akan gagal karena status tidak valid)
INSERT INTO SALAM.mahasiswas (nim, nama, tanggal_lahir, ipk, status)
VALUES ('0987654321', 'Andi', '1999-03-10', 2.80, 'Dropout');





-- Create user dan uji hak akses

-- Buat pengguna backend_dev dengan password 'ifunggul'
CREATE USER backend_dev WITH PASSWORD 'ifunggul';
-- Berikan akses ke database postgres
GRANT CONNECT ON DATABASE postgres TO backend_dev;
-- Berikan hak penggunaan schema salam
GRANT USAGE ON SCHEMA salam TO backend_dev;
-- Berikan hak CRUD (SELECT, INSERT, UPDATE, DELETE) pada semua tabel di schema salam
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA salam TO backend_dev;
-- Berikan hak akses otomatis untuk tabel yang dibuat di masa depan
ALTER DEFAULT PRIVILEGES IN SCHEMA salam GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO backend_dev;
-- Berikan hak akses pada sequence untuk backend_dev
GRANT USAGE, SELECT ON SEQUENCE salam.mahasiswas_id_seq TO backend_dev;


-- Buat pengguna bi_dev dengan password 'ifunggul'
CREATE USER bi_dev WITH PASSWORD 'ifunggul';
-- Berikan akses ke database postgres
GRANT CONNECT ON DATABASE postgres TO bi_dev;
-- Berikan hak penggunaan schema salam
GRANT USAGE ON SCHEMA salam TO bi_dev;
-- Berikan hak SELECT (hanya baca) pada semua tabel di schema salam
GRANT SELECT ON ALL TABLES IN SCHEMA salam TO bi_dev;
-- Berikan hak SELECT (hanya baca) pada semua sequence di schema salam
GRANT SELECT ON ALL SEQUENCES IN SCHEMA salam TO bi_dev;
-- Berikan hak akses otomatis untuk view dan tabel yang dibuat di masa depan
ALTER DEFAULT PRIVILEGES IN SCHEMA salam GRANT SELECT ON TABLES TO bi_dev;


-- Buat pengguna data_engineer dengan password 'ifunggul'
CREATE USER data_engineer WITH PASSWORD 'ifunggul';
-- Berikan akses ke database postgres (atau database lain jika perlu)
GRANT CONNECT ON DATABASE postgres TO data_engineer;
-- Berikan hak akses penggunaan schema salam
GRANT USAGE ON SCHEMA salam TO data_engineer;
-- Berikan hak CREATE pada schema salam agar bisa membuat objek
GRANT CREATE ON SCHEMA salam TO data_engineer;
-- Ubah pemilik tabel mahasiswas menjadi data_engineer (hanya bisa dilakukan oleh pemilik asli atau superuser)
ALTER TABLE salam.mahasiswas OWNER TO data_engineer;
-- Berikan hak akses penuh (ALL PRIVILEGES) kepada data_engineer pada tabel mahasiswas
GRANT ALL PRIVILEGES ON TABLE salam.mahasiswas TO data_engineer;
-- Berikan hak akses penuh (ALL PRIVILEGES) pada semua tabel di schema salam
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA salam TO data_engineer;
-- Berikan hak akses penuh (ALL PRIVILEGES) pada semua sequences di schema salam
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA salam TO data_engineer;
-- Berikan hak akses penuh (ALL PRIVILEGES) pada semua functions di schema salam
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA salam TO data_engineer;
-- Berikan hak akses otomatis untuk objek yang dibuat di masa depan (tabel, sequences, functions)
ALTER DEFAULT PRIVILEGES IN SCHEMA salam GRANT ALL PRIVILEGES ON TABLES TO data_engineer;
ALTER DEFAULT PRIVILEGES IN SCHEMA salam GRANT ALL PRIVILEGES ON SEQUENCES TO data_engineer;
ALTER DEFAULT PRIVILEGES IN SCHEMA salam GRANT ALL PRIVILEGES ON FUNCTIONS TO data_engineer;


-- Menguji INSERT oleh backend_dev (harus berhasil)
INSERT INTO SALAM.mahasiswas (nim, nama, tanggal_lahir, ipk, status)
VALUES ('1111111111', 'Ali', '2002-01-10', 3.75, 'Aktif');

-- Menguji DELETE oleh backend_dev (harus berhasil)
DELETE FROM SALAM.mahasiswas WHERE nim = '1111111111';

-- Menguji SELECT oleh bi_dev (harus berhasil)
SELECT * FROM SALAM.mahasiswas;

-- Menguji INSERT oleh bi_dev (harus gagal)
INSERT INTO SALAM.mahasiswas (nim, nama, tanggal_lahir, ipk, status)
VALUES ('2222222222', 'Rani', '2003-04-12', 3.60, 'Aktif');

-- Menguji CREATE TABLE oleh data_engineer (harus berhasil)
CREATE TABLE SALAM.alumni (
    id SERIAL PRIMARY KEY,
    nim VARCHAR(10) UNIQUE,
    nama VARCHAR(100) NOT NULL,
    tahun_lulus INT
);
-- Menguji menambah kolom baru oleh data_engineer (harus berhasil)
ALTER TABLE SALAM.mahasiswas
ADD COLUMN alamat VARCHAR(255);

-- Menguji mengubah tipe data kolom oleh data_engineer (harus berhasil)
ALTER TABLE SALAM.mahasiswas
ALTER COLUMN nama TYPE TEXT;

-- Menguji menghapus kolom oleh data_engineer (harus berhasil)
ALTER TABLE SALAM.mahasiswas
DROP COLUMN alamat;

-- Menguji DROP TABLE oleh data_engineer (harus berhasil)
DROP TABLE SALAM.alumni;


