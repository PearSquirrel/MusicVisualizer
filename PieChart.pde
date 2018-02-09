public class PieChart {
      
  int posX = 425;
  int posY = 0;
  int figureWidth = 300;
  int figureHeight = 300;
  
  private boolean isListening;
  private int size = 200;
  private int baseSize = size;

  PApplet parent;
  GPlot plot;
  float[] data = {35, 55, 10};

  int[][] colors;
  String[] labels = {"Business", "Technology", "Design"};
  float angle_1 = 0;
  float angle_2 = data[0];
  float num = 0;
  
  float scale = 1.0;
  
  PFont font = createFont("Arial", 14, true);
  
  String title = "Convergent Expertise Distribution";
  String subtitle = "Spring 2018";
  
  // FFT stuff
  Minim minim;
  AudioInput in;
  FFT fft;
  BeatDetect beat;
  int w;
  PImage fade;
    
  public PieChart(PApplet parent) {
    this.parent = parent;
    int numColors = 100;
    colors = new int[numColors][3];
    for (int i = 0; i < numColors; i++) {
      colors[i][0] = int(random(255));
      colors[i][1] = int(random(255));
      colors[i][2] = int(random(255));
    }
    
    plot = new GPlot(parent);
    plot.setPos(posX, posY);
    plot.setDim(figureWidth, figureHeight);
    
    // Set the plot limits (this will fix them)
    plot.setXLim(-1.2*scale, 1.2*scale);
    plot.setYLim(-1.2*scale, 1.2*scale);
  
    // Set the plot title and the axis labels
    plot.setTitleText(this.title + " (" + this.subtitle + ")");
    //plot.getXAxis().setAxisLabelText("x axis");
    //plot.getYAxis().setAxisLabelText("y axis");
  
    // Activate the panning effect
    //plot.activatePanning();
    
    // add a layer per slice of pie
    for (int i = 0; i < labels.length; i++) {
      plot.addLayer(labels[i], new GPointsArray(0));
      plot.getLayer(labels[i]).setLineColor(getColor(i));
    }
    
    setup();
  }
  
  private void setup(){
    //background(255);
    //smooth();
    //noStroke();
    //noLoop();
    //textFont(font);
  }
  
  public void setCoords(int x, int y, int fWidth, int fHeight) {
 posX = x;
 posY = y;
 figureWidth= fWidth;
 figureHeight = fHeight;
     plot.setDim(figureWidth, figureHeight);
    plot.setPos(posX, posY);
}

void setAudioInputs(AudioInput in) {
  this.in = in;
  minim = new Minim(this);
  // a beat detection object SOUND_FREQUENCY based on my mic
  beat = new BeatDetect(in.bufferSize(), in.sampleRate());
}  
  
public void startListening() {
  this.isListening = true;
}

public void stopListening() {
    this.isListening = false;
}

void drawFFT() {  
  fft.forward(in.mix);
  
  // Prepare the points for the plot  
  GPointsArray points = new GPointsArray(fft.avgSize());
  float avg = 0;
  for (int i = 0; i < fft.avgSize(); i++) {
    points.add(i + 1 - fft.avgSize()/2.0, fft.getAvg(i), "H" + i);
    avg = fft.getAvg(i);
  }
  
  plot.setPoints(points);
}
  
  private void fillColor(int index) {
    fill(colors[index][0], colors[index][1], colors[index][2]);
  }
  
  private color getColor(int i) {
    return color(colors[i][0], colors[i][1], colors[i][2]);
  }
  
  int size1 = size;
  int size2 = size;
  int size3 = size;
  
  private void drawPie(GPlot plot) {
    float scale = figureWidth/300.0;
    if (isListening) {
    beat.detect(in.mix);
    if (beat.isSnare()) {
      size1 = baseSize + 30;
    } else {
      size1 -= 5;
    }
    if (size1 < baseSize) {
      size1 = baseSize;
    }
    if (beat.isKick()) {
      size2 = baseSize + 30;
    } else {
      size2 -= 5;
    }
    if (size2 < baseSize) {
      size2 = baseSize;
    }
    if (beat.isHat()) {
      size3 = baseSize + 30;
    } else {
      size3 -= 5;
    }
    if (size3 < baseSize) {
      size3 = baseSize;
    }
    }
    
    num = 0;
    for (int i=0; i<data.length; i++) {
      num += data[i];
    }
    num = 360/num;
    if (isListening) {
      angle_1+=2;
    }
    
    float plotWidth = plot.getDim()[0];    
    float plotHeight = plot.getDim()[1];
  
    int y =  (int) -plotHeight/2;
    for (int i = 0; i < data.length; i++) {
      angle_2 = angle_1;
      angle_1 += data[i] * num;
      
      fillColor(i);
      if (i % 3 == 0) {
        arc(plotWidth/2, -plotHeight/2, size1*scale, size1*scale, radians(angle_2), radians(angle_1));
      } else if (i % 3 == 1) {
        arc(plotWidth/2, -plotHeight/2, size2*scale, size2*scale, radians(angle_2), radians(angle_1));
      } else {
        arc(plotWidth/2, -plotHeight/2, size3*scale, size3*scale, radians(angle_2), radians(angle_1));        
      }
    }
  }
  
  public void draw(){
    plot.beginDraw();
    plot.drawBackground();
    plot.drawBox();
    //plot.drawXAxis();
    //plot.drawYAxis();
    //plot.drawTopAxis();
    //plot.drawRightAxis();
    plot.drawTitle();
    //plot.getMainLayer().drawPoints();
    //plot.getLayer("surface").drawFilledContour(GPlot.HORIZONTAL, 0);
    drawPie(plot);
    // make pie slices into layers and replace the legend with real stuff
    // could 1. make slices using a crapton of points, or 2.
    // add to grafica's GLayer something like public void drawCustom(Drawable toDraw)
    // and then call
    // plot.getLayer("firstPieceOfPie").drawCustom(new Drawable({
    //   public void draw() {
    //    ...
    //   }));
    plot.drawLegend(labels, new float[] {0.1, 0.35,0.65}, 
                  new float[] {0.95, 0.95,0.95});
    plot.endDraw();
  }
}