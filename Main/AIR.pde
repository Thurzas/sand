public class AIR extends Element{
  float limit=125;
  @Override  
  public void behave(){
/*    if(abs(heat)>100)
      heat=0;
    if(heat>0)
    {
      int ratio=(int)heat/2;
      r=(byte)(ratio);
      g=(byte)0;
      b=(byte)0;
      Cell d,r,l,t;
      d=component.get(Direction.DOWN);
      r=component.get(Direction.RIGHT);
      l=component.get(Direction.LEFT);
      t=component.get(Direction.TOP);
      float h=heat*0.4;
      if(heat>E)
        Heat(h);
    }    
    else if(r>0)
      r--;
*/
    lastPos=component.posInWorld;
    if(hasMoved())
      r=125;
    else
      r=0;
  }  
  @Override
  public void onSpawn(){
    r=0;
    g=0;
    b=0; 
    minDensity=0;
  }
  @Override
  public boolean equals(Object o){
    if(o instanceof AIR)
    {
      return true;
    }
    return false;
  }
  
  @Override
  public boolean canMove(Cell B)
  {
    return true;
  }
    @Override
  public Element clone(){
    return new AIR();
  }
}
