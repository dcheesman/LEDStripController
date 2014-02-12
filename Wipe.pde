class Wipe extends Effect {
    color baseColor;
    int xpos;
    float weight = 1;

    Wipe(int _millis, color _c) {
        super(_millis);
        xpos = 0;
        baseColor = _c;
        imageBuffer.beginDraw();
        imageBuffer.noFill();
        imageBuffer.stroke(baseColor);
        imageBuffer.strokeWeight(weight);
        imageBuffer.endDraw();
    }

    void update() {
        imageBuffer.beginDraw();
        imageBuffer.background(0, 1);
        imageBuffer.line(xpos, 0, xpos, rows);
        imageBuffer.endDraw();
        xpos++;
    }
}
