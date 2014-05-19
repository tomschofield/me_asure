//All code is license to Tom Schofield and John Bowers under Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)
//better to do a whole analysis based on half the time so take out time out mid analysis
import java.util.*;

class InteractionManager {
  boolean hasSteppedAway;
  boolean analysisFinished = true;
  boolean isNewFace =false;
  boolean faceIsLost = true;
  boolean pisNewFace =false;
  boolean pfaceIsLost = true;
  boolean countingOut = false;
  boolean searching = true;
  //time in millis between getting face and giving result
  int analysisDuration = 10000; 
  int analysisStartTime = 0;
  //time in millis before deciding that this is a different person
  int timeoutDuration = 2000; 
  int timeoutStartTime = 0;
  int pFound = 0;
  float currentRatio =0.5; 
  float ratioIncrement =0.0;
  int count = 0;
  InteractionManager() {
  }
  void update() {
    timeFacultyAnalysis();

    if (analysisFinished && found ==0) {
      searching = true;
    }
    else {
      searching = false;
    }

    if (isNewFace!=pisNewFace) {
      //println("is new face "+isNewFace);
    }
    if (faceIsLost!=pfaceIsLost) {
      //println("face is lost "+faceIsLost);
      //      if(faceIsLost){
      //       for (int i=0;i<faculties.length;i++) {
      //        faculties[i].found=false;
      //       } 
      //      }
    }
    if (!analysisFinished) {
      currentRatio = ratioIncrement * (millis()-analysisStartTime);
      println("currentRatio "+currentRatio+"   "+str(count));
      faceSmoother.setRatio(1-currentRatio);
      count++;
    }

    pisNewFace = isNewFace;
    pfaceIsLost = faceIsLost;
    isNewFace = false;
  }
  void checkFound(int found) {
    checkIsNewFace(found);
  }
  void timeFacultyAnalysis() {
    if (isNewFace) {

      shuffleArray(facultyIndices);
      //println(facultyIndices);
      println("Restting analysis time");
      for (int i=0;i<measures.length;i++) {
        //measures[i]=0;
      }
      //float numFramesAtNFPS = analysisDuration/(frameRate*10);

      float incPerMilli = 1.0 / analysisDuration;
      //we want to take analysisDuration to get from x to 1
      //numFramesAtNFPS give us the number of frames it takes us to get from 0-analysisDuration

        //so ratio
      ratioIncrement = incPerMilli;//1.0/(0000000000000.1 + numFramesAtNFPS);

      println("ratioIncrement "+ratioIncrement);
      currentRatio = 0.0;
      analysisStartTime = millis();
      analysisFinished = false;
    }
    if (millis()-analysisStartTime >= analysisDuration) {
      analysisFinished = true;
      //println("finished analysis");
      //count = 0;
    }
  }
  void drawInteractionInfo(float x, float y) {
    pushMatrix();
    pushStyle();
    fill(255, 0, 0);
    textFont(font, 24);
     if (millis()-analysisStartTime<(analysisDuration*0.3)) {
      //info="FOUND SUBJECT";
      image(image,0,0);//,700, 394);  
    }
    translate(x, y);
    String info = "";//Subject Information: \n";
   
    //    if(millis()-analysisStartTime<(analysisDuration*0.3)){
    //    info+="Found new Subject\n";
    //    }
    //    else{
    //     info+="\n"; 
    //    }
    //    if(faceIsLost){
    //    info+="Subject is lost: searching for subjects\n";
    //    }
    //    if(!analysisFinished&&!faceIsLost  ){
    //     info+="Time left for faculty analysis "+str( analysisDuration-(millis()-analysisStartTime));
    //     info+="\n";
    //    }
    //    if(analysisFinished&&!searching){
    //      info+="Analysis Complete\nPlease Move Away";
    //    }
   // text(info, 0, 0);
    popStyle();
    popMatrix();
  }
  void checkIsNewFace(int found) {
    
    println("countingOut "+countingOut +" faceIsLost "+faceIsLost +" isNewFace "+isNewFace);
    if (!countingOut && pFound!=found && found >=1) {
      isNewFace = true;
    }
    
    if (found >=1) {
      faceIsLost = false;

      //timeoutStartTime = millis();
    }
    //if the number of faces has changed and there's no face now then...
    if (pFound!=found && found ==0) {
      //set the time when we lost the face
      timeoutStartTime = millis();
      countingOut = true;
    }
    //if the number of faces has changed and there IS a face now then...
    

    if (millis()-timeoutStartTime>=timeoutDuration) {
      if (found ==0 ) {
        faceIsLost = true;
        //println("face is lost");
      }
      //println("lost face");
      countingOut = false;
    }
    pFound = found;
  }
}

