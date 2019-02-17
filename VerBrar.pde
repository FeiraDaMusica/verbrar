import processing.sound.*;
import processing.serial.*;


Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port
// Declare the processing sound variables 
SoundFile sample;
Amplitude rms;
FFT fft;

int bands = 128;

// Declare a smooth factor to smooth out sudden changes in amplitude.
// With a smooth factor of 1, only the last measured amplitude is used for the
// visualisation, which can lead to very abrupt changes. As you decrease the
// smooth factor towards 0, the measured amplitudes are averaged across frames,
// leading to more pleasant gradual changes
float smoothingFactor = 0.25;
float smoothingFactor2 = 0.2;
// Used for storing the smoothed amplitude value
float sum;
float[] sum2 = new float[bands];
int scale = 5;
float barWidth;
float magnify = 200; // This is how big we want the rose to be.
float phase = 0; // Phase Coefficient : this is basically how far round the circle we are going to go
float amp = 0; // Amp Coefficient : this is basically how far from the origin we are.
int elements = 128;// This is the number of points and lines we will calculate at once. 1000 is alot actually. 
float threshold = 0.35;// try increasing this if it jumps around too much
int wait=0;
boolean playit;
ArrayList lista;
public void setup() {
  size(900, 900);
  myPort = new Serial(this, "COM6", 9600);
  //Load and play a soundfile and loop it
  sample = new SoundFile(this, "m.aiff");
  sample.loop();
  barWidth = width/float(bands);

  // Create and patch the rms tracker
  rms = new Amplitude(this);
  rms.input(sample);
  lista = new ArrayList();
  fft = new FFT(this, bands);
  fft.input(sample);
}      
int i = 1 ;
float soma; 
float parametro;
public void draw() {
  // Set background color, noStroke and fill color
  background(0);
  noStroke();
  fill(255, 0, 150);

  // smooth the rms data by smoothing factor
  sum += (rms.analyze() - sum) * smoothingFactor;

  // rms.analyze() return a value between 0 and 1. It's
  // scaled to height/2 and then multiplied by a fixed scale factor
  float rms_scaled = sum * (height/2) * 5;

   soma = soma + rms_scaled;
   i++;
   if (i>10){
    parametro = soma/10;
    i = 1;
    soma = 0;
   }

  if (rms_scaled > parametro) {
    myPort.write('H');
    println("enviou");
  }

  // We draw a circle whose size is coupled to the audio analysis
  ellipse(width/2, height/2, rms_scaled, rms_scaled);

  fft.analyze();
  for (int i = 0; i < bands; i++) {
    // Smooth the FFT spectrum data by smoothing factor
    sum2[i] += (fft.spectrum[i] - sum2[i]) * smoothingFactor2;

    // Draw the rectangles, adjust their height using the scale factor
    fill(i*barWidth, 0, 0);
    ellipse(width/2, height/2, rms_scaled, -sum2[i]*height*scale*5);
  }
}
