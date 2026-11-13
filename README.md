# 📖 Aplikasi Penilaian Tahfidzul Qur'an

Aplikasi web single-file untuk penilaian ujian Tahfidzul Qur'an siswa MTs Al Imam Asy-Syafi'i Tarakan. Backend menggunakan **Supabase** (PostgreSQL), frontend murni HTML + JavaScript, siap di-deploy ke **GitHub Pages**.

---

## ✨ Fitur

- Login penguji & admin
- Daftar santri per penguji dengan progres dan pencarian
- Status santri (Iqra' / Al-Qur'an) ditentukan dan dikunci penguji; cara penilaian mengikuti status
- Isi nilai lewat pencarian surah, dengan tombol salin nilai surah sebelumnya
- Penugasan santri ke penguji: bagi otomatis, per kelas, satuan, atau import Excel
- Rekap nilai + Export Excel (ringkasan & detail per surah)
- Import/export data santri dari Excel
- Bisa di-install ke HP (PWA)

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

**Ada 2 cara mengatur kredensial Supabase:**

#### Cara A: Input di Browser (Direkomendasikan — tanpa edit file)

1. Upload `index.html` apa adanya (tidak perlu edit)
2. Buka aplikasi di browser
3. Akan muncul form **"Setup Kredensial Supabase"**
4. Isi **Project URL** dan **Anon Key** dari langkah 3
5. Klik **Simpan & Lanjutkan** — kredensial disimpan permanen di browser
6. Setiap device/browser hanya perlu setup ini sekali

**Kelebihan:**
- ✅ Tidak perlu edit file setiap ada update/deploy
- ✅ Kredensial tidak ter-commit ke GitHub (lebih aman)
- ✅ Bisa ganti kredensial kapan saja tanpa push ulang

**Kekurangan:**
- ⚠️ Setiap browser/device harus setup sekali
- ⚠️ Kalau hapus data browser (clear cache/cookies), perlu setup ulang

#### Cara B: Hardcode di File (untuk Semua Device Sekaligus)

Buka `index.html` dengan text editor. Cari baris:

```javascript
const DEFAULT_URL = '';  // contoh: 'https://xxxxx.supabase.co'
const DEFAULT_KEY = '';  // contoh: 'eyJhbGciOi...'
```

Isi dengan kredensial Anda, simpan, lalu upload ke GitHub.

**Kelebihan:**
- ✅ Semua user langsung bisa pakai (tidak perlu setup masing-masing)

**Kekurangan:**
- ⚠️ Kalau repo GitHub public, anon key Anda ikut public (walaupun anon key Supabase secara desain memang aman untuk publik asalkan RLS dikonfigurasi dengan benar)
- ⚠️ Harus push ulang setiap ganti kredensial

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

### Admin

Menu bawah: **Beranda · Santri · Penugasan · Rekap**. Pengaturan dibuka dari tombol nama di kanan atas.

1. **Pengaturan → Lembaga**: nama, alamat, tahun ajaran, semester.
2. **Pengaturan → Akun penguji**: buat akun untuk tiap penguji.
3. **Santri**: tambah satu per satu atau **Import Excel** (kolom `nama`, `nisn`, `kelas`, `jenis_kelamin`; template ada di menu ⋯).
4. **Penugasan**: tekan **Bagi otomatis** untuk membagi santri ke penguji. Pilihan lain (satu santri, satu kelas, import Excel, cetak PDF) ada di menu ⋯. Daftar dikelompokkan per penguji.
5. **Rekap**: lihat nilai, buka rincian, **Export Excel**.

### Penguji

Menu bawah: **Santri · Rekap**.

1. Setelah login langsung tampil **daftar santri** yang ditugaskan, dengan tab *Belum dinilai* / *Selesai*.
2. Ketuk santri → pilih **status**: **Iqra'** atau **Al-Qur'an**. Aplikasi meminta konfirmasi lalu **mengunci** status itu supaya tidak terganti tanpa sengaja. Penguji bisa membuka kuncinya sendiri bila keliru.
3. Untuk santri Al-Qur'an, isi **jumlah hafalan selama ini** (keterangan saja, tidak mengubah nilai), lalu **Mulai menilai**.
4. **Santri Al-Qur'an**: ketik nama/nomor surah di kolom pencarian → ketuk hasilnya → isi 4 nilai (Lancar, Tajwid, Hafalan, Adab). Tombol **Salin nilai surah sebelumnya** muncul di surah yang baru dipilih. Surah tersusun otomatis menurut urutan; pencarian tidak menampilkan surah yang sudah dipilih.
5. **Santri Iqra'**: isi 3 nilai membaca (Lancar, Tajwid, Adab). Bila santri punya hafalan yang layak dinilai, nyalakan **Munculkan nilai hafalan** lalu nilai surahnya seperti santri Al-Qur'an.
6. **Simpan penilaian**. Nilai bisa dibuka dan diubah lagi dari tab *Selesai*.

### Transfer santri antar penguji

1. Penguji A membuka **Transfer santri ke penguji lain** di atas daftar santrinya, memilih penguji tujuan dan satu atau beberapa santri, lalu mengirim permintaan (boleh dengan catatan).
2. Penguji B melihat kartu permintaan di atas daftar santrinya (berisi siapa yang meminta, santri mana, dan catatannya) dengan tombol **Setuju** dan **Tolak**. Aplikasi memeriksa permintaan baru tiap 30 detik selama halaman itu terbuka.
3. Bila disetujui, santri pindah ke daftar penguji B **beserta nilai yang sudah diisi**. Bila ditolak, santri tetap di penguji A. Penguji A bisa membatalkan permintaan selama belum dijawab.
4. Admin tidak perlu menyetujui. Riwayat semua transfer ada di bagian bawah halaman **Penugasan**.

