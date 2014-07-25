class StateDrawer
{
  TransitionState startPos;
  TransitionState nextPos;
  PVector[] startTangents;
  PVector[] endTangents;

  StateDrawer(TransitionState startPosState)
  {
    startPos = startPosState;   
    startTangents = new PVector[NUM_BUBBLES];
    endTangents = new PVector[NUM_BUBBLES];
  }

  void setNextPosState(TransitionState state, float transitionSize)
  {
    if (nextPos != null)
    {
      startPos = nextPos;
    }
    
    nextPos = state;
    for (int i = 0; i<NUM_BUBBLES; i++)
    {
      startTangents[i] = startPos.getTangent(i, transitionSize);
      endTangents[i] = nextPos.getTangent(i, transitionSize);
    }
  }

  void drawTransition(float t)
  {
    float cosArg = (1-t)*PI;
    float bezierArg = cos(cosArg)*0.5+0.5;
    //println("bezierArg"+bezierArg);
    for (int i = 0; i<NUM_BUBBLES; i++)
    {
      Bubble startBub = startPos.bubbles[i];
      Bubble endBub = nextPos.bubbles[i];
      float xPos = bezierPoint(startBub.x, startTangents[i].x, endTangents[i].x, endBub.x, bezierArg);
      float yPos = bezierPoint(startBub.y, startTangents[i].y, endTangents[i].y, endBub.y, bezierArg);
      
      color gray = lerpColor(startBub.grayscale, endBub.grayscale, bezierArg);


      xPos += sound.getOffset(startBub.noiseSeed);      
      yPos += sound.getOffset(endBub.noiseSeed);
      //fill(gray);
      fill(0);
      float brightnessSacle = map(brightness(gray),0,225,1,0);
      brightnessSacle = constrain(brightnessSacle,0,1);
      float transitionScale = scaleSizeByT(t);
      float ellipseSizeScale = brightnessSacle*transitionScale;
      
      ellipse(xPos, yPos, sound.ellipseSize*ellipseSizeScale, sound.ellipseSize*ellipseSizeScale);
    }
  }
  
  float scaleSizeByT(float t)
  {
    if (t<0.5)
      return 1.0+t;
    else
      return 1.0+abs(1.0-t);
  }
}

