public abstract class Fluid extends Element
{
  int durability=10;
  int maxDurability=10;
  
  //HashMap<PVector,Cell>neighbors= new HashMap<PVector,Cell>();

  @Override
  public void onSpawn(){
    friction=0.1;
  }
  @Override
  public void behave(){
    Cell d,dl,dr,l,r,t;
    d=component.get(Direction.DOWN);
    l=component.get(Direction.LEFT);
    r=component.get(Direction.RIGHT);
    t=component.get(Direction.TOP); 
    dl=component.get(Direction.DOWNLEFT); 
    dr=component.get(Direction.DOWNRIGHT);
    if(canMove(d))
    {
      acceleration.add(gravity);
    }
    else
    {
      float rand =random(1f);
      int move = 1;
      if(rand>0.5)
      {
        if(canMove(r))
          acceleration=new PVector(move,0);
        else if(canMove(l))
          acceleration=new PVector(-move,0);
        else if(canMove(dr))
          acceleration=new PVector(move,gravity.y);
        else if(canMove(dl))
          acceleration=new PVector(-move,gravity.y);
      }
      else
      {
        if(canMove(l))
          acceleration=new PVector(-move,0);
        else if(canMove(r))
          acceleration=new PVector(move,0);
        else if(canMove(dl))          
          acceleration=new PVector(-move,gravity.y);
        else if(canMove(dr))
          acceleration=new PVector(move,gravity.y);
      }      
    }
    acceleration.add(component._v);
    acceleration.normalize();
    velocity.add(acceleration);
    velocity.limit(maxSpeed);  
    lastPos=component.posInWorld;
/*    if(!applyVelocity())
    {
      //velocity=new PVector();
      acceleration.x*=-0.25;
      acceleration.y*=0;
    }*/
    applyVelocity();
    acceleration.mult(maxForce); 
    component._v0=component._v;
    component._d0=component._d;
  }  


  @Override
  public boolean Move( Cell B){
     if(canMove(B)){         
      Element t = component.type;
      component.setType(B.type);
      B.setType(t);
      component.moved=true;
      B.moved=true;
      return true;
     }
     return false;
  }
  
    @Override
  public boolean canMove(Cell B)
  {
    if(B==null)
      return false;
      
    if(B.equals(this.component))
      return true;
    if(!component.isFree(B.posInWorld))
    {
      return false;
    }
    
    if(B.type instanceof Fluid || B.type instanceof Solid)
    {            
      if(B.type.density<density)
        return true; 
      else
        return false;
    }
    if(B.type instanceof FIRE)
      return false;
    
    
    if(B.type instanceof ROCK)
      return false;
    return true;
  }
}
