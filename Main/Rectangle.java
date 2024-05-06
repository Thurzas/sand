import java.lang.Math; 
import processing.core.PVector;
import java.util.ArrayList;
import processing.core.PGraphics;
public class Rectangle
{
  PVector Coords;
  PVector size;
  int Rank;
  public Rectangle(PVector Coords, PVector size)
  {
    this.Coords=Coords;
    this.size=size;
  }  
  
   public int GetRanking()
   {
     return Rank;
   }
   public void SetRanking(int rank)
   {
     this.Rank=rank;
   }
  public PVector GetCenter(){
     return new PVector(Coords.x+size.x/2,Coords.y+size.y/2);
  }
  
  public PVector GetCoords()
  {
    return Coords;    
  }
  public PVector GetSize()
  {
    return size;    
  }
  
  public void SetSize(PVector p){
    this.size=p;
  }
  
  public void SetCoords(PVector p){
    this.Coords=p;
  }
  public boolean Contains(PVector item){
      return( item.x >= Coords.x &&
              item.x <= Coords.x+size.x&&
              item.y >= Coords.y &&
              item.y <= Coords.y + size.y);
  }
  
  public boolean Collide(Rectangle shape)
  {
     if(shape instanceof Rectangle)
     {
       Rectangle range = (Rectangle)shape;
        if((range.Coords.x > Coords.x + size.x)
        || (range.Coords.x + range.size.x < Coords.x) 
        || (range.Coords.y > Coords.y + size.y)
        || (range.Coords.y + range.size.y < Coords.y))
       {
           return false; 
       }
       else
       {
           return true;        
       }
     }
     else
       return false;
  }

  public void show(PGraphics ctx){
   ctx.noFill();
   // ctx.rectMode(PGraphics.CENTER);
   ctx.stroke(0,0,255);   
   ctx.rect(Coords.x,Coords.y,size.x,size.y);  
   //ctx.rectMode(PGraphics.CORNER);
  }
  @Override
  public String toString()
  {
    return "Rect : " + "@"+ Coords+ " size  :"+ size; 
  }
}
