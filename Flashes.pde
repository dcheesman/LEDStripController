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