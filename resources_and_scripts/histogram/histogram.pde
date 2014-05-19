String [] col;
PFont font;
int [] bars ;
float [] devs;
String [] measureNames;
int histogramSelector = 0;
Table table;
void setup() {
  size(1280, 720); 
  background(255); 
  measureNames = new String[16];

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
  
  font = loadFont("AdobeGothicStd-Bold-14.vlw");
  textFont(font, 14);
  loadData(histogramSelector);
}

void draw() {
  //  for (int x=0; x < bars.length; x++) { 
  //    float val = 100* float(col[x]);
  //    line(10+(x), height-(val), 10+(x), val);
  //  }
  int max = max(bars);
  background(255);
  int index =0;
  int outVal = 0;
  float ratio = 400.0/max(bars);
  float blockWidth = 800/bars.length;
  float reading = 0;
  for (int i=0; i< bars.length; i++) { 
    int val = int(bars[i] * ratio);
    fill(255, 0, 0);
    rect(blockWidth*i, height-val, blockWidth, val);
    fill(0, 0, 0);
    if (mouseX>=blockWidth*i && mouseX<(blockWidth*i) + blockWidth) {
      index  =i;
      outVal = val;
      reading = devs[i];
    }
  }
  text(reading, blockWidth*index, height-(5+outVal) );
  text(measureNames[histogramSelector],30,50 );
}
void keyPressed(){
  if(key=='s'){
   saveFrame(); 
  }
  if(key=='w'){
   histogramSelector++;
   if(histogramSelector>=table.getColumnCount()){
     histogramSelector=0;
   }
  }
  else if (key=='q'){
    histogramSelector--;
    if(histogramSelector<0){
      histogramSelector = table.getColumnCount()-1;
    }
  }
  loadData (histogramSelector);
  
}
void loadData(int whichCol){
   table = loadTable("readings.csv");
  // println(table.getRowCount());
  //println(table.getStringColumn(0));
  col = table.getStringColumn(whichCol);
  col = sort(col);
  bars = getHistogram(col);
  devs = getDivisions(col);
  
}
int [] getHistogram(String [] vals) {
  float[] fVals = new float[vals.length];
  float []emptyVals= new float[vals.length];
  for (int i=0;i<fVals.length;i++) {
    fVals[i]= float(vals[i]);
  }
  int count  =0;

  println(max(fVals), " ", min(fVals));
  float numBins = 100;
  float binSize = (max(fVals)-min(fVals))/numBins;
  int [] barValues = new int[(int)numBins];
  float [] binStartValues = new float[(int)numBins];

  for (int i=0;i<binStartValues.length;i++) {
    binStartValues[i] = min(fVals) +  (i * binSize);
  }
  println(binStartValues);
  for (int i=0;i<fVals.length;i++) {
    float distFromStart = fVals[i]-min(fVals);
    for (int j=0;j<binStartValues.length-1;j++) {
      if (fVals[i]>=binStartValues[j] && fVals[i]<binStartValues[j+1]) {
        barValues[j]++;
      }
    }
  }
  return barValues;
}
float [] getDivisions(String [] vals) {
  float[] fVals = new float[vals.length];
  float []emptyVals= new float[vals.length];
  for (int i=0;i<fVals.length;i++) {
    fVals[i]= float(vals[i]);
  }
  int count  =0;

  println(max(fVals), " ", min(fVals));
  float numBins = 100;
  float binSize = (max(fVals)-min(fVals))/numBins;
  int [] barValues = new int[(int)numBins];
  float [] binStartValues = new float[(int)numBins];

  for (int i=0;i<binStartValues.length;i++) {
    binStartValues[i] = min(fVals) +  (i * binSize);
  }
  return binStartValues;
}
void checkIsUnique() {
  String [] lines = loadStrings("readings.csv");
  String [] emptyLines = new String[lines.length];
  int count = 0;
  for (int i=0;i<lines.length;i++) {
    boolean found = false;
    for (int j=0;j<emptyLines.length;j++) {
      if (lines[i].equals(emptyLines[j])) {
        found = true; 
        println("found");
      }
    }
    if (!found) {
      emptyLines[count] = lines[i];
      count++;
    }
  }
  println(emptyLines);
}

