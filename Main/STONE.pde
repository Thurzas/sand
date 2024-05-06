public class STONE extends Solid{
  @Override
  public void onSpawn(){
    friction=1.1;
    minDensity=8;
    int rand =(int)(90+random(10f));
    r=(byte)rand;
    g=(byte)rand;
    b=(byte)rand;
  }
  @Override
  public boolean equals(Object o){
    if(o instanceof STONE)
    {
      return true;
    }
      return false;
  }
  
  
  @Override
  public void behave(){
    super.behave();
    Cell u,ul,ur;
    boolean erode=false;
    u=component.get(Direction.TOP);
    ul=component.get(Direction.TOPLEFT);
    ur=component.get(Direction.TOPRIGHT); 
    if(u !=null)
      if(u.type instanceof WATER)
        erode=true;

    if(ul !=null)
      if(ul.type instanceof WATER)
        erode=true;

    if(ur !=null)
      if(ur.type instanceof WATER)
        erode=true;
        
    if(erode)
    {
      float r = random(1);
      if(r<0.003)
        component.setType(new SAND());
    }
  }
  @Override
  public boolean canMove( Cell B)
  {
    if(B==null)
      return false;
    if(!component.isFree(B.posInWorld))
    {
      return false;
    }
    
    if(B.equals(this.component))
      return true;
    if(B.type instanceof FIRE)
      return false;
    if(B.type instanceof Solid)
      return false;
      
    if(B.type instanceof ROCK)
      return false;
      
    return true;
  }
  
    @Override
  public Element clone(){
    return new STONE();
  }
}