---

## 📏 Sistem Penilaian

### Santri Al-Qur'an

```
Nilai Akhir = (Kualitas × 70%) + (Kuantitas × 30%)
```

- **Kualitas**: rata-rata nilai semua surah yang diuji. Nilai satu surah = Kelancaran 30% + Tajwid 30% + Kekuatan Hafalan 25% + Adab & Tartil 15%.
- **Kuantitas**: `(juz tersetor ÷ target kelas) × 100`, maksimal 100. Sebuah surah dihitung tersetor bila nilainya ≥ 65. Juz dihitung dari jumlah ayat surah yang tersetor.

| Kelas | Target |
|-------|--------|
| 7 | 2 juz |
| 8 | 4 juz |
| 9 | 6 juz |

### Santri Iqra'

Santri Iqra' tidak wajib menghafal, jadi nilai tertingginya 76.

```
Nilai Akhir = (Nilai Membaca × 76%) + (Nilai Hafalan × 24%)
```

- **Nilai Membaca**: rata-rata Lancar, Tajwid, Adab.
- **Nilai Hafalan**: hanya dihitung bila penguji menyalakan *Munculkan nilai hafalan*. Hafalannya dinilai dengan sistem Al-Qur'an di atas (kualitas 70% + kuantitas 30%, target sesuai kelas). Bila tidak dinyalakan, bagian ini nol.

### Predikat

- ≥ 90: Mumtaz
- ≥ 80: Jayyid Jiddan
- ≥ 70: Jayyid
- ≥ 60: Maqbul
- < 60: Rasib

---

## 🗂️ Struktur File

```
tahfidz-app/
├── index.html                       ← aplikasi (frontend + JS)
├── manifest.json                    ← konfigurasi PWA
├── sw.js                            ← service worker PWA
├── icon-192.png                     ← ikon 192×192
├── icon-512.png                     ← ikon 512×512
├── supabase-schema.sql              ← database schema (hanya untuk proyek Supabase BARU)
└── README.md                        ← panduan ini
```

**Untuk deploy**, upload ke GitHub Pages:
- `index.html` (wajib)
- `manifest.json`, `sw.js`, `icon-192.png`, `icon-512.png` (wajib untuk PWA)
- `supabase-schema.sql` tidak dipakai oleh aplikasi; cukup dijalankan sekali di Supabase SQL Editor saat membuat proyek baru

---

## 🔄 Pergantian Periode Ujian / Tahun Ajaran

Nilai lama **tidak dihapus**: disalin ke arsip dan tetap bisa dilihat serta di-export dari menu Rekap.

1. **Cek proyek Supabase** di https://supabase.com/dashboard. Proyek gratis otomatis di-*pause* kalau lama tidak dipakai; klik **Restore** bila statusnya *Paused*.
2. Bila aplikasi menampilkan **"Database perlu diperbarui"**: login sebagai admin, salin SQL yang ditampilkan, jalankan di Supabase → SQL Editor, lalu tekan *Periksa lagi*.
3. **Pengaturan → Tahun ajaran → Arsipkan nilai & mulai periode baru**: beri nama arsip untuk nilai yang sekarang (mis. `2025/2026 Genap`), lalu isi tahun ajaran dan semester baru. Semua nilai disalin ke arsip, lalu nilai dan penugasan dikosongkan. Prosesnya satu kesatuan: kalau gagal di tengah, tidak ada yang berubah. Kelas santri tidak diubah oleh langkah ini.
3a. Bila berganti tahun ajaran: **Pengaturan → Tahun ajaran → Atur naik kelas / lulus** (juga ada di menu ⋯ halaman Santri). Semua santri tercentang di awal; hilangkan centang pada santri yang tinggal kelas atau belum lulus. Yang dicentang di kelas 7 dan 8 naik ke kelas tujuan (bisa diubah per rombel), yang dicentang di kelas 9 menjadi *lulus*. Lakukan sekali saja setelah nilai diarsipkan.
4. **Santri → Import Excel** dengan daftar santri terbaru. Santri yang NISN-nya sudah ada **diperbarui** (nama, kelas) dan tidak digandakan; yang belum ada ditambahkan. Aplikasi menampilkan santri aktif yang tidak ada di file; bila mereka sudah pindah, buka datanya dan centang *Tidak aktif lagi*.
5. **Pengaturan → Akun penguji**: periksa akun, lalu buat **Penugasan** baru.
6. Coba login sebagai salah satu penguji dan simpan satu nilai percobaan, kemudian hapus lagi.

**Melihat nilai lama:** menu **Rekap** → pilih periode di baris paling atas. Nilai arsip hanya bisa dibaca dan di-export, tidak bisa diubah.

**Santri lulus / tidak aktif** tetap tersimpan dan bisa dilihat di menu Santri → tab *Lulus / tidak aktif*.

## 📱 Install ke HP (PWA)

Aplikasi ini adalah **Progressive Web App** — bisa di-install ke HP layaknya aplikasi native, dengan ikon di homescreen dan jalan full-screen.

**Cara install:**

- **Chrome Android / Edge Android**: Otomatis muncul banner "Install" di bawah, atau tap menu 3 titik → "Add to Home screen"
- **Safari iPhone/iPad**: Tap tombol Share (kotak ⬆️) → "Add to Home Screen" → "Add"
- **Chrome Desktop**: Klik ikon install (⊕) di address bar, atau menu 3 titik → "Install Tahfidz..."

Di dalam aplikasi, buka **Profil → Install Aplikasi → Cara Install** untuk instruksi per device.

Setelah diinstall, aplikasi bisa dibuka dari homescreen tanpa browser, dan **tetap jalan walau koneksi internet putus sejenak** (untuk data yang sudah ter-cache).

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
