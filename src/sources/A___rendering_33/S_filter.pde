/**
FILTER
* 2018-2019
* v 0.1.2
* here is calling classic FX ROPE + FX FORCE FIELD
*/
void init_filter() {
  if(FULL_RENDERING) {
    // FORCE FIELD FX
    type_field = r.FLUID;
    pattern_field = r.BLANK;
    set_type_force_field(type_field);
    init_force_field();
    // set_different_force_field();
    println("init filter FORCE FIELD");
    // warp force
    init_warp_force();
    println("init filter FORCE WARP FX");


    // FX CLASSIC
    // set path fx shader;
    set_fx_path(preference_path+"shader/fx/");
    get_fx_path();
    if(fx_rope_path_exists) {
      println("FX CLASSIC shader loaded");
    } else {
      printErr("fx path filter",fx_rope_path,"don't exists");
    }

    setting_fx_classic();

    // CLASSIC FX + FORCE FIELD FX
    write_filter_index();
  }
}


boolean move_filter_fx;
boolean extra_filter_fx;
ArrayList<Integer>active_fx;
int fx_classic_num;
void filter() {
  move_filter_fx = fx_button_is(1);
  extra_filter_fx = fx_button_is(2);

  // add fx
  if(extra_filter_fx) {
    if(active_fx == null) active_fx = new ArrayList<Integer>();
    boolean add_fx = true;
    if(active_fx.size() > 0) {  
      for(Integer i : active_fx) {
        if(i == which_fx) {
          add_fx = false;
          break;
        }
      }
    }
    if(add_fx) {
      active_fx.add(which_fx);
    }
  }

  if(active_fx != null) {
    if(reset_fx_button_alert_is()) {
      active_fx.clear();
    }
  }

  if(FULL_RENDERING && fx_button_is(0)) {
    update_fx_value_from_slider();
    update_fx_classic();
    if(extra_filter_fx && active_fx != null && active_fx.size() > 0) {
      for(int i : active_fx) {
        draw_fx(i);
      }
    } else {
      draw_fx(which_fx);
    }
  } 
}




void draw_fx(int which) {
  // select fx 
  int num_of_special_fx = 1 ;
  
   if(which < num_of_special_fx) {
      apply_force_field();
      warp_force(fx_str_x,fx_speed,vec3(fx_cx,fx_cy,fx_cz));
      // warp_force();
   } else {
    int target = which- num_of_special_fx; // min 1 cause the first one is a special one;
    for(int i = 0 ; i < fx_classic_num ; i++) {
      if(target == i) {
        if(get_fx(target).get_type() == FX_WARP_TEX) {
          if(fx_pattern == null) {
            draw_fx_pattern(16,16,2,RGB,true);
          } else {
            draw_fx_pattern(16,16,2,RGB,reset_fx_button_alert_is());
          }
          select_fx(g,get_fx_pattern(0),get_fx_pattern(1),get_fx(target));
        } else {
          select_fx(g,null,null,get_fx(target));
        }      
      }
    }
  }
}





/**
UTIL FILTER
*/
PImage [] fx_pattern;
PImage get_fx_pattern(int which) {
  if(fx_pattern != null && which < fx_pattern.length) {
    return fx_pattern[which];
  } else {
    return null;
  }
}


void draw_fx_pattern(int w, int h, int num, int mode, boolean event) {
  if(fx_pattern == null || num < fx_pattern.length) {
    fx_pattern = new PImage[num];
  }
  for(int i = 0; i < fx_pattern.length ; i++) {
    if(event || fx_pattern[i] == null) {
      if(mode == RGB) {
        fx_pattern[i] = generate_fx_pattern(3,w,h); // warp RGB
      } else if(mode == GRAY) {
        fx_pattern[i] = generate_fx_pattern(0,w,h); // warp GRAY
      } 
    }
  }  
}


PGraphics generate_fx_pattern(int mode, int sx, int sw) {
  vec3 inc = vec3(random(1)*random(1),random(1)*random(1),random(1)*random(1));
  if(mode == 0) {
    // black and white
    return pattern_noise(sx,sw,inc.x);
  } else if(mode == 3) {
    // rgb
    return pattern_noise(sx,sw,inc.array());
  } else return null;
}


