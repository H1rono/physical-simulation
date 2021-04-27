class Ball {
    public PVector accelaration, velocity, position;
    public float mass, radius;

    public Ball(PVector _position, PVector _velocity, float _mass, float _radius) {
        accelaration = new PVector(0, 0);
        velocity = _velocity;
        position = _position;
        mass = _mass;
        radius = _radius;
    }

    public PVector get_force() {
        return accelaration.copy().mult(mass);
    }

    public void set_force(PVector force) {
        accelaration = force.copy().div(mass);
    }

    public void add_force(PVector force) {
        accelaration.add(force.copy().div(mass));
    }

    public void update(float delta_time) {
        velocity.add(accelaration.copy().mult(delta_time));
        position.add(velocity.copy().mult(delta_time));
        //まだ力を導入していない
    }

    public void draw() {
        ellipse(position.x, position.y, radius * 2, radius * 2);
    }
}
