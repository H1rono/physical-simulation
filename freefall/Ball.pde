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
        velocity = _velocity;
        position = _position;
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

    public void update(float delta_time) {
        velocity.add(accelaration.copy().mult(delta_time));
        position.add(velocity.copy().mult(delta_time));
        //まだ力を導入していない
    }

    public void draw() {
        circle(position.x, position.y, radius * 2);
    }
}
