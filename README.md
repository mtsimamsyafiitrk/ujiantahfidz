# 📖 Aplikasi Penilaian Tahfidzul Qur'an

Aplikasi web single-file untuk penilaian ujian Tahfidzul Qur'an siswa MTs Al Imam Asy-Syafi'i Tarakan. Backend menggunakan **Supabase** (PostgreSQL), frontend murni HTML + JavaScript, siap di-deploy ke **GitHub Pages**.

---

## ✨ Fitur

- 🔐 **Login multi-user** — penguji & admin, password ter-hash (SHA-256)
- 👥 **Manajemen siswa** — input manual + import dari Excel
- 📋 **Penugasan** — admin tentukan siapa menguji siapa (per-siswa atau massal per kelas)
- ✍️ **Form penilaian fleksibel** — penguji tambah baris surah sesuai kebutuhan
- 📏 **Bobot otomatis** — Kelancaran 30%, Tajwid 30%, Kekuatan Hafalan 25%, Adab & Tartil 15%
- 📊 **Rekap + Export Excel** — 2 sheet (ringkasan & detail per surah)
- ✏️ **Edit & Hapus penilaian** yang sudah masuk
- 📘 **Pengaturan daftar surah** — 114 surah pre-loaded, bisa diaktifkan/nonaktifkan
- 🔴 **Live progress bar** — jumlah selesai/belum real-time
- 📱 **Mobile-first & responsif** — ringan, cepat, bisa diakses dari HP

---

## 🚀 Panduan Setup (5 Langkah)

### 1️⃣ Buat Project Supabase Gratis

1. Buka https://supabase.com dan daftar/login
2. Klik **"New Project"** → isi nama (misal: `tahfidz-alimam`), pilih region terdekat (Singapore)
3. Tunggu ~2 menit sampai project aktif

### 2️⃣ Jalankan SQL Schema

1. Di dashboard Supabase, buka menu kiri **SQL Editor**
2. Klik **"+ New Query"**
3. Copy seluruh isi file **`supabase-schema.sql`** dan paste di editor
4. Klik tombol **"RUN"** (atau `Ctrl+Enter`)
5. Muncul pesan `Database berhasil di-setup. Login: admin / admin123` — artinya schema berhasil dibuat

### 3️⃣ Ambil Kredensial API

1. Di Supabase, buka **Project Settings** (ikon gear di kiri bawah) → **API**
2. Catat 2 hal:
   - **Project URL** (contoh: `https://abcdefgh.supabase.co`)
   - **anon public key** (panjang, dimulai `eyJ...`)

### 4️⃣ Konfigurasi Aplikasi

Buka file `index.html` pakai text editor. Cari baris berikut (sekitar baris 660-an):

```javascript
const SUPABASE_URL     = 'https://YOUR_PROJECT.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR_ANON_KEY_HERE';
```

Ganti dengan nilai yang kamu catat di langkah 3. Simpan file.

### 5️⃣ Deploy ke GitHub Pages

**Cara cepat — via GitHub Web:**

1. Buat akun/login di https://github.com
2. Klik **"New repository"** → beri nama (misal: `tahfidz-alimam`) → centang **"Public"** → Create
3. Di halaman repo, klik **"uploading an existing file"** → upload `index.html` (SQL schema tidak perlu di-upload)
4. Commit dengan pesan apa saja
5. Masuk ke **Settings** (tab repo) → menu kiri **Pages**
6. Di bagian **Source**, pilih branch **`main`** dan folder **`/ (root)`** → klik **Save**
7. Tunggu ~1 menit, lalu akses `https://USERNAME.github.io/tahfidz-alimam/`

**Selesai!** Aplikasi sudah online 🎉

---

## 🔑 Login Awal

- **Username:** `admin`
- **Password:** `admin123`

⚠️ **WAJIB diganti setelah login pertama!** (Profil → Ganti Password)

---

## 📝 Alur Penggunaan

### Untuk Admin:

1. **Login** pakai akun admin default
2. **Ganti password** (Profil → Ganti Password)
3. **Edit data lembaga** (Admin → Lembaga) — nama, alamat, tahun ajaran
4. **Tambah penguji** (Admin → Penguji) — buat akun untuk masing-masing guru/asatidz
5. **Input data siswa** (Admin → Siswa) — manual atau import Excel
   - Download template Excel untuk format yang benar
6. **Buat penugasan** (Admin → Assignment):
   - **Satuan**: pilih siswa + penguji 1-per-1
   - **Massal**: pilih kelas → semua siswa di kelas ditugaskan ke 1 penguji sekaligus
7. **Aktifkan surah** yang diujikan (Admin → Surah) — opsional, default semua aktif

### Untuk Penguji:

1. **Login** pakai akun yang dibuat admin
2. Di **Beranda** lihat jumlah siswa yang harus dinilai
3. Buka menu **Nilai** → klik siswa yang mau diuji
4. Isi tanggal ujian, catatan, dan **tambah baris surah** untuk tiap surah yang diuji
5. Isi nilai per aspek (0–100), total per surah dihitung otomatis
6. Simpan → status otomatis jadi "Selesai"
7. **Edit** kapan saja kalau ada koreksi

