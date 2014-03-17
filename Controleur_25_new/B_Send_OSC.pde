//GLOBAL
import oscP5.*;
import netP5.*;

OscP5 osc;
NetAddress targetPreScene ;
// local
String IPadress = ("127.0.0.1") ;
// Message to préScène
String toPreScene [] = new String [8] ;



void sendOSCsetup() {
  osc = new OscP5(this, 10000);
 targetPreScene = new NetAddress(IPadress,10000);
}

void sendOSCdraw() {
  OscMessage RomanescoControleur = new OscMessage("ROMANESCO contrôleur");
  
  //int value join in one String 
  translateDataToSend() ;
  
  //BUTTON to String
  toPreScene[0] = joinIntToString(valueButtonGlobal) ; 
  toPreScene[1] = joinIntToString(valueButtonObj) ;
  toPreScene[2] = joinIntToString(valueButtonTex) ;
  toPreScene[3] = joinIntToString(valueButtonTypo) ;
  //println(valueButtonObj) ;
  //println(toPreScene[1]) ;
  //SLIDER to String
  int[] dataIntGlobal = new int[numSliderGroupZero] ;
  for ( int i = 1   ; i < numSliderGroupZero-1 ; i++) { 
    dataIntGlobal[i-1] = floor(valueSlider[i]) ; 
  }
  toPreScene[4] = joinIntToString(dataIntGlobal) ;
  //float value slider obj
  int[] dataIntObj = new int[numSliderGroupOne] ;
  for ( int i = 101   ; i < 101+numSliderGroupOne ; i++) { dataIntObj[i-101] = floor(valueSlider[i]) ; }
  toPreScene[5] = joinIntToString(dataIntObj);
  //float value slider tex
  int[] dataIntTex = new int[numSliderGroupTwo] ;
  for ( int i = 201   ; i < 201+numSliderGroupTwo ; i++) { dataIntTex[i-201] = floor(valueSlider[i]) ; }
  toPreScene[6] = joinIntToString(dataIntTex) ;
  //float value slider typo
  int[] dataIntTypo = new int[numSliderGroupThree] ;
  for ( int i = 301   ; i < 301+numSliderGroupThree ; i++) { dataIntTypo[i-301] = floor(valueSlider[i]) ; }
  toPreScene[7] = joinIntToString(dataIntTypo) ;
  
  //add to OSC
  for ( int i = 0 ; i < toPreScene.length ; i++) {
    RomanescoControleur.add(toPreScene[i]);
  }
  
  //send
  osc.send(RomanescoControleur, targetPreScene ); 
}



  
  
  
void translateDataToSend() {
  //BUTTON GLOBAL
  //sound
  valueButtonGlobal[1] = EtatBbeat ;
  valueButtonGlobal[2] = EtatBkick ;
  valueButtonGlobal[3] = EtatBsnare ;
  valueButtonGlobal[4] = EtatBhat ;
  //dropdown typo
  valueButtonGlobal[7] = dropdown[lastDropdown].getSelection() +1 ; ;
  //curtain
  valueButtonGlobal[10] = EtatBOcurtain ;
  
  //BUTTON OBJ
  if(numGroup[1] > 0 ) {
    for ( int i = 0 ; i < numGroup[1]   ; i ++) {
      valueButtonObj[i *10 +1] = EtatBOf[i *10 +1] ;
      valueButtonObj[i *10 +2] = EtatBOf[i *10 +2] ;
      valueButtonObj[i *10 +3] = EtatBOf[i *10 +3] ;
      valueButtonObj[i *10 +4] = EtatBOf[i *10 +4] ;
      valueButtonObj[i *10 +5] = EtatBOf[i *10 +5] ;
      valueButtonObj[i *10 +9] = dropdown[i +1].getSelection() ;
    }
  }
    //println(valueButtonObj) ;
    // println(EtatBOf) ;
  //BUTTON TEX

  if(numGroup[2] > 0 ) {
    for ( int i = 0 ; i < numGroup[2] ; i ++) {
      valueButtonTex[i *10 +1] = EtatBTf[i *10 +1] ;
      valueButtonTex[i *10 +2] = EtatBTf[i *10 +2] ;
      valueButtonTex[i *10 +3] = EtatBTf[i *10 +3] ;
      valueButtonTex[i *10 +4] = EtatBTf[i *10 +4] ;
      valueButtonTex[i *10 +5] = EtatBTf[i *10 +5] ;
      valueButtonTex[i *10 +9] = dropdown[i +1].getSelection() ;
    }
  }

  //BUTTON TYPO
  if(numGroup[3] > 0 ) {
    for ( int i = 0 ; i < numGroup[3] ; i ++) {
      valueButtonTypo[i *10 +1] = EtatBTYf[i *10 +1] ;
      valueButtonTypo[i *10 +2] = EtatBTYf[i *10 +2] ;
      valueButtonTypo[i *10 +3] = EtatBTYf[i *10 +3] ;
      valueButtonTypo[i *10 +4] = EtatBTYf[i *10 +4] ;
      valueButtonTypo[i *10 +5] = EtatBTYf[i *10 +5] ;
      valueButtonTypo[i *10 +9] = dropdown[i +41].getSelection() ;
    }
  }
  

}
  





  
