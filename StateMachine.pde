class StateMachine
{
  int NUM_STATES = 9;
  StateDrawer drawer;
  TransitionState posStates[];

  float t = 0;
  int currentFinalState;
  float totalT;
  float lastToggleT;

  boolean isMovingBetweenPositionStates;

  StateMachine()
  {
    posStates = new TransitionState[NUM_STATES];
    posStates[0] = new RectMoirePositionState("magdaleen.JPG");
    posStates[1] = new RectMoirePositionState("vision.jpg");
    posStates[2] = new RandomPositionState("roman2.jpg");
    posStates[3] = new RectMoirePositionState("ouma.JPG");
    posStates[4] = new RectMoirePositionState("vision2.jpg");
    posStates[5] = new RectMoirePositionState("amanda.JPG");
    posStates[6] = new RandomPositionState("seperate.jpg");
    posStates[7] = new RectMoirePositionState("portrait2.JPG");
    posStates[8] = new RectMoirePositionState("bed.JPG");

    drawer = new StateDrawer(posStates[0]);
    drawer.setNextPosState(posStates[1], random(50, 150));

    currentFinalState = 1;
    isMovingBetweenPositionStates = false;
    totalT = 0;
    lastToggleT = 0;
  }

  void updateState()
  {
    drawer.drawTransition(t);
    if (isMovingBetweenPositionStates)
    {
      t += sound.tInc;
    } else
    {
      t = abs(sound.tInc*50);
    }

    totalT += sound.tInc;

    if (t<0)
      t = 0;

    //println(t);

    if (t>=1)
    {
      currentFinalState += 1;
      currentFinalState = currentFinalState%NUM_STATES;

      drawer.setNextPosState(posStates[currentFinalState], random(50, 150));      
      t = 0;
    }
    
    sound.amplifyFactor = getAmplifyFactor(t);

    if (totalT-lastToggleT > 1)
    {
      lastToggleT = totalT;

      toggleSize();
      toggleMovingBetweenPositionStates();
      toggleOffset();
      ensureSoundHasEffect();
    }
  }

  void toggleMovingBetweenPositionStates()
  {    
      isMovingBetweenPositionStates = !isMovingBetweenPositionStates;
  }

  void toggleSize()
  {
    if (random(0, 1) > 0.5)
      sound.varyingSize = !sound.varyingSize;
  }

  void toggleSpeed()
  {
    if (random(0, 1) > 0.5)
      sound.varyingSpeed = !sound.varyingSpeed;

    if (sound.varyingSpeed)
      toggleMovingBetweenPositionStates();
    else
      isMovingBetweenPositionStates = true;
  }

  void toggleOffset()
  {
    if (random(0, 1) > 0.2)
      sound.varyingOffset = true;
    else
      sound.varyingOffset = false;
  }

  void ensureSoundHasEffect()
  {
    if (!sound.varyingOffset && !sound.varyingSize)
      sound.varyingOffset = true;
  }
  
  float getAmplifyFactor(float t)
  {
    if (t<0.5)
      return t*2;
    else
      return (1-t)*2;
  }
}

