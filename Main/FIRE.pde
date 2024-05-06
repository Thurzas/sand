public class FIRE extends Element
{
  boolean burned;
  int tick;
  @Override 
  public void onSpawn(){
    r=125;
    g=(byte)(random(125));
    b=35;
    heat=100;
  }
  
  @Override
  public void behave(){
    g=(byte)(random(125));
    Cell d,r,l,t;
    d=component.get(Direction.DOWN);
    r=component.get(Direction.RIGHT);
    l=component.get(Direction.LEFT);
    t=component.get(Direction.TOP);
    
    Heat(100);    
    if(tick==10)
      component.setType(new AIR());
      
    tick++;
  }  
  @Override
  public void Heat(float h){
        Cell l,r,t,d,tr,tl,dr,dl;
    float pwr=0.5;
    t=component.get(Direction.TOP);
    d=component.get(Direction.DOWN); 
    l=component.get(Direction.LEFT);
    r=component.get(Direction.RIGHT);
    tr=component.get(Direction.TOPRIGHT);
    tl=component.get(Direction.TOPLEFT);
    dl=component.get(Direction.DOWNLEFT);
    dr=component.get(Direction.DOWNRIGHT);
    if( t!= null)
    {
      t.type.heat+=h*pwr;

    }
    if( d!= null)
    {
      d.type.heat+=h*pwr;
    }
    if( l!= null)
    {
      l.type.heat+=h*pwr;

    }
    if( r!= null)
    {
      r.type.heat+=h*pwr;

    }
    if( dr!= null)
    {
      dr.type.heat+=h*pwr;

    } 
    if( tr!= null)
    {
      tr.type.heat+=h*pwr;

    }  
    if( tl!= null)
    {
      tl.type.heat+=h*pwr;

    } 
    if( tr!= null)
    {
      tr.type.heat+=h*pwr;

    }
    heat-=h/5;
  }
  @Override
  public boolean canMove(Cell B)
  {
    if(B==null)
      return false;
    if(!component.isFree(B.posInWorld))
    {
      return false;
    }

    if(B.type instanceof WATER)
      return false;

    if(B.type instanceof SAND)
      return false;
      
    if(B.type instanceof ROCK)
      return false;
      
    return true;  
  }
  
  @Override
  public Element clone(){
    return new FIRE();
  }
}
