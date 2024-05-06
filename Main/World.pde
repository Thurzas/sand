public class World {
  public Chunk[][] grid;
  PVector ChunkSize=new PVector(16,16);
  ArrayList<Tree> trees;
  public int callInspector;
  int tick;
  int H;
  int W;
  PVector size;
  final float dt=0.1;
  public World(int w, int h){
    size=new PVector(w,h);
    W=(int)(w/ChunkSize.x) +1;
    H=(int)(h/ChunkSize.y) +1;
    grid=new Chunk[H][W];
    grid = new Chunk[H][W];
    for(int y = 0; y <  H; y++){
      for(int x = 0; x< W; x++){
          grid[y][x]=new Chunk(new PVector(x,y),ChunkSize,this);
          //println(grid[y][x]);
      }
    }
    //println("Chunks : " + grid[0].length*grid.length);
    println("size  " + size);
  }

  public void Update(){
    callInspector=0;
    //dens_step();
    //vel_step();
      for(int y = (int)H-1; y>=0 ; y--){
        for(int x = (int)W-1; x>=0; x--){
        grid[y][x].Update();
      }
    }    
    //println("Updated : "+callInspector + " fps : " + frames);
  }

  public void draw(PGraphics ctx,boolean rect){    
  //draw world
   ctx.beginDraw();
   ctx.loadPixels();
   for(int y = 0; y < h; y++){
    for(int x = 0; x< w; x++){
      Element type=get(x,y).type;
      ctx.pixels[x+y*w]=color(type.r*2,type.g*2,type.b*2);
    }
   }
   
   if(rect)
   {     
     for(int y = 0; y <  H; y++){
      for(int x = 0; x< W; x++){
        if(grid[y][x].active)
        {
          PVector p1,p2,p3,p4;
          p1=grid[y][x].localToWorld(grid[y][x].pos);
          p2=grid[y][x].localToWorld(new PVector(grid[y][x].size.x+grid[y][x].pos.x, grid[y][x].pos.y));
          p3=grid[y][x].localToWorld(new PVector(grid[y][x].size.x+grid[y][x].pos.x, grid[y][x].pos.y+grid[y][x].size.y));
          p4=grid[y][x].localToWorld(new PVector(grid[y][x].pos.x, grid[y][x].pos.y+grid[y][x].size.y));
          ArrayList<PVector> l1=line(p1,p2);
          ArrayList<PVector> l2=line(p2,p3);
          ArrayList<PVector> l3=line(p3,p4);
          ArrayList<PVector> l4=line(p4,p1);
          for(PVector p : l1){
            if(p.x<w && p.y<h)            
              ctx.pixels[(int)p.x+(int)p.y*w]=color(0,255,0);
          }
          for(PVector p : l2){
            if(p.x<w && p.y<h)
              ctx.pixels[(int)p.x+(int)p.y*w]=color(0,255,0);
          }
          for(PVector p : l3){
            if(p.x<w && p.y<h)
              ctx.pixels[(int)p.x+(int)p.y*w]=color(0,255,0);
          }
          for(PVector p : l4){
            if(p.x<w && p.y<h)
              ctx.pixels[(int)p.x+(int)p.y*w]=color(0,255,0);
          }
        }
      }
     }
   }
   ctx.updatePixels();
   ctx.endDraw();
   scale(rez);
   image(ctx,0,0);    
  }
  public ArrayList<PVector> line(PVector a,PVector p){
    ArrayList<PVector> cells=new ArrayList<PVector>();     
     int x1 =round(a.x);
     int x2 =round(p.x);
     int y1 =round(a.y);
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
                     
               cells.add(new PVector(x1,y1));
               e-=dy;
               if(e<0)
               {
                y1++;
  
                cells.add(new PVector(x1,y1));
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
                      
                  cells.add(new PVector(x1,y1));
                e-=dx;
                if(e<0)
                {
                 x1++;
                       
                   cells.add(new PVector(x1,y1));
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
                     
                 cells.add(new PVector(x1,y1));
               e+=dy;
               if(e<0)
               {
                 y1--;

                      
                   cells.add(new PVector(x1,y1));
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
                   
                 cells.add(new PVector(x1,y1));
               e+=dx;
               if(e>0)
               {
                 x1++; //diagonal
                       
                   cells.add(new PVector(x1,y1));
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
               
             cells.add(new PVector(x1,y1));
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
                     
                 cells.add(new PVector(x1,y1));
               e+=dy;
               if(e>=0)
               {
                 y1++; //diagonal
                      
                   cells.add(new PVector(x1,y1));
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
                     
                 cells.add(new PVector(x1,y1));
               e+=dx;
               if(e<=0)
               {
                 x1--;
                       
                   cells.add(new PVector(x1,y1));
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
                     
                 cells.add(new PVector(x1,y1));
               e-=dy;
               if(e>=0)
               {
                 y1--; //diagonal
                       
                   cells.add(new PVector(x1,y1));
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
                    
                 cells.add(new PVector(x1,y1));
               e-=dx;
               if(e>=0)
               {
                 x1--;
                    
                   cells.add(new PVector(x1,y1));
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
              
             cells.add(new PVector(x1,y1));
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
                
             cells.add(new PVector(x1,y1));
           y1++;
         }
       }
       else
       {
         while(y1>=y2)
         {
              
             cells.add(new PVector(x1,y1));
           y1--;
         }
       }
      }
   }
   return cells;   
  }

  public Chunk getChunk(int x,int y){
    return grid[y][x];
  }
  public Chunk getChunkFrom(int x, int y){
    int X,Y;
    X=x/(int)ChunkSize.x;
    Y=y/(int)ChunkSize.y;
    return grid[Y][X];
  }
  public Cell get(int x, int y){
    int X,Y;
    X=x/(int)ChunkSize.x;
    Y=y/(int)ChunkSize.y;
    return grid[Y][X].get((int)(x-X*ChunkSize.x),(int)(y-Y*ChunkSize.y));
  } 
  
  void diffuseD ( )
  {      
    float diff=1;
    float a=dt*diff*size.x*size.y;
    for ( int k=0 ; k<20 ; k++ ) {
      for ( int i=1 ; i<=size.y ; i++ ) {
        for ( int j=1 ; j<=size.x ; j++ ) {
          Cell c = get(i,j);
          if(c!=null)
          {
            Cell t=c.get(Direction.TOP);
            Cell d=c.get(Direction.DOWN);
            Cell l=c.get(Direction.LEFT);
            Cell r=c.get(Direction.RIGHT);    
            if(t!=null&&d!=null&&l!=null&&r!=null)
              c._d = (c._d0 + a*(l._d + r._d + d._d + t._d) )/(1+4*a);
          }
           //(x0[IX(i,j)] + a*(x[IX(i-1,j)]+x[IX(i+1,j)]+x[IX(i,j-1)]+x[IX(i,j+1)]))/(1+4*a);
        }
      }
    }
    set_bnd ();
  }
  void diffuseV()
  {          
    float diff=1;
    float a=dt*diff*size.x*size.y;
    for ( int k=0 ; k<20 ; k++ ) {
      for ( int i=1 ; i<=size.y ; i++ ) {
        for ( int j=1 ; j<=size.x ; j++ ) {
          Cell c = get(i,j);
          if(c!=null)
          {
            Cell t=c.get(Direction.TOP);
            Cell d=c.get(Direction.DOWN);
            Cell l=c.get(Direction.LEFT);
            Cell r=c.get(Direction.RIGHT); 
            if(t!=null&&d!=null&&l!=null&&r!=null)
              c._v = new PVector((c._v0.x + a*(l._v.x + r._v.x + d._v.x + t._v.x) )/(1+4*a), (c._v0.y + a*(l._v.y + r._v.y + d._v.y + t._v.y))/(1+4*a));
             //(x0[IX(i,j)] + a*(x[IX(i-1,j)]+x[IX(i+1,j)]+x[IX(i,j-1)]+x[IX(i,j+1)]))/(1+4*a);
          }
        }
      }
    }
    set_bnd();
  } 
  void advectD()
    {
    int i, j, i0, j0, i1, j1;
    float x, y, s0, t0, s1, t1, dt0;
    dt0 = dt*size.x;
    for ( i=1 ; i<=size.y ; i++ ) {
      for ( j=1 ; j<= size.x; j++ ) {
        Cell c = get(i,j);
        if(c!=null)
        {
          x = i-dt0*c._v.x;
          y = j-dt0*c._v.y;
          if (x<0.5)
            x=0.5; 
          if (x>size.x+0.5)
            x=size.x+ 0.5;
          
          i0=(int)x;
          i1=i0+1;
          if (y<0.5)
            y=0.5; 
          if (y>size.y+0.5)
            y=size.y+ 0.5;
          j0=(int)y; j1=j0+1;
          
          s1 = x-i0;
          s0 = 1-s1;
          t1 = y-j0;
          t0 = 1-t1;
          Cell c1,c2,c3,c4;
          c1=get(i0,j0);
          c2=get(i0,j1);
          c3=get(i1,j0);
          c4=get(i1,j1);       
          if(c1!=null && c2!=null && c3!=null && c4!=null)
            c._d = s0*(t0*c1._d0+t1*c2._d0+s1*(t0*c3._d0+t1*c4._d0));
        }
      }
    }
    set_bnd ();    
  }
  
  void advectV()
    {
    int i, j, i0, j0, i1, j1;
    float x, y, s0, t0, s1, t1, dt0;
    dt0 = dt*size.x;
    for ( i=1 ; i<=size.y ; i++ ) {
      for ( j=1 ; j<=size.x ; j++ ) {
        Cell c = get(i,j);
        if(c!=null){
          x = i-dt0*c._v.x;
          y = j-dt0*c._v.y;
          if (x<0.5)
            x=0.5; 
          if (x>size.x+0.5)
            x=size.x+ 0.5;
          
          i0=(int)x;
          i1=i0+1;
          if (y<0.5)
            y=0.5; 
          if (y>size.y+0.5)
            y=size.y+ 0.5;
          j0=(int)y;
          j1=j0+1;
          
          s1 = x-i0;
          s0 = 1-s1;
          t1 = y-j0;
          t0 = 1-t1;
          Cell c1,c2,c3,c4;
          c1=get(i0,j0);
          c2=get(i0,j1);
          c3=get(i1,j0);
          c4=get(i1,j1);  
          if(c1!=null && c2!=null && c3!=null && c4!=null)
            c._v = new PVector(s0*(t0*c1._v0.x+t1*c2._v0.x+s1*(t0*c3._v0.x+t1*c4._v0.x)),
                             s0*(t0*c1._v0.y+t1*c2._v0.y+s1*(t0*c3._v0.y+t1*c4._v0.y)));
        }
      }
    }
    set_bnd();    
  }
  void set_bnd(){
    
  }
  
  
  void dens_step ()
  {
    diffuseD();
    advectD();
  }  
  void vel_step ()
  {
    //add_source ( N, u, u0, dt );
    //add_source ( N, v, v0, dt );
    diffuseV();
    //project( N );
    advectV();
    //project( N );
  } 
}
