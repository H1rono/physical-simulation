class Ball extends WorldElement {
    private PVector center, velocity, force, impulse;
    private float radius, mass;

    public Ball(PVector _center,PVector _velocity, float _radius, float _mass) {
        center = new PVector(0, 0);
        center.set(_center);
        radius = _radius;
        mass = _mass;
        velocity = _velocity;
        force = new PVector(0, 0);
        impulse = new PVector(0, 0);
    }

    public float get_radius() { return radius; }
    public void set_radius(float _radius) { radius = _radius; }

    @Override
    public PVector get_center() { return center; }
    @Override
    public void set_center(PVector _center) { center.set(_center); }
    @Override
    public void add_center(PVector _center) { center.add(_center); }

    @Override
    public PVector get_velocity() { return velocity; }
    @Override
    public void set_velocity(PVector _velocity) { velocity.set(_velocity); }
    @Override
    public void add_velocity(PVector _velocity) { velocity.add(_velocity); }

    @Override
    public float get_mass() { return mass; }
    
    @Override
    public void set_force(PVector _force) {
        force.set(_force);
    }
    @Override
    public void add_force(PVector _force) {
        force.add(_force);
    }

    @Override
    public void reset_impulse() {
        impulse.set(0, 0);
    }
    @Override
    public void add_impulse(PVector _impulse) {
        impulse.add(_impulse);
    }
    @Override
    public void apply_impulse() {
        velocity.add(PVector.div(impulse, mass));
    }

    @Override
    public float min_x() { return center.x - radius; }
    @Override
    public float max_x() { return center.x + radius; }
    @Override
    public float min_y() { return center.y - radius; }
    @Override
    public float max_y() { return center.y + radius; }

    @Override
    public PVector support(PVector point) {
        float m = point.mag();
        PVector d = PVector.mult(point, radius / m);
        return PVector.add(center, d);
    }

    @Override
    public boolean is_movable() { return true; }

    @Override
    public void update(float delta_time) {
        center.add(PVector.mult(velocity, delta_time))
        .add(PVector.mult(force, delta_time * delta_time / mass / 2));
        velocity.add(PVector.mult(force, delta_time / mass));
    }

    @Override
    public void draw() {
        circle(center.x, center.y, radius * 2);
    }
}
