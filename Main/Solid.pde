public abstract class Solid extends Element{
  float friction;
  boolean isFreeFalling;

  @Override
  public void onSpawn(){
    maxDensity=51;
  }
  @Override
  public void behave(){
    Cell d,dl,dr;
    d=component.get(Direction.DOWN);
    dl=component.get(Direction.DOWNLEFT);
    dr=component.get(Direction.DOWNRIGHT); 
    if(canMove(d))
    {
      acceleration.x=0;
      acceleration.add(gravity);
    }
    else
    {
        float rand = random(2f);
        movementQuantity.x+=rand;
        if(rand>1f)
        {
          if(canMove(dr))
            acceleration.x=movementQuantity.x;
          else if(canMove(dl))
            acceleration.x=-movementQuantity.x;
        }
        else
        {
          if(canMove(dl))          
            acceleration.x=-movementQuantity.x;
          else if(canMove(dr))
            acceleration.x=movementQuantity.x;
        }      
       movementQuantity.x-=friction;
    }
    acceleration.normalize();
    lastPos=component.posInWorld;
    velocity.add(acceleration);
    velocity.limit(maxSpeed);  
    applyVelocity();
    acceleration.mult(maxForce);
    CheckActivity();
  }  
  
  void setActive(boolean b)
  {
    isFreeFalling=b;
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
  public boolean canMove(Cell B){
    
    if(B==null)
      return false;
    if(!component.isFree(B.posInWorld))
    {
      return false;
    }
    if(B.equals(this.component))
      return true;
      
    if(B.type instanceof Fluid)    
      if(B.type.density<=density)
        return true;
      else
        return false;
    if(B.type instanceof Solid)
      return false;
      
    return true;
  }
}
