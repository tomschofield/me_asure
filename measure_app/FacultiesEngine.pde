//All code is license to Tom Schofield and John Bowers under Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)
class FacultiesEngine {
  PVector [] pts;
  ArrayList foundFaculties = new ArrayList();
  FacultiesEngine() {
  }
  //this should go through and define the calculations for each faculty
  void update(PVector [] _pts, Faculty [] faculties, float [] measures) {
    pts = _pts;
    //for each measure, go through the appopriate faculty and see if it fulfilled
    // measures[ UPPER_LIP_SIZE ];

    faculties[0].update(measures[ UPPER_LIP_SIZE ]);
    faculties[1].update(measures[ UPPER_LIP_SIZE ]);

    faculties[2].update(measures[ UPPER_LIP_CURVE ]);
    faculties[3].update(measures[ UPPER_LIP_CURVE ]);
    faculties[4].update(measures[ UPPER_LIP_CURVE ]);
    faculties[5].update(measures[ UPPER_LIP_CURVE ]);
    faculties[6].update(measures[ UPPER_LIP_CURVE ]);
    faculties[7].update(measures[ UPPER_LIP_CURVE ]);
    faculties[8].update(measures[ UPPER_LIP_CURVE ]);

    faculties[9].update(measures[ LOWER_LIP_SIZE ]);
    faculties[10].update(measures[ LOWER_LIP_SIZE ]);
    faculties[11].update(measures[ LOWER_LIP_SIZE ]);
    faculties[12].update(measures[ LOWER_LIP_SIZE ]);

    faculties[13].update(measures[ LOWER_LIP_CURVE ]);

    faculties[14].update(measures[ MOUTH_CURVE ]);

    faculties[15].update(measures[ NOSE_WIDTH ]);
    faculties[16].update(measures[ NOSE_WIDTH ]);

    //not currently implemented
    faculties[17].update(0);

    faculties[18].update(measures[ SEPTUM_SIZE ]);
    faculties[19].update(measures[ SEPTUM_SIZE ]);
    faculties[20].update(measures[ SEPTUM_SIZE ]);

    faculties[21].update(measures[ NOSE_LENGTH ]);

    faculties[22].update(measures[ NOSE_PROPORTION ]);
    faculties[23].update(measures[ NOSE_PROPORTION ]);
    faculties[24].update(measures[ NOSE_PROPORTION ]);


    faculties[25].update(measures[ EYE_SIZE ]);

    faculties[26].update(measures[ EYE_OPENNESS ]);
    faculties[27].update(measures[ EYE_OPENNESS ]);
    faculties[28].update(measures[ EYE_OPENNESS ]);
    faculties[29].update(measures[ EYE_OPENNESS ]);

    faculties[30].update(measures[ EYEBROW_CURVE ]);
    faculties[31].update(measures[ EYEBROW_CURVE ]);
    faculties[32].update(measures[ EYEBROW_CURVE ]);

    faculties[33].update(measures[ EYEBROW_PROPORTIONS ]);
    faculties[34].update(measures[ EYEBROW_PROPORTIONS ]);

    faculties[35].update(measures[ CHIN_SHAPE ]);
    faculties[36].update(measures[ CHIN_SHAPE ]);
    faculties[37].update(measures[ CHIN_SHAPE ]);
    faculties[38].update(measures[ CHIN_SHAPE ]);
    faculties[39].update(measures[ CHIN_SHAPE ]);
    faculties[40].update(measures[ CHIN_SHAPE ]);
    faculties[41].update(measures[ CHIN_SHAPE ]);

    faculties[43].update(measures[ CHIN_EXTENSION ]);
    faculties[44].update(measures[ CHIN_EXTENSION ]);
    faculties[45].update(measures[ CHIN_EXTENSION ]);
    faculties[46].update(measures[ CHIN_EXTENSION ]);

    //println("updated measures", measures[0]);
  }

