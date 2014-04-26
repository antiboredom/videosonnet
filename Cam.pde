class Cam {
  String username, password, ip, control_url, operator_url, videostream;
  PVector pos = new PVector();

  Cam(String _ip, String _user, String _pass) {
    ip = _ip;
    control_url = "http://" + ip + "/axis-cgi/com/ptz.cgi?";
    operator_url = "http://" + ip + "/axis-cgi/operator/param.cgi?";
    videostream = "http://" + ip + "/mjpg/video.mjpg";
    username = _user;
    password = _pass;
  }

  void centerCam(float x, float y) {
    command("center=" + int(x) + "," + int(y));
  }

  void moveCam(float x, float y) {
    moveCam(int(x), int(y));
  }

  void moveCam(int x, int y) {
    command("pan=" + x + "&tilt=" + y);
  }

  void zoomout() {
    command("zoom=1");
  }

  void zoomin() {
    command("zoom=9999");
  }

  void zoomin(int z) {
    command("zoom=" + z);
  }

  void setfocus(int f) {
    command("rfocus=" + f);
  }
  
  void autofocus() {
   command("autofocus=on"); 
  }

  void iris(int i) {
    command("iris=" + i);
  }


  void areazoom(float x, float y) {
    command("areazoom=" + x + "," + y + ",800");
  }

  void areazoom(float x, float y, int z) {
    command("areazoom=" + x + "," + y + "," + z);
  }
  
  void autopan() {
    moveCam(pos.x, pos.y);
    pos.x += 50;
    if (pos.x > 180) pos.x = -180;
  }

  void pan(float x) {
    command("pan=" + x);
  }
  
  void tracking(boolean shouldTrack) {
    String c = shouldTrack ? "yes" : "no";
    operator("action=update%20&AutoTracking.A0.Running=" + c);
  }


  void record(int t) {
    String[] cmd = {
      "/Applications/VLC.app/Contents/MacOS/VLC", 
      "-I", "rc", 
      "-vvv", "rtsp://" + username + ":" + password + "@" + ip + ":554/axis-media/media.amp", 
      "--sout", "file/ts:" + dataPath("zoom" + millis() + ".ts"), 
      "--run-time", str(t)
      };
      exec(cmd);
      println(t);
  }


  void command(String c) {
    println(c);
    authHTTPRequest(username, password, control_url + c);
  }
  
  void operator(String c) {
    println(c);
    authHTTPRequest(username, password, operator_url + c);
  }
}

