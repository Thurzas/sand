public class OIL extends Fluid
{
  @Override
  public void onSpawn(){
    r=57;
    g=57;
    b=57; 
    viscosity=1;
    minDensity=1;
    friction=0.3;
  }
  @Override 
  public void Heat(float h){
    heat+=h;
    if(heat>30)
      component.setType(new FIRE());
  }
  @Override
  public boolean equals(Object o){
    if(o instanceof OIL)
    {
      return true;
    }
    return false;
  }
    
    @Override
  public Element clone(){
    return new OIL();
  }
}
