class CamMover {

  ArrayList<Action> actions = new ArrayList<Action>();
  int left, right;
  int start_time;
  int current_action = -1;
  String state = "";
  Cam cam;

  CamMover(Cam _cam, int _left, int _right) {
    cam = _cam;
    left = _left;
    right = _right;
    set_timing();
  }


  void set_timing() {
  }

  void update() {
    for (int i = 0; i < actions.size(); i++) {
      Action a = actions.get(i);
      if (millis() >= a.time && i > current_action && state != a.name) {
        perform(a);
        current_action = i;
      }
    }

    if (current_action == actions.size() - 1) {
      println("__________");
      set_timing();
    }
  }

  void perform(Action a) {
    if (a.name == "zoomout") {
      println("zooming out");
      cam.zoomout();
    }
    else if (a.name == "panright") {
      println("panning right");
      cam.pan(right);
    }
    else if (a.name == "panleft") {
      println("panning left");
      cam.pan(left);
    }
    else if (a.name == "zoomin") {
      println("zooming in");
      cam.zoomin();
    }

    else if (a.name == "blur") {
      println("blurring");
      cam.setfocus(9999);
    }

    else if (a.name == "focus") {
      println("focusing");
      cam.setfocus(-9999);
    }

    else if (a.name == "lighten") {
      println("lightening");
      cam.iris(9999);
    }
    
    else if (a.name == "autofocus") {
      println("autofocus");
      cam.autofocus();
    }

    else if (a.name == "darken") {
      println("darkening");
      cam.iris(1);
    }

    state = a.name;
  }

  void add_action(String name, int time) {
    if (actions.size() > 0) {
      int prev_time = actions.get(actions.size() - 1).time;
      time += prev_time;
    } 
    else {
      time += start_time;
    }
    actions.add(new Action(name, time));
  }
}

class Action {
  String name;
  int time;

  Action(String _name, int _time) {
    name = _name;
    time = _time;
  }
}
