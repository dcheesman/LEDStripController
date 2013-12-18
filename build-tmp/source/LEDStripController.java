import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class LEDStripController extends PApplet {

// set the size and configuration of your LEDs
int cols = 10;
int rows = 6;
int LEDCount = cols*rows;

// ArrayList to hold the current effects
ArrayList <Effect> effects;

// Image buffer to hold pixels in
PGraphics canvas;

public void setup() {
	// Size of the on-screen display
	size(800, 600);

	// makes the screen feedback accurate
	noSmooth();

	// initialize effect array
	effects = new ArrayList();

	// canvas for the leds to run on
	canvas = createGraphics(cols, rows);
}

public void draw() {
	updateEffects();

	canvas.beginDraw();
	canvas.background(0);
	for(Effect e : effects){
		canvas.image(e.getBuffer(),0,0);
	}
	canvas.endDraw();

	// clear the previous frame
	background(0);

	// stretch the canvas image accross the screen
	image(canvas, 0,0,width,height);	
}

public void updateEffects(){
	// go backwards through the effect array. Update and remove dead effects
	for(int i=effects.size()-1; i>=0; i--){
        Effect e = (Effect) effects.get(i);
        if(e.finished()){
            effects.remove(i);
        } else {
            e.update();                        
        }
    }
}

public void keyPressed(){
    println(keyCode);
    if(key == 't') {
    	int c = color(245, 255, 120);
        Twinkle twinkle = new Twinkle(3000, c);
        effects.add(twinkle);
    }
}
class Effect{
	int milliseconds;
	int startTime;

	PGraphics imageBuffer;

	Effect(int _millis){
		imageBuffer = createGraphics(cols, rows);
		milliseconds = _millis;
		startTime = millis();
	}

	public void update(){

	}

	public boolean finished(){
		// check if the effect should be over
		if(millis()>startTime+milliseconds){
            return true;
        } else {
            return false;
        }
	}

	public PGraphics getBuffer(){
		return imageBuffer;
	}
}
// Take all the functions and variables from the Effects class
class Twinkle extends Effect{
	
	// Which noise x-position to start at
	int[] noiseID;

	// speed that this ID will move through
    float[] noiseSpeed;

    int baseColor;

	Twinkle(int _millis, int _c){
		// run the Effect initializer
		super(_millis);

		baseColor = _c;

		noiseID = new int[LEDCount];
        noiseSpeed = new float[LEDCount];
        for(int i=0;i<noiseID.length;i++){
            noiseID[i] = round(random(0,LEDCount));
            noiseSpeed[i] = random(.005f, .015f);
        }
	}

	public void update(){
		// do any commands in the Effect class update function
		imageBuffer.beginDraw();

		// create the pixel array
		imageBuffer.loadPixels();

		super.update();
		for(int i=0; i<noiseID.length; i++){
            // get the grayscale amount for the noise
            float noiseAmount = noise(noiseID[i], frameCount* noiseSpeed[i]) * 100;
            imageBuffer.pixels[i] = color(red(baseColor), green(baseColor), blue(baseColor), noiseAmount);
        }

        // load the pixel array into the buffer
        imageBuffer.updatePixels();
        imageBuffer.endDraw();
	}
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "LEDStripController" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
