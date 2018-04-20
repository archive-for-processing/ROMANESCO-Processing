/**
DROPDOWN 
2014-2018
v 1.2.0
ROMANESCO PROCESSING ENVIRONMENT
*/
boolean dropdownOpen ; // use to indicate to indicate at the other button, they cannot be used when the user are on the dropdown menu



/**
CLASS
*/
public class Dropdown {
  //Slider dropdown
  private Slider slider_dd;
  private Vec2 size_box; 
  //dropdown
  private int line = 0;
  private String content[];
  private String name;

  private boolean locked, slider ;
  // color
  private final int colorTitleIn, colorTitleOut, colorBG, colorTextBox ; 
  private final int boxIn, boxOut;

  private Vec3 pos; 
  private Vec2 size;
  private Vec2 pos_text;
  int pos_ref_x, pos_ref_y ;
  private Vec2 change_pos = Vec2() ;
  private float factorPos; // use to calculate the margin between the box
  // box
  private int height_box;
  private int num_box;

  private int start = 0 ;
  private int end = 1 ;
  private int offset = 0 ; //for the slider update
  private float missing ;

  /**
  CONSTRUCTOR
  */
  public Dropdown(String name, String [] content, Vec3 pos, Vec2 size, Vec2 pos_text, ROPE_color rc, int num_box, int height_box) {
    this.name = name ; 
    this.pos = pos.copy();
    pos_ref_x = (int)pos.x ;
    pos_ref_y = (int)pos.y ;
    
    this.pos_text = pos_text.copy() ;

    this.size = size.copy(); // header size
    
    this.colorBG = rc.get_color()[0];
    this.boxIn = rc.get_color()[1];
    this.boxOut = rc.get_color()[2];
    this.colorTitleIn = rc.get_color()[3];
    this.colorTitleOut = rc.get_color()[4];  
    this.colorTextBox = rc.get_color()[5];
    
    set_box(num_box, height_box);
    set_content(content);
  }




  /**
  method
  */
  public void set_box(int num_box, int height_box) {
    this.height_box = height_box;
    this.num_box = num_box;
    float ratio = .95;
    int size_text = 10;
    size_box = Vec2(longest_word_in_pixel(content, size_text) *ratio, height_box);
  }

  // content
  public void set_content(String [] content) {
    boolean new_slider = false ;
    if(this.content == null || this.content.length != content.length) new_slider = true ;
    this.content = content;
    end = num_box;
    if (content != null) {
      if (end > content.length) {
        end = content.length;
      }
      missing = content.length -end;
    }

    //condition to display the slider
    if (content.length > end) {
      slider = true; 
    } else {
      slider = false;
    }
    
    if (slider && (slider_dd == null || new_slider)) {
      update_slider();
    }
  }

  private void update_slider() {
    Vec2 size_slider = Vec2(height_box *.5, (end *height_box) -pos.z);
    float x = pos.x -size_slider.x;
    float y = pos.y +height_box;
    Vec2 pos_slider = Vec2(x,y);
  
    float ratio = float(content.length) / float(end -1);
    
    Vec2 size_molette =  Vec2(size_slider.x, size_slider.y /ratio);

    slider_dd = new Slider(pos_slider, size_slider, size_molette, "RECT");
  }



  public void change_pos(int x, int y) {
    pos.set(pos_ref_x, pos_ref_y,0);
    Vec3 temp = Vec3(x,y,0);
    pos.add(temp);
  }


  public void update(PFont titleFont, PFont dropdown_font) {
    rectMode(CORNER);
    if (locked) {
      dropdownOpen = true ;
      //give the position of dropdown
      int step = 2 ;
      //give the position in list of Item with the position from the slider's molette
      if (slider) offset = round(map(slider_dd.getValue(), 0,1, 0, missing));

      for (int i = start +offset ; i < end +offset ; i++) {
        render_box(content[i], step++, size_box, dropdown_font, colorTextBox);
        if (slider) {
          float x = pos.x -slider_dd.get_size().x;
          float y = pos.y +height_box;
          slider_dd.set_pos(x,y);
          slider_dd.inside_molette_rect();
          slider_dd.select_molette();
          slider_dd.update_molette();
          slider_dd.show_slider(colorBG,colorBG,0);
          /**
          the color must be set in other place, that's not pertinent to set color in this method
          */
          slider_dd.show_molette(jaune, orange, jaune, orange, 0) ;
        }
      }
    } else {
      //header rendering
      dropdownOpen = false ;
    }
    title_without_box(name, 1, size, titleFont);
  }





  //DISPLAY
  private void title_without_box(String name, int step, Vec2 size, PFont font) {
    //update
    factorPos = step + pos.z -1 ;
    float yLevel = step == 1 ? pos.y  : (pos.y + (size.y *(factorPos )));
    Vec2 newPosDropdown = Vec2(pos.x, yLevel) ;
    if (inside(newPosDropdown, size,Vec2(mouseX,mouseY),RECT)) {
      fill(colorTitleIn); 
    } else {
      fill(colorTitleOut);
    }
    textFont(font);
    text(name, pos.x +pos_text.x, yLevel +pos_text.y);
  }
  
  private void render_box(String label, int step, Vec2 size_box, PFont font, int textColor) {
    //update
    factorPos = step + pos.z -1 ;
    float yLevel = step == 1 ? pos.y  : (pos.y + (size_box.y *(factorPos)));
    Vec2 newPosDropdown = Vec2(pos.x, yLevel) ;
    if (inside(newPosDropdown, size_box, Vec2(mouseX,mouseY),RECT)) {
      fill(boxIn); 
    } else {
      fill(boxOut);
    }
    //display
    noStroke() ;
    if (inside(newPosDropdown, size,Vec2(mouseX,mouseY),RECT)) {
      fill(boxIn); 
    } else {
      fill(boxOut);
    }
    int sizeWidthMin = 60 ;
    int sizeWidthMax = 300 ;
    if (size_box.x < sizeWidthMin ) {
      size_box.x = sizeWidthMin ; 
    } else if(size_box.x > sizeWidthMax ) {
      size_box.x = sizeWidthMax ;
    }
    rect(pos.x, yLevel, size_box.x, size_box.y);
    fill(textColor);
    textFont(font);
    text(label, pos.x +pos_text.x, yLevel +height_box -(ceil(height_box*.2)));
  }
  
  

  //Check the dropdown when this one is open
  public int selectDropdownLine(float newWidth) {
    if(mouseX >= pos.x && mouseX <= pos.x +newWidth && mouseY >= pos.y && mouseY <= ((content.length+1) *size.y) +pos.y) {
      //choice the line
      int line = floor( (mouseY - (pos.y +size.y)) / size.y ) +offset;
      return line;
    } else {
      return -1; 
    }
  }
  //return which line is selected
  public void whichDropdownLine(int l ) {
    line = l ;
  }
  //return which line of dropdown is selected
  public int get_content_line() {
    return line ;
  }

  public String [] get_content() {
    return content;
  }

  public Vec3 get_pos() {
    return pos;
  }

  public Vec2 get_size() {
    return size;
  }

  public int get_num_box() {
    return num_box;
  }

  public String get_name() {
    return name;
  }
}
