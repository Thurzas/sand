public class ROCK extends Immovable{
  @Override
  public void behave(){
  /*    Cell d,r,l,t;
      d=component.get(Direction.DOWN);
      r=component.get(Direction.RIGHT);
      l=component.get(Direction.LEFT);
      t=component.get(Direction.TOP);
      float h=heat*0.16;
      if(d!=null)
        d.type.Heat(h);
      if(l!=null)
        l.type.Heat(h);
      if(r!=null)
        r.type.Heat(h);
      if(t!=null)
        t.type.Heat(h);
      heat=0;*/
      lastPos=component.posInWorld;
    }
  @Override
  public void onSpawn(){
    r=125;
    g=125;
    b=125; 
  }
  @Override
  public boolean equals(Object o){
    if(o instanceof ROCK)
    {
      return true;
    }  
    return false;

  }
    
    @Override
  public Element clone(){
    return new ROCK();
  }
}