void write_filter_index() {
  Table index_fx = new Table();
  index_fx.addColumn("Name");
  index_fx.addColumn("Author");
  index_fx.addColumn("Version");
  index_fx.addColumn("Pack");
  

  int num = fx_classic_num+1; // +1 cause of the special force field fx
  TableRow [] info_fx = new TableRow [num];

  for(int i = 0 ; i < info_fx.length ; i++) {
    info_fx[i] = index_fx.addRow();
  }

  info_fx[0].setString("Name","Force");
  info_fx[0].setString("Author","Stan le Punk");
  info_fx[0].setString("Version","0.1.0");
  info_fx[0].setString("Pack","Base 2014");


  for(int i = 0 ; i < fx_classic_num ; i++) {
    FX fx = get_fx(i); 
    int target = i+1;
    info_fx[target].setString("Name",fx.get_name());
    info_fx[target].setString("Author",fx.get_author());
    info_fx[target].setString("Version",fx.get_version());
    info_fx[target].setString("Pack",fx.get_pack());
  }


  saveTable(index_fx, preference_path+"index_fx.csv"); 

}













































/**
FX ROMANESCO
* classic FX class
* v 0.0.1
* 2019-2019
*/

void setting_fx_classic() {
  setting_fx_blur_circular();
  setting_fx_blur_gaussian();
  setting_fx_blur_radial();

  setting_fx_haltone_dot();
  setting_fx_haltone_line();

  setting_fx_pixel();

  setting_fx_split_rgb();

  setting_fx_warp_proc();
  setting_fx_warp_tex();
}

float fx_cx;
float fx_cy;
float fx_cz;
float fx_px;
float fx_py;
float fx_sx;
float fx_sy;
float fx_str_x;
float fx_str_y;
float fx_quantity;
float fx_quality;
float fx_speed;
float fx_angle;
float fx_threshold;
void update_fx_value_from_slider() {
  fx_cx = map(value_slider_fx[0],0,MAX_VALUE_SLIDER,0,1);
  fx_cy = map(value_slider_fx[1],0,MAX_VALUE_SLIDER,0,1);
  fx_cz = map(value_slider_fx[2],0,MAX_VALUE_SLIDER,0,1);

  fx_px = map(value_slider_fx[3],0,MAX_VALUE_SLIDER,0,1);
  fx_py = map(value_slider_fx[4],0,MAX_VALUE_SLIDER,0,1);

  fx_sx = map(value_slider_fx[5],0,MAX_VALUE_SLIDER,0,1);
  fx_sy = map(value_slider_fx[6],0,MAX_VALUE_SLIDER,0,1);

  fx_str_x = map(value_slider_fx[7],0,MAX_VALUE_SLIDER,0,1);
  fx_str_y = map(value_slider_fx[8],0,MAX_VALUE_SLIDER,0,1);

  fx_quantity = map(value_slider_fx[9],0,MAX_VALUE_SLIDER,0,1);

  fx_quality = map(value_slider_fx[10],0,MAX_VALUE_SLIDER,0,1);

  fx_speed = map(value_slider_fx[11],0,MAX_VALUE_SLIDER,0,1);

  fx_angle = map(value_slider_fx[12],0,MAX_VALUE_SLIDER,0,1);

  fx_threshold = map(value_slider_fx[13],0,MAX_VALUE_SLIDER,0,1);

}

void update_fx_classic() {

  update_fx_blur_circular(move_filter_fx,fx_quantity,fx_str_x);
  update_fx_blur_gaussian(move_filter_fx,fx_str_x);
  update_fx_blur_radial(move_filter_fx,vec2(fx_px,fx_py),fx_str_x);
  
  update_fx_haltone_dot(move_filter_fx,vec2(fx_px,fx_py),fx_sx,fx_angle,fx_threshold);
  update_fx_haltone_line(move_filter_fx,vec2(fx_px,fx_py),fx_quantity,fx_angle);

  update_fx_pixel(move_filter_fx,fx_quantity,vec2(fx_sx,fx_sy),vec3(fx_cx,fx_cy,fx_cz));

  update_fx_split_rgb(move_filter_fx,vec2(fx_str_x,fx_str_y),fx_speed);
  
  update_fx_warp_proc(move_filter_fx,fx_str_x,fx_speed);
  update_fx_warp_tex(move_filter_fx,fx_str_x);


}


/**
* blur circular
*/
String set_blur_circular = "blur circular";
void setting_fx_blur_circular() {
  String version = "0.0.1";
  int revision = 1;
  String author = "Stan le Punk";
  String pack = "Base 2019";
  int id = fx_classic_num;
  init_fx(set_blur_circular,FX_BLUR_CIRCULAR,id,author,pack,version,revision);
  fx_classic_num++;
}