  void display(Faculty [] faculties, PVector point) {
    pushStyle();
    textFont(font, 24);
    String facultyList = "";
    int wordLimit = 4;
    int wordCount = 0;
    for (int i=0;i<faculties.length;i++) {
      if (faculties[i].found) {
        facultyList+=faculties[i].name+", ";
        wordCount++;
        if (wordCount>=wordLimit) {
          wordCount = 0; 
          facultyList+="\n";
        }
      }
    }
    text(facultyList, point.x, point.y);
    popStyle();
  }
  void constrainTextToBox() {
  }

  void updateTextArrangement() {
  }
  void displayDescriptionsDynamic(Faculty [] faculties, PVector point) {
    pushStyle();
    textFont(largeFont, 48);
    fill(200, 200);
    String facultyList = "";
    int wordLimit = 4;
    int wordCount = 0;
    // if(interactionManager.isNewFace){
    foundFaculties.clear();
    //}


    //first get the existing ones
    Faculty [] tempFacs = new Faculty[faculties.length];
    for(int i=0;i<faculties.length;i++){
      tempFacs[i]=faculties[i];
    }
    Arrays.sort(tempFacs);
    for(int i=0;i<tempFacs.length;i++){
    // println( i+" "+tempFacs[i].timeOut);
    }
    
    for (int i=0;i<tempFacs.length;i++) {
      if (tempFacs[i].timeOut>90) {//    &&faculties[i].yPos!=-1) {
        foundFaculties.add(faculties[i]);
      }
    }
    // println(foundFaculties.size());

    //    //now find the new ones
    //    for (int i=0;i<faculties.length;i++) {
    //      if (faculties[i].timeOut>0&&faculties[i].yPos==-1) {
    //        foundFaculties.add(faculties[i]);
    //      }
    //      
    //    }
    //    //if this faculty is dead then make its ypos in the negatives
    //    for (int i=0;i<faculties.length;i++) {
    //      if (faculties[i].timeOut<=0) {
    //        faculties[i].yPos=-1;
    //      }
    //      
    //    }

    
    for (int i=0;i<foundFaculties.size();i++) {
      Faculty thisFaculty = (Faculty) foundFaculties.get(i);
      
      //if (thisFaculty.timeOut>0) {

        fill(200, thisFaculty.timeOut);
        float textHeight = splitTokens(thisFaculty.description, "\n").length*48;
        //println(splitTokens(thisFaculty.description,"\n").length);
        text(thisFaculty.description, 0, i*48*2.1, width, height );
     // }
    }

    popStyle();
  }
  void displayDescriptions(Faculty [] faculties, PVector point) {
    pushStyle();
    textFont(font, 48);
    fill(200, 200);
    String facultyList = "";
    int wordLimit = 4;
    int wordCount = 0;
    ArrayList foundFaculties = new ArrayList();
    foundFaculties.clear();
    Faculty [] tempFacs = new Faculty[faculties.length];
    for(int i=0;i<faculties.length;i++){
      tempFacs[i]=faculties[i];
    }
    Arrays.sort(tempFacs);
    for (int i=0;i<tempFacs.length;i++) {
      if (tempFacs[facultyIndices[i]].timeOut>40) {
        foundFaculties.add(faculties[i]);
      }
    }
//    for (int i=0;i<faculties.length;i++) {
//      if (faculties[facultyIndices[i]].timeOut>40) {
//        foundFaculties.add(faculties[i]);
//      }
//    }
    print("foundFaculties.size() "+foundFaculties.size());
    for (int i=0;i<foundFaculties.size();i++) {
      Faculty thisFaculty = (Faculty) foundFaculties.get(i);
    //  if (thisFaculty.timeOut>0) {

        fill(200, map(thisFaculty.timeOut,0,255,100,200) );// ,thisFaculty.timeOut);
        float textHeight = splitTokens(thisFaculty.description, "\n").length*48;
        //println(splitTokens(thisFaculty.description,"\n").length);
        thisFaculty.setTargetPos(i*48*2.1);
        text(thisFaculty.description, 0, thisFaculty.yPos, width, height );
      }
   // }

    popStyle();
  }
}

