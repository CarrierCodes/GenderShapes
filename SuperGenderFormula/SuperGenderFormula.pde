// Define Constants
static final float HappyParam = 1.0;
static final float FearParam = 4.0;
static final float SadParam = .1;
static final float AngerParam = 5.0;
static final int updateWindow = 2;

// Init Loop Vars
float t = 0.0;
int rowNum = 0;
Table table;
int maxRows;

void setup()
{
  size(900, 900);
  frameRate(60);
  strokeWeight(2);

  // Import Table of Preproccessed motion Values
  table = loadTable("../sampleEmotionAvgsOut.csv", "header");
  maxRows = table.getRowCount();
}

void draw(){
  background(255);
  translate(width / 2, height / 2);

  EmotionOperator emotionOp = new EmotionOperator(table.getRow(rowNum));

  beginShape();
  
  for (float theta = .0001; theta < 2 * PI; theta += .01)
  {
    float rad = r(theta,
      emotionOp.getFearVal(), // a fear--
      emotionOp.getFearVal(), // b fear --
      emotionOp.getAngryVal(), // m anger ++
      emotionOp.getHappyVal(), 
      sin(t) * .5 + .5, // n2 happy means in sync
      cos(t) * .5 + .5  // n3
    );
    float x = rad * cos(theta) * 50;
    float y = rad * sin(theta) * 50;
    vertex(x, y);
    
  }
  
  endShape();

  // update time variable
  t += emotionOp.getSadVal();
  if (t >= 2*PI)
  {
    t = 0;
  }

  // saveFrame("output/line-######.png");
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
            pow(abs(sin(m * theta / 4.0) / b), n3), -1 / n1);
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
    println("Current Row: " + str(currentRow));
    println("Happy Input: " + str(happyInput));
    println("Happy Op: " + str(getHappyVal()));
    println();
    println("Fear Input: " + str(fearInput));
    println("Fear Op: " + str(getFearVal()));
    println();
    println("Sad Input: " + str(sadInput));
    println("Sad Op: " + str(getSadVal()));
    println();
    println("Angry Input: " + str(angryInput));
    println("Angry Op: " + str(getAngryVal()));
    println();
    println();
  }

  float getHappyVal()
  {
    return HappyParam * happyInput; 
  }

  float getFearVal()
  {
    return 4.0 - FearParam * fearInput;
  }

  float getSadVal()
  {
    return SadParam * sadInput;
  }

  float getAngryVal()
  {
    return 3.0 + AngerParam * angryInput;
  }
}


