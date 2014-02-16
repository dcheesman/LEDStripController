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
        }
        return false;
	}

	PGraphics getBuffer(){
		return imageBuffer;
	}
}