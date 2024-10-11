import 'dart:io';
import 'dart:math';

// Kode ANSI untuk kontrol terminal
const String clearScreen = '\x1B[2J\x1B[0;0H';
const String hideCursor = '\x1B[?25l';

// Konstanta permainan
const int width = 60; // Lebar yang ditingkatkan untuk peta yang lebih besar
const int height = 20; // Tinggi yang ditingkatkan untuk peta yang lebih besar

void main() {
  // Posisi awal kadal
  List<List<int>> lizardBody = [
    [height ~/ 2, width ~/ 2], // Posisi kepala
  ];

  // Menghasilkan posisi makanan secara acak
  List<int> food = randomPosition(width, height);

  // Sembunyikan kursor untuk pengalaman permainan yang lebih mulus
  stdout.write(hideCursor);

  // Loop permainan utama
  while (true) {
    // Hapus layar dan gambar ulang permainan
    stdout.write(clearScreen);
    drawGame(lizardBody, food);

    // Dapatkan posisi kepala saat ini
    List<int> head = lizardBody.first;

    // Pindahkan kepala menuju makanan
    if (head[0] < food[0]) {
      head[0]++; // Bergerak ke bawah
    } else if (head[0] > food[0]) {
      head[0]--; // Bergerak ke atas
    } else if (head[1] < food[1]) {
      head[1]++; // Bergerak ke kanan
    } else if (head[1] > food[1]) {
      head[1]--; // Bergerak ke kiri
    }

    // Periksa jika kepala bertabrakan dengan tubuh
    if (lizardBody.skip(1).any((segment) => segment[0] == head[0] && segment[1] == head[1])) {
      print("Game Over: Bertabrakan dengan tubuh!");
      break; // Akhiri permainan jika bertabrakan
    }

    // Tambahkan posisi kepala baru
    lizardBody.insert(0, List.from(head));

    // Periksa jika kadal memakan makanan
    if (head[0] == food[0] && head[1] == food[1]) {
      food = randomPosition(width, height); // Menghasilkan makanan baru
      // Untuk menambah panjang tubuh, cukup tambahkan segmen baru
      lizardBody.add([0, 0]); // Placeholder untuk pertumbuhan
    } else {
      lizardBody.removeLast(); // Hapus ekor jika tidak ada makanan yang dimakan
    }

    // Kontrol kecepatan permainan
    sleep(Duration(milliseconds: 300));
  }
}

// Fungsi untuk menggambar grid permainan
void drawGame(List<List<int>> lizardBody, List<int> food) {
  // Dapatkan posisi kepala
  List<int> head = lizardBody.first;
  
  // Tentukan posisi tangan, kaki, dan ekor
  int armsY = head[0] + 1; // Tangan di bawah kepala
  int bodyStartY = head[0] + 2; // Mulai tubuh di bawah kepala
  int legsY = head[0] + (lizardBody.length >= 3 ? 3 + lizardBody.length - 2 : 3); // Kaki di bawah tubuh
  int tailY = legsY + 1; // Ekor di bawah kaki
  
  for (int i = 0; i < height; i++) {
    for (int j = 0; j < width; j++) {
      // Gambar makanan
      if (i == food[0] && j == food[1]) {
        stdout.write('*'); // Makanan
      } 
      // Gambar kepala
      else if (i == head[0] && j == head[1]) {
        stdout.write('0'); // Kepala diwakili sebagai '0'
      } 
      // Gambar tangan (Tangan)
      else if (i == armsY && j >= (head[1] - 3) && j <= (head[1] + 3)) {
        stdout.write('0'); // Tangan
      } 
      // Gambar segmen tubuh
      else if (i >= bodyStartY && i < legsY && j == head[1]) {
        stdout.write('0'); // Segmen tubuh
      }
      // Gambar kaki (Kaki)
      else if (i == legsY && j >= (head[1] - 3) && j <= (head[1] + 3)) {
        stdout.write('0'); // Kaki
      }
      // Gambar ekor (Ekor)
      else if (i == tailY && j == head[1]) {
        stdout.write('0'); // Ekor
      } 
      // Gambar ruang kosong
      else {
        stdout.write(' '); 
      }
    }
    stdout.writeln(); // Baris baru setelah setiap baris
  }
}

// Fungsi untuk menghasilkan posisi acak untuk makanan dalam grid
List<int> randomPosition(int width, int height) {
  Random rand = Random();
  int x, y;
  do {
    x = rand.nextInt(height);
    y = rand.nextInt(width);
  } while (x == height ~/ 2 && y == width ~/ 2); // Mencegah makanan muncul di posisi kepala
  return [x, y];
}
