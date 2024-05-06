  class Chunk{
    Cell[][] grid;
    boolean active;
    PVector size;
    PVector pos;
    World world;
    boolean moved;
    int timer=0;
    ArrayList<Cell> cel;
    public Chunk(PVector pos,PVector size,World w){
      this.pos=pos;
      this.size=size;
      this.world=w;
      active=true;
      grid=new Cell[(int)size.y][(int)size.x];
      grid = new Cell[(int)size.y][(int)size.x];
      for(int y = 0; y <  size.y; y++){
        for(int x = 0; x< size.x; x++){
          grid[y][x]=new Cell(new PVector(x+pos.x*size.x,y+pos.y*size.y),w);
        }
      }
    }
    public Chunk get(Direction dir)
    {
      PVector p = new PVector(pos.x+dir.x,pos.y+dir.y);
      if(isFree(p))
        return world.getChunk((int)p.x,(int)p.y);
      else return null;
    }
    
    public boolean isFree(PVector p){
      if(p.x<0||p.y<0||p.x>=world.grid[0].length||p.y>=world.grid.length)
        return false;
        
      return true;
    } 
    public Cell get(int x,int y){
      if(x>=0&&y>=0&&x<grid[0].length &&y<grid.length)
        return grid[y][x];
      else
        return null;
    }
    public boolean isActive(){
      if(moved)
        return true;
      else
      {
        for(int y = 0; y <  size.y; y++){
          for(int x = 0; x< size.x; x++){
            if(grid[y][x].type.hasMoved()){
              active=true;
              return true;
            }
          }
        }
      }
      moved=false;      
      return false;      
    }
    public PVector localToWorld(PVector p){
      return new PVector(p.x +pos.x*size.x,p.y + pos.y*size.y);
    }
    public void setActive(boolean active){
      this.active=active;
    }

    public void Update(){
      if(timer==10)
      {
        setActive(true);
        timer=0;
      }      
      timer++;
      if(!active)
        return;
      world.callInspector++;
      moved=false;
      for(int y = 0; y < size.y; y++){
        for(int x = 0; x < size.x; x++){
          grid[y][x].moved=false;
        }
      }  
      for(int y = (int)size.y-1; y>=0 ; y--){
        for(int x = (int)size.x-1; x>=(int)(size.x*0.5); x--){
          Cell c1 = grid[y][x];
          if(c1.moved)continue;
            c1.type.behave();
        }
        for(int x = 0; x<(int)(size.x*0.5)+1; x++){
          Cell c1 = grid[y][x];
          if(c1.moved)continue;
            c1.type.behave();
        } 
      }
      active=moved;
      isActive();
    }
  
    @Override
    public String toString(){
      return "Chunk : " + pos+ "||" + size; 
    }
  }
