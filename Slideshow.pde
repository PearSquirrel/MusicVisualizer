
public class Slideshow {
  int numFrames = 18;  // The number of frames in the animation
  int frame = 0;
  ArrayList<Slide> slides;
  boolean hasSlides = false;
  int curSlide = 0;
  boolean drawnBackground = false;
  
  public Slideshow() {
    this.slides = new ArrayList<Slide>();
    this.slides.add(new Slide());
    setup();
  }
  
  public Slideshow add(Slide slide) {
    if (!hasSlides) {
      this.slides.set(0, slide);
      curSlide = 0;
      hasSlides = true;
    } else {
      this.slides.add(slide);
    }
    return this;
  }
    
void setup()
{
  background(0);
}

public void setSlide(int index) {
  this.curSlide = index;
  drawnBackground = false;
}

public void nextSlide() {
  System.out.println("NEXT SLIDE");
  System.out.println("CUR SLIDE" + curSlide + " SLIDES SIZE" + slides.size());
  if (curSlide < slides.size()-1) {
    curSlide++;
  } else {
    // loop
    curSlide = 0;
  }
  drawnBackground = false;
}
 
public void draw() 
{
  if (!drawnBackground) {
    this.slides.get(curSlide).drawBackground();
    drawnBackground = true;
  } else {
    this.slides.get(curSlide).draw();
  }
}

void changeImage() {
  if (frame<18)
  { frame++;
  }
  else frame = 0;
}
}