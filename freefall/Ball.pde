class Ball {
    public PVector accelaration, velocity, position;
    public float mass, radius;

    public Ball(PVector _accelaration, PVector _velocity, PVector _position, float _mass, float _radius) {
        accelaration = _accelaration;
        velocity = _velocity;
        position = _position;
        mass = _mass;
        radius = _radius;
    }

    public Ball(PVector _velocity, PVector _position, float _mass, float _radius) {
        this(new PVector(0, 0), _velocity, _position, _mass, _radius);
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

    public void display() {
        ellipse(position.x, position.y, radius * 2, radius * 2);
    }
}
