// bring in library to talk with USB
import processing.serial.*;
Serial port;

// set the size and configuration of your LEDs (never less that 1 on either)
int cols = 20;
int rows = 8;
int LEDCount = cols*rows;

// ArrayList to hold the current effects
ArrayList <Effect> effects;

// Image buffer to hold pixels in
PGraphics canvas;

// Interface to pick colors for effects
ColorPicker colorPicker;
color selectedColor;

void setup() {
	// Size of the on-screen display
	size(800, 600);

	// makes the screen feedback accurate
	noSmooth();

	// set the frame refresh rate
	frameRate(24);

	// set serial (USB) port. Change the number in [brackets]
	try {
		port = new Serial(this, Serial.list()[2], 9600);
	} catch (Exception e) {
		println("Problem connecting to Serial port: " + e);
	}
	

	// initialize effect array
	effects = new ArrayList();

	// canvas for the leds to run on
	canvas = createGraphics(cols, rows);

	colorPicker = new ColorPicker(0,0,50,50);
	selectedColor = color(255,255,255);
}

void draw() {
	background(60);
	// update any changes to effects
	updateEffects();

	// add all the images from effects to the canvas buffer
	canvas.beginDraw();
	canvas.background(0);
	for(Effect e : effects){
		canvas.image(e.getBuffer(),0,0);
	}
	canvas.endDraw();

	// stretch the canvas image accross the screen
	pushStyle();
	imageMode(CENTER);
	image(canvas, width/2,height/2,cols*15,rows*15);
	popStyle();

	colorPicker.display();
	fill(selectedColor);
	noStroke();
	rect(50,0,50,50);

	try {
		sendToArduino();
	} catch (Exception e) {
		// println("Problem with sendToArduino(): " + e);
	}
	debug();
}

// run to show framerate and other debug info
void debug(){
	fill(0,120);
	noStroke();
	rect(0, height-30, width/8, 10);

	fill(255);
	stroke(255);
	text(frameRate, 10, height-20);
}

