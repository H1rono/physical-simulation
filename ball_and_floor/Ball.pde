/*
ボールを表現するクラス
- 位置ベクトル、速度ベクトル、加速度ベクトル、質量、半径を保持
- Δtに応じて位置、速度を変化させる関数
*/

class Ball {
    public PVector position, velocity, accelaration;
    private PVector impulse;
    public float mass, radius;

    public Ball(PVector _position, PVector _velocity, float _mass, float _radius) {
        position = _position;
        velocity = _velocity;
        accelaration = new PVector(0, 0);
        impulse = new PVector(0, 0);
        mass = _mass;
        radius = _radius;
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

    public boolean is_collide(Ball ball) {
        float dist = position.dist(ball.position);
        float rad_dif = abs(radius - ball.radius), rad_sum = radius + ball.radius;
        return rad_dif <= dist && dist <= rad_sum;
    }

    public boolean is_collide(Floor floor) {
        return abs(position.y - floor.height) <= radius;
    }

    Effect effect_on(Ball ball) {
        float ball_dir = ball.position.copy().sub(position).heading();
        PVector dir_e = PVector.fromAngle(ball_dir);

        PVector impulse_ = new PVector(0, 0);
        float this_v = dir_e.dot(this.velocity);
        float ball_v = dir_e.dot(ball.velocity);
        if (ball_v - this_v < 0) {
            // 衝突した
            float im = (
                mass * ball.mass / (mass + ball.mass)
                * (1 + 1/* 反発係数 */)
                * (this_v - ball_v)
            );
            impulse_.add(dir_e).mult(im);
        }

        PVector force_ = new PVector(0, 0);
        float this_f = dir_e.dot(this.get_force());
        float ball_f = dir_e.dot(ball.get_force());
        force_.add(dir_e).mult(min(this_f - ball_f, 0));

        return new Effect(force_, impulse_);
    }

    public Effect effect_on(Floor floor) {
        return new Effect();
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
