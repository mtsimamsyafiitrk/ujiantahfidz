-- ═══════════════════════════════════════════════════════════════════
-- SCHEMA DATABASE — Aplikasi Penilaian Tahfidz (Supabase / PostgreSQL)
-- ═══════════════════════════════════════════════════════════════════
-- Dipakai HANYA untuk menyiapkan proyek Supabase BARU (mis. proyek lama
-- sudah tidak bisa di-restore). Jalankan sekali di Supabase → SQL Editor.
--
-- CATATAN: file ini disusun ulang dari kode index.html (tabel & kolom yang
-- dipakai aplikasi), bukan salinan dari database lama. Jangan dijalankan
-- di database yang masih berisi data.
-- ═══════════════════════════════════════════════════════════════════

create extension if not exists pgcrypto;

create table if not exists penguji (
  id         uuid primary key default gen_random_uuid(),
  username   text not null unique,
  password   text not null,                 -- SHA-256 (hex)
  nama       text not null,
  role       text not null default 'penguji'
             check (role in ('admin','ketua_tahfidz','penguji')),
  created_at timestamptz not null default now()
);

create table if not exists siswa (
  id            uuid primary key default gen_random_uuid(),
  nisn          text,
  nama          text not null,
  kelas         text,
  semester      text,
  jenis_kelamin text,
  tahun_ajaran  text,
  -- status santri: 'ALQURAN_LANJUT' = Al-Qur'an, 'TAHAP_IQRA' = Iqra' ('ALQURAN_PEMULA' = nilai lama)
  kategori      text default 'ALQURAN_LANJUT'
                check (kategori in ('ALQURAN_LANJUT','ALQURAN_PEMULA','TAHAP_IQRA')),
  status_dikunci boolean not null default false,   -- dikunci penguji saat ujian
  jumlah_hafalan numeric,                          -- jumlah hafalan selama ini (juz), keterangan saja
  created_at    timestamptz not null default now()
);

-- 1 siswa = 1 penguji
create table if not exists assignment (
  id         uuid primary key default gen_random_uuid(),
  siswa_id   uuid not null unique references siswa(id) on delete cascade,
  penguji_id uuid not null references penguji(id) on delete cascade,
  status     text not null default 'belum' check (status in ('belum','selesai')),
  created_at timestamptz not null default now()
);

create table if not exists penilaian (
  id              uuid primary key default gen_random_uuid(),
  siswa_id        uuid not null references siswa(id) on delete cascade,
  penguji_id      uuid not null references penguji(id) on delete cascade,
  tanggal_ujian   date,
  catatan         text,
  nilai_kualitas  numeric,
  jumlah_juz      numeric,
  nilai_kuantitas numeric,
  nilai_akhir     numeric,
  -- khusus santri Iqra': nilai membaca (bobot 76%) dan apakah nilai hafalan dimunculkan (bobot 24%)
  baca_lancar     numeric,
  baca_tajwid     numeric,
  baca_adab       numeric,
  hafalan_aktif   boolean not null default false,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  unique (siswa_id, penguji_id)
);

create table if not exists nilai_detail (
  id               uuid primary key default gen_random_uuid(),
  penilaian_id     uuid not null references penilaian(id) on delete cascade,
  surah_nama       text not null,
  kelancaran       numeric not null default 0,
  tajwid           numeric not null default 0,
  kekuatan_hafalan numeric not null default 0,
  adab_tartil      numeric not null default 0,
  -- bobot: Kelancaran 30%, Tajwid 30%, Kekuatan Hafalan 25%, Adab & Tartil 15%
  total            numeric generated always as
                   (kelancaran * 0.30 + tajwid * 0.30 + kekuatan_hafalan * 0.25 + adab_tartil * 0.15) stored,
  urutan           int not null default 0
);
create index if not exists nilai_detail_penilaian_idx on nilai_detail (penilaian_id);

create table if not exists surah (
  id          uuid primary key default gen_random_uuid(),
  nomor       int not null unique,
  nama        text not null unique,          -- harus sama persis dengan SURAH_JUZ di index.html
  nama_arab   text,
  jumlah_ayat int not null,
  aktif       boolean not null default true
);

create table if not exists pengaturan (
  id           int primary key default 1 check (id = 1),
  nama_lembaga text not null default 'MTs Al Imam Asy-Syafi''i',
  alamat       text default 'Tarakan',
  tahun_ajaran text default '2026/2027',
  semester     text default 'Ganjil',
  kelas_arsip  text not null default '[]'    -- JSON array nama kelas yang diarsipkan
);

