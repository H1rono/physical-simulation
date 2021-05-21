// 「箱」を表現するクラス
class Box {
    private PVector position, velocity, accelaration, impulse;
    private float mass, w_len, h_len; // w_len: 横幅、h_len: 縦幅

    // 適当なコンストラクタ
    public Box(PVector _position, PVector _velocity, float _mass, float _w_len, float _h_len) {
        position = new PVector();
        velocity = new PVector();
        accelaration = new PVector(0, 0);
        impulse = new PVector(0, 0);
        mass = _mass;
        w_len = _w_len;
        h_len = _h_len;
        position.set(_position);
        velocity.set(_velocity);
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

    public PVector get_momentum() {
        return velocity.copy().mult(mass);
    }

    public PVector get_center() {
        return position.copy().add(w_len / 2, h_len / 2);
    }

    public float get_mass() {
        return mass;
    }

    // pointから四角形に到達するのに最も近いベクトル
    // contains(point) == trueの場合、PVector(0, 0)
    public PVector closest_vector(PVector point) {
        return new PVector(
            point.x < position.x ? point.x - position.x
            : point.x <= position.x + w_len ? 0
            : point.x - (position.x + w_len),
            point.y < position.y ? point.y - position.y
            : point.y <= position.y + h_len ? 0
            : point.y - (position.y + h_len)
        );
    }

    // 座標を含んでいるか判定する関数
    public boolean contains(float x, float y) {
        return (
            position.x <= x && x <= position.x + w_len
            && position.y <= y && y <= position.x + h_len
        );
    }
    public boolean contains(PVector point) {
        return contains(point.x, point.y);
    }

    // 衝突判定の関数
    // いつか共通のinterfaceを作って一般化したい
    public boolean is_collide(Box other) {
        PVector cv = other.closest_vector(get_center());
        return (
            abs(cv.x) <= w_len / 2
            && abs(cv.y) <= h_len / 2
        );
    }
    public boolean is_collide(Ball other) {
        PVector cv = other.closest_vector(get_center());
        return (
            abs(cv.x) <= w_len / 2
            && abs(cv.y) <= h_len / 2
        );
    }
    public boolean is_collide(Floor other) {
        PVector cv = other.closest_vector(get_center());
        return (
            abs(cv.x) <= w_len / 2
            && abs(cv.y) <= h_len / 2
        );
    }

    // 「影響」の関数
    public Effect effect_on(Box other) {
        PVector dir_e = closest_vector(other.get_center()).normalize();

        PVector impulse_ = new PVector(0, 0);
        {
            float this_m = this.get_mass(), other_m = other.get_mass();
            float this_mm = dir_e.dot(this.get_momentum());
            float other_mm = dir_e.dot(other.get_momentum());
            if (other_mm - this_mm < 0) {
                // 衝突した
                float im = (
                    (1 + 1/* 反発係数 */)
                    * (other_m * this_mm - this_m * other_mm)
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
        }

        return new Effect(force_, impulse_);
    }

    public Effect effect_on(Ball other) {
        PVector dir_e = closest_vector(other.get_center()).normalize();

        PVector impulse_ = new PVector(0, 0);
        {
            float this_m = this.get_mass(), other_m = other.get_mass();
            float this_mm = dir_e.dot(this.get_momentum());
            float other_mm = dir_e.dot(other.get_momentum());
            if (other_mm - this_mm < 0) {
                // 衝突した
                float im = (
                    (1 + 1/* 反発係数 */)
                    * (other_m * this_mm - this_m * other_mm)
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
        }

        return new Effect(force_, impulse_);
    }

    public Effect effect_on(Floor other) {
        PVector dir_e = closest_vector(other.get_center()).normalize();

        PVector impulse_ = new PVector(0, 0);
        {
            float this_m = this.get_mass(), other_m = other.get_mass();
            float this_mm = dir_e.dot(this.get_momentum());
            float other_mm = dir_e.dot(other.get_momentum());
            if (other_mm - this_mm < 0) {
                // 衝突した
                float im = (
                    (1 + 1/* 反発係数 */)
                    * (other_m * this_mm - this_m * other_mm)
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
        }

        return new Effect(force_, impulse_);
    }

    public void add_effect(Effect effect) {
        add_force(effect.force);
        impulse.add(effect.impulse);
    }

    public void update(float delta_time) {
        velocity
            .add(impulse.div(mass))
            .add(accelaration.copy().mult(delta_time));
        position.add(velocity.copy().mult(delta_time));
        impulse.set(0, 0);
    }

    public void draw() {
        rect(position.x, position.y, w_len, h_len);
    }
}
