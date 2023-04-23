class Character {
  
  PVector location;
  PVector velocity;
  PVector acceleration;
  float topspeed;
  
  float mass = 1;
  float maxforce = 0.15;
  
  float wanderAngle = 0;
  
  color fillcolor;
  
  PImage characterImg;
  
  //VectorUtil util = new VectorUtil();
  NodeCollisionDetector nodeCD = new NodeCollisionDetector();
  
  /*
  Constructor
  */
  Character(color c, PImage cImg) {
    
    location = new PVector(random(width),random(height));
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    topspeed = 2.5;
    fillcolor = c;
    
    characterImg = cImg;
  }
  
  /*
  Display the character
  */
  void display() {
    
    float angle = atan2(velocity.y, velocity.x);
    
    imageMode(CENTER);
    pushMatrix();
    translate(location.x, location.y);
    rotate(angle + PI/2);
    stroke(0);
    fill(fillcolor);
    image(characterImg, 0, 0, 30, 30);
    popMatrix();
    
  }
  
  /*
  Bounded by edges (change if you want it to be caged veruss back and forth)
  */
  void checkEdges() {
    
    if (location.x > width) {
      location.x = 0;
    } else if (location.x < 0) {
      location.x = width;
    }
    
    if (location.y > height) {
      location.y = 0;
    } else if (location.y < 0) {
      location.y = height;
    }
    
  }

  /*
  Apply Steering Force
  */
  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }
  
  /*
  Update character
  */
  void update() {
    velocity.add(acceleration);
    velocity.limit(topspeed);
    location.add(velocity);
    acceleration.mult(0);
    
  }
  
  /* 
  Seek steering behaviour
  */
  PVector seek(PVector target) {
    
    PVector desired = PVector.sub(target,location);
    desired.normalize();
    desired.mult(topspeed);
    
    PVector steer = PVector.sub(desired,velocity);
    
    steer.limit(maxforce);
    return steer;
    
  }
  
  /*
  Arrive steering behaviour
  */
  PVector arrive(PVector target, float r) {
    PVector desired = PVector.sub(target,location);
    float distance = desired.mag();
    desired.normalize();
    
    if (distance < r) {
      // map the speed by the distance from the target
      float speed = (distance/r) * topspeed;
      desired.mult(speed);
    } else {
      desired.mult(topspeed);
    }
    
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    return steer;
    
  }
 
  /*
  Wander steering behaviour
  */
  PVector wander() {
  
    float wanderRadius = 100;         // Radius for our "wander circle"
    float wanderDist = 200;         // Distance for our "wander circle"
    float change = 1.5;
    
    PVector prediction = velocity.copy();
    prediction.normalize();
    prediction.mult(wanderDist);
    prediction.add(location);
    
    wanderAngle += random(-change, change);
    
    float currentDirection = atan2(velocity.y, velocity.x);
    float newDirection = currentDirection + wanderAngle;
    
    float x = wanderRadius * cos(newDirection);
    float y = wanderRadius * sin(newDirection);
    
    PVector targetOffset = new PVector(x, y);
    PVector target = PVector.add(prediction, targetOffset);
    
    return seek(target);
  }
  
  /* 
  Avoid node collision
  */
  PVector avoidCollisionNodes(ArrayList<Node> obstacles, float lookahead, float collisionThreshold) {
    PVector prediction = PVector.mult(velocity, lookahead);
    prediction.add(location);
    
    float whiskerMagnitude = 25;
    float whiskerTheta1 = atan2(velocity.y, velocity.x) - PI/6;
    float whiskerTheta2 = atan2(velocity.y, velocity.x) + PI/6;
    
    // Whisker 1
    PVector whisker1 = new PVector(whiskerMagnitude * cos(whiskerTheta1), 
                                    whiskerMagnitude * sin(whiskerTheta1));
    whisker1.add(location);                                 
    
    // Whisker 2
    PVector whisker2 = new PVector(whiskerMagnitude * cos(whiskerTheta2), 
                                    whiskerMagnitude * sin(whiskerTheta2));
    whisker2.add(location);
    
    // you can uncomment this for debugging
    //line(location.x, location.y, prediction.x, prediction.y);
    //line(location.x, location.y, whisker1.x, whisker1.y);
    //line(location.x, location.y, whisker2.x, whisker2.y);
    // end
    
    PVector c = nodeCD.getNormalToAvoid(obstacles, location, prediction, collisionThreshold);
    PVector w1 = nodeCD.getNormalToAvoid(obstacles, location, whisker1, collisionThreshold);
    PVector w2 = nodeCD.getNormalToAvoid(obstacles, location, whisker2, collisionThreshold);

    PVector steer = new PVector(0,0);
    int count = 0;
    
    if (nodeCD.isCollision(c)) {
      count++;
      steer.add(seek(c));
      
      // you can uncomment these for debugging
      //strokeWeight(4);
      //line(location.x, location.y, prediction.x, prediction.y);
      //stroke(1);
      // end
      
    } else if (nodeCD.isCollision(w1)) {
      count++;
      steer.add(seek(w1));
    
      // you can uncomment these for debugging
      //strokeWeight(4);
      //line(location.x, location.y, whisker1.x, whisker1.y);
      //stroke(1);
      // end
      
    } else if (nodeCD.isCollision(w2)) {
      count++;
      steer.add(seek(w2));
    
      // you can uncomment these for debugging
      //strokeWeight(4);
      //line(location.x, location.y, whisker2.x, whisker2.y);
      //stroke(1);
      // end
    }
    if (count != 0) {
      steer.div(count);
    }
    return steer;
  }
}
