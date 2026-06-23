# Hand Tracking - Menulis Angka dengan Jari Telunjuk

Proyek interaktif berbasis kamera yang mendeteksi tangan menggunakan **MediaPipe**, kemudian mengirim data koordinat ujung jari telunjuk ke **Processing** melalui protokol **OSC** untuk membimbing pengguna mengikuti titik-titik membentuk pola angka, mirip pembelajaran menulis angka untuk anak TK.

## Demo Konsep

Pengguna mengarahkan ujung jari telunjuk ke kamera, lalu mengikuti titik-titik bernomor secara berurutan dari **START** hingga **FINISH** untuk membentuk pola angka.

---

## Teknologi yang Digunakan

| Komponen      | Fungsi                                                          |
|---------------|-------------------------------------------------------------------|
| Processing    | Menggambar visual titik-titik angka dan animasi progres           |
| Python        | Membaca kamera dan menjalankan deteksi tangan                     |
| MediaPipe     | Mendeteksi 21 titik landmark tangan secara real-time               |
| OpenCV        | Mengakses kamera dan menampilkan preview                          |
| python-osc    | Mengirim data koordinat dari Python ke Processing                 |
| oscP5         | Menerima data OSC di sisi Processing                              |

---

## Struktur Folder

```
Hand_Tracking_Number/
├── No7/
│   ├── No7.pde              # Sketch Processing untuk angka 7
│   ├── hand_sender.py       # Script Python pengirim data tangan
│   └── hand_landmarker.task # Model MediaPipe untuk deteksi tangan
├── Bahan/
│   ├── Sketsa_Hand_full.pde
│   ├── hand_full.py
│   └── hand_landmarker.task
└── README.md
```

---

## Persyaratan Sistem

- **Python** versi 3.10, 3.11, atau 3.12
  > ⚠️ MediaPipe **belum mendukung** Python 3.13 ke atas. Cek versi dengan `python --version`
- **Processing** versi 4.x — [download di sini](https://processing.org/download)
- Webcam aktif
- Koneksi internet (hanya untuk instalasi awal)

---

## Instalasi

### 1. Install Library Python

Buka **Command Prompt**, jalankan satu per satu:

```bash
pip install mediapipe
pip install opencv-python
pip install python-osc
```

### 2. Install Library Processing

1. Buka aplikasi **Processing**
2. Klik **Sketch → Import Library → Add Library**
3. Cari `oscP5`, klik **Install**
4. Restart Processing setelah instalasi selesai

### 3. Download Model MediaPipe

File `hand_landmarker.task` sudah disediakan di masing-masing folder proyek. Jika file tidak terbaca atau hilang, download ulang di:

```
https://storage.googleapis.com/mediapipe-models/hand_landmarker/hand_landmarker/float16/1/hand_landmarker.task
```

Pastikan file `hand_landmarker.task` berada **di folder yang sama** dengan `hand_sender.py`.

---

## Cara Menjalankan

> ⚠️ **Urutan menjalankan program sangat penting** — Processing harus dijalankan **lebih dulu** sebelum Python.

### Langkah 1 — Jalankan Sketch Processing

1. Buka file `No7.pde` di aplikasi Processing
2. Klik tombol **Run** (▶) atau tekan `Ctrl + R`
3. Jendela Processing akan terbuka menampilkan titik-titik angka 7

### Langkah 2 — Jalankan Script Python

1. Buka folder proyek di File Explorer (folder `No7`)
2. Klik **address bar**, ketik `cmd`, lalu tekan **Enter**
3. Jalankan:

```bash
python hand_sender.py
```

4. Jendela kamera akan terbuka menampilkan preview dengan titik kuning di ujung telunjuk

### Langkah 3 — Mainkan

1. Arahkan **ujung jari telunjuk** ke layar Processing
2. Sentuh lingkaran **hijau (START)** terlebih dahulu
3. Lanjutkan menyentuh lingkaran secara **berurutan** sesuai nomor
4. Lingkaran **kuning berkedip** menandakan target yang harus disentuh sekarang
5. Setelah mencapai lingkaran **merah (FINISH)**, layar akan berubah hijau menandakan selesai
6. Tekan tombol **R** pada keyboard untuk mengulang dari awal

### Menghentikan Program

- Untuk menutup kamera Python: klik jendela kamera, tekan **Q**
- Untuk menutup Processing: tutup jendela sketch seperti biasa

---

## Troubleshooting

| Masalah                                              | Solusi                                                                 |
|-------------------------------------------------------|-------------------------------------------------------------------------|
| `AttributeError: module 'mediapipe' has no attribute 'solutions'` | Versi MediaPipe baru tidak pakai `mp.solutions`. Gunakan kode dengan API `HandLandmarker` seperti pada script ini |
| `No matching distribution found for mediapipe`        | Python yang digunakan terlalu baru (3.13+). Install Python 3.11 secara terpisah |
| Kamera tidak terbuka                                  | Ganti `cv2.VideoCapture(0)` menjadi `cv2.VideoCapture(1)` di `hand_sender.py` |
| Processing tidak menerima data tangan                 | Pastikan Processing dijalankan **sebelum** Python, dan port `12000` tidak diblokir firewall |
| Library `oscP5` tidak ditemukan                       | Install ulang lewat Library Manager, lalu restart Processing            |
| Titik tidak terdeteksi walau telunjuk sudah di posisi yang tepat | Pastikan pencahayaan ruangan cukup terang dan tangan tidak terhalang |

---

## Catatan Tambahan

- Program ini menggunakan **localhost (127.0.0.1)** pada **port 12000** untuk komunikasi OSC antara Python dan Processing. Pastikan port tersebut tidak sedang digunakan program lain.
- Koordinat tangan dikirim dalam skala **0.0 – 1.0** (relatif), kemudian dikonversi ke ukuran layar Processing (`width` dan `height`).
- Untuk mengembangkan ke angka lain (0–9), cukup ubah array koordinat `dots[][]` di file `.pde` sesuai pola angka yang diinginkan.

---

## Pengembangan Selanjutnya

- [ ] Menambahkan pola untuk angka 0–9
- [ ] Sistem menu pemilihan angka
- [ ] Efek suara saat berhasil menyentuh titik
- [ ] Sistem skor dan waktu penyelesaian

---

## Lisensi

Proyek ini dibuat untuk keperluan pembelajaran mata kuliah **Mixed Reality**.
