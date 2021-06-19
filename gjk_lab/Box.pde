class Box extends WorldElement {
    private PVector center, velocity, accelaration, impulse;
    private float w_len, h_len, rotation, mass;

    /*
    rotation == 0:
        ^ y-axis
        |     w_len
        |  v1--------v2
        |  |          |
        |  |  center  | h_len
        |  |          |
        |  v4--------v3
        |
        +------------------> x-axis
    ======================================
    Scalar c = cos(rotation), s = sin(rotation), w = w_len / 2, h = h_len / 2
    Vector(2) d1 = (-w, h), d2 = (w, h), d3 = (w, -h), d4 = (-w, -h)
    Matrix(2,2) R = [[c, -s], [s, c]]
    v1 - center = d1 * R = (-w * c + h * (-s), -w * s + h * c)
    v2 - center = d2 * R = ( w * c + h * (-s),  w * s + h * c)
    v3 - center = d3 * R = ( w * c - h * (-s),  w * s - h * c)
    v4 - center = d4 * R = (-w * c - h * (-s), -w * s - h * c)
    */

    public Box(PVector cen, float w, float h, float m) {
        center = new PVector(0, 0);
        velocity = new PVector(0, 0);
        accelaration = new PVector(0, 0);
        center.set(cen);
        w_len = abs(w);
        h_len = abs(h);
        rotation = 0;
        mass = m;
    }

    public PVector get_center() { return center; }
    public void set_center(PVector cen) { center.set(cen); }

    public float get_width() { return w_len; }
    public void set_width(float w) { w_len = abs(w); }

    public float get_height() { return h_len; }
    public void set_height(float h) { h_len = abs(h); }

    public float get_rotation() { return rotation; }
    public void set_rotation(float r) { rotation = r; }
    public void rotate_by(float r) { rotation += r; }

    @Override
    public PVector get_velocity() { return velocity; }

    @Override
    public PVector get_accelaration() { return accelaration; }

    @Override
    public float get_mass() { return mass; }

    @Override
    public void reset_force(PVector force) {
        accelaration.set(force).div(mass);
    }

    @Override
    public void add_force(PVector force) {
        accelaration.add(PVector.div(force, mass));
    }

    @Override
    public void reset_impulse(PVector impulse) {
        this.impulse.set(impulse);
    }

    @Override
    public void add_impulse(PVector impulse) {
        this.impulse.add(impulse);
    }

    @Override
    public float min_x() {
        float w = w_len / 2, h = h_len / 2, c = cos(rotation), s = sin(rotation);
        return center.x + min(
            min(-w * c - h * s,  w * c - h * s), // v1, v2
            min( w * c + h * s, -w * c + h * s)  // v3, v4
        );
    }
    @Override
    public float max_x() {
        float w = w_len / 2, h = h_len / 2, c = cos(rotation), s = sin(rotation);
        return center.x + max(
            max(-w * c - h * s,  w * c - h * s), // v1, v2
            max( w * c + h * s, -w * c + h * s)  // v3, v4
        );
    }

    @Override
    public float min_y() {
        float w = w_len / 2, h = h_len / 2, c = cos(rotation), s = sin(rotation);
        return center.y + min(
            min(-w * s + h * c,  w * s + h * c), // v1, v2
            min( w * s - h * c, -w * s - h * c)  // v3, v4
        );
    }
    @Override
    public float max_y() {
        float w = w_len / 2, h = h_len / 2, c = cos(rotation), s = sin(rotation);
        return center.y + max(
            max(-w * s + h * c,  w * s + h * c), // v1, v2
            max( w * s - h * c, -w * s - h * c)  // v3, v4
        );
    }

    @Override
    public boolean is_movable() { return true; }

    @Override
    public PVector support(PVector point) {
        float w = w_len / 2, h = h_len / 2, c = cos(rotation), s = sin(rotation);
        PVector v1 = new PVector(-w * c - h * s, -w * s + h * c).add(center),
                v2 = new PVector( w * c - h * s,  w * s + h * c).add(center),
                v3 = new PVector( w * c + h * s,  w * s - h * c).add(center),
                v4 = new PVector(-w * c + h * s, -w * s - h * c).add(center),
                res = v1;
        if (res.dot(point) < v2.dot(point)) { res = v2; }
        if (res.dot(point) < v3.dot(point)) { res = v3; }
        if (res.dot(point) < v4.dot(point)) { res = v4; }
        return res;
    }

    @Override
    public void update(float delta_time) {
        center.add(PVector.mult(velocity, delta_time));
        velocity.add(PVector.mult(accelaration, delta_time));
    }

    @Override
    public void draw() {
        push();
        translate(center.x, center.y);
        rotate(rotation);
        rectMode(CENTER);
        rect(0, 0, w_len, h_len);
        pop();
    }
}