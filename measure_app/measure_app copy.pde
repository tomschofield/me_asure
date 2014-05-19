
// adapted from from Greg Borenstein's 2011 example
// <a href="http://www.gregborenstein.com/" target="_blank" rel="nofollow">http://www.gregborenstein.com/</a>
// <a href="https://gist.github.com/1603230" target="_blank" rel="nofollow">https://gist.github.com/1603230</a>
//

//resting state
//



import oscP5.*;

import java.util.*;

OscP5 oscP5;
float yStretch =1.3;
// num faces found
int found;
PImage image;
// pose
float poseScale;
PVector posePosition = new PVector();
PVector poseOrientation = new PVector();

// gesture
float mouthHeight;
float mouthWidth;
float eyeLeft;
float eyeRight;
float eyebrowLeft;
float eyebrowRight;
float jaw;
float nostrils;
PFont font;
PFont veryLargeFont;
PFont smallFont;
PFont boldFont;
PFont largeFont;
PVector[] meshPoints;

Graph mouthHGraph;
Graph mouthWGraph;
int [] facultyIndices;
Smoother faceSmoother;

FaceOrganLines organLines;

SliderGraph mouthWidthSliderGraph;
SliderGraph [] sliders;
Graph [] graphs;
InteractionManager interactionManager;

FacultiesEngine engine;

Faculty [] faculties;
float [][] myReadings;
int UPPER_LIP_SIZE = 0;
int UPPER_LIP_CURVE = 1;
int LOWER_LIP_SIZE = 2;
int LOWER_LIP_CURVE = 3;
int MOUTH_CURVE = 4;
int NOSE_WIDTH = 5;
int SEPTUM_SIZE = 6;
int EYE_SIZE = 7;
int EYE_OPENNESS = 8;
int EYEBROW_SIZE = 9;
int EYEBROW_CURVE = 10;
int EYEBROW_PROPORTIONS = 11;
int CHIN_SHAPE = 12;
int CHIN_EXTENSION = 13;
int NOSE_LENGTH = 14;
int NOSE_PROPORTION = 15;

int num_measures = 16;
String [] measureNames;
float [] measures;
float measures_buffer [][];
int measures_buffer_size = 100;
float pmeasure = 0;
int count = 0;
void setup() {
  smooth();
  noCursor();
  size(1920, 1080, P2D);
  // hint(ENABLE_RETINA_PIXELS) ;
  frameRate(30);
  font = loadFont("Serif-24.vlw");
  smallFont = loadFont("Serif-10.vlw");
  boldFont = loadFont("ACaslonPro-Bold-24.vlw");
  largeFont = loadFont("Serif-48.vlw");
  veryLargeFont = loadFont("Serif-68.vlw");
  
  image = loadImage("subject.png");
  textFont(font, 24);
  oscP5 = new OscP5(this, 8338);

  meshPoints = new PVector[66];
  myReadings = new float[1500][];

  for (int i = 0; i < meshPoints.length; i++) {
    meshPoints[i] = new PVector();
  }
 setupOSC();
  
  faceSmoother = new Smoother();

  organLines = new FaceOrganLines(meshPoints);



  float [] thresholds= {
    0, 12.9, 14.0, 15.5, 21.0
  };


  setupFaculties();
  //replace with proper faculty finding here;
  facultyIndices = new int [faculties.length];
  for(int i=0;i<facultyIndices.length;i++){
    facultyIndices[i]=i;
  }
  shuffleArray(facultyIndices);
  setupMeasures();
  for (int i=0;i<measures.length;i++) {
    //x y width height initvalues
    println("measures_buffer[i] length "+measures_buffer[i].length);
//    graphs[i] = new Graph(200, 20+(i*55), 1400, 50, measures_buffer[i], 0, 1, 10, 100.0, measureNames[i]);
     graphs[i] = new Graph(100+(i*80), height-400, 1400, 50, measures_buffer[i], 0, 1, 10, 100.0, measureNames[i]);

  }
  // mouthWGraph = new Graph(120, height-250, 800, 50, faceSmoother.buffer_mouthHeight, 0, 1, 10, 20.0, "MOUTH WIDTH");

  //  mouthHGraph = new Graph(120, height-400, 800, 50, faceSmoother.buffer_mouthWidth, 0, 1, 1, 20.0, "MOUTH HEIGHT");

  for (int i=0;i<measures.length;i++) {
    measures[i]=0.0;
    sliders[i] =new SliderGraph(width-300, (i*50)+20, 250, 20, 0.0, 0.5, 0.0, measureNames[i], thresholds);
  }
  //  mouthWidthSliderGraph = new SliderGraph(width-300, 50, 250, 20, 12.0, 16.0, 0.0, "Mouth Width", myfaculties, thresholds);
  interactionManager = new InteractionManager();
  engine = new FacultiesEngine();
}

