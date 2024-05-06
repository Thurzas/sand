import java.util.*; 
int timer;
int rez = 4;
int w;
int h;
ArrayList<PVector> points;
PGraphics ctx;
Element state= new SAND();
//Water properties
float Flow;
float remaining_mass;
PVector k=new PVector();
int fps=60;
int frames;
int radius=5;
boolean squares=false;
PImage img;  // Declare a variable of type PImage
Menu menu;
Menu radiusMenu;
/*
void setup() {
  size(320,240);
  // Make a new instance of a PImage by loading an image file
  img = loadImage("sapin.jpg");
}

void draw() {
  background(0);
  // Draw the image to the screen at coordinate (0,0)
  image(img,0,0);
}*/
Direction dir=Direction.LEFT;
World world ;
void setup() { 
  //fullScreen(P3D);
  size(1080,1024,P3D);
  surface.setLocation(0,0);
  w = 1+width/rez;
  h = 1+height/rez;
  k=new PVector(150,150);
  ctx=createGraphics(w,h);
  
  ((PGraphicsOpenGL)g).textureSampling(2); // Prevent Processing from applying smoothing/filtering when we scale stuff
  
  world = new World(w,h); 
  println(w + " " + h);
  println(world.grid.length + " " + world.grid[0].length);
      // Add some sand
  print("testing sand: ");
  for (int y=50; y<60; ++y) {
    for (int x=100; x<110; ++x) {
      world.get(x,y).setType(new DIRT());
    }
  }
  println("OK");
  print("testing water: ");
  for (int y=50; y<60; ++y) {
    for (int x=130; x<150; ++x) {
      world.get(x,y).setType(new WATER());
    }
  }
  print("testing rock: ");
  for(int i=0;i<w;i++)
  {
    for(int j = 0;j<=2;j++)
      world.get(i,h-50+j).setType(new ROCK());
  }
 println("OK");
  
 frameRate(fps);
 println(w +" " + h);
 print("testing menu: ");
 MenuItem[] items = new MenuItem[8];
 PVector size = new PVector(20,20);
 
 items[0]=new MenuItem("Air", new Rectangle(new PVector(5,5),size));
 items[1]=new MenuItem("sand", new Rectangle(new PVector(30,5),size));
 items[2]=new MenuItem("dirt", new Rectangle(new PVector(55,5),size));
 items[3]=new MenuItem("water", new Rectangle(new PVector(80,5),size));
 items[4]=new MenuItem("oil", new Rectangle(new PVector(105,5),size));
 items[5]=new MenuItem("lava", new Rectangle(new PVector(130,5),size));
 items[6]=new MenuItem("stone", new Rectangle(new PVector(155,5),size));
 items[7]=new MenuItem("steam", new Rectangle(new PVector(180,5),size));
 
 print("menu items"); 
 items[0]=new MenuItem("Air", new Rectangle(new PVector(5,5),size),new MaterialMenuItem(items[0],new AIR()));
 items[1]=new MenuItem("sand", new Rectangle(new PVector(30,5),size),new MaterialMenuItem(items[1],new SAND()));
 items[2]=new MenuItem("dirt", new Rectangle(new PVector(55,5),size),new MaterialMenuItem(items[2],new DIRT()));
 items[3]=new MenuItem("water", new Rectangle(new PVector(80,5),size),new MaterialMenuItem(items[3],new WATER()));
 items[4]=new MenuItem("oil", new Rectangle(new PVector(105,5),size),new MaterialMenuItem(items[4],new OIL()));
 items[5]=new MenuItem("lava", new Rectangle(new PVector(130,5),size),new MaterialMenuItem(items[5],new LAVA()));
 items[6]=new MenuItem("stone", new Rectangle(new PVector(155,5),size),new MaterialMenuItem(items[6],new STONE()));
 items[7]=new MenuItem("steam", new Rectangle(new PVector(180,5),size),new MaterialMenuItem(items[7],new STEAM()));
 
 println("OK");
 menu = new Menu(ctx,new PVector(0,0),"Material menu", items);
 MenuItem[] items2=new MenuItem[2];

 items2[0]=new MenuItem("Minus",new Rectangle(new PVector(5,50),new PVector(3,3))); 
 items2[1]=new MenuItem("Plus",new Rectangle(new PVector(5,40),new PVector(3,3)));
 
 items2[0]=new MenuItem("Minus",new Rectangle(new PVector(5,50),new PVector(5,5)),new RadiusMenuItem(items2[1],false,new ROCK()));
 items2[1]=new MenuItem("Plus",new Rectangle(new PVector(5,40),new PVector(4,4)),new RadiusMenuItem(items2[0],true,new ROCK()));
 radiusMenu = new Menu(ctx,new PVector(0,20),"Radius menu",items2);
}

  //Update world
  public void draw(){ 
   //println(world.get(0,0).type.heat + " " + world.get(254,254).type.heat);
   frames=(int)frameRate;
    world.Update();
    world.draw(ctx,squares);
    menu.draw();
    radiusMenu.draw();
  }
    
    
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  radius+=2*e;
  if(radius<1)
    radius=1;
}

