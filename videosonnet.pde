// We need a few java libraries to do the authenticated HTTP request
import java.net.Authenticator;
import java.net.PasswordAuthentication;
import java.net.URL;
import java.net.URLConnection;
import java.io.InputStreamReader;
import gab.opencv.*;
import java.awt.Rectangle;

public static final int WIDTH = 1280;
public static final int HEIGHT = 720;

JSONObject credentials;
String ip;
String username;
String password;

PImage currentFrame;
int faceFrameCount = 0;
int imageFrameCount = 0;

OpenCV opencv;
Rectangle[] faces;
MJPEGParser parser;

Conversation conv;
//ZoomBlur conv;

Cam cam;

void setup() {
  size(WIDTH, HEIGHT);
  
  credentials = loadJSONObject("credentials.json");
  ip = credentials.getString("ip");
  username = credentials.getString("username");
  password = credentials.getString("password");
  
  currentFrame = createImage(WIDTH, HEIGHT, RGB);

  opencv = new OpenCV(this, WIDTH, HEIGHT);
  //opencv.loadCascade(OpenCV.CASCADE_PROFILEFACE);  
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  faces = new Rectangle[0];
  cam = new Cam(ip, username, password);
  conv = new Conversation(cam, 160, 95);
  //conv = new ZoomBlur(cam, 180, 130);
  parser = new MJPEGParser(cam.videostream, WIDTH, HEIGHT, username, password, this);
}


void draw() {
  image(currentFrame, 0, 0);
  conv.update();
}

void mouseReleased() {
  cam.centerCam(mouseX, mouseY);
}




void newFrame(PImage newPimage) {
  currentFrame = newPimage;
  if (imageFrameCount%10 == 0 && conv.state == "findface") {
    opencv.loadImage(currentFrame);
    faces = opencv.detect();
    if (faces.length > 0) {
      faceFrameCount++;
    } 
    else {
      faceFrameCount = 0;
    }
  }
  imageFrameCount++;
}


// This is the authenticated HTTP request
void authHTTPRequest(String username, String password, String url) {
  try 
  {
    Authenticator.setDefault(new HTTPAuthenticator(username, password));

    URL urlObject = new URL(url);
    URLConnection urlConnection = urlObject.openConnection();

    BufferedReader in = new BufferedReader(new InputStreamReader(urlConnection.getInputStream()));
    String inputLine;
    while ( (inputLine = in.readLine ()) != null) 
      println(inputLine);
    in.close();
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
}

class HTTPAuthenticator extends Authenticator {
  private String username, password;

  public HTTPAuthenticator(String user, String pass) {
    username = user;
    password = pass;
  }

  protected PasswordAuthentication getPasswordAuthentication() {
    System.out.println("Requesting Host  : " + getRequestingHost());
    System.out.println("Requesting Port  : " + getRequestingPort());
    System.out.println("Requesting Prompt : " + getRequestingPrompt());
    System.out.println("Requesting Protocol: " + getRequestingProtocol());
    System.out.println("Requesting Scheme : " + getRequestingScheme());
    System.out.println("Requesting Site  : " + getRequestingSite());
    return new PasswordAuthentication(username, password.toCharArray());
  }
}  


///Applications/VLC.app/Contents/MacOS/VLC -vvv rtsp://root:enter@128.122.151.227:554/axis-media/media.amp --sout file/ts:test.ts

