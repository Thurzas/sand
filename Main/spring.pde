public class spring{
  Fluid a;
  Fluid b;
  float L; //rest length
  PVector v;
  float k; //stiffness
  public spring(Fluid a, Fluid b, float L,float k)
  {
     this.a=a;
     this.b=b;
     this.L=L;
     v=new PVector(b.component.posInWorld.x-a.component.posInWorld.x,b.component.posInWorld.y-a.component.posInWorld.y);    
  }
  
  public PVector getDisplacement(float h)
  {
    float Dist = sqrt(v.x*v.x + v.y*v.y);
    float D= k*(1-L/h)*(L-Dist);
    PVector vv= v.normalize();
    vv.mult(D);
    //vv.mult(D);
    return vv;
  }
}
