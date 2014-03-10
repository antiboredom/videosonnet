class ZoomBlur extends CamMover {

  float record_time = 0;
  float spd = .05;
  float x = 0;
  float y = 0;
  Wave spdWave;
  Wave pauseWave = new Wave(200, .1, 1000);

  ZoomBlur(Cam _cam, int _left, int _right) {
    super(_cam, _left, _right);
    spdWave = new Wave(0, .01, 2);
    cam.record(120);
  }

  void set_timing () {
    if (pauseWave == null) {
      pauseWave = new Wave(200, .1, 1000);
    }
    start_time = millis();
    current_action = 0;
    actions = new ArrayList<Action>();
    float p = abs(pauseWave.wave());
    add_action("noisemove2", 1);
    add_action("noisemove", int(p));
    add_action("noisemove2", 1);
    add_action("noisemove", int(p));
    //add_action("noisemove2", 1);
//    add_action("noisemove", 1500);
//    add_action("noisemove2", 1);


    //add_action("zoomout", 1);
    //add_action("zoomin", 3000);
    //add_action("blur", 1000);
    //add_action("autofocus", 1000);
    //add_action("blur", 1000);
    //add_action("autofocus", 1000);
    
    //add_action("focus", 1000);
    //add_action("zoomout", 3000);
    //add_action("zoomin", 3000);
  }

  void perform(Action a) {
    super.perform(a);
    println("moving");
    x+= abs(spdWave.wave());
    y+=spd;
    cam.pan(noise(x) * -100);
    //cam.moveCam(noise(x) * -100, noise(y) * -50);
    record_time = noise(x) * 3 + 1;

    String to_record = noise(x) > .5 ? "zoomin" : "zoomout";

    if (state == to_record) {
      println("record time:" + record_time);
      //cam.record(int(record_time));
      //x += spd;
    }
  }
  
  void update() {
    super.update();
      
  }
}
