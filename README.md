# Flutter To-Do List SQLite + Kategori

Project ini dibuat untuk mengerjakan Soal 1 dan Soal 5 pada BAB 3 Data Persistence dengan SQLite di Flutter.

## Fitur

- Menambah tugas
- Menampilkan daftar tugas
- Mengubah status selesai/belum selesai
- Mengedit tugas
- Menghapus tugas
- Menghapus semua tugas selesai
- Membuat kategori tugas
- CRUD kategori
- Relasi tabel `todos` dan `categories`
- Menampilkan nama kategori pada setiap tugas
- Filter tugas berdasarkan kategori

## Cara Menjalankan

```bash
flutter pub get
flutter run
```

## Struktur Project

```text
lib/
├── main.dart
├── models/
│   ├── todo.dart
│   └── category.dart
├── database/
│   └── database_helper.dart
└── screens/
    ├── todo_list_screen.dart
    ├── todo_form_screen.dart
    └── category_screen.dart
```
