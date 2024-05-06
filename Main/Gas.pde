public abstract class Gas extends Element
{
  int time=0;
  float viscosity;
  float h=16;
  float tspeed;
  float tlimit=1;
  float delay=100;
  @Override
  public void behave(){
    Cell tl,tr,l,r,t; 
    t=component.get(Direction.TOP);
    tl=component.get(Direction.TOPLEFT);
    tr=component.get(Direction.TOPRIGHT); 
    l=component.get(Direction.LEFT);
    r=component.get(Direction.RIGHT);
    if(canMove(t))
    {
      acceleration.y=-gravity.y;
    }
    else
    {
        float rand =random(1f);
        movementQuantity.x+= 1/viscosity + rand;
        if(rand>0.5)
        {

          if(canMove(r))
            acceleration.x=movementQuantity.x;              
          else if(canMove(l))
            acceleration.x=-movementQuantity.x;
          else if(canMove(tr))
            acceleration=new PVector(movementQuantity.x,movementQuantity.y);
          else if (canMove(tl))
            acceleration= new PVector(-movementQuantity.x,movementQuantity.y);              
        }
        else
        {
          if(canMove(l))
            acceleration.x=-movementQuantity.x;
          else if(canMove(r))
            acceleration.x=movementQuantity.x;
          else if(canMove(tl))
            acceleration=new PVector(-movementQuantity.x,movementQuantity.y);
          else if (canMove(tr))
            acceleration= new PVector(movementQuantity.x,movementQuantity.y);
        }      
       movementQuantity.x-=friction;
       movementQuantity.y+=friction;    
    }  //<>// //<>// //<>// //<>//
    heat-=getHeatDissipation(time++);
    acceleration.normalize();
    velocity.add(acceleration);
    velocity.limit(maxSpeed);  
    acceleration.mult(maxForce);  
    applyVelocity(); 
    lastPos=component.posInWorld;
    time++;
  }
  
  @Override
  public void Heat(float h){
    
  }
  
  public float getHeatDissipation(int tick){
    return tlimit/exp(delay/tick);
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

    if(B.type instanceof Solid)
      return false;
      
    if(B.type instanceof Immovable)
      return false;
    return true;
  }
}
