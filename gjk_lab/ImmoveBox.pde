class ImmoveBox extends WorldElement {
    private PVector center;
    private float w_len, h_len, rotation;

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

    public ImmoveBox(PVector _center, float _w_len, float _h_len, float _rotation) {
        center = new PVector(0, 0);
        center.set(_center);
        w_len = abs(_w_len);
        h_len = abs(_h_len);
        rotation = 0;
    }

    public ImmoveBox(PVector _center, float _w_len, float _h_len) {
        this(_center, _w_len, _h_len, 0);
    }

    @Override
    public PVector get_center() { return center; }
    @Override
    public void set_center(PVector _center) { center.set(_center); }
    @Override
    public void add_center(PVector _center) { }

    public float get_width() { return w_len; }
    public float get_height() { return h_len; }
    public float get_rotation() { return rotation; }

    @Override
    public PVector get_velocity() { return new PVector(0, 0); }
    @Override
    public void set_velocity(PVector _velocity) { }
    @Override
    public void add_velocity(PVector _velocity) { }
    
    @Override
    public float get_mass() { return Float.POSITIVE_INFINITY; }

    @Override
    public void set_force(PVector _force) {
        // do nothing
    }
    @Override
    public void add_force(PVector _force) {
        // do nothing
    }

    @Override
    public void reset_impulse() {
        // do nothing
    }
    @Override
    public void add_impulse(PVector _impulse) {
        // do nothing
    }
    @Override
    public void apply_impulse() {
        // do nothing
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
    public boolean is_movable() { return false; }

    @Override
    public PVector support(PVector point) {
        float w = w_len / 2, h = h_len / 2;
        PVector v1 = new PVector(-w,-h).rotate(rotation).add(center),
                v2 = new PVector(w,-h).rotate(rotation).add(center),
                v3 = new PVector(w,h).rotate(rotation).add(center),
                v4 = new PVector(-w,h).rotate(rotation).add(center);
        float d1 = v1.dot(point), d2 = v2.dot(point), d3 = v3.dot(point), d4 = v4.dot(point);
        float max_dot = max(max(d1, d2), max(d3, d4));
        boolean m1 = max_dot == d1, m2 = max_dot == d2, m3 = max_dot == d3, m4 = max_dot == d4;
        if (m1) {
            return (
                m2 ? v1.add(v2).div(2)
                : m3 ? v1.add(v3).div(2)
                : m4 ? v1.add(v4).div(2)
                : v1
            );
        } else if (m2) {
            return (
                m3 ? v2.add(v3).div(2)
                : m4 ? v2.add(v4).div(2)
                : v2
            );
        } else if (m3) {
            return m4 ? v3.add(v4).div(2) : v3;
        } else {
            return v4;
        }
    }

    @Override
    public void update(float delta_time) {
        // do nothing
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
