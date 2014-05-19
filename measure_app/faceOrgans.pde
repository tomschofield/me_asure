//a class for getting the points we need and normalising them
class FaceOrganLines {
  PVector [] pts;
  PVector [] normalisedPoints = new PVector[66];
  FaceOrganLines(PVector [] _pts) {
    pts = _pts;
    for(int i=0;i<normalisedPoints.length;i++){
      normalisedPoints[i]=new PVector(0,0);
    }
  }
  void updatePoints(PVector [] _pts) {
    pts = _pts;
  }
  PVector [] getJawline() {
    return Arrays.copyOfRange(pts, 0, 16);
  }
  PVector [] getRightEyebrow() {
    return Arrays.copyOfRange(pts, 17, 21);
  }
  PVector [] getLeftEyebrow() {
    return Arrays.copyOfRange(pts, 22, 26);
  }
  PVector [] getNoseBridge() {
    return Arrays.copyOfRange(pts, 27, 30);
  }
  PVector [] getNostrils() {
    return Arrays.copyOfRange(pts, 31, 35);
  }
  PVector [] getRightEye() {
    return Arrays.copyOfRange(pts, 36, 41);
  }
  PVector [] getLeftEye() {
    return Arrays.copyOfRange(pts, 42, 47);
  }
  PVector [] getLipsOuter() {
    return Arrays.copyOfRange(pts, 48, 59);
  }
  PVector [] getLipsInner() {
    return Arrays.copyOfRange(pts, 60, 65);
  }
  PVector [] getNormalisedPoints(float scaleFactor) {

      for (int i=0;i<normalisedPoints.length;i++) {
        normalisedPoints[i].x = getNormalisedXYForPoint(pts[i]).x*scaleFactor;
        normalisedPoints[i].y = getNormalisedXYForPoint(pts[i]).y*scaleFactor;
      }
    
    return normalisedPoints;
  }
  //returns a normalised location on the face where the height of the face == 1.0
  PVector getNormalisedXYForPoint(PVector point) {

    //float faceWidth = pts[16].x -  pts[0].x;
    //float highestLeft = getMinYInPVectorArray(getLeftEyebrow());
    //float highestRight = getMinYInPVectorArray(getRightEyebrow());
    float highestPoint = getMinYInPVectorArray(pts)   ;//min(highestLeft, highestRight);

    float lowestPoint = getMaxYInPVectorArray(pts);//getJawline());
    float faceHeight = lowestPoint-highestPoint;
    
    float left = getMinXInPVectorArray(pts)   ;
    float right = getMaxXInPVectorArray(pts)   ;
    
    float faceWidth  =right-left;

    float ratio = faceHeight/faceWidth;

    float normX = map( point.x, pts[0].x, pts[16].x, 0.0, 1.0); 
    float normY = map( point.y, highestPoint, lowestPoint, 0.0, ratio);

    PVector normalised = new PVector(normX, normY);
//    println( "highestPoint, lowestPoint ,point.y ", highestPoint+" "+ lowestPoint+" "+point.y);
//    println( "normalised ", normalised);

    return normalised;
  }
  //0-16 = jawline
  //17-21 = myRightBrow
  //22-26 = myLeftBrow
  //27-30 = nose bridge
  //31-35 = nostrils
  //36-41 = myRightEye
  //42-47 = myLeftEye
  //48-59 = lipsOuter
  //60-65 - lipsInner
}

