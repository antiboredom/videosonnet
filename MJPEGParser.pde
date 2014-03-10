import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.IOException;
import java.net.Authenticator;
import java.net.PasswordAuthentication;
import java.net.URL;
import java.awt.image.PixelGrabber; 

import java.lang.reflect.Method;

// This generates an error that I am ignoring:
// http://thillakan-tech.blogspot.com/2009/09/eclipse-error-access-restrictionthe.html
import com.sun.image.codec.jpeg.JPEGImageDecoder;
import com.sun.image.codec.jpeg.JPEGCodec;
//import java.awt.image.BufferedImage;

public class MJPEGParser implements Runnable {

  PApplet sketch;
  
  Method newFrameMethod;
  
  BufferedImage bimage;
  PImage pimage;
  
  String username;
  String password;
  String mJpegUrl;
  
  int w;
  int h;

  DataInputStream dis;  
  

  public MJPEGParser(String mjpeg_url)
  {
    this(mjpeg_url,640,480,null,null,null);
  }
  
  public MJPEGParser(String _mJpegUrl, int _width, int _height, String _username, String _password, PApplet _sketch)
  {
    sketch = _sketch;
    
    try {
      newFrameMethod = _sketch.getClass().getMethod("newFrame", new Class[] { PImage.class });
    } catch (Exception e) {
      // no such method, or an error.. which is fine, just ignore
    }
    
    username = _username;
    password = _password;
    mJpegUrl = _mJpegUrl;
    
    w = _width;
    h = _height;
    
    pimage = sketch.createImage(_width,_height,PConstants.RGB);//new PImage(_width, _height);

    Thread myThread = new Thread(this);
    myThread.start();
  }
  
  public PImage getPImage() {
      return pimage.get();
  }
  
  public void run() {
      connect();

      while (true) {
        readLine(3, dis); // discard the first 3 lines
        readJPG();
        readLine(2, dis); // discard the last two lines
      }
  }
  
  private void connect() {
    try 
    {
      if (username != null && password != null)
      {
          Authenticator.setDefault(new HTTPAuthenticator(username, password));
       }
      
       URL url = new URL(mJpegUrl);
        
       BufferedInputStream bin = new BufferedInputStream(url.openStream());
       dis = new DataInputStream(bin);
    
      } catch (IOException e) {
          e.printStackTrace();
      }    
  }

  JPEGImageDecoder decoder;
  private void readJPG() { // read the embedded jpeg image
    try {
      decoder = JPEGCodec.createJPEGDecoder(dis);
      bimage = decoder.decodeAsBufferedImage();
      
      pimage.loadPixels();
      synchronized(pimage.pixels) {
        PixelGrabber pg = new PixelGrabber(bimage, 0, 0, w, h, pimage.pixels, 0, w);
        pg.grabPixels();
      }
      
      pimage.updatePixels();      
      
      if (newFrameMethod != null) {
        try {
          newFrameMethod.invoke(sketch, new Object[] { pimage.get() });
        } catch (Exception e) {
          newFrameMethod = null;
          e.printStackTrace();
        }        
      }

      //System.out.println("Decoded Image: " + bimage.getWidth() + " " + bimage.getHeight());
      //System.gc();
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
  
  private void readLine(int n, DataInputStream dis) { // used to strip out the header lines
    for (int i = 0; i < n; i++) {
      readLine(dis);
    }
  }
  
      String lineEnd = "\n"; // assumes that the end of the line is marked with this
      byte[] lineEndBytes = lineEnd.getBytes();
      byte[] byteBuf = new byte[lineEndBytes.length];
      boolean end = false;
      String t = new String(byteBuf);
    
  private void readLine(DataInputStream dis) {
    //System.out.println("readLine");
    try {
      end = false;

      
      while (!end) {
          dis.read(byteBuf, 0, lineEndBytes.length);
          t = new String(byteBuf);
          // System.out.print(t); //uncomment if you want to see what the lines actually look like
          if (t.equals(lineEnd)) end = true;
      }
    } catch (Exception e) {
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
        System.out.println("Requesting Protocol: "
            + getRequestingProtocol());
        System.out.println("Requesting Scheme : " + getRequestingScheme());
        System.out.println("Requesting Site  : " + getRequestingSite());
        return new PasswordAuthentication(username, password.toCharArray());
      }
    }  
}
