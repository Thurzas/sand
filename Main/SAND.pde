public class SAND extends Solid{
  @Override
  public void onSpawn(){
    friction=0.6;
    minDensity=6;
    //maxDensity=15;
    r=(byte)(110+random(15));    
    g=(byte)(110+random(15));
    b=0; 
  }
  
  @Override  
  public boolean equals(Object o){
    if(o instanceof SAND)
    {
      return true;
    }
      return false;
  }

    @Override
  public Element clone(){
    return new SAND();
  }
}
