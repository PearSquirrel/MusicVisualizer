public class Slide {
  PImage background;
  
  BarGraph b;
  LineGraph l;
  PieChart p;
  
  public Slide() {
    background = loadImage("slide_bgs/1.jpeg");
  }
  
  public Slide(String imagePath) {
    background = loadImage(imagePath);
  }
  
  public Slide add(BarGraph b) {
    this.b = b;
    return this;
  }
  
  public Slide add(PieChart p) {
    this.p = p;
    return this;
  }
  
  public Slide add(LineGraph l) {
    this.l = l;
    return this;
  }
  
  public void drawBackground() {
    image(background, 0, 0, width, height);
  }
  
  public void draw() {
    if (this.l != null) l.draw();
    if (this.b != null) b.draw();
    if (this.p != null) p.draw();
  }
}