-- Aplikasi melakukan autentikasi sendiri dengan anon key (lihat README → Catatan Teknis)
alter table penguji      disable row level security;
alter table siswa        disable row level security;
alter table assignment   disable row level security;
alter table penilaian    disable row level security;
alter table nilai_detail disable row level security;
alter table surah        disable row level security;
alter table pengaturan   disable row level security;

insert into pengaturan (id) values (1) on conflict (id) do nothing;

-- Akun awal: admin / admin123  → WAJIB ganti password setelah login pertama
insert into penguji (username, password, nama, role)
values ('admin', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'Administrator', 'admin')
on conflict (username) do nothing;

insert into surah (nomor, nama, jumlah_ayat) values
  (1, 'Al-Fatihah', 7),
  (2, 'Al-Baqarah', 286),
  (3, 'Ali Imran', 200),
  (4, 'An-Nisa', 176),
  (5, 'Al-Maidah', 120),
  (6, 'Al-An''am', 165),
  (7, 'Al-A''raf', 206),
  (8, 'Al-Anfal', 75),
  (9, 'At-Taubah', 129),
  (10, 'Yunus', 109),
  (11, 'Hud', 123),
  (12, 'Yusuf', 111),
  (13, 'Ar-Ra''d', 43),
  (14, 'Ibrahim', 52),
  (15, 'Al-Hijr', 99),
  (16, 'An-Nahl', 128),
  (17, 'Al-Isra', 111),
  (18, 'Al-Kahf', 110),
  (19, 'Maryam', 98),
  (20, 'Ta Ha', 135),
  (21, 'Al-Anbiya', 112),
  (22, 'Al-Hajj', 78),
  (23, 'Al-Mu''minun', 118),
  (24, 'An-Nur', 64),
  (25, 'Al-Furqan', 77),
  (26, 'Asy-Syu''ara', 227),
  (27, 'An-Naml', 93),
  (28, 'Al-Qasas', 88),
  (29, 'Al-''Ankabut', 69),
  (30, 'Ar-Rum', 60),
  (31, 'Luqman', 34),
  (32, 'As-Sajdah', 30),
  (33, 'Al-Ahzab', 73),
  (34, 'Saba', 54),
  (35, 'Fatir', 45),
  (36, 'Ya Sin', 83),
  (37, 'As-Saffat', 182),
  (38, 'Sad', 88),
  (39, 'Az-Zumar', 75),
  (40, 'Gafir', 85),
  (41, 'Fussilat', 54),
  (42, 'Asy-Syura', 53),
  (43, 'Az-Zukhruf', 89),
  (44, 'Ad-Dukhan', 59),
  (45, 'Al-Jasiyah', 37),
  (46, 'Al-Ahqaf', 35),
  (47, 'Muhammad', 38),
  (48, 'Al-Fath', 29),
  (49, 'Al-Hujurat', 18),
  (50, 'Qaf', 45),
  (51, 'Az-Zariyat', 60),
  (52, 'At-Tur', 49),
  (53, 'An-Najm', 62),
  (54, 'Al-Qamar', 55),
  (55, 'Ar-Rahman', 78),
  (56, 'Al-Waqi''ah', 96),
  (57, 'Al-Hadid', 29),
  (58, 'Al-Mujadalah', 22),
  (59, 'Al-Hasyr', 24),
  (60, 'Al-Mumtahanah', 13),
  (61, 'As-Saff', 14),
  (62, 'Al-Jumu''ah', 11),
  (63, 'Al-Munafiqun', 11),
  (64, 'At-Tagabun', 18),
  (65, 'At-Talaq', 12),
  (66, 'At-Tahrim', 12),
  (67, 'Al-Mulk', 30),
  (68, 'Al-Qalam', 52),
  (69, 'Al-Haqqah', 52),
  (70, 'Al-Ma''arij', 44),
  (71, 'Nuh', 28),
  (72, 'Al-Jinn', 28),
  (73, 'Al-Muzzammil', 20),
  (74, 'Al-Muddassir', 56),
  (75, 'Al-Qiyamah', 40),
  (76, 'Al-Insan', 31),
  (77, 'Al-Mursalat', 50),
  (78, 'An-Naba', 40),
  (79, 'An-Nazi''at', 46),
  (80, '''Abasa', 42),
  (81, 'At-Takwir', 29),
  (82, 'Al-Infitar', 19),
  (83, 'Al-Mutaffifin', 36),
  (84, 'Al-Insyiqaq', 25),
  (85, 'Al-Buruj', 22),
  (86, 'At-Tariq', 17),
  (87, 'Al-A''la', 19),
  (88, 'Al-Gasyiyah', 26),
  (89, 'Al-Fajr', 30),
  (90, 'Al-Balad', 20),
  (91, 'Asy-Syams', 15),
  (92, 'Al-Lail', 21),
  (93, 'Ad-Duha', 11),
  (94, 'Asy-Syarh', 8),
  (95, 'At-Tin', 8),
  (96, 'Al-''Alaq', 19),
  (97, 'Al-Qadr', 5),
  (98, 'Al-Bayyinah', 8),
  (99, 'Az-Zalzalah', 8),
  (100, 'Al-''Adiyat', 11),
  (101, 'Al-Qari''ah', 11),
  (102, 'At-Takasur', 8),
  (103, 'Al-''Asr', 3),
  (104, 'Al-Humazah', 9),
  (105, 'Al-Fil', 5),
  (106, 'Quraisy', 4),
  (107, 'Al-Ma''un', 7),
  (108, 'Al-Kausar', 3),
  (109, 'Al-Kafirun', 6),
  (110, 'An-Nasr', 3),
  (111, 'Al-Lahab', 5),
  (112, 'Al-Ikhlas', 4),
  (113, 'Al-Falaq', 5),
  (114, 'An-Nas', 6)
on conflict (nomor) do nothing;

-- ───────────────────────────────────────────────────────────────────
-- Arsip nilai per periode, naik kelas & lulus (sama dengan SQL migrasi di aplikasi)
-- ───────────────────────────────────────────────────────────────────
-- Migrasi: status santri, nilai membaca Iqra', arsip nilai per periode, naik kelas & lulus
-- Aman dijalankan berulang kali. Data yang sudah ada tidak berubah.
ALTER TABLE siswa
  ADD COLUMN IF NOT EXISTS status_dikunci BOOLEAN NOT NULL DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS jumlah_hafalan NUMERIC,
  ADD COLUMN IF NOT EXISTS lulus BOOLEAN NOT NULL DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS tahun_lulus TEXT;

ALTER TABLE penilaian
  ADD COLUMN IF NOT EXISTS baca_lancar NUMERIC,
  ADD COLUMN IF NOT EXISTS baca_tajwid NUMERIC,
  ADD COLUMN IF NOT EXISTS baca_adab NUMERIC,
  ADD COLUMN IF NOT EXISTS hafalan_aktif BOOLEAN NOT NULL DEFAULT FALSE;

ALTER TABLE pengaturan
  ADD COLUMN IF NOT EXISTS semester TEXT DEFAULT 'Ganjil';

-- Salinan nilai per periode ujian. Tidak terhubung ke tabel siswa/penilaian,
-- jadi tetap utuh walau santri naik kelas, lulus, atau dihapus.
CREATE TABLE IF NOT EXISTS arsip_nilai (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  periode         TEXT NOT NULL,
  tahun_ajaran    TEXT,
  semester        TEXT,
  diarsipkan_pada TIMESTAMPTZ NOT NULL DEFAULT now(),
  siswa_id        UUID,
  nisn            TEXT,
  nama            TEXT,
  kelas           TEXT,
  kategori        TEXT,
  jumlah_hafalan  NUMERIC,
  penguji_id      UUID,
  penguji_nama    TEXT,
  tanggal_ujian   DATE,
  catatan         TEXT,
  nilai_kualitas  NUMERIC,
  jumlah_juz      NUMERIC,
  nilai_kuantitas NUMERIC,
  nilai_akhir     NUMERIC,
  baca_lancar     NUMERIC,
  baca_tajwid     NUMERIC,
  baca_adab       NUMERIC,
  hafalan_aktif   BOOLEAN NOT NULL DEFAULT FALSE,
  detail          JSONB NOT NULL DEFAULT '[]'
);
CREATE INDEX IF NOT EXISTS arsip_nilai_periode_idx ON arsip_nilai (periode);
ALTER TABLE arsip_nilai DISABLE ROW LEVEL SECURITY;
GRANT ALL ON arsip_nilai TO anon, authenticated;

-- Tutup periode: arsipkan semua nilai, kosongkan nilai & penugasan,
-- (opsional) naikkan kelas 7→8, 8→9 dan luluskan kelas 9, lalu set periode baru.
-- Seluruhnya satu transaksi: kalau satu langkah gagal, tidak ada yang berubah.
CREATE OR REPLACE FUNCTION tutup_periode(p_nama TEXT, p_naik_kelas BOOLEAN, p_ta_baru TEXT, p_semester_baru TEXT)
RETURNS JSON LANGUAGE plpgsql AS $fn$
DECLARE
  v_ta TEXT; v_smt TEXT;
  n_arsip INT := 0; n_lulus INT := 0; n_naik INT := 0; n_tmp INT := 0;
BEGIN
  IF COALESCE(TRIM(p_nama), '') = '' THEN RAISE EXCEPTION 'Nama periode wajib diisi'; END IF;
  IF COALESCE(TRIM(p_ta_baru), '') = '' THEN RAISE EXCEPTION 'Tahun ajaran baru wajib diisi'; END IF;
  IF EXISTS (SELECT 1 FROM arsip_nilai WHERE periode = TRIM(p_nama)) THEN
    RAISE EXCEPTION 'Periode "%" sudah ada di arsip. Pakai nama lain.', TRIM(p_nama);
  END IF;
  SELECT tahun_ajaran, semester INTO v_ta, v_smt FROM pengaturan WHERE id = 1;

  INSERT INTO arsip_nilai (periode, tahun_ajaran, semester, siswa_id, nisn, nama, kelas, kategori, jumlah_hafalan,
      penguji_id, penguji_nama, tanggal_ujian, catatan, nilai_kualitas, jumlah_juz, nilai_kuantitas, nilai_akhir,
      baca_lancar, baca_tajwid, baca_adab, hafalan_aktif, detail)
  SELECT TRIM(p_nama), v_ta, v_smt, s.id, s.nisn, s.nama, s.kelas, s.kategori, s.jumlah_hafalan,
      g.id, g.nama, p.tanggal_ujian, p.catatan, p.nilai_kualitas, p.jumlah_juz, p.nilai_kuantitas, p.nilai_akhir,
      p.baca_lancar, p.baca_tajwid, p.baca_adab, p.hafalan_aktif,
      COALESCE((SELECT jsonb_agg(jsonb_build_object(
                  'surah_nama', d.surah_nama, 'kelancaran', d.kelancaran, 'tajwid', d.tajwid,
                  'kekuatan_hafalan', d.kekuatan_hafalan, 'adab_tartil', d.adab_tartil,
                  'total', d.total, 'urutan', d.urutan) ORDER BY d.urutan)
                FROM nilai_detail d WHERE d.penilaian_id = p.id), '[]'::jsonb)
  FROM penilaian p
  JOIN siswa s ON s.id = p.siswa_id
  LEFT JOIN penguji g ON g.id = p.penguji_id;
  GET DIAGNOSTICS n_arsip = ROW_COUNT;

  DELETE FROM nilai_detail WHERE id IS NOT NULL;
  DELETE FROM penilaian WHERE id IS NOT NULL;
  DELETE FROM assignment WHERE id IS NOT NULL;

  IF p_naik_kelas THEN
    -- Urutan penting: luluskan kelas 9 dulu, baru 8→9, lalu 7→8
    UPDATE siswa SET lulus = TRUE, tahun_lulus = v_ta
      WHERE NOT lulus AND substring(kelas FROM '[789]') = '9';
    GET DIAGNOSTICS n_lulus = ROW_COUNT;
    UPDATE siswa SET kelas = regexp_replace(kelas, '8', '9')
      WHERE NOT lulus AND substring(kelas FROM '[789]') = '8';
    GET DIAGNOSTICS n_naik = ROW_COUNT;
    UPDATE siswa SET kelas = regexp_replace(kelas, '7', '8')
      WHERE NOT lulus AND substring(kelas FROM '[789]') = '7';
    GET DIAGNOSTICS n_tmp = ROW_COUNT;
    n_naik := n_naik + n_tmp;
  END IF;

  -- Periode baru: penguji menentukan dan mengunci status lagi
  UPDATE siswa SET status_dikunci = FALSE WHERE status_dikunci;
  UPDATE siswa SET tahun_ajaran = TRIM(p_ta_baru), semester = p_semester_baru WHERE NOT lulus;
  UPDATE pengaturan SET tahun_ajaran = TRIM(p_ta_baru), semester = p_semester_baru, kelas_arsip = '[]' WHERE id = 1;

  RETURN json_build_object('diarsipkan', n_arsip, 'lulus', n_lulus, 'naik_kelas', n_naik);
END $fn$;
GRANT EXECUTE ON FUNCTION tutup_periode(TEXT, BOOLEAN, TEXT, TEXT) TO anon, authenticated;

NOTIFY pgrst, 'reload schema';

select 'Database berhasil di-setup. Login: admin / admin123' as hasil;
