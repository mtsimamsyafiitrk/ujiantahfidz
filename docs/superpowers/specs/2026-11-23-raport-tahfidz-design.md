# Raport Tahfidz PDF per Kelas — Desain

## Tujuan
Dokumen arsip sekolah, dilampirkan ke laporan hasil belajar santri pada semester terkait.
Satu halaman A4 tegak per santri, diekspor sekaligus satu kelas menjadi satu file PDF.

## Bukan tujuan
- Sertifikat/penghargaan untuk santri (pilihan C ditolak).
- Rincian nilai per surah di PDF (tetap ada di aplikasi & export Excel).
- Cetak raport dari periode arsip (hanya periode aktif).

## Pendekatan
1. **jsPDF + autotable (dipilih)** — sudah dipakai di aplikasi, file langsung terunduh, sama di laptop & HP. Tata letak digambar lewat kode, jadi mirip contoh, tidak identik piksel.
2. Halaman cetak + "Save as PDF" browser — tampilan persis, tapi pengguna harus memilih simpan PDF tiap kali, margin beda per browser, kurang andal di HP.
3. html2canvas — dibuang: dependensi baru, teks jadi gambar buram.

## Tata letak (contoh: https://claude.ai/artifact/J8Nx5tjjcKmgidy51wsBXM)
1. **Kop**: logo Ponpes (kiri, `logo-ponpes.webp`) dan logo MTs utuh (kanan, `logo-mts.webp`), nama lembaga, lalu tiap baris kolom Alamat di Pengaturan, garis ganda.
   Isi Alamat: `Jl. Swaran Jaya, RT. 015 Juata Permai, Kota Tarakan 77116` / `Email: mtsimamsyafiitrk@gmail.com · Akreditasi: C`.
2. **Judul**: LAPORAN HASIL UJIAN TAHFIDZUL QUR'AN, Semester … Tahun Ajaran ….
3. **Identitas** (2 kolom): Nama, NISN, Status, Kelas, Tanggal Ujian, Target Kelas.
4. **Tabel per juz**: Juz | Surah yang diujikan (surah pertama – terakhir, jumlah) | Kelancaran | Tajwid | Kekuatan Hafalan | Adab & Tartil | Nilai (rata-rata surah di juz itu). Baris akhir: rata-rata aspek dan Nilai Kualitas.
5. **Rekapitulasi**: Kualitas × 70%, Kuantitas (juz tersetor ÷ target) × 30%, Nilai Akhir; kotak Predikat (Mumtaz/Jayyid Jiddan/Jayyid/Maqbul/Rasib) dengan keterangan batas.
6. **Catatan Penguji**.
7. **Tanda tangan**: baris "Tarakan, <tanggal ujian>" di atas kolom kanan; di bawahnya tiga jabatan sejajar — Penguji (nama penguji santri), Ketua Tahfidz, Kepala Madrasah.

## Keputusan yang saya ambil (silakan koreksi)
- Nama Kepala Madrasah (Harmin, S.Pd.) dan Ketua Tahfidz (Muhammad Syarif, S.Pd.) disimpan di Pengaturan → Data Lembaga (dua kolom baru di tabel `pengaturan`), supaya bisa diganti tanpa ubah kode.
- Tanggal di tanda tangan = tanggal ujian, supaya tetap sama kalau diekspor ulang.
- Surah yang melintasi beberapa juz (mis. Al-Baqarah) masuk ke juz awalnya.
- Santri Iqra': kop, identitas, rekap, catatan, dan tanda tangan sama; tabel diganti nilai Membaca (Lancar, Tajwid, Adab → rata-rata × 76%). Jika hafalan diaktifkan, tabel per juz ikut tampil dan nilai hafalan × 24%.
- Santri di kelas yang belum dinilai tidak dicetak; setelah ekspor muncul pesan berisi jumlah/nama mereka.
- Tombol "Export Raport PDF" di layar Rekap, aktif saat filter satu kelas dipilih. Nama file: `Raport_Tahfidz_<kelas>_<semester>_<tahun ajaran>.pdf`.
- Nilai dan predikat memakai fungsi yang sudah ada (`hitungPenilaian`, `predikat`), tidak ada rumus baru.

## Yang diserahkan ke pembuat
Ukuran huruf, jarak, ketebalan garis — mengikuti contoh sedekat mungkin di jsPDF.
