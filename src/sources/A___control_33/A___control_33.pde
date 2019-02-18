/**
Romanesco dui
2012–2019
version 32
Processing 3.5.3
*/
/**
Controller 
V 1.2.0
2015 may 4_100 lines of code
2016 september 8_700 lines of code
2017 March 11_100 lines of code
2018 June 5_000 lines of code without CROPE and ROPE internal library who have around 18_000 lines
*/
String IAM = "controller";

// DEV SETTING

boolean DEV_MODE = true; // inter alia, path preferences folder, curtain
boolean LIVE = false;
boolean MIROIR = false;
boolean KEEP_BUTTON_ITEM_STATE = true;










// EXPORT SETTING

// DIRECT
// boolean LIVE = false;
// boolean MIROIR = false;
// boolean KEEP_BUTTON_ITEM_STATE = true;
// boolean DEV_MODE = false;  // inter alia, path preferences folder, curtain

// LIVE
// boolean LIVE = true;
// boolean MIROIR = false;
// boolean KEEP_BUTTON_ITEM_STATE = true;
// boolean DEV_MODE = false; // inter alia, path preferences folder, curtain









void settings() {
  size(670,725);
  size_window_ref = ivec2(width,height);
  set_design();
}

void setup() {
  colorMode(HSB,360,100,100);
  // surface.setLocation(0,20);
  load_window_location();
  path_setting();
  version();
  setting_misc();
  init_button_general();
  init_midi();
  create_and_initialize_data(); 
  load_setup();
  // load_filter();
  
  set_system_specification();
  set_font();
  set_display_slider();
  set_import_pic_button();
  set_console();
  set_button_item_console();  
  build_console();
  build_dropdown_bar();
  build_dropdown_item_selected();
  build_button_item_console();
  build_inventory();
  set_OSC();
  set_data();
  reset();
}

void draw() {
  check_size_window();
  update_window_location();
  check_slider_item();
  
  add_media();
  check_button();

  manage_autosave();
  
  update_media();
  
  surface.setTitle(nameVersion + ": " +prettyVersion+"."+version+ " - Controller");

  set_data();

  display_structure();

  show_misc_text();
  show_slider_controller();

  update_button();
  show_button();

  show_dropdown();
  
  midi_manager(false);
  update_midi();
  update_OSC();
  update_dial();

  reset();
  credit();
}


void mouseWheel(MouseEvent e) {
  scroll(e);
}

void mousePressed () {
  if(!dropdown_is()) {
    mousePressed_button_general();
    mousepressed_button_item_console();
    mousepressed_button_inventory();
  } 
}

void keyPressed() {
  keypressed_midi();
  shortcuts_controller();
}


void keyReleased() { 
  key_false();
  keyboard[keyCode] = false;
}