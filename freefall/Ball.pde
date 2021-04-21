class Ball {
    PVector velocity, position;
    float mass, radius;
    //massはまだ使っていない
    PVector memo_vector;
    Ball(PVector _velocity, PVector _position, float _mass, float _radius) {
        velocity = _velocity;
        position = _position;
        mass = _mass;
        radius = _radius;
      }
    void add_force(){
        //まだ使っていない
    }
    void update() {
        velocity.add(gravity.copy().div(frameRate));
        position.add(velocity.copy().div(frameRate));
        //まだ力を導入していない
    }
    void display() {
        ellipse(position.x, position.y, radius * 2, radius * 2);
    }
}
