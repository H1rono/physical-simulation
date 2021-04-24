/*
自由落下のシミュレーション
TODO:
- ボールを表現するクラス
- 位置ベクトル、速度ベクトル、加速度ベクトル、質量を保持
- Δtに応じて位置、速度を変化させる関数
*/

final PVector gravity = new PVector(0, 9.8);
//まだ使っていない
final float air_resistance = 0;

Ball ball;

void setup() {
    size(720, 720);
    ball = new Ball(
        new PVector(50, -10), new PVector(200, 200), 10, 20
    );
    ball.set_force(gravity.copy().mult(ball.mass));
    frameRate(60);
    smooth();
    strokeWeight(1);
    stroke(0);
}

void draw() {
    background(255);
    ball.update(0.1);
    display();
}

void display() {
    ball.display();
}
