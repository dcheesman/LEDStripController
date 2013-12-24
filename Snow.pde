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