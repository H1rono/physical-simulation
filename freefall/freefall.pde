/*
自由落下のシミュレーション
*/

final PVector gravity = new PVector(0, 9.8);
//まだ使っていない
final float air_resistance = 0;
final float delta_time = 0.1;

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
    ball.update(delta_time);
    ball.draw();
}
