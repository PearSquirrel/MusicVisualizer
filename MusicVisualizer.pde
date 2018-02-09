import grafica.*;
import java.util.Random;
import ddf.minim.analysis.*;
import ddf.minim.*;
import java.lang.*;
import processing.video.*;

Movie myMovie;
boolean playingMovie = false;

Minim minim;
AudioInput in;
FFT fft;

BarGraph barGraph1;
PieChart pieChart1;
LineGraph lineGraph1;

BarGraph barGraph2;
PieChart pieChart2;
LineGraph lineGraph2;
Slideshow slideshow;

public void setup() {
  surface.setResizable(true);
  fullScreen();
  
  //size(1240, 400);
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
  
  slideshow = new Slideshow();
    
  barGraph1 = new BarGraph(this);
  barGraph1.setTitle("Bar Graph #1");
  barGraph1.setData(gaussianStack);
  barGraph1.setAudioInputs(in, fft);
  barGraph1.startListening();
  barGraph1.setCoords(width/2-200,height/2-100,300,300);

  
  pieChart1 = new PieChart(this);
  pieChart1.setAudioInputs(in);
  pieChart1.startListening();
  pieChart1.setCoords(width/2-200,height/2-100,300,300);
  
  lineGraph1 = new LineGraph(this);
  lineGraph1.setCoords(width/2-200,height/2-100,300,300);
  lineGraph1.setAudioInputs(in);
  lineGraph1.startListening();
  
  ArrayList<Slide> slides = new ArrayList<Slide>();
  slides.add(new Slide("slide_bgs/1.jpeg"));
  slides.add(new Slide("slide_bgs/2.jpeg"));
  slides.add(new Slide("slide_bgs/3.jpeg").add(lineGraph1));
  slides.add(new Slide("slide_bgs/4.jpeg").add(pieChart1));
  slides.add(new Slide("slide_bgs/5.jpeg").add(barGraph1));
  
  // lazy copying instead of translating, good enough for now
  barGraph2 = new BarGraph(this);
  barGraph2.setTitle("Bar Graph #1");
  barGraph2.setData(gaussianStack);
  barGraph2.setAudioInputs(in, fft);
  barGraph2.startListening();
  barGraph2.setCoords(100,height/2-100,300,300);
  
  pieChart2 = new PieChart(this);
  pieChart2.setAudioInputs(in);
  pieChart2.startListening();
  pieChart2.setCoords(525,height/2-100,300,300);
  
  lineGraph2 = new LineGraph(this);
  lineGraph2.setAudioInputs(in);
  lineGraph2.startListening();
  lineGraph2.setCoords(950,height/2-100,300,300);

  slides.add(new Slide("slide_bgs/6.jpeg")
    .add(lineGraph2)
    .add(barGraph2)
    .add(pieChart2)
  );
  
  slides.add(new Slide("slide_bgs/7.jpeg"));

  
  for (Slide slide : slides) {
    slideshow.add(slide);
  }
  
  myMovie = new Movie(this, "skywalker.mp4");
}

void mousePressed() {
  //System.out.println("MOUSE PRESSED");
  //slideshow.nextSlide();
}

int[] tint = new int[3];
boolean isTinted = false;
void keyPressed() {
  System.out.println(key +" " + keyCode + " b " + (int)'b');
  if (key == CODED) {
    if (keyCode == DOWN) {
      isTinted = false;
    }
  } else {
    // for the demo, there are 7 slides total
    if (key >= '1' && key <= '7') {
      slideshow.setSlide((int) (key - '1'));
    }
    switch (key) {
    case 'm':
    myMovie.play();
    playingMovie = true;
    default:
      break;
    }
  }
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}

public void draw() {
  slideshow.draw();
  if (playingMovie) {
    tint(255, 20);
    image(myMovie, 0, 0);
  }
  
}