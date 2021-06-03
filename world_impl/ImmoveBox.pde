public class ImmoveBox implements PhysicalObj {
    private PVector position;
    private float w_len, h_len;

    public ImmoveBox(PVector _position, float _w_len, float _h_len) {
        position = new PVector(0, 0);
        position.set(_position);
        w_len = _w_len;
        h_len = _h_len;
    }

    @Override
    public PVector get_force() {
        return new PVector(0, 0);
    }

    @Override
    public void set_force(PVector force) {
        // do nothing
    }

    @Override
    public void add_force(PVector force) {
        // do nothing
    }

    @Override
    public PVector get_velocity() {
        return new PVector(0, 0);
    }

    @Override
    public PVector get_center() {
        // 他のオブジェクトとの位置関係はclosest_vectorで調べられるからテキトー
        return position.copy().add(w_len / 2, h_len / 2);
    }

    @Override
    public float get_mass() {
        return 0;
    }

    @Override
    public PVector closest_vector(float x, float y) {
        return new PVector(
            x < position.x ? x - position.x
            : x <= position.x + w_len ? 0
            : x - (position.x + w_len),
            y < position.y ? y - position.y
            : y <= position.y + h_len ? 0
            : y - (position.y + h_len)
        );
    }
    @Override
    public PVector closest_vector(PVector point) {
        return closest_vector(point.x, point.y);
    }

    @Override
    public boolean is_collide(PhysicalObj other) {
        PVector cv = other.closest_vector(get_center());
        return (
            abs(cv.x) <= w_len / 2
            && abs(cv.y) <= h_len / 2
        );
    }

    @Override
    public Effect effect_on(PhysicalObj other) {
        PVector dir_e = closest_vector(other.get_center()).normalize();

        PVector impulse_ = new PVector(0, 0);
        {
            float this_m = this.get_mass(), other_m = other.get_mass();
            float this_v = dir_e.dot(this.get_velocity());
            float other_v = dir_e.dot(other.get_velocity());
            if (other_v - this_v < 0) {
                // 衝突した
                float im = (
                    (1 + 1/* 反発係数 */)
                    * (this_v - other_v)
                    * this_m * other_m
                    / (this_m + other_m)
                );
                impulse_.add(dir_e).mult(im);
            }
        }

        PVector force_ = new PVector(0, 0);
        {
            float this_f = dir_e.dot(this.get_force());
            float ball_f = dir_e.dot(other.get_force());
            force_.add(dir_e).mult(min(this_f - ball_f, 0));
            // TODO: 摩擦
        }

        return new Effect(force_, impulse_);
    }

    @Override
    public void add_effect(Effect effect) {
        // do nothing
    }

    @Override
    public void update(float delta_time) {
        // do nothing
    }

    @Override
    public void draw() {
        rect(position.x, position.y, w_len, h_len);
    }
}
