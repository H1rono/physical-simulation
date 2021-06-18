class Circle extends WorldElement {
    private PVector center, velocity, accelaration, impulse;
    private float radius, mass;

    public Circle(PVector c, float rad, float mas) {
        center = new PVector(0, 0);
        center.set(c);
        radius = rad;
        mass = mas;
    }

    public float get_radius() { return radius; }
    public void set_radius(float r) { radius = r; }

    public PVector get_center() { return center; }
    public void set_center(PVector c) { center.set(c); }
    public PVector set_center(float x, float y) { return center.set(x, y); }

    public PVector get_center() { return center; }
    public PVector get_velocity() { return velocity; }
    public PVector get_accelaration() { return accelaration; }

    public float get_mass() { return mass; }

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
    public void draw() {
        circle(center.x, center.y, radius * 2);
    }
}