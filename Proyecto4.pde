import gab.opencv.*;
import processing.video.*;

Capture video;
OpenCV opencv;
PImage src;

int maxColores = 5;
int[] hues;
int[] colores;
int ancho = 10;

PImage[] outputs;

int colorCambio = -1;

void setup() {
  video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, video.width, video.height);
  
  size(830, 480);
  
  colores = new int[maxColores];
  hues = new int[maxColores];
  
  outputs = new PImage[maxColores];
  
  video.start();
}

void draw() {
  
  background(0);
  
  if (video.available()) {
    video.read();
  }

  opencv.loadImage(video);
  
  opencv.useColor();
  src = opencv.getSnapshot();
  
  opencv.useColor(HSB);
  
  detectColors();
  
  image(src, 0, 0);
  for (int i=0; i<outputs.length; i++) {
    if (outputs[i] != null) {
      
      noStroke();
      fill(colores[i]);
      rect(src.width, i*src.height/5, 190, src.height/5);
    }
  }
  textAlign(CENTER);
  textSize(20);
  stroke(255);
  fill(255);
  
  if (colorCambio > -1) {
    text("Presiona para cambiar el color " + colorCambio, width/2, 50);
  } else {
    text("Presiona cualquier tecla del 1 al 4", width/2, 50);
  }
}

void detectColors() {
    
  for (int i=0; i<hues.length; i++) {
    
    if (hues[i] <= 0) continue;
    
    opencv.setGray(opencv.getH().clone());
    
    int hueToDetect = hues[i];
    
    opencv.inRange(hueToDetect-ancho/2, hueToDetect+ancho/2);
    
    opencv.erode();

    outputs[i] = opencv.getSnapshot();
  }
}


void mousePressed() {
    
  if (colorCambio > -1) {
    
    color c = get(mouseX, mouseY);
    println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));
   
    int hue = int(map(hue(c), 0, 255, 0, 180));
    
    colores[colorCambio-1] = c;
    hues[colorCambio-1] = hue;
    
    println("Índice de color " + (colorCambio-1) + ", valor: " + hue);
  }
}

void keyPressed() {
  
  if (key == '1') {
    colorCambio = 1;
    
  } else if (key == '2') {
    colorCambio = 2;
    
  } else if (key == '3') {
    colorCambio = 3;
  
  } else if (key == '4') {
    colorCambio = 4;
  
  } else if (key == '5') {
    colorCambio = 5;
  }
}

void keyReleased() {
  colorCambio = -1; 
}
