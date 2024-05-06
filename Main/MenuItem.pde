import java.util.stream.Collectors;
public class MenuItem implements Comparable
{
        /*** Private Properties ***/
      private java.util.function.Function<MenuItem, Boolean> chooseAction; // Function to run when item is chosen
      private java.util.function.Function<MenuItem, String> textAction; // Function to update the text for dynamic menu text
      
      /*** Public Properties ***/
      
      public PVector pos,size;
      public String Text; // The text that shows up in the menu for this item
      public ArrayList<MenuItem> children; // The children items of this item
      public Rectangle boundary;
      /*** Constructors ***/

      // Standard constructor
      public MenuItem(String text, Rectangle boundary)
      {
        this.boundary=boundary;
        this.pos=boundary.Coords;
        this.size=boundary.size;
        this.Text = text;
        this.children = new ArrayList<MenuItem>();        
        this.textAction = new DefaultStrFunc(this,text);      
      }
      public MenuItem(String text,MenuItem[] children)
      {
        this.Text = text;
        this.children = new ArrayList<MenuItem>();
        for(int i = 0; i<children.length;i++){
          this.children.add(children[i]);
        }
        
        this.textAction = new DefaultStrFunc(this,text);
        
      }
      public MenuItem(String text, Rectangle boundary, java.util.function.Function<MenuItem, Boolean> chooseAction)
      {        
        this.Text = text;
        this.boundary=boundary;
        //this constructor does not initialize pos and size ??
        this.pos=boundary.GetCoords();
        this.size=boundary.GetSize();
        this.chooseAction = chooseAction;
        this.children = new ArrayList<MenuItem>();
        this.textAction=new DefaultStrFunc(this,text);
      }
      public MenuItem(String text, Rectangle boundary, java.util.function.Function<MenuItem, Boolean> chooseAction, java.util.function.Function<MenuItem,String>textAction)
      {        
        this.Text = text;
        this.boundary=boundary;
        this.pos=boundary.Coords;
        this.size=boundary.size;
        this.chooseAction = chooseAction;
        this.textAction = textAction;
        this.children = new ArrayList<MenuItem>();
        
      }
      public MenuItem(Rectangle boundary,java.util.function.Function<MenuItem,String> textAction)
      {
        this.boundary=boundary;
        this.textAction=textAction;
        this.pos=boundary.Coords;
        this.size=boundary.size;
         // Initialize children
        if (children == null)
        {
          this.children = new ArrayList<MenuItem>();
        }
        else
        {
          this.children = new ArrayList<MenuItem>(children);
        }
      }
     

      /*** Methods ***/

      // Default text action which just returns the static text
      private String get_text(MenuItem item)
      {
        return this.Text;
      }

      // Get menu text
      public String GetText()
      {
         return this.textAction.apply(this);
      }

      // True means go into sub menu if it exists, false means stay where you are
      public Boolean doAction()
      {
        if (this.chooseAction == null)
        {
          return true;
        }
        else
        {
          return this.chooseAction(this);
        }
      }
      
      public Boolean chooseAction(MenuItem item)
      {
         return item.chooseAction.apply(item);
      }
      // Set the static text
      public void SetText(String text)
      {
        this.Text = text;
      }

      // Set the dynamic text action
      public void SetTextAction(java.util.function.Function<Main.MenuItem, String> textAction)
      {
        this.textAction=textAction;
      }

      public int compareTo(Object obj)
      {
        if (obj == null) return 1;

        MenuItem otherItem = (MenuItem)obj;

        if (otherItem != null)
          return this.GetText().compareTo(otherItem.GetText());
        
        return -1;
      }

}
public class DefaultStrFunc implements java.util.function.Function<Main.MenuItem,String>,editable<String>
{
  Main.MenuItem item;
  String text;
  
  public DefaultStrFunc(Main.MenuItem item, String text){
    this.item=item;
    this.text=text;

  }
  @Override
  public String apply(MenuItem item)
  {
    return text;
  }
  @Override
  public void set(String text){
    this.text=text;
  }
  @Override
  public String get()
  {
    return text;
  }
}

//ALWAYS use this interface to make setters/getters in those funcs.
public interface editable<T>
{
  public void set(T set);
  public T get();
}

public interface editableList<T>
{
  public void set(T set);
  public T get();
  public T[][] getArray();
}
public class MaterialSelector implements java.util.function.Function<Main.MenuItem,Boolean>
{
  Main.MenuItem item;
  Element type;
  public MaterialSelector(Main.MenuItem item, Element type){
    this.item=item;
    this.type=type;
  }
  @Override
  public Boolean apply(MenuItem e)
  {
     return true;
  }
}

public class MaterialMenuItem implements java.util.function.Function<Main.MenuItem,Boolean>,editableList<Element>
{
  Main.MenuItem item;
  Element type;
  Element[][] background;
  public MaterialMenuItem(Main.MenuItem item, Element type){
    this.item=item;
    this.type=type;
    this.background=new Element[(int)item.size.y][(int)item.size.x];
    for(int y = 0; y <  item.size.y; y++){
      for(int x = 0; x< item.size.x; x++){
         background[y][x]=type.clone();
      }
    }
  }
  @Override
  public Boolean apply(MenuItem e)
  {
    if(type!=null)
    {
      state=type;
     return true;
    }
    return false;
  }
  @Override
  public Element get()
  {
    return type;
  }
  public Element[][] getArray(){
    return background;
  }
  @Override
  public void set(Element e)
  {
    type=e;
  }
}

public class RadiusMenuItem implements java.util.function.Function<Main.MenuItem,Boolean>,editableList<Element>
{
  Main.MenuItem item;
  Element[][] background;
  Element type;
  boolean plus;
  public RadiusMenuItem(Main.MenuItem item, boolean plus,Element type){
    this.item=item;
    this.type=type;
    this.plus=plus;
    if(plus)
      this.background=Plus();
    else
      this.background=Minus();
  }
  
  public Element[][] Plus(){
    return new Element[][]
    {
      new Element[]{ new AIR(),new AIR(),new AIR(),new AIR(),new AIR()},
      new Element[]{ new AIR(),new AIR(),type.clone(),new AIR(),new AIR()},
      new Element[]{ new AIR(),type.clone(),type.clone(),type.clone(),new AIR()},
      new Element[]{ new AIR(),new AIR(),type.clone(),new AIR(),new AIR()},      
      new Element[]{ new AIR(),new AIR(),new AIR(),new AIR(),new AIR()},
    };    
  }
  public Element[][] Minus(){
    return new Element[][]
    {
      new Element[]{ new AIR(),new AIR(),new AIR(),new AIR(),new AIR()},
      new Element[]{ new AIR(),new AIR(),new AIR(),new AIR(),new AIR()},
      new Element[]{ new AIR(),type.clone(),type.clone(),type.clone(),new AIR()},
      new Element[]{ new AIR(),new AIR(),new AIR(),new AIR(),new AIR()},      
      new Element[]{ new AIR(),new AIR(),new AIR(),new AIR(),new AIR()},
    };  
  }
  @Override
  public Boolean apply(MenuItem e)
  {
    if(plus)
    {
      radius+=2;
    }
    else
    {
      radius-=2;
      if(radius<1)
        radius=1;
    }
    return false;
  }
  @Override
  public Element get()
  {
    return type;
  }
  public Element[][] getArray(){
    return background;
  }
  @Override
  public void set(Element e)
  {
    type=e;
  }
}
