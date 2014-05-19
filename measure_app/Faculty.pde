class Faculty implements Comparable<Faculty> {

  String name;
  float currentLevel;
  boolean found =false;
  float threshold =0.0;
  float upperThreshold = 0.0;
  float lowerThreshold = 0.0;
  int timeOutCount = 0;
  int timeOutThresh = 0;
  float threshRatio = 0.1;
  String description = "placeholder";
  float timeOut = 0;
  float timeOutThreshold = 255.0;
  //number of frames to time out
  float timeOutSpeed = 100.0;
  float timeOutInc = timeOutThreshold/timeOutSpeed;
  float yPos=-1.0;
  float target = -1.0;
  //ie should the value be greater than the threshold or less than it to satisfy the condition
  boolean isGreaterThan;
  Faculty(String _name, float _currentLevel, boolean _isGreaterThan) {
    name = _name;
    currentLevel = _currentLevel;
    isGreaterThan = _isGreaterThan;
  }
  void setTargetPos(float _target) {
    target=_target;
  }
  void setDescription(String _description) {
    description = _description;
  }
  void setThreshold(float _threshold) {
    threshold = _threshold;
    upperThreshold = threshold + (threshold*threshRatio);
    lowerThreshold = threshold - (threshold*threshRatio);
  }
  void update(float _currentLevel) {
    currentLevel = _currentLevel;
    if (isGreaterThan) {

      if (currentLevel>=upperThreshold) {
        found = true;
      }
      else if (currentLevel<lowerThreshold) {
        found = false;
      }
    }
    else {
      if (currentLevel<=lowerThreshold) {
        found = true;
      }
      else if (currentLevel > upperThreshold) {
        found = false;
      }
    }
    if (found) {
      if (timeOut<=timeOutThreshold) {
        timeOut+=timeOutInc;
        //println("test");
      }
    }
    else {
      if (timeOut>=0) {
        timeOut-=timeOutInc;
      }
    }
    float ySpeed = 2.5;
    if (target<yPos) {
      yPos-=(ySpeed*timeOutInc);
      if (target>yPos) {
        yPos=target;
      }
    } 
    if (target>yPos) {
      yPos+=(ySpeed*timeOutInc);
      if (target<yPos) {
        yPos=target;
      }
    }
  }
  void updateOld(float _currentLevel) {
    currentLevel = _currentLevel;
    if (isGreaterThan) {
      if (currentLevel>=threshold) {
        found = true;
      }
      else {
        found = false;
      }
    }
    else {
      if (currentLevel<=threshold) {
        found = true;
      }
      else {
        found = false;
      }
    }
  }
  public int compareTo(Faculty compareFaculty) {

    float compareQuantity = ((Faculty) compareFaculty).timeOut; 

    //ascending order
    return int(compareFaculty.timeOut-this.timeOut);

    //descending order
    //return compareQuantity - this.quantity;
  }
}

