class Bubble
{
  float x, y;
  float noiseSeed;
  PVector centroid;
  color grayscale;
  
  Bubble(int xPos, int yPos, PVector blobCentroidPos, int gray)
  {
    x = xPos;
    y = yPos;
    centroid = blobCentroidPos;
    noiseSeed = random(0,100);
    grayscale = color(gray);
  }
  
  PVector getTangentPoint(float scale)
  {
    PVector centreToPos = new PVector(x-centroid.x, y-centroid.y);
    centreToPos.normalize();
    centreToPos.mult(scale);
    return PVector.add(new PVector(x,y),centreToPos);
  }
}
