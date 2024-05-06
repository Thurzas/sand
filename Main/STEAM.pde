public class STEAM extends Gas{

    byte or;
    byte og;
    byte ob;
   @Override   
   public void onSpawn(){
    float rand = random(10f);   
    or=(byte)(65+rand);
    og=(byte)(60+rand);
    ob=(byte)(65+rand);  
    r=or;
    g=og;
    b=ob;
    minDensity=20;
    friction=0.1;
    viscosity=0.1;
    heat=50+random(100);
   }
  @Override
  public boolean equals(Object o){
    if(o instanceof STEAM)
    {
        return true;
    }
    return false;
  }
  @Override
  public void behave(){
    super.behave();
    Cell l,ri,t,d;   
    l=component.get(Direction.LEFT);  
    ri=component.get(Direction.RIGHT);
    t=component.get(Direction.TOP);
    d=component.get(Direction.DOWN);
    if((ri!=null && ri.type instanceof WATER) ||
       (l!=null && l.type instanceof WATER) ||
       (t!=null && t.type instanceof WATER) ||
       (d!=null && d.type instanceof WATER))
    {  
      r=or;
      g=og;
      b=ob;
    }
    else if((ri!=null && ri.type instanceof STEAM) &&
       (l!=null && l.type instanceof STEAM) &&
       (t!=null && t.type instanceof STEAM) &&
       (d!=null && d.type instanceof STEAM))
    {
     r=or;
      g=og;
      b=ob;
    }
    else
    {
      r=0;
      g=0;
      b=0;      
    }    
    if(heat<=0)
      component.setType(new WATER());

  }
  @Override
  public boolean canMove(Cell B)
  {
    if(B==null)
      return false;
      
    if(B.equals(component))
      return true;
    if(!component.isFree(B.posInWorld))
    {
      return false;
    }
    
    if(B.type instanceof Fluid)
      return false;
    if(B.type instanceof STEAM)
      return false;
    if(B.type instanceof Solid)
      return false;
      
    if(B.type instanceof Immovable)
      return false;
    return true;
  }

    @Override
  public Element clone(){
    return new STEAM();
  }
}
