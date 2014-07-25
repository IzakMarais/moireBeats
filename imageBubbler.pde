
StateMachine transitioner;

int NUM_BUBBLES = 900;

SoundAnalyzer sound;
Maxim maxim;

void setup()
{
  size(888, 500);
  
  transitioner = new StateMachine();

  maxim = new Maxim(this); 
  //sound = new SoundAnalyzer("Fiction_extract.wav");
  sound = new SoundAnalyzer("Fiction.wav");
  //sound = new SoundAnalyzer("mybeat.wav");
  
  noStroke();
}

void draw()
{
  sound.updateVisuals(); 

  fill(255);
  rect(0, 0, width, height);
    
  transitioner.updateState(); 
 
}

