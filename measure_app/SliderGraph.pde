class SliderGraph {
  float xPos;
  float yPos;
  float w ;
  float h;
  float minRange;
  float maxRange;
  float currentVal;
  String label;
  String [] faculties;
  String faculty = "";
  float [] thresholds;
  
  SliderGraph(float _xPos, float _yPos, float _w, float _h, float _minRange, float _maxRange, float _currentVal, String _label,  float [] _thresholds) {
    xPos = _xPos;
    yPos = _yPos;
    w = _w;
    h = _h;
    minRange =_minRange;
    maxRange = _maxRange;
    currentVal= _minRange;
    label= _label;
    //faculties = _faculties;
    thresholds = _thresholds;
  }
  void update(float newVal) {
    currentVal = newVal;
    getFaculty();
  }
  void display() {
    
    float sliderXpos = map(currentVal,minRange,maxRange,0,w);
    constrain(sliderXpos,0,w);
    pushMatrix();
    pushStyle();
    strokeWeight(4);
    textFont(boldFont,24);
    noFill();
    stroke(255);
    translate(xPos,yPos);
    line(0,0,w,0);
    rect(sliderXpos, -0.5*h, 10,h);
    fill(255);
    //text(faculty, sliderXpos,(0.5*h)+10);
    text(label,-5-(textWidth(label)),8);
    popStyle();
    popMatrix();
  }
  void getFaculty(){
    for(int i=1;i<thresholds.length;i++){
     if(currentVal >= thresholds[i-1] && currentVal < thresholds[i]){
      // faculty = faculties[i-1];
     }
    }
    
  }
}

