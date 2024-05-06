import processing.core.PVector;
import java.util.*;
public class Cell{
  public PVector posInWorld;
  public Element type;
  public boolean moved;
  public World world;
  PVector _v;
  PVector _v0;
  float _d;
  float _d0;
  public Cell(PVector posInWorld,World world){
    this.posInWorld=posInWorld;
    this.moved=false;
    this.world=world;
    setType(new AIR());
    _v = new PVector();
    _v0=new PVector();
    _d=type.minDensity;
    _d0=type.minDensity;
  }
  
  public void setType(Element Type){
    this.type = Type;
    type.setCell(this);
    Chunk c = getChunkFrom((int)posInWorld.x,(int)posInWorld.y);
    if(c!=null)
      c.setActive(true);
  }
  public Cell get(Direction dir)
  {
    PVector p = new PVector(posInWorld.x+dir.x,posInWorld.y+dir.y);
    if(isFree(p))
      return world.get((int)p.x,(int)p.y);
    else return null;
  }
  public boolean isFree(PVector p){
    if(p.x<0||p.y<0||p.x>=world.size.x||p.y>=world.size.y)
      return false;
      
    return true;
  }  
  
  public Chunk getChunkFrom(int x, int y){
     return world.getChunkFrom(x,y);
  }
  public Cell inMatrix(int x, int y){
    if(x>=0&&y>=0&&x<world.size.x&&y<world.size.y)
      return world.get(x,y);
    else
      return null;
  }
  
  @Override
  public boolean equals(Object o ){
    if(o instanceof Cell)
    {
      Cell c = (Cell)o;
      if(posInWorld.x==c.posInWorld.x&&posInWorld.y==c.posInWorld.y)       
        return true;
    }
    return false;
  }
  public HashMap<PVector,Cell>neighbors(int range, Element target){
    Filler f = new Filler(w,h,this,new Selector(target,this,mooreOrder(range)));
    f.Fill(this);
    while(!f.workComplete())
    {
      f.Work();
    }
    //println("count : " + f.count + "  filled : " + f.filled + " in list : " +((Selector)f.func).getTargets().size());
    return ((Selector)f.func).getTargets();
  }
  
  int mooreOrder(int range){
    return 1+range*2;
  }
  
 /* public HashMap<PVector,Cell> neighbors(int range,Element target){
    HashMap<PVector,Cell> neighbors=new HashMap<PVector,Cell>();

    HashMap<PVector,Cell> perimeter=perimeter(range);
    for(Map.Entry<PVector,Cell> p : perimeter.entrySet()){
      Cell c =p.getValue();
      HashMap<PVector,Cell> line = line(c.posInWorld,range,target);
      for(Map.Entry<PVector,Cell> l : line.entrySet()){
        neighbors.put(l.getKey(),l.getValue());
      }
    }
    return neighbors;
  }*/
  public HashMap<PVector,Cell> perimeter(int range){
    HashMap<PVector,Cell> cells=new HashMap<PVector,Cell>();
    Direction dir=Direction.LEFT;
    Cell c=inMatrix((int)posInWorld.x+range,(int)posInWorld.y+range);
    if(c!=null)
    {
      Cell curr=c.get(dir);
      for(int j=0;j<4;j++){
        for(int i =0;i<=range*2;i++)
        {
          if(curr!=null)
          {
            curr=c.get(dir);
            cells.put(c.posInWorld,c);
          }
          c=curr;
        }
        try
        {
          dir=Direction.rotate(dir,Direction.RIGHT);
        }
        catch(Exception e)
        {
          println("error in perimeter : " + e.getMessage());
        }
      }
    }
    return cells;
  }
  
