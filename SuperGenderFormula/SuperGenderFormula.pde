// Define Constants
static final float HappyParam = 10.0;
static final float FearParam = 2.0;
static final float HappyCap = 10.0;
// static final float SadParam = .1;
static final float AngerParam = 2.0;
static final float AngryCap = 36.0;
static final int updateWindow = 2;

// Init Loop Vars
float t = 0.0;
int rowNum = 100;
Table table;
int maxRows;

void setup()
{
  size(1800, 900);
  frameRate(60);
  strokeWeight(2);
  stroke(255);
  noFill();

  // Import Table of Preproccessed motion Values
  table = loadTable("../sampleEmotionAvgsOut.csv", "header");
  maxRows = table.getRowCount();
}

void draw(){
  background(0);
  translate(width / 2, height / 2);

  EmotionOperator emotionOp = new EmotionOperator(table.getRow(rowNum));

  beginShape();
  
  for (float theta = PI/144; theta <= (15 * PI); theta += .01) 
  {
    float rad = r(theta,
      3, // a 
      3, // b 
      emotionOp.getAngryVal(), // m anger ++
      emotionOp.getHappyVal(), // bigger means rounder
      sin(t - (PI/2.0)), // n2 
      cos(t - (PI/2.0))  // n3
    );
    float x = rad * cos(theta) * 50;
    float y = rad * sin(theta) * 50;
    vertex(x, y);
    
  }
  
  endShape();

  // update time variable
  t += min(.5, max(.1, emotionOp.getFearVal()));
  
  if (t >= 2*PI)
  {
    t = 0;
  }

  saveFrame("output/line-######.png");
  if (t % updateWindow == 0)
  {
    // update
    emotionOp.printEmotionCalculations(rowNum);
    rowNum += 1;

    if (rowNum >= maxRows)
    {
      exit();
      // rowNum = 0;
    }
  }
}  

float r(float theta, float a, float b, float m, float n1, float n2, float n3)
{
  return pow(pow(abs(cos(m * theta / 4.0) / a), n2) +
            pow(abs(sin(m * theta / 4.0) / b), n3), -1.0 / n1);
}

class EmotionOperator
{
  float happyInput, fearInput, sadInput, angryInput;

  EmotionOperator(TableRow emotionRow)
  {
    happyInput = emotionRow.getFloat("Happy");
    fearInput = emotionRow.getFloat("Fear");
    sadInput = emotionRow.getFloat("Sad");
    angryInput = emotionRow.getFloat("Angry");
  }

  void printEmotionCalculations(int currentRow)
  {
    /*println("Current Row: " + str(currentRow));
    println("Happy Input: " + str(happyInput));
    println("Happy Op: " + str(getHappyVal()));
    println();*/
    println("Fear Input: " + str(fearInput));
    println("Fear Op: " + str(getFearVal()));
    println();
    /*println("Sad Input: " + str(sadInput));
    println("Sad Op: " + str(getSadVal()));
    println();
    println("Angry Input: " + str(angryInput));
    println("Angry Op: " + str(getAngryVal()));
    println();*/
    println();
  }

  float getHappyVal()
  {
    return specialSigmoid(((happyInput)/.25)+1.0, 10.0, 0.25); 
  }

  float getFearVal()
  {
    return fearInput -.1;
  }

  /*float getSadVal()
  {
    return SadParam * sadInput;
  }*/

  float getAngryVal()
  {
    return specialSigmoid((angryInput - .08) /.08, AngryCap, 0.5);
  }
}

float specialSigmoid(float inputValue, float customCap, float centerOffset)
{
  return ((1.0 / (1.0 + exp(-inputValue))) - centerOffset) * customCap;
}
