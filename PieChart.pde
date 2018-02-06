public class PieChart {
  private boolean isListening;
  private int size = 200;

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
    minim = new Minim(this);
    in = minim.getLineIn(Minim.STEREO, 512);
    // a beat detection object SOUND_FREQUENCY based on my mic
    beat = new BeatDetect(in.bufferSize(), in.sampleRate());
    this.parent = parent;
    int numColors = 100;
    colors = new int[numColors][3];
    for (int i = 0; i < numColors; i++) {
      colors[i][0] = int(random(255));
      colors[i][1] = int(random(255));
      colors[i][2] = int(random(255));
    }
    
    plot = new GPlot(parent);
    plot.setPos(425, 0);
    plot.setDim(300, 300);
    
    // Set the plot limits (this will fix them)
    plot.setXLim(-1.2*scale, 1.2*scale);
    plot.setYLim(-1.2*scale, 1.2*scale);
  
    // Set the plot title and the axis labels
    plot.setTitleText(this.title + " (" + this.subtitle + ")");
    plot.getXAxis().setAxisLabelText("x axis");
    plot.getYAxis().setAxisLabelText("y axis");
  
    // Activate the panning effect
    plot.activatePanning();
    
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
  
  private void drawPie(GPlot plot) {
    num = 0;
    for (int i=0; i<data.length; i++) {
      num += data[i];
    }
    num = 360/num;
    angle_1+=2;
    
    float plotWidth = plot.getDim()[0];    
    float plotHeight = plot.getDim()[1];
  
    int y =  (int) -plotHeight/2;
    for (int i = 0; i < data.length; i++) {
      angle_2 = angle_1;
      angle_1 += data[i] * num;
      
      // TODO: remove hard-coded values so that resizing works nicely
      fillColor(i);
      arc(plotWidth/2, -plotHeight/2, this.size, this.size, radians(angle_2), radians(angle_1));
    }
  }
  
  public void draw(){
    beat.detect(in.mix);
    if (beat.isSnare()) {
      this.size += 20;
    } else {
      this.size -= 5;
    }
    if (this.size < 200) {
      this.size = 200;
    }
    plot.beginDraw();
    plot.drawBackground();
    plot.drawBox();
    plot.drawXAxis();
    plot.drawYAxis();
    plot.drawTopAxis();
    plot.drawRightAxis();
    plot.drawTitle();
    plot.getMainLayer().drawPoints();
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