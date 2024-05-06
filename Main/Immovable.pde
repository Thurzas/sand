public abstract class Immovable extends Solid
{
  @Override
  public void behave(){
    //do nothing (immovable)
    
  }
  
  @Override
  public boolean canMove(Cell B)
  {
    return false;
  }
}