void draw() {
  background(0);
  scale(1,yStretch);
  translate(0,-0.5*yStretch);
  
  //organLines.updatePoints(meshPoints);
  
  interactionManager.update();
  pmeasure = measures[0];
  organLines.updatePoints(faceSmoother.pMeshPoints);
  populateMeasures();
  
  //measures_buffer[measures_buffer.length-1]=measures;
  //for each graph
  for (int i=0;i<graphs.length;i++) {
    //for each value, update 
    
    for(int j=0;j<measures_buffer_size-1;j++){
      measures_buffer[i][j] = measures_buffer[i][j+1];
    }
    measures_buffer[i][measures_buffer_size-1] = measures[i];
  }
  //faceSmoother.updateMeasures(measures);
  //  if(measures[0]!=pmeasure&&measures[0]>0){
  //    myReadings[count]=Arrays.copyOfRange(measures, 0, measures.length);
  //    count++;
  //    println("new value ",measures[0]);
  //  }
  for (int i=0;i<sliders.length;i++) {
    sliders[i].update(measures[i]);
    sliders[i].display();
  }
  //calculate the faculties
  engine.update(organLines.getNormalisedPoints(1.0), faculties, measures);
  engine.displayDescriptions(faculties, new PVector(-10, -10));


//  for (int i=0;i<graphs.length;i++) {
//    graphs[i].updatePoints(measures_buffer[i]);
//    graphs[i].drawAxes(color(255, 255, 255));
//    graphs[i].drawScatter(color(255, 255, 255));
//  }

  //drawDebugInfo(50, 50, 0.5);
  textFont(smallFont, 10);

  //if (found!=0) {
    //    drawFacePoints(organLines.getJawline());
    //    drawFacePoints(organLines.getRightEye());
    //    drawFacePoints(organLines.getLeftEye());
    //    drawFacePoints(organLines.getLeftEyebrow());
    //    drawFacePoints(organLines.getRightEyebrow());
    //    drawFacePoints(organLines.getLipsOuter());
    //    drawFacePoints(organLines.getLipsInner());
    //    drawFacePoints(organLines.getNoseBridge());
    //    drawFacePoints(organLines.getNostrils());
    int scale = 400;
    drawFacePoints(organLines.getNormalisedPoints(800), (width/2)-(scale), (height/2)-(scale));
  //}

  organLines.getNormalisedXYForPoint(organLines.getJawline()[8]);
  interactionManager.drawInteractionInfo(width-600,30);
  pushStyle();
  fill(200);
  textFont(font,12);
  text(str(frameRate), 30,height-285);
  popStyle();
}
//void addReading(){
// organLines.updatePoints(faceSmoother.pMeshPoints);
//  populateMeasures();
//  
//  myReadings.add(measures); 
//  
//}
void populateMeasures() {

  PVector[] myPts = organLines.getNormalisedPoints(1.0);
  measures[ UPPER_LIP_SIZE ]= myPts[54].dist(myPts[48]);
  //could be improved
  measures[ UPPER_LIP_CURVE]= myPts[48].y- myPts[50].y;
  measures[ LOWER_LIP_SIZE] = myPts[54].dist(myPts[59]);
  measures[ LOWER_LIP_CURVE] = myPts[57].y - myPts[54].y;
  measures[ MOUTH_CURVE] = measures[ UPPER_LIP_CURVE] + measures[ LOWER_LIP_CURVE ];
  measures[ NOSE_WIDTH ]= myPts[31].dist(myPts[35]);
  measures[ SEPTUM_SIZE] = myPts[32].dist(myPts[34]);
  measures[ EYE_SIZE ]= (myPts[36].dist(myPts[39]) + myPts[42].dist(myPts[45]))/2.0;
  measures[ EYE_OPENNESS ]= (myPts[37].dist(myPts[41]) + myPts[44].dist(myPts[46]))/2.0;
  measures[ EYEBROW_SIZE ]= (myPts[17].dist(myPts[21]) + myPts[22].dist(myPts[26]))/2.0;
  measures[ EYEBROW_CURVE ]= ((myPts[17].y- myPts[19].y) + (myPts[22].y - myPts[24].y))/2.0;
  measures[ EYEBROW_PROPORTIONS ]= ((myPts[17].dist(myPts[18]))/(myPts[17].dist(myPts[21])) +  (myPts[25].dist(myPts[26]))/(myPts[22].dist(myPts[26])))/2.0;
  //0=round 0.5 = square 1.0 - point

  measures[ CHIN_SHAPE] = 0.0;
  measures[ CHIN_EXTENSION ]= myPts[8].dist(myPts[57]);

  measures[NOSE_LENGTH] = myPts[27].dist(myPts[30]); 
  measures[NOSE_PROPORTION] = (myPts[27].dist(myPts[28]))/(myPts[27].dist(myPts[30]));
}


