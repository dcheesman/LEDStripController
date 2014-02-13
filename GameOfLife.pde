/**
 * An effect class to represent Conway's game of life: http://en.wikipedia.org/wiki/Conway's_Game_of_Life
 * With some randomness added in for aestetic appeal.
 */
class GameOfLife extends Effect {
    color baseColor;
    float weight = 1;
    int[][] grid, newGrid;

    GameOfLife(int _millis, color _c) {
        super(_millis);
        baseColor = _c;
        grid = new int[cols][rows];
        newGrid = new int[cols][rows];
        
        //Populate a "random" seed
        for (int x = 0; x < cols; x++) {
            for (int y = 0; y < rows; y++) {
                grid[x][y] = (int) random(1024) % 2;
            }
        }
      
        imageBuffer.beginDraw();
        imageBuffer.noFill();
        imageBuffer.stroke(baseColor);
        imageBuffer.strokeWeight(weight);
        imageBuffer.endDraw();
    }

    void update() {
        processTurn();
        imageBuffer.beginDraw();
        imageBuffer.background(0, 1);
        for (int x = 0; x < cols; x++) {
            for (int y = 0; y < rows; y++) {
                if (newGrid[x][y] == 1) {
                    imageBuffer.point(x, y);
                }
            }
        }
        
        //shift the color randomly
        float red = ((baseColor >> 16 & 0xFF) * random(16)) % 255;
        float green = ((baseColor >> 8 & 0xFF) * random(16)) % 255;
        float blue = ((baseColor & 0XFF) * random(16)) % 255;
        float alpha = random(128, 255);
        imageBuffer.stroke(color(red, green, blue, alpha));
        imageBuffer.endDraw();
        
        grid = newGrid;
    }
    
    void processTurn() {
        for (int x = 0; x < cols; x++) {
            for (int y = 0; y < rows; y++) {
                //Calculate number of neighbors
                int count = 0;
                if (x > 0 && y > 0) {
                  count += grid[x - 1][y - 1]; //Nortwest
                }
                
                if (x > 0) {
                   count += grid[x - 1][y]; //West
                }
                
                if (x > 0 && y < rows - 1) {
                  count += grid[x - 1][y + 1]; //Southwest
                }
                
                if (y > 0) {
                  count += grid[x][y - 1]; //North
                }
                
                if (x < cols - 1 && y < rows - 1) {
                  count += grid[x + 1][y + 1]; //Southeast
                }
                
                if (x < cols - 1 && y > 0) {
                  count += grid[x + 1][y - 1]; //Northeast
                }
                
                if (x < cols - 1) {
                  count += grid[x + 1][y]; //East
                }
                
                if (y < rows - 1) {
                  count += grid[x][y + 1]; //South
                }
                
                if (grid[x][y] == 1 && count < 2) {
                    newGrid[x][y] = 0; //Isolation Death
                } else if (grid[x][y] == 1 && count > 3) {
                    newGrid[x][y] = 0; //Overpopulation Death
                } else if (grid[x][y] == 0 && count == 3) {
                    newGrid[x][y] = 1; //Birth
                } else {
                    newGrid[x][y] = grid[x][y]; //Continue
                }
            }
        }
    }
}
