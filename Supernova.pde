class Supernova extends Effect{
  float w, h;
  float x, y;
  
  Supernova(int _millis){
    super(_millis);
    
    w = 0;
    h = 0;
    x = cols/2;
    y = rows/2;
    
    imageBuffer.beginDraw();
    imageBuffer.rectMode(CENTER);
    imageBuffer.noFill();
    imageBuffer.endDraw();
    
    imageBuffer.beginDraw();
    imageBuffer.stroke(random(55,100),random(55,100),random(55,100));
    imageBuffer.background(0,0);
    imageBuffer.rect(x,y,w,h);
    imageBuffer.ellipse(x,y,w,h);
    imageBuffer.endDraw();
    
  } 
  
  void update(){
    imageBuffer.beginDraw();
    imageBuffer.stroke(random(5,255),random(155,255),random(5,255));
    imageBuffer.background(0,0);
    imageBuffer.rect(x,y,w,h);
    imageBuffer.ellipse(x,y,w,h);
    imageBuffer.endDraw();
    w++;
    h++;
  }
}