void updateEffects(){
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

void sendToArduino(){
	/*This is where we will send the canvas through the serial
	bus to the Arduino*/

	// load the pixel array in the canvas object
	canvas.loadPixels();

	// send each pixel to the arduino
	for(int i=0;i<canvas.pixels.length; i++){
		color p = canvas.pixels[i];
		int nR = (p >> 16) & 0xFF;  // Faster way of getting red(p)
		int nG = (p >> 8) & 0xFF;   // Faster way of getting green(p)
		int nB = p & 0xFF; 

	    // send comma separated values: ledID red green blue	    
	    String output = i + "\t" + round(nR) + "\t" + round(nG) + "\t" + round(nB) + "\n";
        port.write(output);
	}
    port.write("\n");

}

void keyPressed(){
    println(keyCode);
    if(key == 's') {
        Snow snow = new Snow(9000);
        effects.add(snow);
    }

    if(key == 't') {
    	color c = color(245, 255, 120);
        Twinkle twinkle = new Twinkle(3000, c);
        effects.add(twinkle);
    }

    if(key == 'f') {    	
        Flashes flashes = new Flashes(15000);
        effects.add(flashes);
    }

    if(key == 'c') {
    	CircleBurst circleBurst = new CircleBurst(2000, selectedColor);
    	effects.add(circleBurst);
    }

    if(key == 'w') {
        Wipe wipe = new Wipe(2000, selectedColor);
        effects.add(wipe);
    }
    
    if(key == 'u') {
        Super super = new Super(2000);
        effects.add(super);
    }

}


void mousePressed(){
	color c = colorPicker.getColor();
	if(c != -1){
		selectedColor = c;	
	}
	println(selectedColor);
}
class CircleBurst extends Effect{
	
	float circleSpeed = 3;

	color baseColor;	

	float r = 1;
	float weight = 2;
	float x;
	float y;

	CircleBurst(int _millis, color _c){
		super(_millis);

		baseColor = _c;

		x = cols/2;
		y = rows/2;
		imageBuffer.beginDraw();
		imageBuffer.noFill();
		imageBuffer.stroke(baseColor);
		imageBuffer.strokeWeight(weight);
		// imageBuffer.noSmooth();
		imageBuffer.endDraw();
	}

	void update(){
		imageBuffer.beginDraw();
		imageBuffer.background(0,10);
		imageBuffer.ellipse(x,y,r,r);
		imageBuffer.endDraw();
		//ease out
		r++;
		// weight+=weight*0.98;
	}
}
class ColorPicker{
	PImage colorGrid;

	int x;
	int y;
	int w;
	int h;

	ColorPicker(int _x, int _y, int _width, int _height){
		x = _x;
		y = _y;
		w = _width;
		h = _height;
		pushStyle();
		colorMode(HSB, 255,255,255);
		colorGrid = createImage(w, h, RGB);
		colorGrid.loadPixels();
		for (int i = 0; i < colorGrid.pixels.length; i++) {
			float x = i%w; 
			float y = floor(i/w);
			float hu = map(x,0,w,0,255);
			float s = map(y,0,h,0,255);
			colorGrid.pixels[i] = color(hu,s,255);
		}
		colorGrid.updatePixels();
		popStyle();
	}

	void display(){
		image(colorGrid,x,y);
	}

	color getColor(){
		color result = -1;
		if(mouseX > x && mouseX < x+w){
			if(mouseY > y && mouseY < x+h){
				result = colorGrid.get(mouseX-x, mouseY-y);
			}
		} 
		return result;
	}
}
class Effect{
	// how long the effect will last in milliseconds
	int milliseconds;

	// when the effect was first triggered
	int startTime;

	// the buffer to hold the effect information
	PGraphics imageBuffer;

	Effect(int _millis){
		imageBuffer = createGraphics(cols, rows);
		milliseconds = _millis;
		startTime = millis();
	}

	void update(){

	}

	boolean finished(){
		// check if the effect should be over
		if(millis()>startTime+milliseconds){
            return true;
        } else {
            return false;
        }
	}
	
	PGraphics getBuffer(){
		return imageBuffer;
	}
}
class Flashes extends Effect{
	
	ArrayList <Flash> flashes;

	Flashes(int _millis){
		super(_millis);
		flashes = new ArrayList();
	}

	void update(){
		super.update();

		// make a new flash every frame
		Flash newF = new Flash();
		flashes.add(newF);

		// clear out finished flashes. Update the others
		for(int i=flashes.size()-1; i>=0; i--){
			Flash f = flashes.get(i);
			if(f.isDead()){
				flashes.remove(i);
			} else {				
				f.update();

				imageBuffer.beginDraw();
				// load buffer's pixels in to pixel[] array
				imageBuffer.loadPixels();
				imageBuffer.pixels[f.id] = color(f.value);
				// load pixel[] array back into image
				imageBuffer.updatePixels();
				imageBuffer.endDraw();	
			}
		}
	}

	// starts a pixel at 255 brightness. Fade to zero
	class Flash{
		int id;
		float value;

		float dimSpeed = .90;
		Flash(){
			id = floor(random(LEDCount));
			value = 255;
		}

		void update(){
			value *= dimSpeed;
		}

		boolean isDead(){
			if(value < 1){
				return true;
			}
			return false;
		}
	}
}
class Snow extends Effect{
	// how fast the flakes should fall
	float fallSpeed = .02;

	//Array of points for the flakes
	PVector[] flakes;

	Snow(int _millis){
		super(_millis);

		//initialize the array to hold the flakes
		flakes = new PVector[rows*cols/8];
		for(int i=0; i<flakes.length; i++){
			// put each new flake in a new location
			flakes[i] = new PVector(floor(random(cols)), random(-5,rows/2));
		}
	}

	void update(){
		// do any commands in the Effect class update function
		imageBuffer.beginDraw();

		super.update();
		
		// fade out the previous image to transparent
		imageBuffer.background(0,0);
		
        // move the flakes down
        updateFlakes();	

		// draw flakes to image buffer
		imageBuffer.fill(255);
		imageBuffer.noStroke();

		for(PVector f : flakes){
			imageBuffer.rect(f.x, f.y, 1, 1);
		}

        imageBuffer.endDraw();
	}

	// makes the flakes move down
	void updateFlakes(){
		for(int i =0; i<flakes.length; i++){
			// if it goes past the end start somewhere new
			if(flakes[i].y + fallSpeed > rows || random(1)<.01){
				flakes[i] = new PVector(floor(random(cols)), random(-5, rows));
			} else {
				flakes[i].y += fallSpeed + random(.1);	
			}
		}
	}
}
class Super extends Effects{
  float w, h;
  float x, y;
  
  Super(int _millis){
    super(_millis);
    
    w = 0;
    h = 0;
    x = cols/2;
    y = rows/2;
    
    imageBuffer.beginDraw();
    imageBuffer.rectMode(CENTER);
    imageBuffer.noFill();
    imageBuffer.endDraw();
    
  }
  
  void update(){
    imageBuffer.beginDraw();
    imageBuffer.stroke(random(155,255),random(155,255),random(155,255),);
    imageBuffer.rect(x,y,w,h);
    imageBuffer.endDraw();
    w++;
    h++;
  }
}
// Take all the functions and variables from the Effects class
class Twinkle extends Effect{
	
	// Which noise x-position to start at
	int[] noiseID;

	// speed that this ID will move through
    float[] noiseSpeed;

    // sets the color of this effect
    color baseColor;

	Twinkle(int _millis, color _c){
		// run the all of the commands from the Effects parent class
		super(_millis);

		baseColor = _c;

		noiseID = new int[LEDCount];
        noiseSpeed = new float[LEDCount];
        for(int i=0;i<noiseID.length;i++){
            noiseID[i] = round(random(0,LEDCount));
            noiseSpeed[i] = random(.015, .035);
        }
	}

	void update(){
		// do any commands in the Effect class update function
		imageBuffer.beginDraw();

		// create the pixel array
		imageBuffer.loadPixels();

		super.update();
		for(int i=0; i<noiseID.length; i++){
            // get the grayscale amount for the noise
            float noiseAmount = noise(noiseID[i], frameCount* noiseSpeed[i]) * 255;
            imageBuffer.pixels[i] = color(red(baseColor), green(baseColor), blue(baseColor), noiseAmount);
        }

        // load the pixel array into the buffer
        imageBuffer.updatePixels();
        imageBuffer.endDraw();
	}
}
class Wipe extends Effect {
    color baseColor;
    int xpos;
    float weight = 1;

    Wipe(int _millis, color _c) {
        super(_millis);
        xpos = 0;
        baseColor = _c;
        imageBuffer.beginDraw();
        imageBuffer.noFill();
        imageBuffer.stroke(baseColor);
        imageBuffer.strokeWeight(weight);
        imageBuffer.endDraw();
    }

    void update() {
        imageBuffer.beginDraw();
        imageBuffer.background(0, 1);
        imageBuffer.line(xpos, 0, xpos, rows);
        imageBuffer.endDraw();
        xpos++;
    }
}

