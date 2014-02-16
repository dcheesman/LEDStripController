class Flock extends Effect{

    int boidCount = 80;
    Boid[] boids;

    float infludenceZone = 5;
    color baseColor;

    Flock(int _millis, color _c){
        super(_millis);

        baseColor = _c;

        boids = new Boid[boidCount];
        for(int i=0; i<boids.length; i++) {
            boids[i] = new Boid();
        }

        imageBuffer.beginDraw();
        imageBuffer.stroke(baseColor);
        imageBuffer.fill(0,20);
        imageBuffer.endDraw();
    }

    void update(){
        steer();
        attract();
        deflect();
        for(Boid boid : boids){
            boid.update();
        }
        display();
    }

    void display(){
        // println(boids[0].location.x + ", " + boids[0].location.y);
        imageBuffer.beginDraw();

        // this makes the last frame semi-transparent
        imageBuffer.rect(-1,-1,cols+2,rows+2);
        imageBuffer.background(0,0);

        for(Boid boid : boids){
            boid.display();
        }
        imageBuffer.endDraw();
    }

    void steer(){
        for(int i=0; i<boids.length-1; i++){
            for(int t=i+1; t<boids.length; t++){
                float d = PVector.dist(boids[i].location, boids[t].location);
                if(d < infludenceZone && d>0){
                    // get the difference between directions
                    PVector delta = PVector.add(boids[i].velocity, boids[t].velocity);
                    delta.mult(.5);
                    delta.normalize();

                    // divide by the distance (stronger when close)
                    delta.div(d);

                    boids[i].velocity.add(delta);
                    boids[t].velocity.add(delta);
                }
            }
        }
    }

    void attract(){
        for(int i=0; i<boids.length-1; i++){
            for(int t=i+1; t<boids.length; t++){
                float d = PVector.dist(boids[i].location, boids[t].location);
                if(d < infludenceZone && d>deflectZone){
                    // get the difference between directions
                    PVector delta = PVector.sub(boids[i].location, boids[t].location);
                    delta.normalize();

                    // divide by the distance (stronger when close)
                    delta.div(d);

                    boids[i].velocity.sub(delta);
                    boids[t].velocity.add(delta);
                }
            }
        }
    }

    float deflectZone = 2;
    void deflect(){
        for(int i=0; i<boids.length-1; i++){
            for(int t=i+1; t<boids.length; t++){
                float d = PVector.dist(boids[i].location, boids[t].location);
                if(d < deflectZone && d>0){
                    // get the difference between directions
                    PVector delta = PVector.sub(boids[i].location, boids[t].location);
                    delta.normalize();

                    // divide by the distance (stronger when close)
                    delta.div(d/2);

                    boids[i].velocity.add(delta);
                    boids[t].velocity.sub(delta);
                }
            }
        }
    }

    class Boid{
        PVector location;
        PVector velocity;

        float maxForce = .5;
        Boid(){
            location = new PVector(random(cols), random(rows));
            // velocity = new PVector(random(-maxForce,maxForce), random(-maxForce,maxForce));
            velocity = new PVector(0,0);
        }

        void update(){
            velocity.limit(maxForce);
            location.add(velocity);

            if(location.x > cols){
                location.x = 0;
            }

            if(location.x < 0){
                location.x = cols;
            }

            if(location.y > rows){
                location.y = 0;
            }

            if(location.y < 0){
                location.y = rows;
            }

            // dampen
            velocity.mult(.98);
        }

        void display(){
            imageBuffer.point(location.x, location.y);
        }
    }
}