import oscP5.*;
import netP5.*;

OscP5 oscP5;

// Simpan 21 titik tangan (x dan y)
float[] handX = new float[21];
float[] handY = new float[21];
boolean handDetected = false;

void setup() {
  size(640, 480);
  
  // Dengarkan OSC di port 12000
  oscP5 = new OscP5(this, 12000);
  
  println("Processing siap menerima data tangan...");
}

void draw() {
  background(30);
  
  if (handDetected) {
    drawHand();
  } else {
    fill(150);
    textAlign(CENTER, CENTER);
    textSize(16);
    text("Arahkan tangan ke kamera...", width/2, height/2);
  }
}

void drawHand() {
  // Gambar garis-garis koneksi antar jari
  stroke(100, 200, 255);
  strokeWeight(2);
  
  // Ibu jari (0-1-2-3-4)
  drawLine(0, 1); drawLine(1, 2); drawLine(2, 3); drawLine(3, 4);
  
  // Jari telunjuk (0-5-6-7-8)
  drawLine(0, 5); drawLine(5, 6); drawLine(6, 7); drawLine(7, 8);
  
  // Jari tengah (0-9-10-11-12)
  drawLine(0, 9); drawLine(9, 10); drawLine(10, 11); drawLine(11, 12);
  
  // Jari manis (0-13-14-15-16)
  drawLine(0, 13); drawLine(13, 14); drawLine(14, 15); drawLine(15, 16);
  
  // Kelingking (0-17-18-19-20)
  drawLine(0, 17); drawLine(17, 18); drawLine(18, 19); drawLine(19, 20);
  
  // Telapak tangan
  drawLine(5, 9); drawLine(9, 13); drawLine(13, 17);

  // Gambar titik-titik landmark
  for (int i = 0; i < 21; i++) {
    float x = handX[i] * width;
    float y = handY[i] * height;
    
    // Ujung jari warna berbeda
    if (i == 4 || i == 8 || i == 12 || i == 16 || i == 20) {
      fill(255, 80, 80);
      noStroke();
      ellipse(x, y, 14, 14);
    } else {
      fill(255, 220, 50);
      noStroke();
      ellipse(x, y, 10, 10);
    }
  }
}

void drawLine(int a, int b) {
  line(handX[a] * width, handY[a] * height,
       handX[b] * width, handY[b] * height);
}

// Fungsi ini otomatis dipanggil saat ada pesan OSC masuk
void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/hand")) {
    handDetected = true;
    // Baca 42 nilai (21 titik x 2 koordinat)
    for (int i = 0; i < 21; i++) {
      handX[i] = msg.get(i * 2).floatValue();
      handY[i] = msg.get(i * 2 + 1).floatValue();
    }
  }
}
