import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.awt.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Romanesco_25 extends PApplet {

  ///////////////////////////////////////////////////////////////
 // Romanesco Pr\u00e9sc\u00e8ne Alpha 0.25 work with Processing 211  ////
///////////////////////////////////////////////////////////////
// romanesco release, change this number to open the app
String release =("25") ;
boolean test = false ;

boolean openScene ;

PFont FuturaStencil ;


GraphicsEnvironment g = GraphicsEnvironment.getLocalGraphicsEnvironment();
GraphicsDevice[] devices = g.getScreenDevices();

int gris, grisClair, grisFonce, orange, rouge, vertClair, vertFonce ;
int c1, c2, c3, c4 ;
int colorOUT, colorIN ;
String pathControleur;
String pathScene, pathMiroir;
boolean open ;

//
String screen = ("") ; // for the saved table information
String whichAppOpeningTheScene = ("") ; // for the saved table information
Button buttonScene, buttonMiroir  ;
Button buttonWindow, buttonFullscreen  ;

//which screen var
Button [] whichScreenButton ;
//slider var
Slider sliderWidth, sliderHeight ;
int heightSlider, widthSlider ;
//which mode rendering
Button [] whichModeButton ;
//Button start
Button buttonStart ;


public void setup() {
  diplaySetup() ;
  colorSetup() ;
  structureSetup() ;
  loadSetup() ;
}
public void draw() {
  displayDraw() ;
  launcherDraw() ;
}
// END DRAW








//MOUSEPRESSED
public void mousePressed() {
  //which type of SCENE display full screen or window
  //to re-init the button
  if (buttonFullscreen.inside || buttonWindow.inside || buttonScene.inside || buttonMiroir.inside) {
    buttonScene.OnOff = false ;
    buttonMiroir.OnOff = false ;
    buttonFullscreen.OnOff = false ;
    buttonWindow.OnOff = false ;
  }
  // after the re-init we can check what's happen on the button
  buttonScene.mouseClic() ;
  buttonMiroir.mouseClic() ;
  buttonFullscreen.mouseClic() ;
  buttonWindow.mouseClic() ;
  
  //which screen for the fullscreen mode
  if(buttonFullscreen.OnOff) whichScreenPressed() ;
  
  //button start
  buttonStart.mouseClic() ;
  if(buttonStart.OnOff ) openApp(openScene) ;
  buttonStart.OnOff = false ;
}


//MOUSELEASED
public void mouseReleased() {
  //which Screen display
  if(buttonFullscreen.OnOff) whichScreenReleased() ;
  
  // setTable() ;
  saveProperty() ;
}



//ANNEXE
//GLOBAL
//which size SCENE for the MIROIR
PVector posButtonScene = new PVector ( 99, 40 ) ;
PVector sizeButtonScene = new PVector ( 85, 20 ) ;
PVector posButtonMiroir = new PVector ( 210, 40 ) ;
PVector sizeButtonMiroir = new PVector ( 85, 20 ) ;
//which size WINDOW or FULL SCREEN
PVector posButtonWindow = new PVector ( 10, 70 ) ;
PVector sizeButtonWindow = new PVector ( 180, 20 ) ;
PVector posButtonFullscreen = new PVector ( 200, 70 ) ;
PVector sizeButtonFullscreen = new PVector ( 180, 20 ) ;
//which size for window
PVector posSliderWidth = new PVector( 10, 134 ) ;
PVector posMoletteWidth = posSliderWidth ;
PVector posSliderHeight = new PVector( 200, 134 ) ;
PVector posMoletteHeight = posSliderHeight ;
PVector sizeSlider = new PVector ( 180, 16 ) ;
//button start
PVector posButtonStart = new PVector (10, 190) ;
PVector sizeButtonStart = new PVector (210, 20 ) ;
// "X" and  "Y" componant give the button position    "Z" componant = space between the button
PVector posWhichScreenButton = new PVector (150, 100, 23 ) ;

int [] standardSizeWidth = {0,160,240,320,480,640,800,964,1024,1280,1344,1366,1400,1600,1920,2048,2560,3840,4096,5120,6400,7680,8192,16384} ;
int [] standardSizeHeight = {0,120,160,240,320,480,544,600,720,768,800,960,1000,1008,1024,1050,1080,1200,1536,2048,2400,3072,4096,4320,4800,6144,12288} ;
  
// SETUP
////////
public void diplaySetup() {
  size(550, 230);
  colorMode(HSB,360,100,100) ;
  background(0);
}

public void colorSetup() {
  grisClair = color (27,10, 70) ; //gris clair
  gris = color (27,20, 50) ; //gris
  grisFonce = color (27,10, 20) ; //gris clair
  orange = color (27,100,100) ; //orange
  rouge = color (9,100,70) ; //rouge
  vertClair = color (88,85,71) ; // vert clair
  vertFonce = color (90,93,46) ; // vert fonc\u00e9
  c1 = color(orange) ;
  c2 = color(rouge ) ;
  c3 = color(vertClair) ;
  c4 = color(vertFonce) ;
  //common data
  colorIN = color (vertClair ) ;
  colorOUT = color (vertFonce ) ;
}


public void structureSetup() {
  String textScene = ("Sc\u00e8ne") ;
  String textMiroir = ("Miroir") ;
  String textFullscreen = ("in Fullscreen") ;
  String textWindow = ("in the Window") ;
  String textButtonStart = ("Launch Romanesco") ;
  
  buttonScene = new Button(posButtonScene, sizeButtonScene, c1, c2, c3, c4, textScene) ;
  buttonMiroir = new Button(posButtonMiroir, sizeButtonMiroir, c1, c2, c3, c4, textMiroir) ;
  buttonWindow = new Button(posButtonWindow, sizeButtonWindow, c1, c2, c3, c4, textWindow) ;
  buttonFullscreen = new Button(posButtonFullscreen, sizeButtonFullscreen, c1, c2, c3, c4, textFullscreen) ;
  buttonStart = new Button(posButtonStart, sizeButtonStart, colorIN, colorOUT, colorIN, colorOUT, textButtonStart ) ;

  //quantityScreen count the number of screen available
  int quantityScreen = devices.length ;
  whichScreenSetup(quantityScreen, posWhichScreenButton) ;
  
  int colorBG = color(grisFonce) ;
  int colorBoxIn = color(vertFonce) ;
  int colorBoxOut = color(rouge) ;
  
  sliderWidth = new Slider(posSliderWidth, posMoletteWidth, sizeSlider, colorBG, colorBoxIn, colorBoxOut ) ;
  sliderWidth.sliderSetting() ;
  sliderHeight = new Slider(posSliderHeight, posMoletteHeight, sizeSlider, colorBG, colorBoxIn, colorBoxOut ) ;
  sliderHeight.sliderSetting() ;
}



public void loadSetup() {
  FuturaStencil =loadFont ("FuturaStencilICG-20.vlw") ;
  // path to OPENING APP
  pathScene = (sketchPath("") + "sources/Prescene_"+release+".app");
  pathMiroir = (sketchPath("") + "sources/Scene_"+release+".app");
  //Change the language of controleur
  // "0" French - "1" English
  String[] l = split( ("1"), " ") ;
  saveStrings(sketchPath("")+"sources/preferences/language.txt", l) ;
}
// END SETUP
////////////



// DRAW
///////
public void displayDraw() {
  background(0) ;
  fill(orange) ;
  textFont(FuturaStencil,20);
}

boolean MiroirSetting ;

public void launcherDraw() {
  text("ROMANESCO alpha "+release, 10.0f, 30.0f);
  text("Choice                or ", 10.0f, 60.0f);
  choiceMiroirOrScene() ;
  if (buttonScene.OnOff || !MiroirSetting ) launchScene() ;
  if (buttonMiroir.OnOff || MiroirSetting) launchMiroir() ;
  
}
// END DRAW
///////////





//ANNEXE
////////
public void choiceMiroirOrScene() {
  buttonScene.displayButton() ;
  buttonMiroir.displayButton() ;
  if(MiroirSetting) whichAppOpeningTheScene =("true") ; else whichAppOpeningTheScene =("false") ;
}
// Scene launcher
public void launchScene() {
  MiroirSetting = false ;
  //button to choice between the fullscreen or window display
  buttonWindow.displayButton() ;
  buttonFullscreen.displayButton() ;
  
  if (buttonWindow.OnOff) {
    screen = ("false") ;
  } else if (buttonFullscreen.OnOff) {
    screen = ("true") ;
  } 
  // what display  
  if (buttonFullscreen.OnOff) {
    fill(orange) ;
    text("on screen", 10.0f, 120.0f);
    //on which screen display the window
    whichScreenDraw() ;
  } else if (buttonWindow.OnOff) {
    screen = ("false") ;
    sizeWindow() ;
  }
  //last step
  openScene = true ;
  launchApp() ;
  
}

// LAUNCH MIROIR
public void launchMiroir() {
  openScene = false ;
  MiroirSetting = true ;
  screen = ("false") ;
  buttonWindow.OnOff = true ;
  addressLocal(10,88) ;
  sizeWindow() ;
  //last step
  launchApp() ;
}

// LAUNCH APP
public void launchApp() {
  if ( buttonWhichScreenOnOff > 0 && buttonFullscreen.OnOff ) {
    buttonStart.displayButton() ;
  //window mode the user must choice a window size  
  } else if ( buttonWindow.OnOff && heightSlider>1 & widthSlider>1 ) {
    buttonStart.displayButton() ;
  } else {
    fill(orange) ;
    text("Please finish the configuration",10,210) ;
  }
}


// OPEN APP
// int timeToLaunch, timeRepere ;
// boolean openScene ;
public void openApp(boolean openTheScene) {
  if(openTheScene) open(pathScene); else open(pathMiroir) ;
  //timeRepere = (hour() *60 *60 )+(minute() *60) +second() ;
  //timeToLaunch = timeRepere +5 ;
  // openScene = true ;
}





Table sceneProperty;
String pathScenePropertySetting = sketchPath("")+"sources/preferences/sceneProperty.csv" ;

public void saveProperty() {
  sceneProperty = new Table();
  String colOne =("fullscreen");
  String colTwo =("whichScreen");
  String colThree =("resizable");
  String colFour =("decorated");
  String colFive =("width");
  String colSix =("height");
  String colSeven =("render");
  String colHeight =("miroir");
  
  sceneProperty.addColumn(colOne);
  sceneProperty.addColumn(colTwo);
  sceneProperty.addColumn(colThree);
  sceneProperty.addColumn(colFour);
  sceneProperty.addColumn(colFive);
  sceneProperty.addColumn(colSix);
  sceneProperty.addColumn(colSeven);
  sceneProperty.addColumn(colHeight);
  
  TableRow newRow = sceneProperty.addRow();
  if (heightSlider>1 & widthSlider>1 ) {
    newRow.setString(colOne, screen);
    newRow.setInt(colTwo, IDscreenSelected());
    newRow.setString(colThree, "true");
    newRow.setString(colFour, "true");
    newRow.setInt(colFive, standardSizeWidth[widthSlider-1]);
    newRow.setInt(colSix, standardSizeHeight[heightSlider -1]);
    newRow.setString(colSeven, "P3D");
    newRow.setString(colHeight, whichAppOpeningTheScene);
    
    saveTable(sceneProperty, pathScenePropertySetting);
  }
}
// END SAVE PROPERTY
////////////////////




/////////////////
// ADDRESS IP
public void addressLocal(int x, int y) {
  fill(orange) ;
  // textFont(SansSerif10, 10) ;
  try {
    //textSize(25) ;
  text("local address", x,y ) ;
  text (java.net.InetAddress.getLocalHost().getHostAddress(), x+188,y) ;
  }
  catch(Exception e) {}
}

////////////////
// SIZE WINDOW
public void sizeWindow() {
  //setting the Scene size
  sliderHeight.sliderUpdate() ;
  sliderWidth.sliderUpdate() ;
  
  heightSlider = PApplet.parseInt(map(sliderHeight.getValue(),0,1,1,standardSizeHeight.length))  ;
  widthSlider = PApplet.parseInt(map(sliderWidth.getValue(),0,1,1,standardSizeWidth.length))  ;
  String h = Integer.toString(standardSizeHeight[heightSlider -1]) ;
  String w = Integer.toString(standardSizeWidth[widthSlider-1]) ;
  //check the width
  int correctionPosY = -14 ;
  if ( widthSlider <= 1 ) {
    fill(rouge) ;
    text("Width " + w, posSliderWidth.x, posSliderWidth.y +correctionPosY);
  } else {
    fill(vertFonce) ;
    text("Width " + w, posSliderWidth.x, posSliderWidth.y +correctionPosY);
  }
  //check the height
  if ( heightSlider <= 1 ) {
    fill(rouge) ;
    text("Heigth " + h, posSliderHeight.x, posSliderHeight.y +correctionPosY);
  } else {
    fill(vertFonce) ;
    text("Heigth " + h, posSliderHeight.x, posSliderHeight.y +correctionPosY);
  }
}

//////////////
//WHICH SCREEN
int screenNum  ;
//SETUP 
public void whichScreenSetup(int n , PVector infoPos) {
  //quantity of button choice
  screenNum = n ;
  whichScreenButton = new Button [screenNum] ;
  //position of the button  
  int x = (int)infoPos.x ;
  int y = (int)infoPos.y ;
  int space = (int)infoPos.z ;
  
  for ( int i = 0 ; i <  screenNum ; i++) {
    PVector pos = new PVector( x +( i *space), y ) ;
    PVector size = new PVector (20,20) ;
    String title = Integer.toString(i+1) ;
    whichScreenButton[i] = new Button(pos, size, c1, c2, c3, c4, title) ;
  }
}

//DRAW
public void whichScreenDraw() {
  for(int i =0 ; i <screenNum ; i++) {
    whichScreenButton[i].displayButton() ;
  }
}

//MOUSEPRESSED
public void whichScreenPressed() {
  for(int i =0 ; i< screenNum ; i++ ) {
    if (whichScreenButton[i].inside ) {
      for( int j =0 ; j < screenNum ; j++ ) whichScreenButton[j].OnOff = false ;
    }
  }
}

//MOUSERELEASED
int buttonWhichScreenOnOff ;

public void whichScreenReleased() {
  buttonWhichScreenOnOff = 0 ;
  for(int i = 0 ; i<screenNum ; i++ ) {
    whichScreenButton[i].mouseClic() ;
    if(whichScreenButton[i].OnOff) buttonWhichScreenOnOff += 1 ;
  }
}

//ID screen
int IDscreen = 0 ;
public int IDscreenSelected() {
  
  for (int i = 0 ; i < screenNum ; i++ ) { 
    if (whichScreenButton[i].OnOff == true ) IDscreen = i+1 ;
  }
  return IDscreen ;
}
class Button
{
  boolean inside, OnOff ;
  PVector pos, size ;
  int On_In, On_Out, Off_In, Off_Out ;
  String textOn, textOff ;
  
  //CONSTRUCTOR
  
  //basic Button
  Button(PVector pos, PVector size) {
    Off_In = color (27,100,100) ; //orange
    Off_Out = color (9,100,70) ; //rouge
    On_In = color (88,85,71) ; // vert clair
    On_Out = color (90,93,46) ; // vert fonc\u00e9
    this.pos = pos ;
    this.size = size ;
  }
  //with specific color
  Button(PVector pos, PVector size, int Off_In, int Off_Out, int On_In, int On_Out) {
    this.Off_In = Off_In ;
    this.Off_Out = Off_Out ;
    this.On_In = On_In ; 
    this.On_Out = On_Out ;
    this.pos = pos ;
    this.size = size ;
  }
  
  //text Button with two text
  Button(PVector pos, PVector size, String textOn, String textOff) {
    Off_In = color (27,100,100) ; //orange
    Off_Out = color (9,100,70) ; //rouge
    On_In = color (88,85,71) ; // vert clair
    On_Out = color (90,93,46) ; // vert fonc\u00e9
    this.textOn = textOn ;
    this.textOff = textOff ;
    this.pos = pos ;
    this.size = size ;
  }
  //text button with specific color with two text
  Button(PVector pos, PVector size, int Off_In, int Off_Out, int On_In, int On_Out, String textOn, String textOff) {
    this.Off_In = Off_In ;
    this.Off_Out = Off_Out ;
    this.On_In = On_In ; 
    this.On_Out = On_Out ;
    this.textOn = textOn ;
    this.textOff = textOff ;
    this.pos = pos ;
    this.size = size ;
  }
    //text button with specific color with one text
  Button(PVector pos, PVector size, int Off_In, int Off_Out, int On_In, int On_Out, String textOn) {
    this.Off_In = Off_In ;
    this.Off_Out = Off_Out ;
    this.On_In = On_In ; 
    this.On_Out = On_Out ;
    this.textOn = textOn ;
    this.textOff = textOn ;
    this.pos = pos ;
    this.size = size ;
  }
  
  
  public void displayButton() {
    String textResult ;
    
    if(OnOff) {
      textResult = textOn ;
      if(insideRect()) fill(On_In) ; else fill (On_Out ) ;
    } else {
      textResult = textOff ;
      if(insideRect()) fill(Off_In) ; else fill (Off_Out ) ;
    }
      
    if (textOff != null || textOn != null ) {
      textSize(size.y) ;
      text(textResult, pos.x, pos.y + size.y ) ; 
    } else {
      rect(pos.x, pos.y, size.x, size.y) ;
    }
  }
  
  
  
  
  
  //COMMON VOID
  //ANNEXE VOID
  //detection cursor on area
  //rect
  public boolean insideRect() { 
    if ( mouseX > pos.x && mouseX < pos.x + size.x && mouseY > pos.y  && mouseY < pos.y + size.y ) {
      inside = true ;
      return true ; 
    } else {
      inside = false ;
      return false ; 
    }
  }

  //ellipse
  public boolean insideEllipse() {
    float disX = pos.x -mouseX ; 
    float disY = pos.y -mouseY  ; 
    if (sqrt(sq(disX) + sq(disY)) < size.x/2 ) {
     inside = true ;
      return true ; 
    } else {
      inside = false ;
      return false ; 
    }
  }
 
  //MOUSEPRESSED
  public void mouseClic() 
  {
    //rect
    if ( insideRect() ) {
      if ( OnOff ) OnOff = false ; else OnOff = true ;
    }
  } 
  
}
class Slider
{
  private PVector pos, size, posText, posMol, sizeMol, newPosMol, posMin, posMax ;
  private int slider, boxIn, boxOut, colorText ;
  private boolean molLocked, inside ;
  private PFont p ;
  
  //CONSTRUCTOR with title
  public Slider(PVector pos, PVector posMol , PVector size, PVector posText, int slider, int boxIn, int boxOut, int colorText, PFont p) {
    this.pos = pos ;
    this.posMol = posMol ;
    this.size = size ;
    this.posText = posText ;
    this.slider = slider ;
    this.boxIn = boxIn ;
    this.boxOut = boxOut ;
    this.colorText = colorText ;
    this.p = p ;

    newPosMol = new PVector (0, 0) ;
    //which molette for slider horizontal or vertical
    if ( size.x >= size.y ) sizeMol = new PVector (size.y, size.y ) ; else sizeMol = new PVector (size.x, size.x ) ;
    posMin = new PVector (pos.x, pos.y) ;
    posMax = new PVector (pos.x + size.x - sizeMol.x, pos.y + size.y - sizeMol.y ) ;
  }
  
  //CONSTRUCTOR minimum
  public Slider(PVector pos, PVector posMol , PVector size, int slider, int boxIn, int boxOut ) {
    this.pos = pos ;
    this.posMol = posMol ;
    this.size = size ;
    this.slider = slider ;
    this.boxIn = boxIn ;
    this.boxOut = boxOut ;

    newPosMol = new PVector (0, 0) ;
    //which molette for slider horizontal or vertical
    if ( size.x >= size.y ) sizeMol = new PVector (size.y, size.y ) ; else sizeMol = new PVector (size.x, size.x ) ;
    posMin = new PVector (pos.x, pos.y) ;
    posMax = new PVector (pos.x + size.x - sizeMol.x, pos.y + size.y - sizeMol.y ) ;
  }
  
  //slider with external molette
  public Slider(PVector pos, PVector posMol , PVector size, PVector sizeMol,  int slider, int boxIn, int boxOut ) {
    this.pos = pos ;
    this.posMol = posMol ;
    this.sizeMol = sizeMol ;
    this.size = size ;
    this.slider = slider ;
    this.boxIn = boxIn ;
    this.boxOut = boxOut ;

    newPosMol = new PVector (0, 0) ;
    posMin = new PVector (pos.x, pos.y) ;
    posMax = new PVector (pos.x + size.x - sizeMol.x, pos.y + size.y - sizeMol.y ) ;
  }
  
  //SETTING
  
  public void sliderSetting() {
    noStroke() ;
    
    //SLIDER
    fill(slider) ;
    rect(pos.x, pos.y, size.x, size.y ) ;
    
    //MOLETTE
    fill(boxOut) ;
    newPosMol = new PVector (posMol.x, posMol.y  ) ;
    rect(posMol.x, posMol.y, sizeMol.x, sizeMol.y ) ;
    
  }
  
  //Slider update with title
  public void sliderUpdate(String s, boolean t) {
    //SLIDER
    fill(slider) ;
    rect(pos.x, pos.y, size.x, size.y ) ;
    if (t) {
      fill(colorText) ;
      textFont (p ) ;
      textSize (posText.z) ;
      text(s, posText.x, posText.y ) ;
    }
    //MOLETTE
    if (insideRect()) fill(boxIn); else fill(boxOut ) ;
    moletteUpdate() ;
    rect(newPosMol.x, newPosMol.y, sizeMol.x , sizeMol.y ) ;
  }
  //Slider update simple
  public void sliderUpdate() {
    //SLIDER
    fill(slider) ;
    rect(pos.x, pos.y, size.x, size.y ) ;
    /*
    if (t) {
      fill(colorText) ;
      textFont (p ) ;
      textSize (posText.z) ;
      text(s, posText.x, posText.y ) ;
    }
    */
    //MOLETTE
    if (insideRect()) fill(boxIn); else fill(boxOut ) ;
    moletteUpdate() ;
    rect(newPosMol.x, newPosMol.y, sizeMol.x , sizeMol.y ) ;
  }
  
  
  public void moletteUpdate() {
    if (locked ()  ) molLocked = true ;
    if (!mousePressed)  molLocked = false ; 
      
    if ( molLocked ) {  
      if ( size.x >= size.y ) newPosMol.x = constrain(mouseX -(sizeMol.x / 2.0f ), posMin.x, posMax.x)  ; else newPosMol.y = constrain(mouseY -(sizeMol.y / 2.0f ), posMin.y, posMax.y) ;
    }
  }
  
  //RETURN
  public float getValue() {
    float value ;
    if ( size.x >= size.y ) value = map (newPosMol.x, posMin.x, posMax.x, 0,1) ; else value = map (newPosMol.y, posMin.y, posMax.y, 0,1) ;
    return value ;
  }
  
  
  //COMMON VOID
  //ANNEXE VOID
  //rect
  public boolean insideRect() { 
    if ( mouseX > pos.x && mouseX < pos.x + size.x && mouseY > pos.y  && mouseY < pos.y + size.y ) {
      inside = true ;
      return true ; 
    } else {
      inside = false ;
      return false ; 
    }
  }

  //ellipse
  public boolean insideEllipse() {
    float disX = pos.x -mouseX ; 
    float disY = pos.y -mouseY  ; 
    if (sqrt(sq(disX) + sq(disY)) < size.x/2 ) {
     inside = true ;
      return true ; 
    } else {
      inside = false ;
      return false ; 
    }
  }
  
  //locked
  public boolean locked () {
    if ( inside  && mousePressed ) return true ; else return false ;
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Romanesco_25" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}