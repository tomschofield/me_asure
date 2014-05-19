class Smoother {
  //infinite impulse response filters/ 
  // pose
  float [] buffer_poseScale;
  PVector [] buffer_posePosition ;
  PVector [] buffer_poseOrientation ;
  float [] buffer_mouthHeight;
  float [] buffer_mouthWidth;
  float [] buffer_eyeLeft;
  float [] buffer_eyeRight;
  float [] buffer_eyebrowLeft;
  float [] buffer_eyebrowRight;
  float [] buffer_jaw;
  float [] buffer_nostrils;
  PVector[][] buffer_meshPoints;
  
  float [][] buffer_measures;

  float pPoseScale;
  PVector pPosePosition;
  PVector pPoseOrientation;
  float pMouthHeight;
  float pMouthWidth;
  float pEyeLeft;
  float pEyeRight;
  float pEyebrowLeft;
  float pEyebrowRight;
  float pJaw;
  float pNostrils;
  PVector [] pMeshPoints;
  //defines the ration between this reading and previous reading a value of 0.9 will be 0.9 of this reading and 0.1 of the previous. SMaller is more smoothed
  float smoothRatio =0.9;

  int bufferSize = 100;
  Smoother() {
    //a counter for each value to mark the place in the circular buffer

      buffer_poseScale = new float[bufferSize];
    buffer_mouthHeight = new float[bufferSize];

    buffer_posePosition = new PVector[bufferSize];
    buffer_poseOrientation = new PVector[bufferSize];

    buffer_mouthWidth = new float[bufferSize];
    buffer_eyeLeft = new float[bufferSize];
    buffer_eyeRight = new float[bufferSize];
    buffer_eyebrowLeft = new float[bufferSize];
    buffer_eyebrowRight = new float[bufferSize];
    buffer_jaw = new float[bufferSize];
    buffer_nostrils = new float[bufferSize];

    buffer_meshPoints= new PVector[bufferSize][];

    for (int i=0;i<bufferSize;i++) {
      buffer_posePosition[i] = new PVector(0, 0);
      buffer_poseOrientation[i] = new PVector(0, 0);
    }
    //for infinite impulse response
    pPosePosition = new PVector(0, 0);
    pPoseOrientation = new PVector(0, 0);
    pMeshPoints = new PVector[66];
    for (int i=0;i<pMeshPoints.length;i++) {
      pMeshPoints[i] = new PVector(0, 0);
    }
    buffer_measures = new float [bufferSize][16];
    for(int i=0;i<buffer_measures.length;i++){
      for(int j=0;j<buffer_measures[i].length;j++){
      buffer_measures[i][j]=0.0;
      }
    }
  }
  void updateMeasures(float [] new_measures){
//    for (int i=1;i<buffer_measures.length-1;i++) {
//      buffer_measures[i]=buffer_measures[i+1];
//    }
  }
  void updatePoseScale(float newVal) {
    for (int i=1;i<buffer_poseScale.length-1;i++) {
      buffer_poseScale[i]=buffer_poseScale[i+1];
    }
    buffer_poseScale [buffer_poseScale.length-1]=newVal;

    pPoseScale = ((1-smoothRatio)*pPoseScale) + (smoothRatio*newVal);
  }
  void setRatio(float newRatio) {
    smoothRatio = newRatio;
  }
  float getMeanPoseScale() {
    float sum = 0;
    for (float i : buffer_poseScale) sum += i;
    return sum/buffer_poseScale.length;
  }

  void updatePosePosition(PVector newVector) {
    for (int i=1;i<buffer_posePosition.length-1;i++) {
      buffer_posePosition[i]=buffer_posePosition[i+1];
    }
    buffer_posePosition [buffer_posePosition.length-1]=newVector;
    pPosePosition.x = ((1-smoothRatio)*pPosePosition.x) + (smoothRatio*newVector.x); 
    pPosePosition.y = ((1-smoothRatio)*pPosePosition.y) + (smoothRatio*newVector.y);
  }
  void updatePoseOrientation(PVector newVector) {
    for (int i=1;i<buffer_poseOrientation.length-1;i++) {
      buffer_poseOrientation[i]=buffer_poseOrientation[i+1];
    }
    buffer_poseOrientation [buffer_poseOrientation.length-1]=newVector;
    pPoseOrientation.x = ((1-smoothRatio)*pPoseOrientation.x) + (smoothRatio*newVector.x); 
    pPoseOrientation.y = ((1-smoothRatio)*pPoseOrientation.y) + (smoothRatio*newVector.y);
  }
  void updateMouthHeight(float newVal) {
    for (int i=1;i<buffer_mouthHeight.length-1;i++) {
      buffer_mouthHeight[i]=buffer_mouthHeight[i+1];
    }
    buffer_mouthHeight [buffer_mouthHeight.length-1]=newVal;
    pMouthHeight = ((1-smoothRatio)*pMouthHeight) + (smoothRatio*newVal);
  }
  float getMeanMouthHeight() {
    float sum = 0;
    for (float i : buffer_mouthHeight) sum += i;
    return sum/buffer_mouthHeight.length;
  }
  void updateMouthWidth(float newVal) {
    for (int i=1;i<buffer_mouthWidth.length-1;i++) {
      buffer_mouthWidth[i]=buffer_mouthWidth[i+1];
    }
    buffer_mouthWidth [buffer_mouthWidth.length-1]=newVal;
    pMouthWidth = ((1-smoothRatio)*pMouthWidth) + (smoothRatio*newVal);
  }
  float getMeanMouthWidth() {
    float sum = 0;
    for (float i : buffer_mouthWidth) sum += i;
    return sum/buffer_mouthWidth.length;
  }
  void updateEyeLeft(float newVal) {
    for (int i=1;i<buffer_eyeLeft.length-1;i++) {
      buffer_eyeLeft[i]=buffer_eyeLeft[i+1];
    }
    buffer_eyeLeft [buffer_eyeLeft.length-1]=newVal;
    pEyeLeft = ((1-smoothRatio)*pEyeLeft) + (smoothRatio*newVal);
  }
  float getMeanEyeLeft() {
    float sum = 0;
    for (float i : buffer_eyeLeft) sum += i;
    return sum/buffer_eyeLeft.length;
  }
  void updateEyeRight(float newVal) {
    for (int i=1;i<buffer_eyeRight.length-1;i++) {
      buffer_eyeRight[i]=buffer_eyeRight[i+1];
    }
    buffer_eyeRight [buffer_eyeRight.length-1]=newVal;
    pEyeRight = ((1-smoothRatio)*pEyeRight) + (smoothRatio*newVal);
  }
  float getMeanEyeRight() {
    float sum = 0;
    for (float i : buffer_eyeRight) sum += i;
    return sum/buffer_eyeRight.length;
  }
  void updateEyebrowLeft(float newVal) {
    for (int i=1;i<buffer_eyebrowLeft.length-1;i++) {
      buffer_eyebrowLeft[i]=buffer_eyebrowLeft[i+1];
    }
    buffer_eyebrowLeft [buffer_eyebrowLeft.length-1]=newVal;
    pEyebrowLeft = ((1-smoothRatio)*pEyebrowLeft) + (smoothRatio*newVal);
  }
  float getMeanEyebrowLeft() {
    float sum = 0;
    for (float i : buffer_eyebrowLeft) sum += i;
    return sum/buffer_eyebrowLeft.length;
  }
  void updateEyebrowRight(float newVal) {
    for (int i=1;i<buffer_eyebrowRight.length-1;i++) {
      buffer_eyebrowRight[i]=buffer_eyebrowRight[i+1];
    }
    buffer_eyebrowRight [buffer_eyebrowRight.length-1]=newVal;
    pEyebrowRight = ((1-smoothRatio)*pEyebrowRight) + (smoothRatio*newVal);
  }
  float getMeanEyebrowRight() {
    float sum = 0;
    for (float i : buffer_eyebrowRight) sum += i;
    return sum/buffer_eyebrowRight.length;
  }
  void updateJaw(float newVal) {
    for (int i=1;i<buffer_jaw.length-1;i++) {
      buffer_jaw[i]=buffer_jaw[i+1];
    }
    buffer_jaw [buffer_jaw.length-1]=newVal;
    pJaw = ((1-smoothRatio)*pJaw) + (smoothRatio*newVal);
  }
  float getMeanJaw() {
    float sum = 0;
    for (float i : buffer_jaw) sum += i;
    return sum/buffer_jaw.length;
  }
  void updateNostrils(float newVal) {
    for (int i=1;i<buffer_nostrils.length-1;i++) {
      buffer_nostrils[i]=buffer_nostrils[i+1];
    }
    buffer_nostrils [buffer_nostrils.length-1]=newVal;
    pNostrils = ((1-smoothRatio)*pNostrils) + (smoothRatio*newVal);
  }
  float getMeanNostrils() {
    float sum = 0;
    for (float i : buffer_nostrils) sum += i;
    return sum/buffer_nostrils.length;
  }
  void updateMesh(PVector [] newVectors) {
    for (int i=1;i<buffer_meshPoints.length-1;i++) {
      buffer_meshPoints[i]=buffer_meshPoints[i+1];
    }
    buffer_meshPoints [buffer_meshPoints.length-1]=newVectors;
    for (int i =0;i<newVectors.length;i++) {
      pMeshPoints[i].x = ((1-smoothRatio)*pMeshPoints[i].x) + (smoothRatio*newVectors[i].x); 
      pMeshPoints[i].y = ((1-smoothRatio)*pMeshPoints[i].y) + (smoothRatio*newVectors[i].y);
    }
  }
}

