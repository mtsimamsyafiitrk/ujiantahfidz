# Raport Tahfidz PDF per Kelas Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans. Steps use checkbox (`- [ ]`) syntax.

**Goal:** Tombol "Export Raport PDF" di layar Rekap yang mengunduh satu PDF per kelas, satu halaman A4 per santri, sesuai desain B.

**Architecture:** Semua di `index.html` (aplikasi single-file). Satu fungsi murni `susunRaport(p)` mengubah satu baris penilaian (bentuk `fetchAllPenilaianLengkap`) menjadi data raport; `exportRaportPDF()` menggambar data itu dengan jsPDF + autotable yang sudah dimuat.

**Tech Stack:** HTML/JS murni, Supabase, jsPDF 2.5.1 + jspdf-autotable 3.8.2 (sudah ada).

**Spec:** `docs/superpowers/specs/2026-11-23-raport-tahfidz-design.md`

## Global Constraints
- Nilai akhir, kualitas, juz, kuantitas diambil dari kolom tersimpan di `penilaian` (sama dengan yang tampil di Rekap); predikat dari `predikat()`.
- Kolom baru `pengaturan.kepala_madrasah`, `pengaturan.ketua_tahfidz` (TEXT). Aplikasi **tidak** diblokir bila kolom belum ada (ujian sedang berjalan): raport mencetak garis kosong, form Pengaturan menampilkan SQL yang perlu dijalankan.
- Tombol hanya untuk admin & ketua_tahfidz, hanya periode berjalan, hanya saat satu kelas dipilih.
- Nama file: `Raport_Tahfidz_<kelas>_<semester>_<tahun ajaran dengan / → ->.pdf`.

## Review Focus
- Surah tanpa data juz (nama tidak ada di `SURAH_JUZ`) → dikelompokkan sebagai juz "-", tidak hilang.
- Baris surah yang belum lengkap 4 aspeknya → tidak ikut rata-rata.
- Santri Iqra' tanpa hafalan aktif → tidak ada tabel juz, rekap: Membaca × 76%.
- Catatan penguji panjang → dibungkus, tidak menabrak tanda tangan.
- Logo gagal dimuat (offline) → PDF tetap jadi tanpa logo.

---

### Task 1: `susunRaport(p)` + uji

**Interfaces — Produces:**
`susunRaport(p) -> { iqra:boolean, juzRows:[{juz, surah, n, kelancaran, tajwid, hafalan, adab, nilai}], rata:{kelancaran,tajwid,hafalan,adab}|null, kualitas, juz, kuantitas, target, membaca|null, hafalanAktif, akhir, predikat }`

- [ ] Uji (Playwright, buka `index.html`, panggil di halaman): data contoh 3 surah juz 30 + 1 surah juz 29 + 1 baris tidak lengkap + 1 surah tak dikenal → 3 grup (30, 29, "-"); grup 30 `n === 3`, `surah === "An-Naba' – 'Abasa"`; nilai grup = rata-rata `hitungTotal`. Iqra' tanpa hafalan → `juzRows.length === 0`, `membaca` = rata-rata 3 nilai baca.
- [ ] Implementasi di dekat `predikat()`; grup diurutkan menurut `urutan` surah pertama.
- [ ] Uji lulus.

### Task 2: Pengaturan — nama penandatangan
- [ ] `SQL_MIGRASI` + `supabase-schema.sql`: `ALTER TABLE pengaturan ADD COLUMN IF NOT EXISTS kepala_madrasah TEXT, ADD COLUMN IF NOT EXISTS ketua_tahfidz TEXT;` (tidak ditambahkan ke `cekPerluMigrasi`).
- [ ] Form Data Lembaga: input `lbKepala`, `lbKetua`; petunjuk "satu baris per baris kop" di Alamat. `saveLembaga()` menyimpan keduanya hanya bila kolom ada (`'kepala_madrasah' in STATE.lembaga`), selain itu tampilkan SQL di form.

### Task 3: `exportRaportPDF()` + tombol
- [ ] Tombol di header Rekap, tampil bila `canSeeAll && !dariArsip && STATE.filter.kelas !== 'all'`.
- [ ] Ambil semua penilaian kelas dari `REKAP.data` (bukan hasil pencarian/penguji filter), urut nama; daftar santri kelas `siswa.eq('kelas',k).eq('lulus',false)` untuk pesan "belum dinilai".
- [ ] Gambar per halaman: kop (logo 18 mm kiri/kanan, nama lembaga, baris alamat, garis ganda), judul, identitas, tabel juz / tabel membaca, rekap + predikat, catatan, tanda tangan 3 kolom (baris tanggal ujian di atas kolom kanan).
- [ ] Uji Playwright: panggil fungsi gambar dengan data contoh, simpan PDF, render halaman 1 ke PNG, periksa visual.
- [ ] Commit, push, PR, merge (CLAUDE.md).
