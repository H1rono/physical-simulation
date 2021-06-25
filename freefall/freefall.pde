/*
自由落下のシミュレーション
*/

final PVector gravity = new PVector(0, 9.8);
//まだ使っていない
final float air_resistance = 0;
final float delta_time = 0.1;

World world;

void setup() {
    size(720, 720);
    world = new World(
        new PVector(0, 9.8), // gravity
        0.1, // air_resistance
        0.1 // delta_time
    );
    // ボールを追加
    // オブジェクトすべてに共通な部分をスーパークラス化するといいかも
    world.add_obj(new Ball(
        new PVector(100, 100), // position
        new PVector(10, -10), // velocity,
        10, // mass
        20 // radius
    ));
    frameRate(60);
    smooth();
    strokeWeight(1);
    stroke(0);
}

void draw() {
    background(255);
    // 重力加速度を再設定
    world.reset_gravity();
    // 力を計算(垂直抗力、ばねの弾性力、摩擦力、空気抵抗、...)
    // ここで物体の衝突を判定する必要がある？
    world.calc_force();
    // 登録した物体を動かす
    world.move();
    // 描画
    world.draw();
}
