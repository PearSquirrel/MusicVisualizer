import grafica.*;
import java.util.Random;
import ddf.minim.analysis.*;
import ddf.minim.*;
import java.lang.*;

Minim minim;
AudioInput in;
FFT fft;

BarGraph barGraph1;
PieChart pieChart1;
LineGraph lineGraph1;

public void setup() {
  size(1240, 400);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  
  ArrayList<Float> gaussianStack = new ArrayList<Float>(10);  
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
  barGraph1.setTitle("Bar Graph #1");
  barGraph1.setData(gaussianStack);
  barGraph1.setAudioInputs(in, fft);
  barGraph1.startListening();
  
  pieChart1 = new PieChart(this);
  lineGraph1 = new LineGraph(this);
  lineGraph1.startListening();
}

public void draw() {
  background(0);
  barGraph1.draw();
  pieChart1.draw();
  lineGraph1.draw();
}