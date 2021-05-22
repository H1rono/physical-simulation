public class Floor {
    private float height;

    public Floor(float _height) {
        this.height = _height;
    }

    public PVector get_force() {
        return new PVector(0, 0);
    }

    public void set_force(PVector force) {
        // do nothing
    }

    public void add_force(PVector force) {
        // do nothing
    }

    public PVector get_momentum() {
        return new PVector(0, 0);
    }

    public PVector get_center() {
        return new PVector(0, this.height);
    }

    public float get_mass() {
        return 0;
    }

    public PVector closest_vector(PVector point) {
        // 下向き正より、point.y - this.height > 0の場合はpointが床より下にある
        return new PVector(0, min(0, point.y - this.height));
    }

    public boolean contains(float x, float y) {
        // 下向き正
        return y >= this.height;
    }
    public boolean contains(PVector point) {
        return point.y >= this.height;
    }

    public boolean is_collide(Ball other) {
        PVector other_center = other.get_center();
        if (other_center.y > this.height) {
            return true;
        }
        return other.contains(other_center.x, this.height);
    }
    public boolean is_collide(Box other) {
        PVector other_center = other.get_center();
        if (other_center.y > this.height) {
            return true;
        }
        return other.contains(other_center.x, this.height);
    }
    public boolean is_collide(Floor other) {
        PVector other_center = other.get_center();
        if (other_center.y > this.height) {
            return true;
        }
        return other.contains(other_center.x, this.height);
    }

    public Effect effect_on(Ball other) {
        PVector other_mm = other.get_momentum();
        float ydif = other.get_center().y - this.height;

        PVector impulse_ = new PVector(0, 0);
        if (ydif * other_mm.y < 0) {
            // 衝突している
            impulse_.y = -other_mm.y * (1 + 1/* 反発係数 */);
        }

        PVector other_f = other.get_force(), force_ = new PVector(0, 0);
        if (ydif * other_f.y < 0) {
            force_.y = -other_f.y;
            // friction
            float vsign = other_mm.x == 0 ? 1 : other_mm.x / abs(other_mm.x);
            if (other_mm.x != 0) {
                force_.x = abs(other_f.y) * 0.5/* 動摩擦係数 */ * -vsign;
            } else {
                float fsign = other_f.x == 0 ? 1 : other_f.x / abs(other_f.x);
                force_.x = -fsign * min(abs(force_.x), abs(other_f.y) * 1/* 静止摩擦係数 */);
            }
        }
        return new Effect(force_, impulse_);
    }

    public Effect effect_on(Box other) {
        PVector other_mm = other.get_momentum();
        float mx = other_mm.x, my = other_mm.y;

        PVector impulse_ = new PVector(0, 0);
        float ydif = other.get_center().y - this.height;
        if (ydif * my < 0) {
            // 衝突している
            impulse_.y = -my * (1 + 1/* 反発係数 */);
        }

        PVector other_f = other.get_force(), force_ = new PVector(0, 0);
        if (ydif * other_f.y < 0) {
            force_.y = -other_f.y;
            // friction
            float vsign = mx == 0 ? 1 : mx / abs(mx);
            if (mx != 0) {
                force_.x = abs(other_f.y) * 0.5/* 動摩擦係数 */ * -vsign;
            } else {
                float fsign = other_f.x == 0 ? 1 : other_f.x / abs(other_f.x);
                force_.x = -fsign * min(abs(force_.x), abs(other_f.y) * 1/* 静止摩擦係数 */);
            }
        }
        return new Effect(force_, impulse_);
    }

    public Effect effect_on(Floor other) {
        PVector other_mm = other.get_momentum();
        float mx = other_mm.x, my = other_mm.y;

        PVector impulse_ = new PVector(0, 0);
        float ydif = other.get_center().y - this.height;
        if (ydif * my < 0) {
            // 衝突している
            impulse_.y = -my * (1 + 1/* 反発係数 */);
        }

        PVector other_f = other.get_force(), force_ = new PVector(0, 0);
        if (ydif * other_f.y < 0) {
            force_.y = -other_f.y;
            // friction
            float vsign = mx == 0 ? 1 : mx / abs(mx);
            if (mx != 0) {
                force_.x = abs(other_f.y) * 0.5/* 動摩擦係数 */ * -vsign;
            } else {
                float fsign = other_f.x == 0 ? 1 : other_f.x / abs(other_f.x);
                force_.x = -fsign * min(abs(force_.x), abs(other_f.y) * 1/* 静止摩擦係数 */);
            }
        }
        return new Effect(force_, impulse_);
    }

    public void add_effect(Effect effect) {
        // do nothing
    }

    public void update(float delta_time) {
        // do nothing
    }

    public void draw() {
        line(0, this.height, width, this.height);
    }
}
