final PVector gravity = new PVector(0, 9.8);
final float delta_time = 0.1;

Floor floor;
Ball ball;

void setup() {
    size(720, 720);
    floor = new Floor(600 /* height */);
    // y=700のところに床の線が引かれる
    ball = new Ball(
        new PVector(100, 200), // position | 680 = 700 - 20
        new PVector(10, 0), // velocity
        10, // mass
        20 // radius
    );
}

void draw() {
    background(255);
    ball.set_force(gravity.copy().mult(ball.mass));
    Effect e_b2f, e_f2b;
    if (ball.is_collide(floor)) { // floor.is_collide(ball) でも同じ結果が得られるようにしたい
        e_f2b = floor.effect_on(ball);
        println(e_f2b.toString());
    } else {
        e_f2b = new Effect();
    }
    if (floor.is_collide(ball)) {
        e_b2f = floor.effect_on(floor);
    } else {
        e_b2f = new Effect();
    }
    ball.add_effect(e_f2b);
    floor.add_effect(e_b2f);
    ball.update(delta_time);
    floor.update(delta_time); // 何もしない
    // 描画
    ball.draw();
    floor.draw();
}
