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