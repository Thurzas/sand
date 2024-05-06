public class Menu
{
  PVector pos;
  PVector size;
  Rectangle boundary;
  Stack<MenuItem> path;
  MenuItem selectedItem;
  Boolean show;
  PGraphics ctx;
  public Menu(PGraphics ctx,PVector pos,String text, MenuItem[] children)
  {
    this.ctx=ctx;
    this.pos=pos;
    this.size=size;
    this.boundary=new Rectangle(pos,size);
    this.path=new Stack<MenuItem>();
    this.path.push(new MenuItem(text,children));
    show=true;
    if (this.path.peek().children.size() > 0)
    {
      this.selectedItem = (MenuItem)this.path.peek().children.get(this.path.peek().children.size()-1);
    }
  }
  
  // Choose action
  public void Choose()
  {
    if (this.selectedItem.doAction())
    {
      if (this.selectedItem.children.size() > 0) // go to sub menu if it exists
      {
        this.path.push(this.selectedItem);
        this.selectedItem = (MenuItem)this.path.peek().children.get(0);
      }
    }
  }
  
  public void Up()
  {
    int location = this.path.peek().children.indexOf(this.selectedItem) + 1;
    if (location < this.path.peek().children.size())
    {
      this.selectedItem = (MenuItem)this.path.peek().children.get(location);
    }
  }
  public void Down()
  {
    int location = this.path.peek().children.indexOf(this.selectedItem) - 1;
    if (location >= 0)
    {
      this.selectedItem = (MenuItem)this.path.peek().children.get(location);
    }
  }
  public void show(boolean b){
    show=b;
  }
  public void draw()
  {
    if(!show)
      return;
    ctx.beginDraw();
    ctx.loadPixels();
    MenuItem currentItem = this.path.peek();
    if (currentItem == null)
    {
      return ;
    }
    for (int n = 0; n < currentItem.children.size(); n++)
    {
      MenuItem item = (MenuItem)currentItem.children.get(n);
      
      Element[][] background;
      if(item.chooseAction instanceof MaterialMenuItem)
        background=((MaterialMenuItem)item.chooseAction).getArray();
      else if  (item.chooseAction instanceof RadiusMenuItem)
        background=((RadiusMenuItem)item.chooseAction).getArray();
      else
        background=new Element[(int)item.size.y][(int)item.size.x];
      if(background!=null){
        for(int y = 0;y<background.length;y++){
          for(int x = 0;x<background[0].length;x++){
             ctx.pixels[x+(int)item.pos.x+((int)item.pos.y+y)*w]=color(background[y][x].r*2,background[y][x].g*2,background[y][x].b*2);
          }
        }
      }
      if(item==this.selectedItem)
      {
        PVector p1,p2,p3,p4;
        p1=item.pos;
        p2=new PVector(item.size.x+item.pos.x, item.pos.y);
        p3=new PVector(item.size.x+item.pos.x, item.pos.y+item.size.y);
        p4=new PVector(item.pos.x, item.pos.y+item.size.y);
        ArrayList<PVector> l1=line(p1,p2);
        ArrayList<PVector> l2=line(p2,p3);
        ArrayList<PVector> l3=line(p3,p4);
        ArrayList<PVector> l4=line(p4,p1);
        for(PVector p : l1){
          if(p.x>0&&p.y>0&&p.x<w && p.y<h)            
            ctx.pixels[(int)p.x+(int)p.y*w]=color(0,255,0);
        }
        for(PVector p : l2){
          if(p.x>0&&p.y>0&&p.x<w && p.y<h)
            ctx.pixels[(int)p.x+(int)p.y*w]=color(0,255,0);
        }
        for(PVector p : l3){
          if(p.x>0&&p.y>0&&p.x<w && p.y<h)
            ctx.pixels[(int)p.x+(int)p.y*w]=color(0,255,0);
        }
        for(PVector p : l4){
          if(p.x>0&&p.y>0&&p.x<w && p.y<h)
            ctx.pixels[(int)p.x+(int)p.y*w]=color(0,255,0);
        }   
      }
    }
    ctx.updatePixels();
    ctx.endDraw();
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

}