void saveOutPoints() {
  PrintWriter output;
  output = createWriter("data/facePoints.txt");
  output.println("lEyeBrow");
  for ( int i=0;i<organLines.getLeftEyebrow().length;i++) {
    PVector thisPoint = organLines.getLeftEyebrow()[i];
    output.print(thisPoint.x);
    output.print(",");
    output.println(thisPoint.y);
  }
  output.flush();
  output.close();
}
void saveReadings() {
  println("saving readings");
  PrintWriter output;
  output = createWriter("data/readings.csv");

  for ( int i=0;i<myReadings.length;i++) {
    if (myReadings[i]!=null) {
      float [] aLine = myReadings[i];

      println(aLine[0]);
      String newLine = "";
      for (int j=0;j<aLine.length-1;j++) {
        newLine+=str(aLine[j])+",";
      }
      newLine+=str(aLine[aLine.length-1]);

      output.println(newLine);
    }
    else {
      break;
    }
  }
  output.flush();
  output.close();
}
void keyPressed() {
  if (key=='s'||key=='S') {
    saveReadings();
  }
}
void drawDebugInfo(int xPos, int yPos, float sFactor) {
  pushMatrix();
  translate(xPos, yPos);
  //scale(sFactor);
  String results = "faceIsLost "+ str(interactionManager.faceIsLost);
  results+="\n";
  results+= "isNewFace "+str(interactionManager.isNewFace);
  results+="\n";
  results+="analysisFinished "+str(interactionManager.analysisFinished);
  results+="\n";


  results+=str(found);
  //  String results  =  "poseScale ";
  //  results += str(poseScale);
  //  results += "\nposePosition ";
  //  results += str(posePosition.x);
  //  results += ",";
  //  results += str(posePosition.y);
  //  results += "\nposeOrientation ";
  //  results += str(poseOrientation.x);
  //  results += ",";
  //  results += str(poseOrientation.y);
  //  results += ",";
  //  results += str(poseOrientation.z);
  //  results += "\nmouthHeight ";
  //  results += str(mouthHeight);
  //  results += "\nmean mouthHeight ";
  //  results += str(faceSmoother.getMeanMouthHeight());
  //  results += "\nmouthWidth ";
  //  results += str(mouthWidth);
  //  results += "\neyeLeft ";
  //  results += str(eyeLeft);
  //  results += "\neeyeRight ";
  //  results += str(eyeRight);
  //  results += "\neyebrowLeft ";
  //  results += str(eyebrowLeft);
  //  results += "\neyebrowRight ";
  //  results += str(eyebrowRight);
  //  results += "\njaw ";
  //  results += str(jaw);
  //  results += "\nnostrils ";
  //  results += str(nostrils);
  //  results += "\nmesh ";
  //  results += str(meshPoints[0].x);
  textFont(font, 24);
  text(results, 0, 0); 
  popMatrix();
}
void drawFacePoints(PVector [] pts, float x, float y) {
  pushMatrix();
  pushStyle();
  translate(x,y);
  //noFill();
  stroke(244, 0, 0);
  strokeWeight(5);

  //beginShape(LINES);

  for (int i=1;i<pts.length;i++) {
    line( pts[i-1].x, pts[i-1].y,pts[i].x, pts[i].y);
    //text(i, pts[i].x, pts[i].y);
  }
  //endShape(CLOSE);
  popMatrix();
  popStyle();
}
// OSC CALLBACK FUNCTIONS

