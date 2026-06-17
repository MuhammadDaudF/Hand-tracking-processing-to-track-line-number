import oscP5.*;
import netP5.*;

OscP5 oscP5;

// Posisi ujung telunjuk
float indexX = -1;
float indexY = -1;

// Radius lingkaran titik
int dotRadius = 25;

// Titik-titik yang membentuk angka 7
// Urutan: kiri atas → kanan atas → diagonal ke kiri bawah
int[][] dots = {
  {150, 100},  // 0 - START (kiri atas)
  {220, 100},  // 1
  {290, 100},  // 2
  {360, 100},  // 3 - (kanan atas)
  {320, 170},  // 4
  {280, 240},  // 5
  {240, 310},  // 6
  {200, 380},  // 7 - FINISH (bawah)
};

// Tracking urutan
int currentTarget = 0;
boolean[] dotPassed = new boolean[dots.length];
boolean finished = false;

void setup() {
  size(640, 480);
  oscP5 = new OscP5(this, 12000);
  textAlign(CENTER, CENTER);
}

void draw() {
  background(30);

  // Judul
  fill(255);
  textSize(20);
  text("Ikuti titik-titik untuk membentuk angka 7", width / 2, 30);

  // Gambar garis panduan putus-putus antar titik
  drawGuideLine();

  // Gambar semua titik
  for (int i = 0; i < dots.length; i++) {
    drawDot(i);
  }

  // Cek apakah telunjuk menyentuh titik target saat ini
  if (!finished && indexX >= 0) {
    checkTouch();
  }

  // Gambar posisi telunjuk
  if (indexX >= 0) {
    noFill();
    stroke(0, 255, 255);
    strokeWeight(2);
    ellipse(indexX, indexY, 20, 20);

    fill(0, 255, 255);
    noStroke();
    ellipse(indexX, indexY, 8, 8);
  }

  // Tampilkan progress
  fill(255);
  textSize(14);
  text("Progress: " + currentTarget + " / " + dots.length, width / 2, height - 40);

  // Tampilkan pesan selesai
  if (finished) {
    fill(50, 220, 50, 200);
    rect(0, 0, width, height);
    fill(255);
    textSize(48);
    text("Angka 7 Selesai!", width / 2, height / 2 - 20);
    textSize(18);
    text("Tekan R untuk ulangi", width / 2, height / 2 + 40);
  }
}

void drawGuideLine() {
  // Garis putus-putus sebagai panduan
  for (int i = 0; i < dots.length - 1; i++) {
    float x1 = dots[i][0];
    float y1 = dots[i][1];
    float x2 = dots[i + 1][0];
    float y2 = dots[i + 1][1];

    // Hitung titik-titik putus-putus
    float d = dist(x1, y1, x2, y2);
    int segments = int(d / 15);

    for (int s = 0; s < segments; s++) {
      if (s % 2 == 0) {
        float ax = lerp(x1, x2, float(s) / segments);
        float ay = lerp(y1, y2, float(s) / segments);
        float bx = lerp(x1, x2, float(s + 1) / segments);
        float by = lerp(y1, y2, float(s + 1) / segments);

        // Warna garis berubah kalau sudah dilewati
        if (i < currentTarget - 1) {
          stroke(50, 220, 50, 180);
        } else {
          stroke(180, 180, 180, 100);
        }
        strokeWeight(3);
        line(ax, ay, bx, by);
      }
    }
  }
}

void drawDot(int i) {
  float x = dots[i][0];
  float y = dots[i][1];

  noStroke();

  if (i == 0 && !dotPassed[i]) {
    // START - warna hijau
    fill(50, 220, 50);
    ellipse(x, y, dotRadius * 2, dotRadius * 2);
    fill(255);
    textSize(13);
    text("START", x, y);

  } else if (i == dots.length - 1 && !finished) {
    // FINISH - warna merah
    if (currentTarget == dots.length - 1) {
      // Berkedip kalau sudah hampir selesai
      if (frameCount % 30 < 15) {
        fill(255, 80, 80);
      } else {
        fill(200, 50, 50);
      }
    } else {
      fill(200, 50, 50);
    }
    ellipse(x, y, dotRadius * 2, dotRadius * 2);
    fill(255);
    textSize(13);
    text("END", x, y);

  } else if (dotPassed[i]) {
    // Sudah dilewati - hijau
    fill(50, 220, 50);
    ellipse(x, y, dotRadius * 2, dotRadius * 2);
    fill(255);
    textSize(16);
    text("✓", x, y);

  } else if (i == currentTarget) {
    // Target sekarang - kuning berkedip
    if (frameCount % 30 < 15) {
      fill(255, 220, 0);
    } else {
      fill(200, 170, 0);
    }
    ellipse(x, y, dotRadius * 2 + 8, dotRadius * 2 + 8);
    fill(30);
    textSize(14);
    text(i + 1, x, y);

  } else {
    // Belum giliran - abu-abu
    fill(120);
    ellipse(x, y, dotRadius * 2, dotRadius * 2);
    fill(255);
    textSize(14);
    text(i + 1, x, y);
  }
}

void checkTouch() {
  float tx = dots[currentTarget][0];
  float ty = dots[currentTarget][1];

  float d = dist(indexX, indexY, tx, ty);

  if (d < dotRadius + 10) {
    dotPassed[currentTarget] = true;
    currentTarget++;

    if (currentTarget >= dots.length) {
      finished = true;
    }
  }
}

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/index")) {
    indexX = msg.get(0).floatValue() * width;
    indexY = msg.get(1).floatValue() * height;
  }
}

// Tekan R untuk reset
void keyPressed() {
  if (key == 'r' || key == 'R') {
    currentTarget = 0;
    finished = false;
    for (int i = 0; i < dots.length; i++) {
      dotPassed[i] = false;
    }
    indexX = -1;
    indexY = -1;
  }
}
