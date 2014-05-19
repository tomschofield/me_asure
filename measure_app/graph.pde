class Graph {
  float xPos ;
  float yPos;
  float w ;
  float h;
  PVector [] pts ;
  float xMin;
  float yMin;
  float xScale;
  float yScale;
  String name;
  PFont sFont;
  float minX;
  float maxX;
  float minY;
  float maxY;
  color graphCol = color(200,100);
  String brokenName="";
  Graph(float _xPos, float _yPos, float _w, float _h, PVector [] _pts, float _xMin, float _yMin, float _xScale, float _yScale, String _name) {
    xPos =_xPos;
    yPos = _yPos;
    w = _w;
    h =_h;
    pts = _pts;
    xScale = _xScale;
    yScale = _yScale;
    name=_name;
    sFont = loadFont("Serif-10.vlw");
    xMin = _xMin;
    yMin = _yMin;
    String [] exploded = splitTokens(name," ");
//    brokenName="";
//    for(int i=0;i<exploded.length;i++){
//      brokenName+=exploded[i];
//      brokenName+="\n";
//    }
    
  }
  Graph(float _xPos, float _yPos, float _w, float _h, float [] _ys, float _xMin, float _yMin, float _xScale, float _yScale, String _name) {
    xPos =_xPos;
    yPos = _yPos;
    w = _w;
    h =_h;
    float spacing = _xScale/_ys.length;
    pts = new PVector[_ys.length];
    for (int i=0;i<_ys.length;i++) {
      pts[i] = new PVector(i*spacing, _ys[i]);
    }

    xScale = _xScale;
    yScale = _yScale;
    name=_name;
    sFont = loadFont("Serif-10.vlw");
    xMin = _xMin;
    yMin = _yMin;
        String [] exploded = splitTokens(name," ");

    brokenName="";
    if(exploded.length>1){
      brokenName+=exploded[0];
      brokenName+="\n";
      for(int i=1;i<exploded.length;i++){
      brokenName+=exploded[i];
      brokenName+=" ";
    }
      
    }
    
  }
  void updatePoints(PVector [] _pts) {
    pts = _pts;
  }
  void updatePoints(float [] _ys) {
    float spacing = xScale/_ys.length;
    for (int i=0;i<_ys.length;i++) {
      pts[i] = new PVector(i*spacing, _ys[i]);
    }
  }
  void drawHorizAxes(color axesColour) {

    pushStyle();
    textFont(font, 24);
    pushMatrix();
    stroke(axesColour);
    noFill();
    translate(xPos, yPos);
    // horizontal
    //line(0, h, w, h);
    //verticle
    line(0, 0, 0, h);
    text(name, -10-textWidth(name), h-(0.5*h));
    popMatrix();
    popStyle();
  }

  void drawHorizScatter(color axesColour) {
    pushStyle();
    pushMatrix();
    stroke(axesColour);
    noFill();
    translate(xPos, yPos);
    if(getMinXInPVectorArray(pts)<minX){
      minX = getMinXInPVectorArray(pts);
    }
    if(getMinYInPVectorArray(pts)<minY){
      minY = getMinYInPVectorArray(pts);
    }
    if(getMaxXInPVectorArray(pts)>maxX){
      maxX = getMaxXInPVectorArray(pts);
    }
    if(getMaxYInPVectorArray(pts)>maxY){
      maxY = getMaxYInPVectorArray(pts);
    }
    for (int i=0;i<pts.length;i++) {

      float x =  w-map( pts[i].x, minX,maxX, 0.0, w);
      float y =  h-map( pts[i].y,minY,maxY, 0.0, h);
      if(i==pts.length-1){
        rect(x-8, y, 16, 6);
      }else{
        ellipse(x, y, 2, 2);
      }
      if (pts[i].x>xScale) {

        println(x+" "+y);
      }
    }
    popMatrix();
    popStyle();
  }
  void drawAxes(color axesColour) {

    pushStyle();
    textFont(boldFont, 24);
    pushMatrix();
    stroke(graphCol);
    noFill();
    translate(xPos, yPos);
    rotate(0.5*PI);
    // horizontal
    //line(0, h, w, h);
    //verticle
    strokeWeight(10);
    line(0, 0, 0, h);
    fill(graphCol);
    
    text(brokenName, 14, h-(0.5*h));
    popMatrix();
    popStyle();
  }

  void drawScatter(color axesColour) {
    pushStyle();
    pushMatrix();
    stroke(axesColour);
    noFill();
    strokeWeight(10);
    stroke(200,100);
    translate(xPos, yPos);
    rotate(-0.5*PI);
    if(getMinXInPVectorArray(pts)<minX){
      minX = getMinXInPVectorArray(pts);
    }
    if(getMinYInPVectorArray(pts)<minY){
      minY = getMinYInPVectorArray(pts);
    }
    if(getMaxXInPVectorArray(pts)>maxX){
      maxX = getMaxXInPVectorArray(pts);
    }
    if(getMaxYInPVectorArray(pts)>maxY){
      maxY = getMaxYInPVectorArray(pts);
    }
    beginShape();
    for (int i=1;i<pts.length;i++) {

      float x =  w-map( pts[i-1].x, minX,maxX, 0.0, w);
      float y =  h-map( pts[i-1].y,minY,maxY, 0.0, h);
      
      float x1 =  w-map( pts[i].x, minX,maxX, 0.0, w);
      float y1 =  h-map( pts[i].y,minY,maxY, 0.0, h);
      if(i==pts.length-1){
        rect(x-8, y, 16, 6);
      }
       // ellipse(x, y, 2, 2);
        //vertex(x,y);
        //line(x,y,x1,y1);
      //}
//      if (pts[i].x>xScale) {
//
//        println(x+" "+y);
//      }
    }
    endShape();
    popMatrix();
    popStyle();
  }
}

