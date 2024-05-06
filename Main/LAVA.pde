public class LAVA extends Fluid
{
  @Override 
  public void onSpawn(){
    heat=5000;
    r=125;
    g=(byte)(random(125));
    b=35;
    viscosity=1;
    minDensity=15;
    maxDensity=30;
    friction=0.3;
  }
  
  @Override
  public void behave(){
    super.behave();
    g=(byte)(random(125));
    Cell d,r,l,t;
    d=component.get(Direction.DOWN);
    r=component.get(Direction.RIGHT);
    l=component.get(Direction.LEFT);
    t=component.get(Direction.TOP);
    //Heat(100);
    if(d!=null&& d.type instanceof Fluid && !(d.type instanceof LAVA))
    {
      d.type.Heat(100);
      heat-=5;
    }
    if(l!=null&& l.type instanceof Fluid && !(l.type instanceof LAVA))
    {
      l.type.Heat(100);
      heat-=5;                     
    }
    if(r!=null&& r.type instanceof Fluid && !(r.type instanceof LAVA))
    {
      r.type.Heat(100);
      heat-=5;
    }
    if(t!=null&& t.type instanceof Fluid && !(t.type instanceof LAVA))
    {
      t.type.Heat(100);   
      heat-=5;
    }
    if(heat<0)
      component.setType(new STONE());
  }  
  
    @Override
  public boolean equals(Object o){
    if(o instanceof LAVA)
    {
        return true;
    }
    return false;
  }
  
    @Override
  public Element clone(){
    LAVA res = new LAVA();
    return res;
  }
}
