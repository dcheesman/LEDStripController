// set the size and configuration of your LEDs
int cols = 10;
int rows = 6;
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

	// initialize effect array
	effects = new ArrayList();

	// canvas for the leds to run on
	canvas = createGraphics(cols, rows);
}

void draw() {
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

void keyPressed(){
    println(keyCode);
    if(key == 't') {
    	color c = color(245, 255, 120);
        Twinkle twinkle = new Twinkle(3000, c);
        effects.add(twinkle);
    }
}
