# SoftberyStore Admin Dashboard V1

Dashboard ini memakai seluruh fitur versi final CANDRA, tetapi sudah dipisahkan untuk bot DINDA dengan brand, logo, PWA, folder Cloudinary, dan project Supabase baru milik SoftberyStore.

## Fitur utama

- Overview profesional dengan filter Hari Ini, Kemarin, 7/30/60/90 hari, Bulan Ini, Tahun Ini, dan rentang tanggal.
- Customer CRM realtime, score, poin reward, saldo diskon, dan pengelolaan poin oleh admin.
- Toggle Score dan Poin di halaman Settings.
- Transaksi Pending/Berhasil/Gagal yang tersinkron dua arah dengan bot WhatsApp.
- Produk berdasarkan layanan, kategori, durasi/varian, profit otomatis, urutan bebas, tampilan list/grid, dan layout mobile.
- Monitoring heartbeat bot.
- Pusat pembersihan database khusus OWNER di Settings.
- Sidebar mobile, instalasi PWA, notifikasi realtime, preset suara, volume, serta impor audio sendiri.

## 1. Siapkan Supabase baru

1. Buka Supabase > SQL Editor.
2. Jalankan file berikut secara berurutan:
   - `supabase/schema.sql`
   - `supabase/dashboard-v5-upgrade.sql`
   - `supabase/CRITICAL-FIX-STATUS-DELETE.sql`
   - `supabase/overview-maintenance-and-profit.sql`
3. Buka Authentication > Users dan buat akun admin.
4. Edit email pada `supabase/CREATE-FIRST-OWNER.sql`, lalu jalankan file itu di SQL Editor.
5. Pastikan akun tersebut tercatat sebagai `OWNER` pada tabel `user_roles`.

File hotfix lain disertakan untuk pemulihan project lama dan tidak perlu dijalankan pada instalasi baru apabila empat file utama di atas berhasil.

## 2. Isi Environment Variables Vercel

Salin seluruh nama variabel dari `.env.example` ke Vercel > Project Settings > Environment Variables:

- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `CLOUDINARY_CLOUD_NAME`
- `CLOUDINARY_API_KEY`
- `CLOUDINARY_API_SECRET`
- `CLOUDINARY_PRODUCT_FOLDER=softberystore/products`

Jangan memakai Service Role Key pada dashboard/Vercel. Service Role Key hanya digunakan bot di Pterodactyl.

## 3. Deploy ke Vercel

Upload folder dashboard ini ke repository baru lalu Import Project di Vercel. Framework terdeteksi sebagai Next.js. Build command tetap `npm run build`.

Untuk pengujian lokal:

```bash
npm install
npm run dev
```

## 4. Migrasikan data DINDA

Setelah SQL dan `.env` bot selesai, jalankan `npm run migrate` satu kali dari Console Pterodactyl. Proses ini memasukkan katalog, gambar produk, 99 transaksi sukses, dan 17 transaksi dibatalkan ke Supabase SoftberyStore secara idempotent.

## 5. Pasang sebagai aplikasi di HP

Buka dashboard melalui Chrome/Edge di HP, login, lalu pilih **Tambahkan ke layar utama / Install app**. Jika sebelumnya pernah memasang versi CANDRA, hapus shortcut lama dahulu agar logo SoftberyStore yang baru tidak tertahan cache.

## Uji akhir

1. Login sebagai OWNER.
2. Pastikan Monitoring menampilkan SoftberyStore Bot online setelah bot dijalankan.
3. Tambah satu varian produk, lalu cek menu bot dengan `.synccatalog`.
4. Buat transaksi uji dari WhatsApp dan ubah status dari dashboard.
5. Uji balasan `y` pada notifikasi owner dan pastikan hanya satu konfirmasi yang dikirim.

