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
  logo = loadImage("convergent-logo.png");
}

void mousePressed() {
  //System.out.println("MOUSE PRESSED");
  //slideshow.nextSlide();
}

int[] tint = new int[3];
boolean isTinted = false;
void keyPressed() {
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
    slideshow.setSlide(5);
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

int convergentHeight = 0;
PImage logo;
int logoX;
int logoWidth;
int logoY;
int movieWidth = 640;
int movieHeight = 360;
int movieX = 0;
int movieY = 0;

public void draw() {
  slideshow.draw();
  if (playingMovie && slideshow.curSlide() == 5 && myMovie.time() >= 1) {
    BarGraph b = slideshow.get(5).b;
    PieChart p = slideshow.get(5).p;
    LineGraph l = slideshow.get(5).l;
    if (b.posX >= 10) {
      b.setCoords(b.posX-10, b.posY+12, b.figureWidth, b.figureHeight);
      p.setCoords(p.posX, p.posY+12, p.figureWidth, p.figureHeight);
      l.setCoords(l.posX+10, l.posY+12, l.figureWidth, l.figureHeight);
    } else {
      if (convergentHeight < height/2+1) {
        rectMode(CENTER);
        fill(0);
        rect(width/2, height/4, width, convergentHeight+=10);
      } else if (myMovie.time() < 24) {
        imageMode(CENTER);
        logoX = width/2;
        logoY = height/4;
        logoWidth = width/2;
        image(logo, logoX, logoY, logoWidth, (int)(logo.height*(width/2.0)/logo.width));
      }
    }

    if (myMovie.time() >= 24 && myMovie.time() < 29 && logoX < (width-logoWidth/2)+50){
        rectMode(CENTER);
        fill(0);
        rect(width/2, height/4, width, convergentHeight);
        imageMode(CENTER);
        image(logo, logoX+=5, logoY+=2, logoWidth, (int)(logo.height*(width/2.0)/logo.width));
    }
    
    if (myMovie.time() >= 29 && myMovie.time() < 60) {
      imageMode(CORNER);
      if (movieHeight < height/2) {
        image(myMovie, movieX, movieY, movieWidth+=5, movieHeight+=5*(360.0/640));
      } else {
        image(myMovie, movieX, movieY, movieWidth, movieHeight);
      }
    }
    
    if (myMovie.time() >= 60) {
      if (myMovie.time() < 68) {
      rectMode(CORNER);
      imageMode(CORNER);
      if (convergentHeight < height) {
        fill(0);
        rect(0, 0, width, convergentHeight+=10*(360.0/640)); 
      } else {
        fill(0);
        rect(0, 0, width, convergentHeight); 
      }
      if (movieWidth < width) {
        image(myMovie, movieX, movieY, movieWidth+=10, movieHeight+=10*(360.0/640));
      } else {
        image(myMovie, movieX, movieY, movieWidth, movieHeight);
      }
    } else {
      rectMode(CORNER);
      imageMode(CORNER);
      fill(0);
      rect(0, 0, width, convergentHeight);
      image(myMovie, movieX, movieY, movieWidth, movieHeight);
      playingMovie = false;
      slideshow.nextSlide();
    }
    }
  }
}