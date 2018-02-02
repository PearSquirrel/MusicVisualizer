import grafica.*;
import java.util.Random;
import ddf.minim.analysis.*;
import ddf.minim.*;


public GPlot plot3;
public float[] gaussianStack;
public int gaussianCounter;
public Random r;

// FFT stuff
Minim minim;
AudioInput in;
FFT fft;
int w;
PImage fade;
boolean isFade = true;

public void setup() {
  size(850, 660);
  setupFFT();
  setupBarChart();
}

void setupBarChart() {
  // Prepare the points for the plot
  gaussianStack = new float[10];
  gaussianCounter = 0;
  r = new Random();
  
  gaussianStack[0] = 13;
  gaussianStack[1] = 31;
  gaussianStack[2] = 20;
  gaussianStack[3] = 11;
  gaussianStack[4] = 12;
  gaussianStack[5] = 2;
  gaussianStack[6] = 56;
  gaussianStack[7] = 35;
  gaussianStack[8] = 10;
  gaussianStack[9] = 45;
  
  
  for (int index = 0; index < gaussianStack.length; index++) {
    gaussianCounter += gaussianStack[index];
  }
  
  GPointsArray points3 = new GPointsArray(gaussianStack.length);

  for (int i = 0; i < gaussianStack.length; i++) {
    points3.add(i + 1 - gaussianStack.length/2.0, gaussianStack[i]/gaussianCounter, "H" + i);
  }
  
  // Setup for the plot
  plot3 = new GPlot(this);
  plot3.setPos(0, 300);
  plot3.setDim(250, 250);
  plot3.setYLim(-0.02, 0.45);
  plot3.setXLim(10, -9);
  plot3.getTitle().setText("Gaussian distribution");
  plot3.getTitle().setTextAlignment(LEFT);
  plot3.getTitle().setRelativePos(0);
  plot3.getYAxis().getAxisLabel().setText("Relative probability");
  plot3.getYAxis().getAxisLabel().setTextAlignment(RIGHT);
  plot3.getYAxis().getAxisLabel().setRelativePos(1);
  plot3.setPoints(points3);
  plot3.startHistograms(GPlot.VERTICAL);
  plot3.getHistogram().setDrawLabels(true);
  plot3.getHistogram().setRotateLabels(true);/*
  plot3.getHistogram().setBgColors(new color[] {
    color(0, 0, 255, 50), color(0, 0, 255, 100), 
    color(0, 0, 255, 150), color(0, 0, 255, 200)
  }
  );*/

  // Setup the mouse actions
  plot3.activateCentering(LEFT, GPlot.CTRLMOD);
}

void setupFFT() {
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  fft.logAverages(60, 2);
  stroke(255);
  w = width/fft.avgSize();
  strokeWeight(w);
  strokeCap(SQUARE);
  
  //background(0);
  if (isFade) {
    fade = get(0, 0, width, height);
  }
}

void drawFFT() {
   background(0);
  if (isFade) {
    tint(255, 255, 255, 252);
    image(fade, 0, 0);
    noTint();
  }
  
  fft.forward(in.mix);
  
  // Prepare the points for the third plot
  gaussianStack = new float[10];
  gaussianCounter = 0;
  r = new Random();
  
  GPointsArray points3 = new GPointsArray(gaussianStack.length);
  
  for (int i = 0; i < fft.avgSize(); i++) {
    points3.add(i + 1 - fft.avgSize()/2.0, fft.getAvg(i)/3.0, "H" + i);
  }
  
  plot3.setPoints(points3);
  
  if (isFade) {
    fade = get(0, 0, width, height);
  }
}

public void draw() {
   drawFFT();
  
  // Draw the third plot  
  plot3.beginDraw();
  plot3.drawBackground();
  plot3.drawBox();
  plot3.drawYAxis();
  plot3.drawTitle();
  plot3.drawHistograms();
  plot3.endDraw();
}