public void found(int i) {
  //println("found: " + i);
  found = i;
  interactionManager.checkFound(i);
}

public void poseScale(float s) {
  // println("scale: " + s);
  poseScale = s;
  faceSmoother.updatePoseScale(s);
}

public void posePosition(float x, float y) {
  // println("pose position\tX: " + x + " Y: " + y );
  posePosition.set(x, y, 0);
  faceSmoother.updatePosePosition(new PVector(x, y, 0));
}

public void poseOrientation(float x, float y, float z) {
  // println("pose orientation\tX: " + x + " Y: " + y + " Z: " + z);
  poseOrientation.set(x, y, z);
  faceSmoother.updatePoseOrientation(new PVector(x, y, z));
}

public void mouthWidthReceived(float w) {
  //pprintln("mouth Width: " + w);
  mouthWidth = w;
  faceSmoother.updateMouthWidth(w);
  //mouthWidthSliderGraph.update(faceSmoother.pMouthWidth);
}

public void mouthHeightReceived(float h) {
  //println("mouth height: " + h);
  mouthHeight = h;
  faceSmoother.updateMouthHeight(h);
}

public void eyeLeftReceived(float f) {
  //println("eye left: " + f);
  eyeLeft = f;
  faceSmoother.updateEyeLeft(f);
}

public void eyeRightReceived(float f) {
  //println("eye right: " + f);
  eyeRight = f;
  faceSmoother.updateEyeRight(f);
}

public void eyebrowLeftReceived(float f) {
  //println("eyebrow left: " + f);
  eyebrowLeft = f;
  faceSmoother.updateEyebrowLeft(f);
}

public void eyebrowRightReceived(float f) {
  //println("eyebrow right: " + f);
  eyebrowRight = f;
  faceSmoother.updateEyebrowRight(f);
}

public void jawReceived(float f) {
  //println("jaw: " + f);
  jaw = f;
  faceSmoother.updateJaw(f);
}

