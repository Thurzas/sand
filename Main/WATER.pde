public class WATER extends Fluid{
  byte originblue;
  @Override
  public void onSpawn(){
    r=0;
    g=0;
    b=(byte)(110+random(15));
    viscosity=0.2;
    minDensity=5;
    maxDensity=15;
    originblue=b;
    friction=0.2;
  }
  @Override
  public void behave(){
    super.behave();
    b=(byte)(50+(density*0.2));
    if(heat>30)
    {
      component.setType(new STEAM());
    }
    if(heat>0)
    heat--;
    Cell l,ri,t,d;      
    l=component.get(Direction.LEFT);  
    ri=component.get(Direction.RIGHT);
    t=component.get(Direction.TOP);
    d=component.get(Direction.DOWN);

    
    if((ri!=null && ri.type instanceof AIR) ||
       (l!=null && l.type instanceof AIR) ||
       (t!=null && t.type instanceof AIR) ||
       (d!=null && d.type instanceof AIR))
    {
      if(canMove(d)){
        r=(byte)100;
        g=(byte)100;
        b=(byte)125;
      }
    }
    else
      {
        r=0;
        g=0;
        b=originblue;
      } 
      
/*
    if(!hasMoved())
    {
      r=(byte)125;
      g=0;
      b=0;
    }*/
  }
  @Override
  public boolean equals(Object o){
    if(o instanceof WATER)
    {
        return true;
    }
    return false;
  }
  
    @Override
  public Element clone(){
    WATER res = new WATER();
    return res;
  }
  
    @Override
  public void Heat(float h)
  {
    Cell l,r,t,d;
    t=component.get(Direction.TOP);
    d=component.get(Direction.DOWN); 
    l=component.get(Direction.LEFT);
    r=component.get(Direction.RIGHT);
    
    if(t!=null)
    {
      if( t.type.heat>h)
        t.type.heat-=h;
      else
        t.type.heat=0;
        
    }
    
    if(d!=null)
    {
      if(d.type.heat>h)
        d.type.heat-=h;
      else
        d.type.heat=0;
    }
    
    if(l!=null)
    {
      if( l.type.heat>h)
        l.type.heat-=h;
      else    
        l.type.heat=0;
    }
    
    if(r!=null)
    {
      if( r.type.heat>h)
        r.type.heat-=h;
      else
        r.type.heat=0;
    }
   heat+=h;
  }
}
