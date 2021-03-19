float t = 0.0;
int anger = 5;
int happy = 0;
float sad = -2.1;
int fear = 0;

void setup(){
  size(900, 900);
  frameRate(60);
  strokeWeight(2);
}

void draw(){
  background(255);
  translate(width / 2, height / 2);

  beginShape();
  
  for (float theta = .0001; theta < 2 * PI; theta += .01){
    float rad = r(theta,
      4 - fear, // a fear--
      4 - fear, // b fear --
      3 + anger, // m anger ++
      1 + sad, // n1 sad++
      sin(t) * .5 + .5, // n2 happy means in sync
      cos(t) * .5 + .5  // n3
    );
    float x = rad * cos(theta) * 50;
    float y = rad * sin(theta) * 50;
    vertex(x, y);
    
  }
  
  endShape();
  t += .1;
  if (t >= 2*PI)
  {
    t = 0;
  }
  
  // saveFrame("output/line-######.png");
}  

float r(float theta, float a, float b, float m, float n1, float n2, float n3){
  return pow(pow(abs(cos(m * theta / 4.0) / a), n2) +
            pow(abs(sin(m * theta / 4.0) / b), n3), -1 / n1);
}