void update_fx_blur_circular(boolean move_is, float num, float strength_x) {
  if(move_is) {
    int iteration = (int)map(num,0,1,2,64);
    fx_set_num(set_blur_circular,iteration);

    int max_blur = width;
    float str = strength_x*max_blur;
    fx_set_strength(set_blur_circular,str);
  }
}



/**
* gaussian blur
*/
String set_blur_gaussian = "blur gaussian";
void setting_fx_blur_gaussian() {
  String version = "0.0.3";
  int revision = 3;
  String author = "Stan le Punk";
  String pack = "Base 2019";
  int id = fx_classic_num;
  init_fx(set_blur_gaussian,FX_BLUR_GAUSSIAN,id,author,pack,version,revision);
  fx_classic_num++;
}

void update_fx_blur_gaussian(boolean move_is, float strength_x) {
  if(move_is) {
    int max_blur = height/10;
    float str = strength_x*max_blur;
    fx_set_strength(set_blur_gaussian,str);
  }
}




/**
* blur radial
*/
String set_blur_radial = "blur radial";
void setting_fx_blur_radial() {
  String version = "0.0.1";
  int revision = 1;
  String author = "Stan le Punk";
  String pack = "Base 2019";
  int id = fx_classic_num;
  init_fx(set_blur_radial,FX_BLUR_RADIAL,id,author,pack,version,revision);
  fx_classic_num++;
}

void update_fx_blur_radial(boolean move_is, vec2 pos,float strength) {
  if(move_is) {
    fx_set_pos(set_blur_radial,pos.x,pos.y);
    
    // scale change nothing
    // float scale = size*width;
    // fx_set_scale(set_blur_radial,scale);
    
    float str = strength*20;
    fx_set_strength(set_blur_radial,str);
  }
}









/**
* halftone line
*/
String set_halftone_dot = "halftone dot";
void setting_fx_haltone_dot() {
  String version = "0.0.1";
  int revision = 1;
  String author = "Stan le Punk";
  String pack = "Base 2019";
  int id = fx_classic_num;
  init_fx(set_halftone_dot,FX_HALFTONE_DOT,id,author,pack,version,revision);
  fx_classic_num++; 
}

void update_fx_haltone_dot(boolean move_is, vec2 pos, float size, float angle, float threshold) {
  if(move_is) {
    float pix_size = map(size,0,1,2,height/5); 
    fx_set_size(set_halftone_dot,pix_size);  

    angle = map(angle,0,1,-TAU,TAU);
    fx_set_angle(set_halftone_dot,angle);

    fx_set_threshold(set_halftone_dot,threshold);

    fx_set_pos(set_halftone_dot,pos.array());
  }
}
















/**
* halftone line
*/
String set_halftone_line = "halftone line";
void setting_fx_haltone_line() {
  String version = "0.0.2";
  int revision = 1;
  String author = "Stan le Punk";
  String pack = "Base 2019";
  int id = fx_classic_num;
  init_fx(set_halftone_line,FX_HALFTONE_LINE,id,author,pack,version,revision);
  fx_classic_num++; 
}

void update_fx_haltone_line(boolean move_is, vec2 pos, float num, float angle) {
  if(move_is) {
    fx_set_mode(set_halftone_line,0); 

    int num_line = (int)map(num,0,1,20,100); 
    fx_set_num(set_halftone_line,num_line);  

    // pass nothing with this two parameter
    // fx_set_quality(set_halftone_line,quality);
    // fx_set_threshold(set_halftone_line,threshold);

    angle = map(angle,0,1,-TAU,TAU);
    fx_set_angle(set_halftone_line,angle);

    fx_set_pos(set_halftone_line,pos.array());
  }
}






/**
* pixel
* v 0.0.1
*/
String set_pixel = "pixel";
// boolean effect_pixel_is;
void setting_fx_pixel() {
  String version = "0.0.1";
  int revision = 1;
  String author = "Stan le Punk";
  String pack = "Base 2019";
  int id = fx_classic_num;
  init_fx(set_pixel,FX_PIXEL,id,author,pack,version,revision);
  fx_classic_num++;
}

