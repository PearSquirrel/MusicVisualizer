import grafica.*;
import java.util.Random;
import ddf.minim.analysis.*;
import ddf.minim.*;
import java.lang.*;


public GPlot plot3;
public ArrayList<Float> gaussianStack;
public int gaussianCounter;
public Random r;

// FFT stuff
Minim minim;
AudioInput in;
FFT fft;
int w;
PImage fade;
boolean isFade = true;

BarGraph barGraph1;

public void setup() {
  size(850, 660);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  
  gaussianStack = new ArrayList<Float>(10);  
  gaussianStack.add(0, 13.0);
  gaussianStack.add(1, 20.0);
  gaussianStack.add(2, 11.0);
  gaussianStack.add(3, 12.0);
  gaussianStack.add(4, 2.0);
  gaussianStack.add(5, 56.0);
/*
  gaussianStack[7] = 35;
  gaussianStack[8] = 10;
  gaussianStack[9] = 45;*/
  
  barGraph1 = new BarGraph(this);
  barGraph1.setData(gaussianStack);
  barGraph1.setAudioInputs(in, fft);
  barGraph1.startListening();
  //barGraph1.stopListening();
  //barGraph1.setup();
}

public void draw() {
   barGraph1.draw();
}