public void mousePressed()
{
  if(mouseButton==LEFT)
  {   
    boolean triggered=false;
    if(menu.show)
    {
     
      for (int n = 0; n < menu.path.peek().children.size(); n++)
      {
        MenuItem item = (MenuItem)menu.path.peek().children.get(n);
        if(item.boundary.Contains(new PVector(mouseX/rez,mouseY/rez)))
        {
          menu.selectedItem=item;
          menu.Choose();
          triggered=true;
        }
      }
      if(!triggered)
      {
        int X=mouseX/rez;
        int Y=mouseY/rez;
        for (int y=Y-radius; y<Y+radius; y++) {
          for (int x=X-radius; x<X+radius; ++x) {
            if(x<w && y<h && x>0 && y>0)
            {
              world.get(x,y).setType(state.clone());
            } 
          }
        }
      }
    }
    else if(radiusMenu.show)
    {
     
      for (int n = 0; n < radiusMenu.path.peek().children.size(); n++)
      {
        MenuItem item = (MenuItem)radiusMenu.path.peek().children.get(n);
        if(item.boundary.Contains(new PVector(mouseX/rez,mouseY/rez)))
        {
          radiusMenu.selectedItem=item;
          radiusMenu.Choose();
          triggered=true;
          println(triggered);
        }
      }
      if(!triggered)
      {
        int X=mouseX/rez;
        int Y=mouseY/rez;
        for (int y=Y-radius; y<Y+radius; y++) {
          for (int x=X-radius; x<X+radius; ++x) {
            if(x<w && y<h && x>0 && y>0)
            {
              world.get(x,y).setType(state.clone());
            } 
          }
        }
      }
    }
    else
    {
      int X=mouseX/rez;
      int Y=mouseY/rez;
      for (int y=Y-radius; y<Y+radius; y++) {
        for (int x=X-radius; x<X+radius; ++x) {
          if(x<w && y<h && x>0 && y>0)
          {
            world.get(x,y).setType(state.clone());
          } 
        }
      }
    }
  }
  else if(mouseButton==CENTER)
  {
     line(mouseX/rez,mouseY/rez);
  }
}
    
public void mouseDragged(){
  if(mouseButton==LEFT)
  {   
    boolean triggered=false;
    if(menu.show)
    {
     
      for (int n = 0; n < menu.path.peek().children.size(); n++)
      {
        MenuItem item = (MenuItem)menu.path.peek().children.get(n);
        if(item.boundary.Contains(new PVector(mouseX/rez,mouseY/rez)))
        {
          menu.selectedItem=item;
          menu.Choose();
          triggered=true;
        }
      }
      if(!triggered)
      {
        int X=mouseX/rez;
        int Y=mouseY/rez;
        for (int y=Y-radius; y<Y+radius; y++) {
          for (int x=X-radius; x<X+radius; ++x) {
            if(x<w && y<h && x>0 && y>0)
            {
              world.get(x,y).setType(state.clone());
            } 
          }
        }
      }
    }
    else if(radiusMenu.show)
    {
     
      for (int n = 0; n < radiusMenu.path.peek().children.size(); n++)
      {
        MenuItem item = (MenuItem)radiusMenu.path.peek().children.get(n);
        if(item.boundary.Contains(new PVector(mouseX/rez,mouseY/rez)))
        {
          radiusMenu.selectedItem=item;
          radiusMenu.Choose();
          triggered=true;
          println(triggered);
        }
      }
      if(!triggered)
      {
        int X=mouseX/rez;
        int Y=mouseY/rez;
        for (int y=Y-radius; y<Y+radius; y++) {
          for (int x=X-radius; x<X+radius; ++x) {
            if(x<w && y<h && x>0 && y>0)
            {
              world.get(x,y).setType(state.clone());
            } 
          }
        }
      }
    }
    else
    {
      int X=mouseX/rez;
      int Y=mouseY/rez;
      for (int y=Y-radius; y<Y+radius; y++) {
        for (int x=X-radius; x<X+radius; ++x) {
          if(x<w && y<h && x>0 && y>0)
          {
            world.get(x,y).setType(state.clone());
          } 
        }
      }
    }
  }
}
public void mouseClicked(){

  if (mouseButton==RIGHT)
  {
    int X=mouseX/rez;
    int Y=mouseY/rez;
    Cell c = world.get(X,Y);
    Element target=c.type;
    /*HashMap<PVector,Cell> neighbors = c.neighbors(2,target);
    for(Map.Entry<PVector,Cell> mapEntry : neighbors.entrySet()){
      Cell crt = mapEntry.getValue();
      crt.setType(new AIR());
    }
    */
    Filler f = new Filler(w,h,world.get(X,Y),target,new AIR());
    f.Fill(c);    
    while(!f.workComplete())
    {
      f.Work();
    }
  }
}

