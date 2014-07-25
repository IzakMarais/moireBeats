
class BlackBlobAnalyzer
{
  PImage blobImage;
  int threshold = 200;

  PVector topLeft;
  PVector bottomRight;

  BlackBlobAnalyzer(String imageFileName)
  {
    blobImage = loadImage(imageFileName);   
    blobImage.loadPixels();

    topLeft = new PVector(blobImage.width, blobImage.height);
    bottomRight = new PVector(0, 0);

    for (int x = 0; x< blobImage.width; x++)
    {
      for (int y = 0; y< blobImage.height; y++)
      {
        color colorAtXY = blobImage.pixels[y*blobImage.width + x];
        if (brightness(colorAtXY) < threshold)
        {
          bottomRight.x = max(x, bottomRight.x);
          bottomRight.y = max(y, bottomRight.y);

          topLeft.x = min(x, topLeft.x);
          topLeft.y = min(y, topLeft.y);
        }
      }
    } 

    bottomRight.x = mapImageXToCanvasX(bottomRight.x);
    bottomRight.y = mapImageYToCanvasY(bottomRight.y);

    topLeft.x = mapImageXToCanvasX(topLeft.x);
    topLeft.y = mapImageYToCanvasY(topLeft.y);
  }

  boolean isInBlob(int x, int y)
  {
    int blobImageX = (int) map(x, 0, width, 0, blobImage.width);
    int blobImageY = (int) map(y, 0, height, 0, blobImage.height);

    color colorAtXY = blobImage.pixels[blobImageY*blobImage.width + blobImageX];
    if (brightness(colorAtXY) < threshold)
      return true;

    return false;
  }

  PVector getTopLeft()
  {
    return topLeft;
  }

  PVector getBottomRight()
  {
    return bottomRight;
  }

  int getGrayAt(int x, int y)
  {
    int blobImageX = (int) map(x, 0, width, 0, blobImage.width);
    int blobImageY = (int) map(y, 0, height, 0, blobImage.height);

    color colorAtXY = blobImage.pixels[blobImageY*blobImage.width + blobImageX];
    return (int)brightness(colorAtXY);
  }

  PVector getBlobCentroid()
  {
    float x = 0;
    float y = 0;
    int darkPixelCount = 0;

    for (int iy = 0; iy<blobImage.height; iy++)
    {
      for (int ix = 0; ix<blobImage.width; ix++)
      {
        color c = blobImage.pixels[iy*blobImage.width + ix];
        if (brightness(c) < threshold)
        {
          x += ix;
          y += iy;
          darkPixelCount++;
        }
      }
    }

    x /= darkPixelCount;
    y /= darkPixelCount;

    x = mapImageXToCanvasX(x);
    y = mapImageYToCanvasY(y);

    return new PVector(x, y);
  }

  void drawImage()
  {
    image(blobImage, 0, 0, width, height);
  }

  float mapImageXToCanvasX(float x)
  {
    return  map(x, 0, blobImage.width, 0, width);
  }

  float mapImageYToCanvasY(float y)
  {
    return map(y, 0, blobImage.height, 0, height);
  }
}

