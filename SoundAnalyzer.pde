

class SoundAnalyzer
{
  int ellipseSize;
  int baseSize = 10;
  float tInc;
  float tIncBase = 0.003;
  float offSetSize; 

  boolean varyingSize;
  boolean varyingSpeed;
  boolean varyingOffset;  

  AudioPlayer player;

  float avgPower;
  float bassPower;
  
  float amplifyFactor;


  SoundAnalyzer(String fileName)
  {
    player = maxim.loadFile(fileName);
    player.setAnalysing(true);

    varyingOffset = false;
    varyingSize = false;
    varyingSpeed = true;
    amplifyFactor = 0;
  }

  void updateVisuals()
  {
    player.play();

    avgPower = player.getAveragePower();
    avgPower = map(avgPower, 0.15, 0.3, 0, 1);
    avgPower = constrain(avgPower,-1,2);
    //println(avgPower);
    
    int numSpectralBands = 0;
    bassPower = 0;
    float[] spec = player.getPowerSpectrum();
    //println("spec length:"+spec.length);
    for(int i = 0; i<(spec.length/50); i++)
    {
      numSpectralBands++;
      bassPower += spec[i];
    }
    bassPower /= numSpectralBands;
    bassPower = map(bassPower, 0.25, 0.5, 0, 1);
    bassPower = constrain(bassPower,-1,2);
    println("BASS:"+bassPower);
    
    float largeEffectBassPower = map(bassPower, 0.3, 0.7, 0, 1);
    largeEffectBassPower = constrain(largeEffectBassPower,-1,2);
    
    bassPower = bassPower*(1-amplifyFactor)+largeEffectBassPower*amplifyFactor;
    

    updateSize();    
    updateSpeed();
    updateOffset();
  }

  void updateSize()
  {
    if (varyingSize)
    {
      ellipseSize = (int) (baseSize*bassPower + baseSize/2);
    } else
    {
      ellipseSize = baseSize;
    }
  }

  void updateSpeed()
  {
    if (varyingSpeed)
    {
      tInc = tIncBase*bassPower;      
    } else
    {
      tInc = tIncBase/3.0;
    }
  }

  void updateOffset()
  {
    if (varyingOffset)
    {
      offSetSize = avgPower*0.05;
      //println(offSetSize);
    } else
    {
      offSetSize = 0;
    }
  }
  
  int getOffset(float seed)
  {    
    return (int)(200.0*(noise(seed+sound.offSetSize)-noise(seed)));
  }
}

