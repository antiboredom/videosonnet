class Conversation extends CamMover {

  ArrayList<Face> faceRecords = new ArrayList<Face>();
  boolean hasRecorded = true;
  int zoomedInAt;
  Wave recordWave = new Wave (0, .1, 3, 5);
  Wave delayWave = new Wave (2000, .5, 700, 2500);

  Conversation(Cam _cam, int _left, int _right) {
    super(_cam, _left, _right);
    delayWave.wave();
  }

  void set_timing () {
    start_time = millis();
    current_action = 0;
    actions = new ArrayList<Action>();

    add_action("zoomout", 1);
    add_action("zoomout", 2000);
    add_action("enabletracking", 1000);
    //add_action("record", 2000);

    add_action("findface", 4000);
    //add_action("findface", 14000);
    add_action("zoomout", 16000);
    add_action("disabletracking", 1000);

    add_action("panright", 2000);
    add_action("enabletracking", 1000);

    add_action("findface", 4000);

    //add_action("findface", 4000);
    add_action("zoomout", 16000);

    add_action("disabletracking", 1000);

    add_action("panleft", 4000);
    add_action("findface", 2000);
  }

  void update() {
    super.update();
    if (state == "findface" || state == "findface2") {
      findface();
    }

    //if (state == "zoomedin" && !hasRecorded && millis() - zoomedInAt >= delayWave.val) {
    if (state == "zoomedin" && !hasRecorded && millis() - zoomedInAt >= 3000) {
      //cam.record(int(random(5, 11)));
      delayWave.wave();
      cam.record(1);//int(recordWave.wave()));
      hasRecorded = true;
    }
  }

  void findface() {
    if (faces.length > 0) {
      noFill();
      stroke(255, 0, 0);
      ArrayList<Face> newFaces = new ArrayList<Face>();
      if (faceRecords.size() == 0) {
        for (int i = 0; i < faces.length; i ++) {
          stroke(255, 0, 0);
          //rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
          faceRecords.add(new Face(faces[i].x, faces[i].y, faces[i].width, faces[i].height));
        }
      } 
      else {
        for (int i = 0; i < faces.length; i ++) {
          boolean alreadyIn = false;
          for (Face f : faceRecords) {
            if (dist(f.x, f.y, faces[i].x, faces[i].y) < 100) {
              f.hit();
              alreadyIn = true;
            }
          }
          if (!alreadyIn) {
            faceRecords.add(new Face(faces[i].x, faces[i].y, faces[i].width, faces[i].height));
          }
        }
      }
    }

    for (Face f : faceRecords) {
      stroke(0, 255, 0);
      rect(f.x, f.y, f.w, f.h);
      text(f.hits, f.x + 10, f.y + 10);
    }

    //if (state == "findface") {
    if (faceFrameCount >= 5 && state == "findface" && faceRecords.size() > 0) {

      int best = 0;
      int bestIndex = 0;
      for (int i = 0; i < faceRecords.size(); i ++) {
        if (faceRecords.get(i).hits > best) {
          best = faceRecords.get(i).hits;
          bestIndex = i;
        }
      }

      cam.areazoom(faceRecords.get(bestIndex).x + faceRecords.get(bestIndex).w / 2, faceRecords.get(bestIndex).y + faceRecords.get(bestIndex).h / 2);
      state = "zoomedin";
      zoomedInAt = millis();
      hasRecorded = false;
      faceFrameCount = 0;
      faceRecords.clear();

      //cam.record(int(random(3, 7)));
    }
  }

  void perform(Action a) {
    super.perform(a);
    if (a.name == "findface") {
      println("finding faces");
      findface();
    }
  }
}

class Face {
  float x, y, w, h;
  int hits = 0;

  Face(float _x, float _y, float _w, float _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }

  void hit() {
    hits++;
  }
}

