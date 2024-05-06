import java.lang.Math; 
import processing.core.PVector;
import java.util.ArrayList;

public class Edge implements Comparable<Edge>{
  
  public PVector p1, p2;
  public float size;
  
  public Edge() {
    p1=null;
    p2=null;
    size=0;
  }
  
  public Edge(PVector p1, PVector p2) {
    this.p1 = p1;
    this.p2 = p2;
    size=(float)Math.sqrt(Math.pow(p2.x-p1.x,2f)+Math.pow(p2.y-p1.y,2f));
  }  
  
  public int compareTo(Edge other){
    if(size<other.size)
      return -1; 
    
    if(size>other.size)
      return 1; 
    
    else
      return 0;
  }     
  
  public boolean isOpposite(Edge e){
    if(e.p1==p2 && e.p2==p1)
      return true;
    else
      return false;
  }
  
  public Edge GetOpposite(){
   return new Edge(p2,p1);    
  }
  

  @Override
  public boolean equals(Object a){
    boolean res= false;
    if(a!=null)
    {        
      if(a instanceof Edge)
      {     
        Edge other = (Edge)a;
        res =(p1.x == other.p1.x && p2.x == other.p2.x && p1.y == other.p1.y && p2.y == other.p2.y);
      }
    }
    return res;    
  }
}
  /*
  @Override
  public String toString()
  {
     return "Edge : "+p1.toString()+", "+p2.toString()+" size :"+size;     
  }*/