public void nostrilsReceived(float f) {
  // println("nostrils: " + f);
  nostrils = f;
  faceSmoother.updateNostrils(f);
}
public void loadMesh(float x0, float y0, float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4, float x5, float y5, float x6, float y6, float x7, float y7, float x8, float y8, float x9, float y9, float x10, float y10, float x11, float y11, float x12, float y12, float x13, float y13, float x14, float y14, float x15, float y15, float x16, float y16, float x17, float y17, float x18, float y18, float x19, float y19, float x20, float y20, float x21, float y21, float x22, float y22, float x23, float y23, float x24, float y24, float x25, float y25, float x26, float y26, float x27, float y27, float x28, float y28, float x29, float y29, float x30, float y30, float x31, float y31, float x32, float y32, float x33, float y33, float x34, float y34, float x35, float y35, float x36, float y36, float x37, float y37, float x38, float y38, float x39, float y39, float x40, float y40, float x41, float y41, float x42, float y42, float x43, float y43, float x44, float y44, float x45, float y45, float x46, float y46, float x47, float y47, float x48, float y48, float x49, float y49, float x50, float y50, float x51, float y51, float x52, float y52, float x53, float y53, float x54, float y54, float x55, float y55, float x56, float y56, float x57, float y57, float x58, float y58, float x59, float y59, float x60, float y60, float x61, float y61, float x62, float y62, float x63, float y63, float x64, float y64, float x65, float y65) {
  //println("loading mesh...");  
  meshPoints[0].x = x0; 
  meshPoints[0].y = y0;
  meshPoints[1].x = x1; 
  meshPoints[1].y = y1;
  meshPoints[2].x = x2; 
  meshPoints[2].y = y2;
  meshPoints[3].x = x3; 
  meshPoints[3].y = y3;
  meshPoints[4].x = x4; 
  meshPoints[4].y = y4;
  meshPoints[5].x = x5; 
  meshPoints[5].y = y5;
  meshPoints[6].x = x6; 
  meshPoints[6].y = y6;
  meshPoints[7].x = x7; 
  meshPoints[7].y = y7;
  meshPoints[8].x = x8; 
  meshPoints[8].y = y8;
  meshPoints[9].x = x9; 
  meshPoints[9].y = y9;
  meshPoints[10].x = x10; 
  meshPoints[10].y = y10;
  meshPoints[11].x = x11; 
  meshPoints[11].y = y11;
  meshPoints[12].x = x12; 
  meshPoints[12].y = y12;
  meshPoints[13].x = x13; 
  meshPoints[13].y = y13;
  meshPoints[14].x = x14; 
  meshPoints[14].y = y14;
  meshPoints[15].x = x15; 
  meshPoints[15].y = y15;
  meshPoints[16].x = x16; 
  meshPoints[16].y = y16;
  meshPoints[17].x = x17; 
  meshPoints[17].y = y17;
  meshPoints[18].x = x18; 
  meshPoints[18].y = y18;
  meshPoints[19].x = x19; 
  meshPoints[19].y = y19;
  meshPoints[20].x = x20; 
  meshPoints[20].y = y20;
  meshPoints[21].x = x21; 
  meshPoints[21].y = y21;
  meshPoints[22].x = x22; 
  meshPoints[22].y = y22;
  meshPoints[23].x = x23; 
  meshPoints[23].y = y23;
  meshPoints[24].x = x24; 
  meshPoints[24].y = y24;
  meshPoints[25].x = x25; 
  meshPoints[25].y = y25;
  meshPoints[26].x = x26; 
  meshPoints[26].y = y26;
  meshPoints[27].x = x27; 
  meshPoints[27].y = y27;
  meshPoints[28].x = x28; 
  meshPoints[28].y = y28;
  meshPoints[29].x = x29; 
  meshPoints[29].y = y29;
  meshPoints[30].x = x30; 
  meshPoints[30].y = y30;
  meshPoints[31].x = x31; 
  meshPoints[31].y = y31;
  meshPoints[32].x = x32; 
  meshPoints[32].y = y32;
  meshPoints[33].x = x33; 
  meshPoints[33].y = y33;
  meshPoints[34].x = x34; 
  meshPoints[34].y = y34;
  meshPoints[35].x = x35; 
  meshPoints[35].y = y35;
  meshPoints[36].x = x36; 
  meshPoints[36].y = y36;
  meshPoints[37].x = x37; 
  meshPoints[37].y = y37;
  meshPoints[38].x = x38; 
  meshPoints[38].y = y38;
  meshPoints[39].x = x39; 
  meshPoints[39].y = y39;
  meshPoints[40].x = x40; 
  meshPoints[40].y = y40;
  meshPoints[41].x = x41; 
  meshPoints[41].y = y41;
  meshPoints[42].x = x42; 
  meshPoints[42].y = y42;
  meshPoints[43].x = x43; 
  meshPoints[43].y = y43;
  meshPoints[44].x = x44; 
  meshPoints[44].y = y44;
  meshPoints[45].x = x45; 
  meshPoints[45].y = y45;
  meshPoints[46].x = x46; 
  meshPoints[46].y = y46;
  meshPoints[47].x = x47; 
  meshPoints[47].y = y47;
  meshPoints[48].x = x48; 
  meshPoints[48].y = y48;
  meshPoints[49].x = x49; 
  meshPoints[49].y = y49;
  meshPoints[50].x = x50; 
  meshPoints[50].y = y50;
  meshPoints[51].x = x51; 
  meshPoints[51].y = y51;
  meshPoints[52].x = x52; 
  meshPoints[52].y = y52;
  meshPoints[53].x = x53; 
  meshPoints[53].y = y53;
  meshPoints[54].x = x54; 
  meshPoints[54].y = y54;
  meshPoints[55].x = x55; 
  meshPoints[55].y = y55;
  meshPoints[56].x = x56; 
  meshPoints[56].y = y56;
  meshPoints[57].x = x57; 
  meshPoints[57].y = y57;
  meshPoints[58].x = x58; 
  meshPoints[58].y = y58;
  meshPoints[59].x = x59; 
  meshPoints[59].y = y59;
  meshPoints[60].x = x60; 
  meshPoints[60].y = y60;
  meshPoints[61].x = x61; 
  meshPoints[61].y = y61;
  meshPoints[62].x = x62; 
  meshPoints[62].y = y62;
  meshPoints[63].x = x63; 
  meshPoints[63].y = y63;
  meshPoints[64].x = x64; 
  meshPoints[64].y = y64;
  meshPoints[65].x = x65; 
  meshPoints[65].y = y65;
  faceSmoother.updateMesh(meshPoints);
}
// all other OSC messages end up here
void oscEvent(OscMessage m) {
  if (m.isPlugged() == false) {
    println("UNPLUGGED: " + m);
  }
}
float getMinXInPVectorArray(PVector [] vectors) {
  float min = 10000000.0;
  for (int i =0;i<vectors.length;i++) {
    if (vectors[i].x<min) {
      min = vectors[i].x;
    }
  }
  return min;
}
float getMinYInPVectorArray(PVector [] vectors) {
  float min = 10000000.0;
  for (int i =0;i<vectors.length;i++) {
    if (vectors[i].y<min) {
      min = vectors[i].y;
    }
  }
  return min;
}
float getMaxXInPVectorArray(PVector [] vectors) {
  float max = 0.0;
  for (int i =0;i<vectors.length;i++) {
    if (vectors[i].x>max) {
      max = vectors[i].x;
    }
  }
  return max;
}
float getMaxYInPVectorArray(PVector [] vectors) {
  float max = 0.0;
  for (int i =0;i<vectors.length;i++) {
    if (vectors[i].y>max) {
      max = vectors[i].y;
    }
  }
  return max;
}
void setupOSC(){
  oscP5.plug(this, "found", "/found");
  oscP5.plug(this, "poseScale", "/pose/scale");
  oscP5.plug(this, "posePosition", "/pose/position");
  oscP5.plug(this, "poseOrientation", "/pose/orientation");
  oscP5.plug(this, "mouthWidthReceived", "/gesture/mouth/width");
  oscP5.plug(this, "mouthHeightReceived", "/gesture/mouth/height");
  oscP5.plug(this, "eyeLeftReceived", "/gesture/eye/left");
  oscP5.plug(this, "eyeRightReceived", "/gesture/eye/right");
  oscP5.plug(this, "eyebrowLeftReceived", "/gesture/eyebrow/left");
  oscP5.plug(this, "eyebrowRightReceived", "/gesture/eyebrow/right");
  oscP5.plug(this, "jawReceived", "/gesture/jaw");
  oscP5.plug(this, "nostrilsReceived", "/gesture/nostrils");
  oscP5.plug(this, "loadMesh", "/raw"); 
  
}

