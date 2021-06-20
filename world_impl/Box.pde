class Box implements PhysicalObj {
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

    @Override
    public PVector get_force() {
        return accelaration.copy().mult(mass);
    }

    @Override
    public void set_force(PVector force) {
        accelaration = force.copy().div(mass);
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
        return position.copy().add(w_len / 2, h_len / 2);
    }

    @Override
    public float get_mass() {
        return mass;
    }

    // pointから四角形に到達するのに最も近いベクトル
    @Override
    public PVector contact_vector(float x, float y) {
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
    public PVector contact_vector(PVector point) {
        return contact_vector(point.x, point.y);
    }

    // 衝突判定の関数
    @Override
    public boolean is_collide(PhysicalObj other) {
        PVector cv = other.contact_vector(get_center());
        return (
            abs(cv.x) <= w_len / 2
            && abs(cv.y) <= h_len / 2
        );
    }

    // 「影響」の関数
    @Override
    public Effect effect_on(PhysicalObj other) {
        PVector dir_e = contact_vector(other.get_center()).normalize();

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
                    * this_m * other_m / (this_m + other_m)
                );
                impulse_.add(dir_e).mult(im);
            }
        }

        PVector force_ = new PVector(0, 0);
        {
            float other_f = dir_e.dot(other.get_force());
            force_.add(dir_e).mult(min(-other_f, 0));
            // TODO: 摩擦
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
        rect(position.x, position.y, w_len, h_len);
    }
}
