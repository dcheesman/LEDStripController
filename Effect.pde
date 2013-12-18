class Effect{
	int milliseconds;
	int startTime;

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