void update_fx_pixel(boolean move_is, float num, vec2 size, vec3 hsb) {

  if(move_is) {
    float sx = map(size.x,0,1,1,width);
    float sy = map(size.y,0,1,1,height);
    fx_set_size(set_pixel,sx,sy);

    int palette_num = (int)map(num,0,1,2,16);
    fx_set_num(set_pixel,palette_num);
    
    float h = hsb.x; // from 0 to 1 where
    float s = hsb.y; // from 0 to 1 where
    float b = hsb.z; // from 0 to 1 where
    if(s < 0) s = 0; else if (s > 1) s = 1;
    if(b < 0) b = 0; else if (b > 1) s = 1;
    fx_set_level_source(set_pixel,h,s,b); // not used ????

    fx_set_event(set_pixel,0,false);
  }
}




/**
* split
* v 0.0.1
*/
String set_split_rgb = "split rgb";
void setting_fx_split_rgb() {
  String version = "0.0.1";
  int revision = 1;
  String author = "Stan le Punk";
  String pack = "Base 2019";
  int id = fx_classic_num;
  init_fx(set_split_rgb,FX_SPLIT_RGB,id,author,pack,version,revision);
  fx_classic_num++; 
}


void update_fx_split_rgb(boolean move_is, vec2 str, float speed) {
  if(move_is) {
    vec2 strength = map(str,0,1,1,4);
    vec2 offset_red = vec2().wave_cos(frameCount,speed*.2,speed *.5).mult(strength);
    vec2 offset_green = vec2().wave_sin(frameCount,speed *.2,speed *.1).mult(strength);
    vec2 offset_blue = vec2().wave_cos(frameCount,speed*.1,speed *.2).mult(strength);
    fx_set_pair(set_split_rgb,0,offset_red.array());
    fx_set_pair(set_split_rgb,1,offset_green.array());
    fx_set_pair(set_split_rgb,2,offset_blue.array());
  }
}




/**
* warp proc
* v 0.0.1
*/
String set_warp_proc = "warp proc";
void setting_fx_warp_proc() {
  String version = "0.0.1";
  int revision = 1;
  String author = "Stan le Punk";
  String pack = "Base 2019";
  int id = fx_classic_num;
  init_fx(set_warp_proc,FX_WARP_PROC,id,author,pack,version,revision);
  fx_classic_num++; 
}


void update_fx_warp_proc(boolean move_is, float str, float speed) {
  if(move_is) {
    float max = map(str,0,1,1,height/20);
    float strength = sin(frameCount *(speed*speed)) *max;
    fx_set_strength(set_warp_proc,strength);
  }
}


/**
* warp tex
* v 0.0.1
*/
String set_warp_tex = "warp tex";
void setting_fx_warp_tex() {
  String version = "0.0.1";
  int revision = 1;
  String author = "Stan le Punk";
  String pack = "Base 2019";
  int id = fx_classic_num;
  init_fx(set_warp_tex,FX_WARP_TEX,id,author,pack,version,revision);
  fx_classic_num++; 
}


void update_fx_warp_tex(boolean move_is, float str) {
  if(move_is) {
    fx_set_strength(set_warp_tex,str);
  }
}





























/**
* FORCE WARP
* X SPECIAL
* this FX is linked with item and call a huge method and 
* class Force Field and class Force
* 2018-2019
* v 0.0.4
*/
Warp_Force warp_force_romanesco;
void init_warp_force() {
  if(warp_force_romanesco == null) {
    warp_force_romanesco = new Warp_Force(preference_path+"/shader/");
    warp_force_romanesco.add(g);
  }
}


void warp_force(float strength, float speed, vec3 colour) {
  strength *= strength;
  strength = map(strength,0,1,0,10);
  
  // cycling
  float cycling = 1;
  float ratio = map(speed,0,1,0,.8);
  if(ratio > 0) {
    ratio = (ratio*ratio*ratio);
    cycling = abs(sin(frameCount *ratio));
  }

  vec4 refresh_warp_force = vec4(colour.x,colour.y,colour.z,1);
  if(ratio > 0) {
    refresh_warp_force.mult(cycling);
  }
  warp_force_romanesco.refresh(refresh_warp_force);
  warp_force_romanesco.shader_init();
  warp_force_romanesco.shader_filter(extra_filter_fx);
  warp_force_romanesco.shader_mode(0);
  // here Force_field is pass
  warp_force_romanesco.show(force_field_romanesco,strength);

  if(warp_force_reset) {
    warp_force_romanesco.reset();
    warp_force_reset = false;
  }

}




boolean warp_force_reset;
void warp_force_keyPressed(char c_1) {
  if(key == c_1) {
    println("Reset Warp Force",frameCount);
    warp_force_reset = true;
  }
}























































