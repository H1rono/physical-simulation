public class Floor implements PhysicalObj {
    private float height;

    public Floor(float _height) {
        this.height = _height;
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
        return new PVector(0, this.height);
    }

    @Override
    public float get_mass() {
        return 0;
    }

    @Override
    public PVector closest_vector(float x, float y) {
        // 下向き正より、point.y - this.height > 0の場合はpointが床より下
        return new PVector(0, min(0, y - this.height));
    }
    @Override
    public PVector closest_vector(PVector point) {
        return closest_vector(0, point.y);
    }

    @Override
    public boolean is_collide(PhysicalObj other) {
        // y = this.heightの直線と交わっているかで判定
        PVector cv = other.closest_vector(0, this.height);
        return cv.y == 0;
    }

    @Override
    public Effect effect_on(PhysicalObj other) {
        PVector other_v = other.get_velocity();
        float ydif = other.get_center().y - this.height;

        PVector impulse_ = new PVector(0, 0);
        if (ydif * other_v.y < 0) {
            // 衝突している
            impulse_.y = -other.get_mass() * other_v.y * (1 + 1/* 反発係数 */);
        }

        PVector other_f = other.get_force(), force_ = new PVector(0, 0);
        if (ydif * other_f.y < 0) {
            force_.y = -other_f.y;
            // 摩擦
            float vsign = other_v.x == 0 ? 1 : other_v.x / abs(other_v.x);
            if (other_v.x != 0) {
                force_.x = abs(other_f.y) * 0.5/* 動摩擦係数 */ * -vsign;
            } else {
                float fsign = other_f.x == 0 ? 1 : other_f.x / abs(other_f.x);
                force_.x = -fsign * min(abs(force_.x), abs(other_f.y) * 1/* 静止摩擦係数 */);
            }
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
        line(0, this.height, width, this.height);
    }
}
