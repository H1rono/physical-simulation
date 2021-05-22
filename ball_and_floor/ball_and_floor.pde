final PVector gravity = new PVector(0, 9.8);
final float delta_time = 0.1;

Floor floor;
Ball[] balls;
Box box;

void setup() {
    size(720, 720);
    floor = new Floor(600 /* height */);
    balls = new Ball[2];
    balls[0] = new Ball(
        new PVector(360, 300), // position
        new PVector(0, 0), // velocity
        10, // mass
        20 // radius
    );
    balls[1] = new Ball(
        new PVector(500, 580), // position
        new PVector(0, 0), // velocity
        10, // mass
        20 // radius
    );
    box = new Box(
        new PVector(200, 500), // position
        new PVector(0, 0), // velocity
        10, // mass
        50, // w_len
        40  // h_len
    );
}

void draw() {
    background(255);
    for (Ball b : balls) {
        b.set_force(gravity.copy().mult(b.get_mass()));
    }
    box.set_force(gravity.copy().mult(box.get_mass()));
    for (int i = 0;     i < balls.length - 1; ++i)
    for (int j = i + 1; j < balls.length;     ++j) {
        Ball bi = balls[i], bj = balls[j];
        Effect e_i2j, e_j2i;
        if (bi.is_collide(bj)) {
            e_j2i = bj.effect_on(bi);
        } else {
            e_j2i = new Effect();
        }
        if (bj.is_collide(bi)) {
            e_i2j = bi.effect_on(bj);
        } else {
            e_i2j = new Effect();
        }
        bi.add_effect(e_j2i);
        bj.add_effect(e_i2j);
    }
    for (Ball b : balls) {
        Effect e_b2f, e_f2b;
        if (b.is_collide(floor)) { // floor.is_collide(ball) でも同じ結果が得られるようにしたい
            e_f2b = floor.effect_on(b);
        } else {
            e_f2b = new Effect();
        }
        if (floor.is_collide(b)) {
            e_b2f = floor.effect_on(floor);
        } else {
            e_b2f = new Effect();
        }
        b.add_effect(e_f2b);
        floor.add_effect(e_b2f);
    }
    Effect e_f2box;
    if (box.is_collide(floor)) {
        e_f2box = floor.effect_on(box);
    } else {
        e_f2box = new Effect();
    }
    box.add_effect(e_f2box);
    for (Ball b : balls) {
        b.update(delta_time);
        b.draw();
    }
    box.update(delta_time);
    box.draw();
    floor.update(delta_time); // 何もしない
    floor.draw();
}