void keyPressed(){
  if(key=='p')
  {
      menu.Up();
      menu.Choose();
  }
  if(key=='o')
  {
      menu.Down();
      menu.Choose();
  } 
  if(key=='i')
  {
      menu.show(!menu.show);
      radiusMenu.show(!radiusMenu.show);
  }
  if(key=='+')
  {
      radiusMenu.Up();
      radiusMenu.Choose();
  }
  if(key=='-')
  {
      radiusMenu.Down();
      radiusMenu.Choose();
  }
  if(key=='d')
  {
    int X=mouseX/rez;
    int Y=mouseY/rez;
    Cell c = world.get(X,Y);
    
    println("density " + c.type.density);
  }
  if(key=='u')
  {
    squares=!squares;
  }
  if(key=='c')
  {
    Cell c = world.get(150,150);    
    HashMap<PVector,Cell> neighbors =c.neighbors(50,new AIR());
    for(Map.Entry<PVector,Cell> mapEntry : neighbors.entrySet()){
      mapEntry.getValue().setType(new ROCK());
    }    
  }
}

public void mouseReleased(){
  k=null;
}

public void line(int x, int y){
     PVector u = new PVector(x,y);
     if(k==null)
       k=u;
     int x1,x2,y1,y2,dx,dy,e;        
     x1 = round(k.x);
     x2 = round(u.x);
     y1 = round(k.y);
     y2 = round(u.y);      
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
             while(x1<x2) // boucle horizontale
             {
                world.get(x1,y1).setType(new ROCK());
               e-=dy;
               if(e<0)
               {
                y1++;
                 world.get(x1,y1).setType(new ROCK());
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
              while(y1<y2) // boucle  verticale
              {                
                 world.get(x1,y1).setType(new ROCK());
                e-=dx;
                if(e<0)
                {
                 x1++;
                  world.get(x1,y1).setType(new ROCK());
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
             while(x1<x2) //horizontal
             {             
                world.get(x1,y1).setType(new ROCK());
               e+=dy;
               if(e<0)
               {
                 y1--;
                  world.get(x1,y1).setType(new ROCK());
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
             while(y1>y2) //vertical
             {             
                world.get(x1,y1).setType(new ROCK());
               e+=dx;
               if(e>0)
               {
                 x1++; //diagonal
                  world.get(x1,y1).setType(new ROCK());
                 e+=dy;
               }
               y1--;
             }           
           }
         }
       }
       //jee ne rentree JAMAIS dans cette condition ?? :/
       
       else // dy == 0
       {
         while(x1<x2)
         {
           world.get(x1,y1).setType(new ROCK());
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
             while(x1>x2){ //horizontal
                world.get(x1,y1).setType(new ROCK());
               e+=dy;
               if(e>=0)
               {
                 y1++; //diagonal
                  world.get(x1,y1).setType(new ROCK());
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
             while(y1<y2){
                world.get(x1,y1).setType(new ROCK());
               e+=dx;
               if(e<=0)
               {
                 x1--;
                  world.get(x1,y1).setType(new ROCK());
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
             while(x1>x2) //horizontal
             {
                world.get(x1,y1).setType(new ROCK());
               e-=dy;
               if(e>=0)
               {
                 y1--; //diagonal
                  world.get(x1,y1).setType(new ROCK());
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
             while(y1>y2){
                world.get(x1,y1).setType(new ROCK());
               e-=dx;
               if(e>=0)
               {
                 x1--;
                  world.get(x1,y1).setType(new ROCK());
                 e+=dy;
               }
               y1--;
             }
           }
         }         
       }
       else //dy = 0 et dx <0
       {
         while(x1>x2)
         {
           world.get(x1,y1).setType(new ROCK());
           x1--;           
         }
       }
     }
   }
   else //dx==0
   {
     dy=y2-y1;
     if(dy!=0)
     {
       if(dy>0)
       {
         while(y1<y2)
         {
            world.get(x1,y1).setType(new ROCK());
           y1++;
         }
       }
       else
       {
         while(y1>y2)
         {
            world.get(x1,y1).setType(new ROCK());
           y1--;
         }
       }
      }
   }
  k=u;
}
