class TransitionState
{
  Bubble[] bubbles; 
  BlackBlobAnalyzer blob;

  PVector blobCenter;

  TransitionState(String imageFileName)
  {
    bubbles = new Bubble[NUM_BUBBLES];

    blob = new BlackBlobAnalyzer(imageFileName);
    blobCenter = blob.getBlobCentroid();
  }

  PVector getTangent(int bubbeNum, float scale)
  {
    return bubbles[bubbeNum].getTangentPoint(scale);
  }
}


class RandomPositionState extends TransitionState
{
  RandomPositionState(String imageFileName)  
  {   
    super(imageFileName);
    int bubblesInBlob = 0;

    while (bubblesInBlob < NUM_BUBBLES)
    {
      int x = (int) random(0, width);
      int y = (int) random(0, height);
      if (blob.isInBlob(x, y))
      {
        bubbles[bubblesInBlob] = new Bubble(x, y, blobCenter, blob.getGrayAt(x, y));        
        bubblesInBlob++;
      }
    }
  }
}

class RectMoirePositionState extends TransitionState
{
  boolean[] usedIndices;
  
  RectMoirePositionState(String imageFileName)  
  {
    super(imageFileName);
    
    PVector topLeft = blob.getTopLeft();
    PVector bottomRight = blob.getBottomRight();
    
    int bubblesInBlob = 0;
    int upperBound = ceil (sqrt (NUM_BUBBLES));
    
    initUsedIndices();
    
    for (int ix = 0; ix < upperBound ; ix ++)
    {
      for (int iy = 0; iy < upperBound; iy ++)
      {
        int x = (int)map(ix, 0, upperBound, topLeft.x, bottomRight.x);
        int y = (int)map(iy, 0, upperBound, topLeft.y, bottomRight.y);
       
        bubbles[getRandomUnusedIndex()] = new Bubble(x, y, blobCenter, blob.getGrayAt(x, y));        
        bubblesInBlob++;  
        if (bubblesInBlob >= NUM_BUBBLES)  
          break;
      }
      if (bubblesInBlob >= NUM_BUBBLES)  
        break;
    }
  }
  
  void initUsedIndices()
  {
    usedIndices = new boolean[NUM_BUBBLES];
    for (int i = 0; i<NUM_BUBBLES; i++)
    {
      usedIndices[i] = false;
    }
    
  }
  
  int getRandomUnusedIndex()
  {
    int index = (int)random(0,NUM_BUBBLES);
    while(usedIndices[index])
    {
      index = (int)random(0,NUM_BUBBLES);
    }
    
    usedIndices[index] = true;
    
    return index;
  }
}

