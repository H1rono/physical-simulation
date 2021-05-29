/* ボールを表現するクラス */

class Ball {
    private PVector position, velocity, accelaration, impulse;
    private float mass, radius;

    public Ball(PVector _position, PVector _velocity, float _mass, float _radius) {
        position = new PVector();
        velocity = new PVector();
        accelaration = new PVector(0, 0);
        impulse = new PVector(0, 0);
        mass = _mass;
        radius = _radius;
        position.set(_position);
        velocity.set(_velocity);
    }

    public PVector get_force() {
        return accelaration.copy().mult(mass);
    }

    public void set_force(PVector force) {
        accelaration.set(force).div(mass);
    }

    public void add_force(PVector force) {
        accelaration.add(force.copy().div(mass));
    }

    public PVector get_momentum() {
        return velocity.copy().mult(mass);
    }

    public PVector get_center() {
        return position.copy();
    }

    public float get_mass() {
        return mass;
    }

    public PVector closest_vector(PVector point) {
        PVector sub = PVector.sub(point, position);
        float mag = sub.mag();
        return mag <= radius ? new PVector(0, 0) : sub.mult((mag - radius) / mag);
    }

    public boolean contains(float x, float y) {
        return pow(position.x - x, 2) + pow(position.y - y, 2) <= pow(radius, 2);
    }
    public boolean contains(PVector point) {
        return position.dist(point) <= radius;
    }

    public boolean is_collide(Ball other) {
        return other.closest_vector(position).mag() <= radius;
    }
    public boolean is_collide(Box other) {
        return other.closest_vector(position).mag() <= radius;
    }
    public boolean is_collide(Floor other) {
        return other.closest_vector(position).mag() <= radius;
    }

    Effect effect_on(Ball other) {
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

    Effect effect_on(Box other) {
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

    Effect effect_on(Floor other) {
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
        circle(position.x, position.y, radius * 2);
    }
}
