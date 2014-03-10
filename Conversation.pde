class Conversation extends CamMover {

  Conversation(Cam _cam, int _left, int _right) {
    super(_cam, _left, _right);
  }

  void set_timing () {
    start_time = millis();
    current_action = 0;
    actions = new ArrayList<Action>();
    add_action("zoomout", 1);
    add_action("findface", 2000);
    add_action("zoomout", 6000);
    add_action("panright", 2000);
    add_action("findface", 2000);
    add_action("zoomout", 6000);
    add_action("panleft", 2000);
    add_action("findface", 2000);
  }

  void update() {
    super.update();
    if (state == "findface") {
      findface();
    }
  }

  void findface() {
    if (faces.length > 0) {
      noFill();
      stroke(255, 0, 0);
      println("FOUND FACES");
      int i =0;// int(random(0, faces.length));
      if (faceFrameCount >= 5 && state != "zoomedin") {
        state = "zoomedin";
        cam.areazoom(faces[i].x, faces[i].y);
        //cam.record(int(random(3, 7)));
      }
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



