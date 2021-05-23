class Ball implements PhysicalObj {
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

    @Override // アノテーション https://qiita.com/tkj06/items/a9fe1881dc965893a5f4
    public PVector get_force() {
        return accelaration.copy().mult(mass);
    }

    @Override
    public void set_force(PVector force) {
        accelaration.set(force).div(mass);
    }

    @Override
    public void add_force(PVector force) {
        accelaration.add(force.copy().div(mass));
    }

    @Override
    public PVector get_velocity() {
        return velocity.copy();
    }

    @Override
    public PVector get_center() {
        return position.copy();
    }

    @Override
    public float get_mass() {
        return mass;
    }

    @Override
    public PVector closest_vector(float x, float y) {
        return closest_vector(new PVector(x, y));
    }
    @Override
    public PVector closest_vector(PVector point) {
        PVector sub = PVector.sub(point, position);
        float mag = sub.mag();
        return mag <= radius ? new PVector(0, 0) : sub.mult((mag - radius) / mag);
    }

    @Override
    public boolean is_collide(PhysicalObj other) {
        return other.closest_vector(position).mag() <= radius;
    }

    @Override
    Effect effect_on(PhysicalObj other) {
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
        }

        return new Effect(force_, impulse_);
    }

    @Override
    public void add_effect(Effect effect) {
        add_force(effect.force);
        impulse.add(effect.impulse);
    }

    @Override
    public void update(float delta_time) {
        velocity
            .add(impulse.div(mass))
            .add(accelaration.copy().mult(delta_time));
        position.add(velocity.copy().mult(delta_time));
        impulse.set(0, 0);
    }

    @Override
    public void draw() {
        circle(position.x, position.y, radius * 2);
    }
}