  boolean constraint(PVector p,float range,Element target)
  {
    float dist = round(sqrt((p.x-posInWorld.x)*(p.x-posInWorld.x) + (p.y-posInWorld.y)*(p.y-posInWorld.y))); 
    Cell c =inMatrix((int)p.x,(int)p.y);
    if(dist<=range&&dist!=0&&c!=null&&c.type.equals(target)) 
      return true;
    
    return false;
  }
  public HashMap<PVector,Cell> line(PVector p,float range,Element target){
    HashMap<PVector,Cell> cells=new HashMap<PVector,Cell>();     
     int x1 =round(posInWorld.x);
     int x2 =round(p.x);
     int y1 =round(posInWorld.y);
     int y2 =round(p.y);
     int dx,dy,e;
     dx=x2-x1;
     dy=y2-y1;
     if(dx!=0)
     {
      if(dx>0)
      {
       if(dy!=0)
       {
         if( dy>0)
         {
           //valeur oblique dans le premier quadran.
           if(dx>=dy)
           {           
             //Vecteur diagonal ou oblique proche de l'horizontale, dans le premier octant
             e=dx;
             dy*=2;
             dx*=2;
             while(x1<=x2) // boucle horizontale
             {
               if(constraint(new PVector(x1,y1),range,target))        
                 cells.put(new PVector(x1,y1),inMatrix(x1,y1));
               e-=dy;
               if(e<0)
               {
                y1++;
                if(constraint(new PVector(x1,y1),range,target))        
                  cells.put(new PVector(x1,y1),inMatrix(x1,y1));
                e+=dx;
               }
               x1++;
             }
           }       
           else //oblique proche de la vertical du 2em octant
            {    
              e=dy;
              dy*=2;
              dx*=2;
              while(y1<=y2) // boucle  verticale
              {           
                if(constraint(new PVector(x1,y1),range,target))        
                  cells.put(new PVector(x1,y1),inMatrix(x1,y1));
                e-=dx;
                if(e<0)
                {
                 x1++;
                 if(constraint(new PVector(x1,y1),range,target))        
                   cells.put(new PVector(x1,y1),inMatrix(x1,y1));
                 e+=dy;
                }
                y1++;
              }        
            }         
         }
         else // dy<0 et dx >0
         {
           if(dx>=-dy) // diagonal ou oblique proche de l'horizontale du 8° octant
           {
             e=dx;
             dx*=2;
             dy*=2;
             while(x1<=x2) //horizontal
             {    
               if(constraint(new PVector(x1,y1),range,target))        
                 cells.put(new PVector(x1,y1),inMatrix(x1,y1));
               e+=dy;
               if(e<0)
               {
                 y1--;

                 if(constraint(new PVector(x1,y1),range,target))       
                   cells.put(new PVector(x1,y1),inMatrix(x1,y1));
                 e+=dx;
               }
               x1++;
             }
           }
           else //vecteur oblique proche de la verticale, 7em octant
           {
             e=dy;
             dx*=2;
             dy*=2;
             while(y1>=y2) //vertical
             {             
               if(constraint(new PVector(x1,y1),range,target))      
                 cells.put(new PVector(x1,y1),inMatrix(x1,y1));
               e+=dx;
               if(e>0)
               {
                 x1++; //diagonal
                 if(constraint(new PVector(x1,y1),range,target))        
                   cells.put(new PVector(x1,y1),inMatrix(x1,y1));
                 e+=dy;
               }
               y1--;
             }           
           }
         }
       }
       else // dy == 0
       {
         while(x1<=x2)
         {
           if(constraint(new PVector(x1,y1),range,target))      
             cells.put(new PVector(x1,y1),inMatrix(x1,y1));
           x1++;
         }         
       }
     }
     else //dx < 0
     {
       dy=y2-y1;
       if(dy!=0)
       {
         if(dy>0) // oblique 2° quadran
         {
           if(-dx>=dy) //diagonal ou oblique proche de l'horizontale du 4° octant
           {
             e=dx;
             dx*=2;
             dy*=2;
             while(x1>=x2){ //horizontal
               if(constraint(new PVector(x1,y1),range,target))        
                 cells.put(new PVector(x1,y1),inMatrix(x1,y1));
               e+=dy;
               if(e>=0)
               {
                 y1++; //diagonal
                 if(constraint(new PVector(x1,y1),range,target))       
                   cells.put(new PVector(x1,y1),inMatrix(x1,y1));
                 e+=dx;
               }
               x1--;
             }
           }
           else //oblique proche de la vertical du 3° octant
           {
             e=dy;
             dx*=2;
             dy*=2;
             while(y1<=y2){
               if(constraint(new PVector(x1,y1),range,target))        
                 cells.put(new PVector(x1,y1),inMatrix(x1,y1));
               e+=dx;
               if(e<=0)
               {
                 x1--;
                 if(constraint(new PVector(x1,y1),range,target))        
                   cells.put(new PVector(x1,y1),inMatrix(x1,y1));
                 e+=dy;
               }
               y1++;
             }             
           }
         }
         else //dy < 0 et dx <0
         {
           if(dx<=dy) // 5°octant
           {
             e=dx;
             dx*=2;
             dy*=2;
             while(x1>=x2) //horizontal
             {
               if(constraint(new PVector(x1,y1),range,target))        
                 cells.put(new PVector(x1,y1),inMatrix(x1,y1));
               e-=dy;
               if(e>=0)
               {
                 y1--; //diagonal
                 if(constraint(new PVector(x1,y1),range,target))        
                   cells.put(new PVector(x1,y1),inMatrix(x1,y1));
                 e+=dx;
               }
               x1--;
             }
           }
           else //6° octant
           {
             e=dy;
             dx*=2;
             dy*=2;
             while(y1>=y2){
               if(constraint(new PVector(x1,y1),range,target))       
                 cells.put(new PVector(x1,y1),inMatrix(x1,y1));
               e-=dx;
               if(e>=0)
               {
                 x1--;
                 if(constraint(new PVector(x1,y1),range,target))     
                   cells.put(new PVector(x1,y1),inMatrix(x1,y1));
                 e+=dy;
               }
               y1--;
             }
           }
         }         
       }
       else //dy = 0 et dx <0
       {
         while(x1>=x2)
         {
           if(constraint(new PVector(x1,y1),range,target))     
             cells.put(new PVector(x1,y1),inMatrix(x1,y1));
           x1--;           
         }
       }
     }
   }
   else
   {
     dy=y2-y1;
     if(dy!=0)
     {
       if(dy>0)
       {
         while(y1<=y2)
         {
           if(constraint(new PVector(x1,y1),range,target))       
             cells.put(new PVector(x1,y1),inMatrix(x1,y1));
           y1++;
         }
       }
       else
       {
         while(y1>=y2)
         {
           if(constraint(new PVector(x1,y1),range,target))     
             cells.put(new PVector(x1,y1),inMatrix(x1,y1));
           y1--;
         }
       }
      }
   }
   return cells;   
  }
}  
