「床」のクラス

草案:

```processing
final PVector gravity;
final float delta_time;

Floor floor;
Ball ball;

// ballとfloor間で力を交換する
void exchange_force(Ball ball, Floor floor) {
    PVector ball_force = ball.get_force();
    /*  運動量momentumから得られる力をforceとする
        momentum = force * delta_timeより、force = momentum / delta_time */
    // get_momentumでballの運動量を取得。未実装
    ball_force.add(ball.get_momentum().div(delta_time));
    // 垂直抗力の大きさはball_forceの鉛直成分
    ball.add_force(new PVector(0, -ball_force.y));
}

void exchange_force(Floor floor, Ball ball) {
    exchange_force(ball, floor);
}

void setup() {
    size(720, 720);
    gravity = new PVector(0, 9.8);
    delta_time = 0.1;
    floor = new Floor(700 /* height */);
    // y=700のところに床の線が引かれる
    ball = new Ball(
        new PVector(100, 680), // position | 680 = 700 - 20
        new PVector(0, 0), // velocity
        10, // mass
        20 // radius
    );
}

void draw() {
    background(255);
    ball.set_force(gravity.copy().mult(ball.mass));
    if (ball.is_collide(floor)) { // floor.is_collide(ball) でも同じ結果が得られるようにしたい
        exchange_force(ball, floor);
    }
    ball.update(delta_time);
    floor.update(delta_time); // 何もしない
    // 描画
    ball.draw();
    floor.draw();
}
```