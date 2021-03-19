static final int ScreenWidth = 1000;
static final int ScreenHeight = 500;

void setup() {
  size(1000, 500);
  background(255);
} 

void draw() {
  stroke(0);
  int screenWidthCenter = ScreenWidth/2;
  int screenHeightCenter = ScreenHeight/2;
  int edgeDistance = 100;
  
  beginShape();
    vertex(screenWidthCenter, screenHeightCenter);
    vertex(screenWidthCenter + edgeDistance, screenHeightCenter);
    vertex(screenWidthCenter + edgeDistance, screenHeightCenter + edgeDistance);
    vertex(screenWidthCenter, screenHeightCenter + edgeDistance);
  endShape(CLOSE);
  
  beginShape();
  int spacing = 20;
  for(int a = 0; a < 360; a += spacing)
  {
    float x = 100 * sin(a) + 200;
    float y = 100 * cos(a) + 200;
    vertex(x, y);
  }
  endShape(CLOSE);
}
