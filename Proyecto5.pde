import processing.sound.*;

FFT visualizador;
AudioIn mic;
int bandas = 256;
float[] espectro = new float[bandas];

void setup() {
  size(768, 600);
  background(255);
    
  visualizador = new FFT(this, bandas);
  mic = new AudioIn(this, 0);
  
  mic.start();

  visualizador.input(mic);
}      

void draw() { 
  background(0);
  visualizador.analyze(espectro);

  for(int i = 0; i < bandas; i++){
  stroke(random(255),random(255),random(255));
  line( i*3, height/2, i*3, height/2 - espectro[i]*height*3);
  line( i*3, height/2, i*3, height/2 + espectro[i]*height*3 );
  } 
}
