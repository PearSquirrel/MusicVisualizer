import grafica.*;
import java.util.Random;
import java.util.Arrays;
import java.util.Collections;
import ddf.minim.analysis.*;
import ddf.minim.*;
import java.util.List;

public class BarGraph {

private boolean isListening;
private String title = "";
public GPlot plot3;
public Random r;

// FFT stuff
AudioInput in;
FFT fft;
int w;
PImage fade;
boolean isFade = false;
PApplet parent;

public BarGraph(PApplet parent) {
  this.parent = parent;
  //setupFFT();
  System.out.println("TEST");
  setData(new ArrayList<Float>());
  System.out.println("TEST2");
}

public void setTitle(String title) {
  this.title = title;
}

public void setData(List<Float> histogram) {
  GPointsArray points = new GPointsArray(histogram.size());
  
  // add points to graph if necessary
  if (histogram.size() > 0) {
    float highestStackValue = Collections.max(histogram);
    for (int i = 0; i < histogram.size(); i++) {
      points.add(i + 1 - histogram.size()/2.0, histogram.get(i)/highestStackValue, "H" + i);
    }
  }
  
  // Setup for the plot
  plot3 = new GPlot(parent);
  plot3.setPos(0, 300);
  plot3.setDim(250, 250);
  plot3.setYLim(-0.02, 0.45);
  plot3.setXLim(6, -5);
  plot3.getTitle().setText(this.title);
  plot3.getTitle().setTextAlignment(LEFT);
  plot3.getTitle().setRelativePos(0);
  plot3.getYAxis().getAxisLabel().setText("Relative probability");
  plot3.getYAxis().getAxisLabel().setTextAlignment(RIGHT);
  plot3.getYAxis().getAxisLabel().setRelativePos(1);
  plot3.setPoints(points);
  plot3.startHistograms(GPlot.VERTICAL);
  plot3.getHistogram().setDrawLabels(true);
  plot3.getHistogram().setRotateLabels(true);
  /*plot3.getHistogram().setBgColors(new color[] {
    color(0, 0, 255, 50), color(0, 0, 255, 100), 
    color(0, 0, 255, 150), color(0, 0, 255, 200)
  }
  );*/

  // Setup the mouse actions
  plot3.activateCentering(LEFT, GPlot.CTRLMOD);
}

void setAudioInputs(AudioInput in, FFT fft) {
  this.in = in;
  this.fft = fft;
  
  int minBandwidth = 60;
  int bandsPerOctave = 1;
  fft.logAverages(minBandwidth, bandsPerOctave);
  
  stroke(255);
  w = (width/fft.avgSize())/100;
  strokeWeight(w);
  strokeCap(SQUARE);
  
  //background(0);
  if (isFade) {
    fade = get(0, 0, width, height);
  }
}

public void startListening() {
  this.isListening = true;
}

public void stopListening() {
    this.isListening = false;
}

void drawFFT() {
   //background(0);
  if (isFade) {
    tint(255, 255, 255, 252);
    image(fade, 0, 0);
    noTint();
  }
  
  fft.forward(in.mix);
  
  // Prepare the points for the plot  
  GPointsArray points = new GPointsArray(fft.avgSize());
  float avg = 0;
  for (int i = 0; i < fft.avgSize(); i++) {
    points.add(i + 1 - fft.avgSize()/2.0, fft.getAvg(i), "H" + i);
    avg = fft.getAvg(i);
    System.out.println(avg);
  }
  System.out.println();
  
  plot3.setXLim(fft.avgSize()/2+1, -fft.avgSize()/2);
  plot3.setYLim(-0.02, avg);


  plot3.setPoints(points);
  
  if (isFade) {
    fade = get(0, 0, width, height);
  }
}

public void draw() {
  if (this.isListening) {
    drawFFT();
  }
  
  // Draw the third plot  
  plot3.beginDraw();
  plot3.drawBackground();
  plot3.drawBox();
  plot3.drawYAxis();
  plot3.drawTitle();
  plot3.drawHistograms();
  plot3.endDraw();
}
}