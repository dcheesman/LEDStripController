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
            noiseSpeed[i] = random(.005, .015);
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
            float noiseAmount = noise(noiseID[i], frameCount* noiseSpeed[i]) * 100;
            imageBuffer.pixels[i] = color(red(baseColor), green(baseColor), blue(baseColor), noiseAmount);
        }

        // load the pixel array into the buffer
        imageBuffer.updatePixels();
        imageBuffer.endDraw();
	}
}