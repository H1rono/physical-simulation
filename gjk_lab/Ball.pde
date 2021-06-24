class Ball extends WorldElement {
    private PVector center, velocity, accelaration, impulse;
    private float radius, mass;

    public Ball(PVector center, PVector velocity, float radius, float mass) {
        this.center = center;
        this.velocity = velocity;
        this.radius = radius;
        this.mass = mass;
        this.accelaration = new PVector(0, 0);
        this.impulse = new PVector(0, 0);
    }

    public Ball(PVector center, float radius, float mass) {
        this(center, new PVector(0, 0), radius, mass);
    }

    public float get_radius() { return radius; }
    public void set_radius(float r) { radius = r; }

    public PVector get_center() { return center; }
    public void set_center(PVector c) { center.set(c); }
    public PVector set_center(float x, float y) { return center.set(x, y); }

    public PVector get_velocity() { return velocity; }
    public PVector get_accelaration() { return accelaration; }

    public float get_mass() { return mass; }

    public PVector get_force() { return PVector.mult(accelaration, mass); }
    public void reset_force(PVector force) {
        accelaration.set(force).div(mass);
    }
    public void add_force(PVector force) {
        accelaration.add(PVector.div(force, mass));
    }

    public void reset_impulse(PVector impulse) {
        this.impulse.set(impulse);
    }
    public void add_impulse(PVector impulse) {
        this.impulse.add(impulse);
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
        velocity.add(PVector.div(impulse, mass));
        center.add(PVector.mult(velocity, delta_time));
        velocity.add(PVector.mult(accelaration, delta_time));
        impulse.set(0, 0);
    }

    @Override
    public void draw() {
        circle(center.x, center.y, radius * 2);
    }
}