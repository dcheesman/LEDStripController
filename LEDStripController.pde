// bring in library to talk with USB
import processing.serial.*;
Serial port;

// set the size and configuration of your LEDs (never less that 1 on either)
int cols = 10;
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
        Supernova supernova = new Supernova(3000);
        effects.add(supernova);
    }

}


void mousePressed(){
	color c = colorPicker.getColor();
	if(c != -1){
		selectedColor = c;	
	}
	println(selectedColor);
}
