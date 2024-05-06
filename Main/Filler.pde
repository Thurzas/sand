import java.util.*;
public class Filler<T>{
 LinkedList<Cell> queue;
 boolean[][] visited;
 int filled=0;
 //int [] dx = {0,   1,  1, 1, 0, -1, -1, -1};
 //int [] dy = {-1, -1,  0, 1, 1, 1, 0, -1};
 int [] dx = {0,   1,  0, -1 };
 int [] dy = {-1, 0,  1, 0 };
 int w;
 int h;
 int count=0;
 boolean vertical;
 boolean horizontal;
 
 public java.util.function.Function func;
 public Filler(int w, int h,Cell c, java.util.function.Function<Cell,T> func){
   queue = new LinkedList<Cell>();   
   visited = new boolean[h][w];
   this.w=w;
   this.h=h;
   this.func=func;
   this.count=0;
   Fill(c);
   vertical=false;
   horizontal=false;
 }
 
 public Filler(int w, int h,Cell c,Element target,Element newtype){
   queue = new LinkedList<Cell>();   
   visited = new boolean[h][w];
   this.w=w;
   this.h=h;
   this.func = new DefaultFunct(target,newtype);
   Fill(c);
 }
 public void Work(){
   if(queue.size()>0)
   {     
     //Cell c = (Cell)queue.get(0);
     Cell c = queue.peek();
     if(c!=null)
     {       
       Fill(c);
       count++;
     }
     //println(queue.size());
     queue.remove();
   }
 }
 
 public void SetVerticalOnlySpread(boolean b){
  if(b)
  {
    vertical=true;
    horizontal=false;
  }
}

public void SetHorizontalOnlySpread(boolean b){
  if(b)
  {
    horizontal=true;
    vertical=false;
  }
}

 public boolean workComplete(){
   if(queue.size()>0)
     return false;
   
   println(count+ " " + filled);
   return true;
 }
 public void Fill(Cell curr)
 {
   if( curr==null || curr.posInWorld.x<0 || curr.posInWorld.y<0 || curr.posInWorld.x >= w || curr.posInWorld.y >= h  || visited[(int)curr.posInWorld.y ][(int)curr.posInWorld.x])
     return;
     
    if(func.apply(curr.type)!=null)
    {    
      filled++;
      if(vertical)
      {
        if(horizontal)
        {
          System.out.println("Something went wrong : horizontal true as vertical param");
        }
        else
        {
          Cell t = curr.inMatrix((int)curr.posInWorld.x,(int)curr.posInWorld.y-1);
          Cell d = curr.inMatrix((int)curr.posInWorld.x,(int)curr.posInWorld.y+1);
          if(t!=null&&!visited[(int)t.posInWorld.y ][(int)t.posInWorld.x])
            queue.add(t);
          if(d!=null&&!visited[(int)d.posInWorld.y ][(int)d.posInWorld.x])
            queue.add(d);            
          }        
      }
      else if(horizontal)
      {
        if(vertical)
        {
          System.out.println("Something went wrong : horizontal true as vertical param");
        }
        else
        {
          Cell l = curr.inMatrix((int)curr.posInWorld.x-1,(int)curr.posInWorld.y);
          Cell r = curr.inMatrix((int)curr.posInWorld.x+1,(int)curr.posInWorld.y);
          if(l!=null&&!visited[(int)l.posInWorld.y ][(int)l.posInWorld.x])
            queue.add(l);
          if(r!=null&&!visited[(int)r.posInWorld.y ][(int)r.posInWorld.x])
            queue.add(r);            
        }       
      }
      else
      {
        for(int  i=0;i<dx.length;i++){
          Cell c = curr.inMatrix((int)curr.posInWorld.x+dx[i],(int)curr.posInWorld.y+dy[i]);
          if(c!=null&&!visited[(int)c.posInWorld.y ][(int)c.posInWorld.x])
            queue.add(c);
        }
      }
    }
    visited[(int)curr.posInWorld.y ][(int)curr.posInWorld.x]=true;
  }
}

public class DefaultFunct implements java.util.function.Function<Main.Element,Main.Element>
  {
    Main.Element target;
    Main.Element change;
    public DefaultFunct(Element target, Main.Element change){
      this.target=target;
      this.change=change;
    }
    @Override
    public Main.Element apply(Element e)
    {
      if(!(e.equals(target))){
         //curr.setType(new WATER());
         return null;
      }
      else
      {
        e.component.setType(change);
        return change;
      }
    }
 }
 
public class Selector implements java.util.function.Function<Main.Element,HashMap<PVector,Cell>>
  {
    Main.Element targetType;
    int dist;
    HashMap<PVector,Cell> targets;
    Cell origin;
    public Selector(Element target){      
      this.targetType=target;
      this.dist=-1;
      targets =new HashMap<PVector,Cell>();
    }
    public Selector(Element target,Cell origin,int dist){  
      this.origin=origin;
      this.dist=dist;
      this.targetType=target;
      targets =new HashMap<PVector,Cell>();
    }
    @Override
    public HashMap<PVector,Cell> apply(Element e)
    {
      if(dist==-1){
        if(e.equals(targetType)){
          targets.put(e.component.posInWorld,e.component);
        }
        else
         return null;
      }
      else
      {
        if(round(e.component.posInWorld.dist(origin.posInWorld))<dist)
        {
          if(!(e.equals(targetType))){
             //curr.setType(new WATER());
             return null;
          }
          else
          {
            targets.put(e.component.posInWorld,e.component);
            return targets;
          }
        }
        else
          return null;
      }
    return targets;
    }
    
    public HashMap<PVector,Cell> getTargets(){
      return targets;
    }
  }
 
 public class DensityCalc implements java.util.function.Function<Main.Element,Integer>
  {
    Main.Element targetType;
    int density;
    Cell origin;
    public DensityCalc(Element target){      
      this.targetType=target;
    }
    public DensityCalc(Element target,Cell origin,int density){  
      this.origin=origin;
      this.density=density;
      this.targetType=target;
    }
    @Override
    public Integer apply(Element e)
    {
      if(!(e.equals(targetType))){
         return null;
      }
      else
      {
        density++;
        return density;
      }
    }
    
    public int getDensity(){
      return density;
    }
  }