void setupFaculties(){
 faculties = new Faculty [47];
  faculties[0] = new Faculty("Analysis", 0, true);
  faculties[1] = new Faculty("Gravity", 0, false);
  faculties[2] = new Faculty("Love of Distinction", 0, true);
  faculties[3] = new Faculty("Complacency", 0, true);
  faculties[4] = new Faculty("Cheerfulness", 0, true);
  faculties[5] = new Faculty("Concentration", 0, true);
  faculties[6] = new Faculty("Love of Home", 0, true);
  faculties[7] = new Faculty("Self-Esteem", 0, false);
  faculties[8] = new Faculty("Gloominess", 0, false);
  faculties[9] = new Faculty("Jealousy", 0, true);
  faculties[10] = new Faculty("Contempt", 0, true);
  faculties[11] = new Faculty("Love of Travel", 0, true);
  faculties[12] = new Faculty("Gravity", 0, false);
  faculties[13] = new Faculty("Envy", 0, false);
  faculties[14] = new Faculty("Simplicity", 0, true);
  faculties[15] = new Faculty("Comparison", 0, true);
  faculties[16] = new Faculty("Confidence", 0, true);
  faculties[17] = new Faculty("Imitation", 0, true);
  faculties[18] = new Faculty("Discovery", 0, true);
  faculties[19] = new Faculty("Combination", 0, true);
  faculties[20] = new Faculty("Metaphor", 0, true);
  faculties[21] = new Faculty("Inquisitiveness", 0, true);
  faculties[22] = new Faculty("Self-Defence", 0, false);
  faculties[23] = new Faculty("Relative-Defence", 0, false);
  faculties[24] = new Faculty("Attack", 0, true);
  faculties[25] = new Faculty("Activity", 0, true);
  faculties[26] = new Faculty("Prayerfulness", 0, true);
  faculties[27] = new Faculty("Humility", 0, false);
  faculties[28] = new Faculty("Confession", 0, false);
  faculties[29] = new Faculty("Penitence", 0, false);
  faculties[30] = new Faculty("Subterfuge", 0, true);
  faculties[31] = new Faculty("Resistance", 0, true);
  faculties[32] = new Faculty("Love of Contest", 0, true);
  faculties[33] = new Faculty("Love of Enjoyment", 0, true);
  faculties[34] = new Faculty("Love of Climbing", 0, true);
  faculties[35] = new Faculty("Congeniality", 0, true);
  faculties[36] = new Faculty("Desire to be Loved", 0, true);
  faculties[37] = new Faculty("Desire to Love", 0, true);
  faculties[38] = new Faculty("Violent Love", 0, true);
  faculties[39] = new Faculty("Ardent Love", 0, true);
  faculties[40] = new Faculty("Fondness", 0, true);
  faculties[41] = new Faculty("Love of Physical Beauty", 0, true);
  faculties[42] = new Faculty("Faithful Love", 0, true);
  faculties[43] = new Faculty("Engrossment", 0, true);
  faculties[44] = new Faculty("Self-Will", 0, true);
  faculties[45] = new Faculty("Perseverance", 0, true);
  faculties[46] = new Faculty("Resolution", 0, true);
  
  
  String rawDescriptions = join( loadStrings("descriptions.txt"), "");
  String []  descriptions =splitTokens(rawDescriptions, "*");
  for (int i=0;i<descriptions.length;i++) {
    //println(i+ "  "+ descriptions[i]);
    String title = trim(splitTokens(descriptions[i], ":")[0]);
    //println("title "+title+ " length "+title.length());
    for (int j=0;j<faculties.length;j++) {
      if (title.equals(faculties[j].name) ) {
        //println("found "+faculties[j].name);
        faculties[j].setDescription(descriptions[i]);
      }
    }
  }

  for (int j=0;j<faculties.length;j++) {
    if (faculties[j].description.equals("placeholder")) {
      println("no description for "+faculties[j].name+ " length "+faculties[j].name.length());
    }
  }
//  for (int j=0;j<faculties.length;j++) {
//    if (!faculties[j].description.equals("placeholder")) {
//      println("found description for "+faculties[j].name);
//    }
//  }


  faculties[0].setThreshold(0.360);
  faculties[1].setThreshold(0.320);
  faculties[2].setThreshold(0.064);
  faculties[3].setThreshold(0.064);
  faculties[4].setThreshold(0.064);
  faculties[5].setThreshold(0.0642);
  faculties[6].setThreshold(0.064);
  faculties[7].setThreshold(0.045);
  faculties[8].setThreshold(0.045);
  faculties[9].setThreshold(0.331);
  faculties[10].setThreshold(0.331);
  faculties[11].setThreshold(0.331);
  faculties[12].setThreshold(0.267);
  faculties[13].setThreshold(0.061);
  faculties[14].setThreshold(0.169);
  faculties[15].setThreshold(0.172);
  faculties[16].setThreshold(0.172);
  //not implemented
  faculties[17].setThreshold(1.0);
  faculties[18].setThreshold(0.089);
  faculties[19].setThreshold(0.089);
  faculties[20].setThreshold(0.089);
  faculties[21].setThreshold(0.277);
  faculties[22].setThreshold(0.333);
  faculties[23].setThreshold(0.333);
  faculties[24].setThreshold(0.336);
  faculties[25].setThreshold(0.162);
  faculties[26].setThreshold(0.05);
  faculties[27].setThreshold(0.035);
  faculties[28].setThreshold(0.035);
  faculties[29].setThreshold(0.035);
  //need improvmenet
  faculties[30].setThreshold(0.057);
  faculties[31].setThreshold(0.057);
  faculties[32].setThreshold(0.057);
  //need improvmenet
  faculties[33].setThreshold(0.263);
  faculties[34].setThreshold(0.263);
  faculties[35].setThreshold(0.263);

  faculties[36].setThreshold(1.2);
  faculties[37].setThreshold(1.2);
  faculties[38].setThreshold(1.2);
  faculties[39].setThreshold(1.2);
  faculties[40].setThreshold(1.2);
  faculties[41].setThreshold(1.2);
  faculties[42].setThreshold(1.2);
  faculties[43].setThreshold(0.294);
  faculties[44].setThreshold(0.294);
  faculties[45].setThreshold(0.294);
  faculties[46].setThreshold(0.294); 
}

