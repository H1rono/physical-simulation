/*
自由落下のシミュレーション
 TODO:
 - ボールを表現するクラス
 - 位置ベクトル、速度ベクトル、加速度ベクトル、質量を保持
 - Δtに応じて位置、速度を変化させる関数
 */
 
final PVector gravity = new PVector(0, 1000);
final float air_resistance = 0;
//まだ使っていない
Ball ball;

void setup() {
    size(1200, 800);
    ball = new Ball(
        new PVector(500, -300), new PVector(200, 200), 3, 20
        );
    frameRate(60);
    smooth();
    strokeWeight(1);
    stroke(0);
}

void draw() {
    background(255);
    ball.update();
    display();
}

void display() {
    ball.display();
}
