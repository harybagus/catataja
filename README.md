# CatatAja

**CatatAja** adalah aplikasi pencatatan mobile yang dikembangkan menggunakan Flutter dan API berbasis Laravel. Aplikasi ini memungkinkan pengguna untuk melakukan berbagai fungsi terkait pencatatan, termasuk pembaruan profil, perubahan tema, serta pengelolaan catatan (CRUD), pencarian catatan, dan fitur pin catatan untuk menyimpan catatan penting.

Dengan CatatAja, Anda bisa membuat dan mengatur catatan secara efisien, serta menyesuaikan tampilan aplikasi sesuai preferensi dengan tema light dan dark mode.

## Kelompok 2

Nama anggota kelompok:

- Muhammad Fahreza (10220053)
- Bagus Hary (10220037)
- Galeh Pamungkas (10220077)
- Sirajuddin Ahmad Kurniawan (10220079)
- Thomas Febry Cahyono (10220063)

## Teknologi yang Digunakan

Berikut teknologi yang kami gunakan untuk membuat aplikasi pencatatan ini:

- Dart
- Flutter
- CatatAja RESTful API

## Fitur

- **User Management**:

  - Registrasi Pengguna
  - Login Pengguna
  - Memperbarui Data Pengguna
  - Logout Pengguna

- **Note Management**:

  - Menambahkan Catatan
  - Menampilkan Seluruh Catatan
  - Mencari Catatan
  - Memperbarui Catatan
  - Pin Catatan
  - Menghapus Catatan

- **Theme Management**:
  - Ubah Tema (Light Mode dan Dark Mode)

## Instalasi

### Prasyarat

Pastikan Anda telah menginstal perangkat lunak berikut:

- [Flutter](https://flutter.dev/docs/get-started/install) - Untuk mengembangkan aplikasi mobile.
- [VS Code](https://code.visualstudio.com/) - Kode editor untuk Flutter.
- [Android Studio](https://developer.android.com/studio) - Untuk mengatur emulator Android.

### Langkah-langkah Instalasi

1. Clone repository ini.
2. Download source code API. Aplikasi ini memerlukan API untuk berfungsi. Anda bisa mengunduh source code-nya di [CatatAja RESTful API](https://github.com/harybagus/catataja-restful-api-2-10.5A.01).
3. Instal semua dependensi yang diperlukan dengan menjalankan perintah `flutter pub get`.
4. Menyetting emulator android. Jika Anda belum mengatur emulator Android, ikuti langkah-langkah berikut:
   - Buka Android Studio.
   - Pilih Tools > AVD Manager untuk membuat atau memilih emulator.
   - Pilih perangkat emulator dan klik Start.
5. Menjalankan CatatAja RESTful API.
   - Untuk menjalankan API, ikuti instruksi di repository API yang telah diunduh.
6. Menjalankan Aplikasi dengan VS Code.
   - Pastikan emulator Android sudah berjalan.
   - Kembali ke VS Code, tekan F5 atau pilih Run > Start Debugging untuk menjalankan aplikasi di emulator.
