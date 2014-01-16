class CircleBurst extends Effect{
	
	float circleSpeed = 3;

	color baseColor;	

	float r = 1;
	float weight = 1;
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