### Rekap & Export:

- **Semua role** bisa buka menu **Rekap** untuk lihat ringkasan nilai
- Filter per kelas atau per penguji
- Export ke Excel (2 sheet: Rekap + Detail Surah)

---

## 📏 Sistem Penilaian

Nilai akhir siswa terdiri dari **2 komponen**:

### 🔵 KUALITAS (Bobot 70%)

Rata-rata nilai dari semua surah yang diujikan. Per surah dihitung dari 4 aspek:

| Aspek | Bobot |
|-------|-------|
| Kelancaran | 30% |
| Tajwid | 30% |
| Kekuatan Hafalan | 25% |
| Adab & Tartil | 15% |

### 🟡 KUANTITAS (Bobot 30%)

Dihitung dari jumlah juz yang dihafal siswa, dibandingkan dengan target minimal per kelas:

| Kelas | Target Minimal |
|-------|---------------|
| Kelas 7 | 2 juz |
| Kelas 8 | 4 juz |
| Kelas 9 | 6 juz |

**Rumus**: `Kuantitas = (Jumlah Juz ÷ Target Juz) × 100` (maksimal 100)

- Kelas 7 hafal 2 juz → 100 ✓
- Kelas 8 hafal 2 juz → 50
- Kelas 9 hafal 8 juz → 100 (dibatasi maksimal)

### 🏆 NILAI AKHIR

```
Nilai Akhir = (Kualitas × 70%) + (Kuantitas × 30%)
```

**Contoh**: Siswa kelas 8, nilai Kualitas 85, hafal 4 juz
- Kuantitas = (4/4) × 100 = 100
- Nilai Akhir = (85 × 0.70) + (100 × 0.30) = 59.5 + 30 = **89.5** (Jayyid Jiddan)

### Predikat

- ≥ 90: Mumtaz (Cemerlang)
- ≥ 80: Jayyid Jiddan (Baik Sekali)
- ≥ 70: Jayyid (Baik)
- ≥ 60: Maqbul (Cukup)
- < 60: Rasib (Kurang)

---

## 🗂️ Struktur File

```
tahfidz-app/
├── index.html              ← aplikasi (frontend + JS)
├── supabase-schema.sql     ← database schema (jalankan sekali di Supabase)
├── migrasi-kuantitas.sql   ← untuk upgrade DB yang sudah ada (jalankan sekali)
└── README.md               ← panduan ini
```

Hanya **`index.html`** yang perlu di-upload ke GitHub Pages.

### ⚠️ Kalau Database Sudah Pernah Di-setup Sebelumnya

Jika Anda sudah pernah jalankan `supabase-schema.sql` versi lama (yang belum ada sistem kuantitas), Anda **tidak perlu setup ulang**. Cukup jalankan file **`migrasi-kuantitas.sql`** sekali di SQL Editor Supabase. File ini akan menambahkan kolom baru (`nilai_kualitas`, `jumlah_juz`, `nilai_kuantitas`) tanpa menghapus data yang sudah ada.

---

## 🛠️ Catatan Teknis

- **Backend**: Supabase (PostgreSQL + REST API)
- **Autentikasi**: Di sisi aplikasi (RLS disabled); cukup untuk skala madrasah internal
- **Password**: Di-hash dengan SHA-256 via `crypto.subtle` (butuh HTTPS atau localhost)
- **Real-time data**: Semua data dari Supabase, tidak ada data penting di localStorage (hanya session login)
- **Libraries** (via CDN, tidak perlu install):
  - `@supabase/supabase-js@2` — client Supabase
  - `xlsx@0.18.5` (SheetJS) — export/import Excel
  - Google Fonts: Amiri, Plus Jakarta Sans, Noto Serif, Material Symbols

---

## ❓ Troubleshooting

**Halaman login menunjukkan banner "Setup Diperlukan"**
→ Kredensial Supabase belum diisi di `index.html`. Cek langkah 4.

**"Username tidak ditemukan" saat login pertama**
→ SQL schema belum dijalankan. Cek langkah 2 di Supabase SQL Editor.

**Import Excel gagal "Kolom nama & kelas tidak ditemukan"**
→ Pastikan nama kolom di Excel: `nama`, `nisn`, `kelas`, `semester`, `jenis_kelamin`, `tahun_ajaran` (huruf kecil, tanpa spasi). Download template untuk contoh yang benar.

**Nilai tidak tersimpan / error "duplicate key"**
→ Satu siswa hanya bisa dinilai 1x oleh penguji yang sama. Jika ingin menilai ulang, gunakan fitur Edit.

---

## 📜 Lisensi

Bebas digunakan untuk kebutuhan pendidikan dan internal madrasah.

Barakallahu fiikum, semoga bermanfaat. 🤲
