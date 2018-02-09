public class LineGraph {
    
  int posX = 850;
  int posY = 0;
  int figureWidth = 300;
  int figureHeight = 300;
 
  private boolean isListening;
  private int size = figureWidth;

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
  
  String title = "Bitcoin Price Prediction";
  String subtitle = "Build Team Project";
  
  // FFT stuff
  Minim minim;
  AudioInput in;
  //FFT fft;
  BeatDetect beat;
  int w;
  PImage fade;
    
  public LineGraph(PApplet parent) {
    this.parent = parent;
    int numColors = 100;
    colors = new int[numColors][3];
    for (int i = 0; i < numColors; i++) {
      colors[i][0] = int(random(255));
      colors[i][1] = int(random(255));
      colors[i][2] = int(random(255));
    }
    
    plot = new GPlot(parent);

    // Prepare the points for the plot
    int nPoints = 100;
    GPointsArray points = new GPointsArray(nPoints);
  
    for (int i = 0; i < nPoints; i++) {
      points.add(i, 10*noise(0.1*i));
    }
    
    // Set the plot title and the axis labels
    plot.setTitleText(title);
    //plot.getXAxis().setAxisLabelText("x axis");
    //plot.getYAxis().setAxisLabelText("y axis");
    plot.getYAxis().getAxisLabel().setText("Price ($)");
    plot.getXAxis().getAxisLabel().setText("Time (days since 10/1/2017)");
    // Add the points
    plot.setPoints(points);
    
    plot.setDim(figureWidth, figureHeight);
    plot.setPos(posX, posY);
  }
  
void setAudioInputs(AudioInput in) {
  this.in = in;
  // a beat detection object SOUND_FREQUENCY based on my mic
  beat = new BeatDetect(in.bufferSize(), in.sampleRate());
  //this.fft = fft;
}
  
public void setCoords(int x, int y, int fWidth, int fHeight) {
 posX = x;
 posY = y;
 figureWidth= fWidth;
 figureHeight = fHeight;
 
 plot.setDim(figureWidth, figureHeight);
 plot.setPos(posX, posY);
}
  
public void startListening() {
  this.isListening = true;
}

public void stopListening() {
    this.isListening = false;
}

void drawWaveForm(GPlot plot) {
  GPointsArray points = new GPointsArray(in.bufferSize());
  GPointsArray points2 = new GPointsArray(in.bufferSize());

  for (int i = 0; i < in.bufferSize(); i++) {
    points.add(i, in.left.get(i));
    points2.add(i, in.right.get(i));
  }
  plot.setYLim(-1, 1);
  plot.setPoints(points);
}
  
  public void draw(){
    plot.beginDraw();
    plot.drawBackground();
    plot.drawBox();
    plot.drawXAxis();
    plot.drawYAxis();
    //plot.drawTopAxis();
    //plot.drawRightAxis();
    plot.drawTitle();
    //plot.getMainLayer().drawPoints();
    //plot.getLayer("surface").drawFilledContour(GPlot.HORIZONTAL, 0);
    if (isListening) {
      drawWaveForm(plot);
    }
    plot.drawLines();
    // make pie slices into layers and replace the legend with real stuff
    // could 1. make slices using a crapton of points, or 2.
    // add to grafica's GLayer something like public void drawCustom(Drawable toDraw)
    // and then call
    // plot.getLayer("firstPieceOfPie").drawCustom(new Drawable({
    //   public void draw() {
    //    ...
    //   }));
    //plot.drawLegend(labels, new float[] {0.1, 0.35,0.65}, 
    //              new float[] {0.95, 0.95,0.95});
    plot.endDraw();
  }
}