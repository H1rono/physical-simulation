import java.util.List;
import java.util.ArrayList;

final float delta_time = 0.05;
World world;

void setup() {
    size(720, 720);
    world = new World(new PVector(0, 9.8));
    world.add_element(new Ball(
        new PVector(100, 100),
        50, 10,
        new PVector(10, 0), true
    ));
    world.add_element(new Box(
        new PVector(width / 2, height - 50),
        width, 100, 0,
        new PVector(0, 0), false
    ));
}

void draw() {
    background(255);
    world.update(delta_time);
    world.draw(this);
}