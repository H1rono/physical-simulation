/*
ボールを表現するクラス
- 位置ベクトル、速度ベクトル、加速度ベクトル、質量、半径を保持
- Δtに応じて位置、速度を変化させる関数
*/

class Ball {
    public PVector accelaration, velocity, position;
    public float mass, radius;

    public Ball(PVector _position, PVector _velocity, float _mass, float _radius) {
        accelaration = new PVector(0, 0);
        position = _position;
        velocity = _velocity;
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

    public void update(float delta_time) {
        velocity.add(accelaration.copy().mult(delta_time));
        position.add(velocity.copy().mult(delta_time));
    }

    public void draw() {
        circle(position.x, position.y, radius * 2);
    }
}
