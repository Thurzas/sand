public class DIRT extends Solid{
  @Override
  public void onSpawn(){
    friction=.8;
    minDensity=2;
    r=(byte)(65+random(10f));
    g=(byte)(40+random(10f));
    b=(byte)(15+random(10f));
  }
  @Override
  public boolean equals(Object o){
    if(o instanceof DIRT)
    {
      return true;
    }
      return false;
  }
    
    @Override
  public Element clone(){
    return new DIRT();
  }
}
