// bring in library to talk with USB
import processing.serial.*;
Serial port;

// set the size and configuration of your LEDs
int cols = 40;
int rows = 20;
int LEDCount = cols*rows;

// ArrayList to hold the current effects
ArrayList <Effect> effects;

// Image buffer to hold pixels in
PGraphics canvas;

void setup() {
	// Size of the on-screen display
	size(800, 600);

	// makes the screen feedback accurate
	noSmooth();

	// set the frame refresh rate
	frameRate(30);

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
}

void draw() {
	// update any changes to effects
	updateEffects();

	// add all the images from effects to the canvas buffer
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

	// make sure the arduino gets a new line
	port.write("\n");

	// load the pixel array in the canvas object
	canvas.loadPixels();

	// send each pixel to the arduino
	for(int i=0;i<canvas.pixels.length; i++){
		color p = canvas.pixels[i];
    	float nR = red(p);
    	float nG = green(p);
    	float nB = blue(p);

	    // send space separated values: ledID red green blue \n
	    port.write(i + " " + round(nR) + " " + round(nG) + " " + round(nB) + "\n");
	}

	// get any response from the arduino for debugging
	int inByte = port.read();
	if(inByte != -1){
		println("rcvd: " + inByte);
	}
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

}