void setupMeasures(){
 measures = new float[num_measures];
  sliders = new SliderGraph[measures.length];
  measureNames = new String[measures.length];

  int UPPER_LIP_SIZE = 0;
  int UPPER_LIP_CURVE = 1;
  int LOWER_LIP_SIZE = 2;
  int LOWER_LIP_CURVE = 3;
  int MOUTH_CURVE = 4;
  int NOSE_WIDTH = 5;
  int SEPTUM_SIZE = 6;
  int EYE_SIZE = 7;
  int EYE_OPENNESS = 8;
  int EYEBROW_SIZE = 9;
  int EYEBROW_CURVE = 10;
  int EYEBROW_PROPORTIONS = 11;
  int CHIN_SHAPE = 12;
  int CHIN_EXTENSION = 13;

  measureNames[0] = "UPPER LIP SIZE";
  measureNames[1] = "UPPER LIP CURVE";
  measureNames[2] = "LOWER LIP SIZE";
  measureNames[3] = "LOWER LIP CURVE";
  measureNames[4] = "MOUTH CURVE";
  measureNames[5] = "NOSE WIDTH";
  measureNames[6] = "SEPTUM SIZE";
  measureNames[7] = "EYE SIZE";
  measureNames[8] = "EYE OPENNESS";
  measureNames[9] = "EYEBROW SIZE";
  measureNames[10] = "EYEBROW CURVE";
  measureNames[11] = "EYEBROW PROPORTIONS";
  measureNames[12] = "CHIN SHAPE";
  measureNames[13] = "CHIN EXTENSION";
  measureNames[14] = "NOSE LENGTH";
  measureNames[15] = "NOSE PROPORTION";
  
  graphs = new Graph[measures.length];
  measures_buffer = new float[measureNames.length][measures_buffer_size];
  for (int i=0;i<measures_buffer.length;i++) {
    for (int j=0;j<measures_buffer[i].length;j++) {
      measures_buffer[i][j]=0.0;
    }
  } 
}
 void shuffleArray(int[] ar)
  {
    Random rnd = new Random();
    for (int i = ar.length - 1; i > 0; i--)
    {
      int index = rnd.nextInt(i + 1);
      // Simple swap
      int a = ar[index];
      ar[index] = ar[i];
      ar[i] = a;
    }
  }
